Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059867;
	b=Im5GNkm5flZHg991bzqw9pK4qJ3XWCl/IsbrqbWR9st9ZIxWac1tIfqWciSmQ47tl4D3
	 NEqimkcb8XYlQ8n9tgK1jQDbasetp0XHGCRX1/nZCCFTdhJULs7IgxlEOk44bSf3NLVzL
	 TlfyCFLQZjzAeKdV8wCJURJsW7RvB54pgOZCH/ZT/4+OpSj4Dkf2vh+eODuxeeBciiKdg
	 VVPKRmuiveINiA/SWolqb1EJCP5idul2tg9rtG/9vcegQkMgP7QD5WKRA16RkkL8aFhU6
	 omO+Dc95Zhu+zbyspZany6JCrjOOENh7Uzna/Ta9kErpDXW8ST2+q4gTNN+8+CVU+Dg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059867;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZD3FexpaKn2y1k84N7Hh2kq7wcnfaHjvTdsSpgHuXpg=;
	b=dx6jzYGZISS3MGWRBuphXeZhV8g0mloFJVR1RvvtEUlSNGWSwcd0JHxvDdXZ2E8+NCTJ
	 Pz9/vbvBfXWKhf3rGTNi2WptXW5OedAqKlYJg8qFi3fUY87rzhORUPDaeX5E4jQchgSmw
	 C3d2KfF6dWdNiaKD4UMjl154GdzH3uQRY725Sh7oR+4BaaOQwNFYuzS8Miy27Vsk4mcce
	 zMxDb27I3UMye96zxa+FZOeR24FfoL/yIScupd5DC24KSrwmL9FVXSipsVxPHvQ0ISUmJ
	 HFevp11RmdkO6E8yttvSuHa5GClBxXBBZYcst1T7+OxQEXwdSNFvjXSvdJHC5312tbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dulqCio9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19A12606A320;
	Thu, 19 Nov 2026 03:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dulqCio9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68E0F1F000C4;
	Thu, 19 Nov 2026 03:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059867;
	bh=ZD3FexpaKn2y1k84N7Hh2kq7wcnfaHjvTdsSpgHuXpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dulqCio9wnfogU4sjGnrVpiGwT0vNem6hfNeH9buZU8TfShyo6rGM5N0nr38vxjua
	 0vDVtgN4uFdgGknOIVX7GcbAGJbj67kW8LpY+l76iYoaEJ4bH91DvdAfI4/fz9uSfN
	 RQbrgEhiYRNIgBRby5J38jAfDAqetCPiM0iwW+yY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0995/1848] fbdev: nvidia: Release write-combining handle on probe failure
Date: Wed, 18 Nov 2026 15:50:33 +0100
Message-ID: <20261118145958.507448214@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adjusted error-path context to retain the existing iounmap(info->screen_base) call ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/nvidia/nvidia.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/video/fbdev/nvidia/nvidia.c b/drivers/video/fbdev/nvidia/nvidia.c
index ecf07b598453e..05d3d1fcd81d7 100644
--- a/drivers/video/fbdev/nvidia/nvidia.c
+++ b/drivers/video/fbdev/nvidia/nvidia.c
@@ -1408,6 +1408,7 @@ static int nvidiafb_probe(struct pci_dev *pd, const struct pci_device_id *ent)
 	return 0;
 
 err_out_iounmap_fb:
+	arch_phys_wc_del(par->wc_cookie);
 	iounmap(info->screen_base);
 	fb_destroy_modelist(&info->modelist);
 err_out_free_base1:
-- 
2.53.0



