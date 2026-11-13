Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590781;
	b=R0jHzogXzzxJlIjgs5gJWpVfWlasHsjjsDfCQyhD/5wfDtVDsbCR98PryAXo0eoJ21uI
	 6Fh1LKq+eTSbqh4l7v5W51WRBjesyux/Z/9+fshHXIzwt+JFQ8Ug9BO6+Earma4/HsYFv
	 rHnBfeeo0Ralj10etJVJfPnfu0tWcsJYBHWR+vRVxQP/jcXshv5+md5QSEpzbKc/M2BDr
	 L0x6yfQFORwtt3S+LFtdzSYu/dlARXNjmgaHuvpvEXHJkO+awIl/GZkumKk30NpWTNwq7
	 rhiQLRmnPQtiEq13uEy3y9uLRBKmaI0toY2o9AaN6sH2Yqeu0+z70R54FkRm/CUbYcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590781;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gGAFm3ES1PfA6L/yrwYcapPAFxc9f/YkuBr78qxKUyU=;
	b=OEHRpMO+zTqTG1kb7XEbSvrk1b6bycT5r5C1REv9sKuR0Mx1Eb2ov1eYwtsVeXWH7mc7
	 tQ4CKF12j6oFgdk46MHBrPLeTmDz1A+0Prua0EoeWS/0QiLVfQttfPfm1qeXm2rJW1hG7
	 1FbTgX999ONwYtsyYH6CSd0A1W00QNtbgOhiy4JNZAc0E0YJrp4hCIuDAv0q9q1s3NcGd
	 2dZjt61pPU2bBUoTP7WMiTrbGLfDBBOvCkMaSALmhFoOK/DFJFibn+jGFBbbVkIIEOD0U
	 64veYGyKt0m9ihqEa8JVCa92YH38pxoHMtTrkAG9UE6C4XVnodDyoGIQxPJGN8H/GdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pCHVNkZz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84238607C379;
	Fri, 13 Nov 2026 17:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pCHVNkZz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24DE11F000C4;
	Fri, 13 Nov 2026 17:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590781;
	bh=gGAFm3ES1PfA6L/yrwYcapPAFxc9f/YkuBr78qxKUyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pCHVNkZztVzKzg+4Dn7ohHTT40kJ+c53wM9z+HpGyFseckt44sWP4DuhbMfZ95C+H
	 sd+w7m9iSPBdwlxcv2iMQet+sWdyhwPyrpv6JNo0ULN/Xf8AjC04L7AklErxFxjgZV
	 +vBcdwUgASLJtstRVxEVC75YkviuRCls9zq0Eyaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 675/686] fbdev: nvidia: Release write-combining handle on probe failure
Date: Fri, 13 Nov 2026 10:53:28 -0500
Message-ID: <20261113153844.533828145@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit 8710af6a35201a6d01b5af8f7e4bad29cc40467f ]

Failures in nvidia_set_fbinfo() or register_framebuffer() leave the handle
from arch_phys_wc_add() allocated. Release it in the shared error path,
as nvidiafb_remove() already does on normal removal.

The missing cleanup was already present in the initial Git import,
when the driver used mtrr_add() directly.

This issue was identified during our ongoing static-analysis research
while reviewing kernel code.

Cc: stable@vger.kernel.org
Assisted-by: LLM
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/nvidia/nvidia.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/video/fbdev/nvidia/nvidia.c b/drivers/video/fbdev/nvidia/nvidia.c
index f917d569bdbd5..aebb81f9ac585 100644
--- a/drivers/video/fbdev/nvidia/nvidia.c
+++ b/drivers/video/fbdev/nvidia/nvidia.c
@@ -1420,6 +1420,7 @@ static int nvidiafb_probe(struct pci_dev *pd, const struct pci_device_id *ent)
 	return 0;
 
 err_out_iounmap_fb:
+	arch_phys_wc_del(par->wc_cookie);
 	fb_destroy_modelist(&info->modelist);
 err_out_free_base1:
 	fb_destroy_modedb(info->monspecs.modedb);
-- 
2.53.0



