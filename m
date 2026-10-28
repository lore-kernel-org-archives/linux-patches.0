Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214193;
	b=NcN6NuMYq4llot80B62lHxws11+TRGi6jhCW5jg7bq5TFrupdPhRw6CgRxbL6c63eWId
	 2PToKrrImb8QIMNddlbBjytj0tlDEZZL2+d3eJx/vRQhnulWIGs6qFvhv/tAffSOuZEE8
	 1NG+9c69o8yxvIXr77LTGdjNZxBHOj0BDLRiiL4kgcGGYl9GNVDbrEf0yIb77fArMnXvJ
	 Y2TF4kkAxN5K3jvkIpfBJLrh63rPtHz+ewcMJx/Iwz2kQRtJHQUnv8hRbkVNIwMq0HvGC
	 rxxocWUWPjuL2RbebRxVptyhpLAbBlHi+shje0BQpTvPv9MNxPZnwIjyNhFaPxm/yJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214193;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gMuiS0UiYKpy5ZCPD9VL0Gs3XyLpXwqA96/Fgqzaxt4=;
	b=yoNEVfhc0dj+ZvMi6+tXwQY0BwCXepxQgdhXhO8W3oGGLtgxg+tey9ISobUbIJoq4JB9
	 z7ojG5BVZgNsz6+FgBdk6DKiInzLjV7OdSqyg7H1r6jkFSzqnXbDBlgv9b1yeSUGyGbLA
	 L2rN3rYw4Hf8WllEXLejD/997DbjP/FlCYL9sPxFyjyl/YyJKmMqkLSzmL8gK12IX2Dpc
	 FBH2QDufa6PJuioLvei/OtYmgrcu2D9y2stWsUH0d2+fjdN0YvFhBXhScAZe51bDFU2fT
	 j4LeBfKbrrzvOKMFmXLjf2MkYbUiVgh05kpdFK4IE8zJkumP+TRTucbkhgn08LMC5BA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BU0VmyMM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E729360A6F6F;
	Wed, 28 Oct 2026 19:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BU0VmyMM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 399311F013CF;
	Wed, 28 Oct 2026 19:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214192;
	bh=gMuiS0UiYKpy5ZCPD9VL0Gs3XyLpXwqA96/Fgqzaxt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BU0VmyMMHR/o3GTYgHUo8s0LvXQnHvC0HFZCqkjgiD9r7AadtI18T0w4gF1kdvsQR
	 GWuwQkSWClYc5IS63MoBBeIydiptSnTw4sSR1529dvIAx7ZzQwtS3JtsWP+FVUn6Yv
	 4GxbRnhEU86rI1wA/jG93pCoQ555MLh4l6G6BjIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philip Yang <Philip.Yang@amd.com>,
	Kent Russell <kent.russell@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0773/1887] drm/amdkfd: debugfs hang_hws skip GPU with MES
Date: Wed, 28 Oct 2026 17:47:49 +0100
Message-ID: <20261028170517.030065951@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philip Yang <Philip.Yang@amd.com>

[ Upstream commit fe9d0061c413f8fb8c529b18b592b04170850ded ]

debugfs hang_hws is used by GPU reset test with HWS, for MES this crash
the kernel with NULL pointer access because dqm->packet_mgr is not setup
for MES path.

Skip GPU with MES for now, MES hang_hws debugfs interface will be
supported later.

Signed-off-by: Philip Yang <Philip.Yang@amd.com>
Reviewed-by: Kent Russell <kent.russell@amd.com>
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_device.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device.c b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
index e2c055abfea97..a4eadd6416f86 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
@@ -1177,6 +1177,11 @@ int kfd_debugfs_hang_hws(struct kfd_dev *dev)
 		return -EINVAL;
 	}
 
+	if (dev->shared_resources.enable_mes) {
+		dev_err(dev->adev->dev, "Inducing MES hang is not supported\n");
+		return -EINVAL;
+	}
+
 	return dqm_debugfs_hang_hws(dev->dqm);
 }
 
-- 
2.53.0



