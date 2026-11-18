Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024428;
	b=ozLLntKc+P358W8WfnK7G7eesCPaldeZZf+KMgdElzZcChFCgqWj6SituzqSKXkBtbu9
	 1TtguQzcg3v3woR1JAcuCUO7Tan2kKdPvCMVw4xxlHVdNAzssWChVAT5f2TKREpW4Gh5Q
	 QUXBKEZ7S7uEa4qHGlb3B4Hm7FDD8bzKlb03Ycsuc7iLrruSd6XFK2IWf2JBVwfMOrIKE
	 2pKUEdHSk03ySm4S70Fw9J6iXTh5xojo5AkECf/T1zMeucHoOOJrIu3ApoQbIoqQEwQyT
	 Voq5qMYPDl/kRWZhQMqP9NFvUNFj2EhltVr0yFeRA0+ItlspoUDGBECjcDXAkhA1WlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024428;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AjfOwEJ9YYu2lBvZRoYv3PFszZTQMGCYnqecEjwN5Tk=;
	b=UfIEIdu1Zk0gmxszkR2ZPUFtdAGTn5f/21mPVHypAIToMBlCmtIBJ+0PAtS9oG6DM9+r
	 6jCsCA8ddJaXOuGf6ZViL6vqhH17wB1XRW00HCMNRXjETPFJU8Yw9kilWCeSxiMU3qW7S
	 j33H7tFraWPJw+EpkihRWVHWVoAEy0n3ursj1M6Ozuf8km9Umhbp0r2SvoRIqXGbNNNFF
	 +lM88de1A3fdq6aTVBBYegq2jQFV8nwlbTLJ4XTgvCLkSgFksccRhy3FflawnRDdcbgDA
	 bZdTrxWpkkOSTzsyFNMwMw07CI2v9MfvQvaU8HCXo6ZfZYvST2dFJVjPrvcPjWi5HSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o9wbsc9H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62C6A606A330;
	Wed, 18 Nov 2026 17:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o9wbsc9H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0E0A1F000C4;
	Wed, 18 Nov 2026 17:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024428;
	bh=AjfOwEJ9YYu2lBvZRoYv3PFszZTQMGCYnqecEjwN5Tk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o9wbsc9Hif/LjWZLU3EDx+fy4Srv+8teCDfiJac6wj9FwcpZ/Ds3Sdf7aj1viJRo6
	 7LYyqmX4r9xA6BfhhLsfioKoD87gvcO2Atzpp/SVT+4v7awMps7+ILT5pmqwqDd8W8
	 2GTdyy/n7mgGbUedUY69urPvkdFP6UBngRLa+fkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Alex Williamson <alex.williamson@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex@shazbot.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0721/2151] vfio: Reject a second cdev open before mutating shared device state
Date: Wed, 18 Nov 2026 15:40:56 +0100
Message-ID: <20261118150148.260700943@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Williamson <alex.williamson@nvidia.com>

[ Upstream commit 258ba46543abdd36844f04bba8b4022a5731d873 ]

The cdev single-open check lives in vfio_df_open(), which runs at the
end of the bind ioctl, after vfio_df_ioctl_bind_iommufd() has already
updated state shared across all opens: vfio_df_check_token() can set
the PF vf_token and vfio_df_get_kvm_safe() records the caller's KVM
pointer in device->kvm and takes a reference.

A second cdev bind of an already-open device runs both, only to be
rejected in vfio_df_open().  The error path clears device->kvm and
drops the reference, tearing down the current opener's KVM association
and potentially resulting in an unbalanced reference on close or
premature release, while the vf_token remains clobbered.

Move the single-open check into vfio_df_ioctl_bind_iommufd() ahead of
both mutations, so a bind that cannot complete leaves the current
opener's state untouched.  df->group is NULL on this path, so a
non-zero open_count is exactly what vfio_df_open() rejected.  The test
in vfio_df_open() becomes redundant and is removed.

Return -EBUSY rather than -EINVAL here.  The arguments are not invalid,
the device is in use, which could be a transient condition due to a
delayed fput if the prior user is terminated.  This provides
compatibility with the group path, where a group open returns -EBUSY,
and users may choose bounded polling to detect such a transient
condition.

Fixes: 839e692fa4eb ("vfio: Make vfio_df_open() single open for device cdev path")
Fixes: 5fcc26969a16 ("vfio: Add VFIO_DEVICE_BIND_IOMMUFD")
Fixes: 86624ba3b522 ("vfio/pci: Do vf_token checks for VFIO_DEVICE_BIND_IOMMUFD")
Assisted-by: LLM
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Alex Williamson <alex.williamson@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Link: https://lore.kernel.org/r/20260911170429.1642480-2-alex.williamson@nvidia.com
Signed-off-by: Alex Williamson <alex@shazbot.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/device_cdev.c | 12 ++++++++++++
 drivers/vfio/vfio_main.c   |  7 -------
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
index 8ceca24ac136c..e5fb416b57093 100644
--- a/drivers/vfio/device_cdev.c
+++ b/drivers/vfio/device_cdev.c
@@ -121,6 +121,18 @@ long vfio_df_ioctl_bind_iommufd(struct vfio_device_file *df,
 		goto out_unlock;
 	}
 
+	/*
+	 * The cdev path allows only a single open.  Reject a second open here,
+	 * before the VF token and device->kvm updates below would clobber the
+	 * current opener's state on a bind that cannot complete.  Return -EBUSY
+	 * rather than -EINVAL since a delayed release of the prior opener can
+	 * make this transient.
+	 */
+	if (device->open_count) {
+		ret = -EBUSY;
+		goto out_unlock;
+	}
+
 	ret = vfio_df_check_token(device, &bind);
 	if (ret)
 		goto out_unlock;
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 19c40fc596999..e5de3a54d2b2c 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -567,13 +567,6 @@ int vfio_df_open(struct vfio_device_file *df)
 
 	lockdep_assert_held(&device->dev_set->lock);
 
-	/*
-	 * Only the group path allows the device to be opened multiple
-	 * times.  The device cdev path doesn't have a secure way for it.
-	 */
-	if (device->open_count != 0 && !df->group)
-		return -EINVAL;
-
 	device->open_count++;
 	if (device->open_count == 1) {
 		ret = vfio_df_device_first_open(df);
-- 
2.53.0



