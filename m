Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591622;
	b=1vNcL++zlbKhN97YxPJQgWFDIw80dSqzU4iAEOW2ogoPo04ogk1rl7CGcpd1iADK8VXn
	 MHHCArSohQc9mR+7rhbdZvNVyhR7kvxbCIfBKaghuAdUJjb/4wSvLZ6y8qqlMMipRrt2y
	 AVE3gWQFwnLm9lZeeWz2V95eYEDzzPUhLIBmP13r675uJlpHn/NmNDTv1U2+BtYWyawSL
	 9YbtzrSwuM86Gqpepni97H6ftWjDEXUKm4ZiBJgo7ZYyI/Jxr2vFk0GRwv+pam7rF2WDO
	 RcE1P4clS6qwqfnom7/PFOMuC3N3/9wG2C+d6Ejx+9ekROW3FDwcxaBsRZlDLKHL3/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591622;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TtfH7vn2JddYNAzvwOTm0VTkhokcmaMUfDm/wKE2GP0=;
	b=QejAGAlTXzI8xpuN12NCRmCVB+Yzbe1CJozOlyqVZn8AZpprYCo2QDYpBqZBZrQXWOaB
	 Z24P+thq3LzG+KElFyca7xln0AxkuxFqrpHKXYW+rB032cT+Z7Xc3GTsrNmJHeq9N3Pa5
	 65+6aR+iXYyBU+snpNMM5Apf11OPwh2M/T2pWqJMDyy4Ea43MlE/ELEgalNo7TZkSPEgA
	 nQy0Z6SnYpzC9lY/NRO4PQEkmqJUhSjb6P20FYXW8WE7y3qgTmcOQYY3XihCw6u8k71ug
	 WnmSg41DAiDYYXjYrgHZ97Rph+hF3kAW3xbJoDH8ZTlm93LHaDjz+HSzaFPRagfkgdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DmzoRjUv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE15F607EE7E;
	Fri, 13 Nov 2026 17:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DmzoRjUv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89DEC1F000C4;
	Fri, 13 Nov 2026 17:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591622;
	bh=TtfH7vn2JddYNAzvwOTm0VTkhokcmaMUfDm/wKE2GP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DmzoRjUvNEyaci4foVwMqGP3+G5AvVWFR+PVEVjxaC1ABHEi2tYknxPmntxxKe1lA
	 JYDAL2/pQZ4v/UCOnSrv8nmtRZD08dNKiEokdqbR3FhXCVuFq4O2eR2jpsSBGcFeQT
	 cOIJF7AYRd01xy+RxIE3viWMB3uEcsPAZwIvyB3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 663/670] fbdev: nvidia: Release write-combining handle on probe failure
Date: Fri, 13 Nov 2026 10:53:47 -0500
Message-ID: <20261113153834.364688836@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d298ba71ee0e3..bd4a6dd573dd4 100644
--- a/drivers/video/fbdev/nvidia/nvidia.c
+++ b/drivers/video/fbdev/nvidia/nvidia.c
@@ -1419,6 +1419,7 @@ static int nvidiafb_probe(struct pci_dev *pd, const struct pci_device_id *ent)
 	return 0;
 
 err_out_iounmap_fb:
+	arch_phys_wc_del(par->wc_cookie);
 	fb_destroy_modelist(&info->modelist);
 err_out_free_base1:
 	fb_destroy_modedb(info->monspecs.modedb);
-- 
2.53.0



