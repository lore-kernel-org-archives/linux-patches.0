Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017397;
	b=5nAcHF9UzOcuJbThWobESjnvd0Wr4C0Hfie2ulm18jVT6JCJo09CuoQfRBfBjp903P6O
	 45wukT7i/h33Fnr/6VoF5Y1nW8L67VSiqiGdZtgj/rmek8DyYSnKpAHLXQtYuKN+4iqMT
	 XwiXRnHwByzlrS9vH5uI7jMpxduaKI7rFaT4PuQJI9UMyv8qbsS/5C3luANch4qmTfKCP
	 yl4Fb68e8pUxt+39cLcKvXIWami2TRf3sbhVj2JzFwtDtAkGkINWczVlS72WpDJIzGHw8
	 55PZkU4ydoqeoTZ+apaAAhHhgqkU8IeGG88EemE0GpJe5Gvg2AF6OZ+obr9d/ZeuNkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017397;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hpF0b5riVj+4qW2u56G2AhGpHoFBSAqWPv3TUALK23U=;
	b=ytKHgUdCl4BxaAtvDuM53Up1LOf7w+e6nAeL9ZBEIeRo6i1qr+7vE5KJkNkgSqV7XNXH
	 q07p+peFBbp7etj+4TKo6iSuWtsuhqpJuI+kS77o2As7GiGrdChBThNcbaaz3kNoBJb/P
	 diWd46XH0lRg566bJ1xIrHoXiCoYkYDhw8H4Q66sPYdfobfCFKC/adnFblPVoSB+66MdL
	 Vg7QIUDCm25Li65OxOAcj4yJhwbsCli8q1NGaOhfj9w7pwGHYbaM3we7eLji28ssAQ3bo
	 d2lI9kmoOxVGeA/oPQ1l2HwOFOqPq4BgbUHJIUhoA/mhZJcMB/g8RXgBFHDmqGzAkdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wDVPo+RM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65121606A331;
	Wed, 18 Nov 2026 15:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wDVPo+RM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC8EC1F000C4;
	Wed, 18 Nov 2026 15:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017397;
	bh=hpF0b5riVj+4qW2u56G2AhGpHoFBSAqWPv3TUALK23U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wDVPo+RMG2x6DZCWds57CUKZQFYxIEq9Y6Aw0Z6WufpzzqGmW6CiyHysFCpnrAQI3
	 +yFyZwabSjTv0mPTctPqE8zA9uz7Tqvzix6uaObQk3uwAbPnazrhpvtZnvMVYslLL1
	 1O0jO3Irs3f1BoSJEf78J5dB/vZWSOSD8u3s7MsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Alex Williamson <alex.williamson@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex@shazbot.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0830/2651] vfio: Reject a second cdev open before mutating shared device state
Date: Wed, 18 Nov 2026 15:34:30 +0100
Message-ID: <20261118150317.767965261@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 1d9515c967b01..30362936c7b59 100644
--- a/drivers/vfio/device_cdev.c
+++ b/drivers/vfio/device_cdev.c
@@ -130,6 +130,18 @@ long vfio_df_ioctl_bind_iommufd(struct vfio_device_file *df,
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
index 423ead48aafe3..cb3deb5a48574 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -603,13 +603,6 @@ int vfio_df_open(struct vfio_device_file *df)
 
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



