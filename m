Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7E1414F12C;
	Tue, 10 Sep 2024 09:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962266; cv=none; b=LHsikfwm5Dt2xtQsSkVj3snipQVA2uxpcZ88Cd2eRFOdZMX1oCipxkASygWAo30ve+lkcZYcVDPQuthpNn7DBHKeQLMsZ8hZnyr+YkZMdYMAad8hH3jZf+yQF6coev0qmeZkKE1HcCYIqYzyaGy/DLpDc9K/Jh0i/4LuRIkvNyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962266; c=relaxed/simple;
	bh=60xRO7hxe1iMOUNs62cZZsPC9RBXWk1jD/NRAppYMRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rhSphyFlOL006Yikm6MHkLStZn3FqJKm69UUGpkPUElsYdSErQbHOTWCr5dApTsDdRI7FmEBobsKD4Lv09igH7HI6Yhjp/EBjka5B7Gip825eEdQie1ZKpOI/KSCyr6QKIotz1QQlITC+m9GpH6N4q+/HR/NGrglrb7VtrlXYyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WaWUIFMr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WaWUIFMr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E2FFC4CEC3;
	Tue, 10 Sep 2024 09:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962266;
	bh=60xRO7hxe1iMOUNs62cZZsPC9RBXWk1jD/NRAppYMRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WaWUIFMrhmOPQg5UiLYHTTQMEj0u6QQ+FF12gr1HSh1UJgS3BJaVLLSjX4/q3lL/i
	 L2jJAEQuf1xSAGLc66tUMhBbJCI+rG2QHVTJNDP0AfbobAyfGsAg/2VxEYBGt2ffhc
	 9aANNv0IKbqT6tOg335oOO7wXH0seJmRfdYufHnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Skeggs <bskeggs@nvidia.com>,
	Dave Airlie <airlied@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 352/375] nouveau: fix the fwsec sb verification register.
Date: Tue, 10 Sep 2024 11:32:29 +0200
Message-ID: <20240910092634.419678524@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@redhat.com>

[ Upstream commit f33b9ab0495b7e3bb01bf6d76045f078e20ada65 ]

This aligns with what open gpu does, the 0x15 hex is just to trick you.

Fixes: 176fdcbddfd2 ("drm/nouveau/gsp/r535: add support for booting GSP-RM")
Reviewed-by: Ben Skeggs <bskeggs@nvidia.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240828023720.1596602-1-airlied@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nvkm/subdev/gsp/fwsec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/fwsec.c b/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/fwsec.c
index 330d72b1a4af..52412965fac1 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/fwsec.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/fwsec.c
@@ -324,7 +324,7 @@ nvkm_gsp_fwsec_sb(struct nvkm_gsp *gsp)
 		return ret;
 
 	/* Verify. */
-	err = nvkm_rd32(device, 0x001400 + (0xf * 4)) & 0x0000ffff;
+	err = nvkm_rd32(device, 0x001400 + (0x15 * 4)) & 0x0000ffff;
 	if (err) {
 		nvkm_error(subdev, "fwsec-sb: 0x%04x\n", err);
 		return -EIO;
-- 
2.43.0



