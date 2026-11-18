Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038707;
	b=j0+PbjMCX18DARVGC2NaDXBRcxrYWWcn3CoL/TRnpiRouO/xA/WxH/UUj2Hrmauye3Nc
	 OdJ9WeHV+t416OC3UV4AV+1828Bb11dxGiBZTzhDldXMNPtgn5lLTYbXlp4v1axPgu6oj
	 fmvRyfgeKp7w1Saqu+6SBvF0zcItLM30gbo6wna0W0IxCEmdPsEB/tt4R4Ocoy34PWF0F
	 kjh7PPO1O09XyrrCSkOinLlFsxQsMs/3/RN9lfGb0YnMXE/a0mBTmmepJW2WS9sZOTaBy
	 bpDzqGDdAaFSJ6ZIZAsRLLEHaCSMg8nO0VTWGpoAzU0awZ8JiVdtMy4f/gknbxPeXkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038707;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=S/hThTwfnXYr3Bz8TsS0lxyopgMCMUZWts5Ukih9ark=;
	b=UcMsIvfyf15YaMEALaf5oTane7t03hh8IMfgAcC1PZcPWQ6jT/0QSRgqyLueUy3DGH6P
	 yuh8ORJ47zxB3w8xiSTtU9P9a4AnVgHosT/id0lHoklBi+5TVkuiROu/5Ujcqc1USOwIv
	 ASLiPlimSFSYsIVr30FEj9UmWlUsm8lobLw+IEl8gCnOSDYvGueCBmRcuVsisBE5o+UnI
	 GMYOgcGhjk+ZQtDfeznB3p8a6WtATA+5LiY3VfMZlUJlUWZRfU58nQ4w3ThtJ84GoF9Rw
	 KPst0jy19qLExVxzh4wZtBZHdf4Yn4a1/e1tJJuqQmFWGU38IqWZbGKMke3uzgS93yg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EL7LjYt4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DEF1606A31C;
	Wed, 18 Nov 2026 21:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EL7LjYt4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADE071F000C4;
	Wed, 18 Nov 2026 21:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038707;
	bh=S/hThTwfnXYr3Bz8TsS0lxyopgMCMUZWts5Ukih9ark=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EL7LjYt4LeHt+G6nas+zYKUfAV+MIHVfQ0VFJK1hw48xpLibyr0Wkp1aNuuPE9RIk
	 7St4JsGUWjtvp6Zo0mjc3XSd6rcbvEkWHNuC3iArrZZDRIfjrACsmORScl8pQjl+PO
	 fLNNtb70cO+FTGeJgTAhwu/YRIlCM5UOkV7yrmOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1840/3318] fbdev: nvidia: Release write-combining handle on probe failure
Date: Wed, 18 Nov 2026 15:41:02 +0100
Message-ID: <20261118150417.057491485@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Retained explicit iounmap() cleanup because the managed-mapping conversion is absent. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/nvidia/nvidia.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/video/fbdev/nvidia/nvidia.c b/drivers/video/fbdev/nvidia/nvidia.c
index 674baba74cf06..bc0abc3c04bbd 100644
--- a/drivers/video/fbdev/nvidia/nvidia.c
+++ b/drivers/video/fbdev/nvidia/nvidia.c
@@ -1417,6 +1417,7 @@ static int nvidiafb_probe(struct pci_dev *pd, const struct pci_device_id *ent)
 	return 0;
 
 err_out_iounmap_fb:
+	arch_phys_wc_del(par->wc_cookie);
 	iounmap(info->screen_base);
 	fb_destroy_modelist(&info->modelist);
 err_out_free_base1:
-- 
2.53.0



