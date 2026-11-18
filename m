Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026300;
	b=ogubCRou2ReaEiXWg9S9mHDcnUSUaeEvF5nxM/RU+uKI9YpZPj1kWd06b0bn4qi5c4WT
	 bJcEQCfYQQFvZPlvNThne2t23mZrwv+ULtxlX6luNAhAAwYIFr6U5SDW+AQUdGOq1fUN4
	 L8ud71UqOetJ9KUXyHcQOdyz8VO37ELWnDDDLTBIMIKhAy82vk17spPdNoPP+R0qyX3DV
	 hZ7e9UG0QDBcYmfIx7Rtrl8LmL+S92JqmDM6JNvSsZJWh/Au49gbbRHXykI23hz/GkkLo
	 +y7M0+q3MqGln+hi3gHLlMVwPrvYdV0sflvM0JOiJHjhFk8O0nIw2nV9r93g0VuQY3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026300;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=INJGJVvA0T/ZkMY7nfTFOncbqdaiqthxJ/mXQlV8cM0=;
	b=HFRlPEwupAbFRlTXnG4tZ95XJOKHAaDaw44dtWlT7Zx7dE0AF0fP3u49obx70eCTXbYU
	 nOCtPrOW/3D0F4geyuxUra9SWxFfh51PU2OBpoHtTOCF/6+7OWhdBpfhgz2LdXnDG8cjN
	 Rr+7ZaZNuDwiOuMz1i1Dj9uBWs4okcxLaGdweVuiwhGTD/uOzCPxggQeuCj/79gOxAlow
	 m9guj+j2xLA2XiOtdlJMfToYOHoXoIsswRcZ31ab3y/lD8WmhP2/H5R649uY7ZKBk70Cr
	 21A4QXk1rrnrWovREBxMjLzOHP/2lfiHmPx+WTJrDJr4Qxp+TA1lpHRKwLuDM+MjAiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TnA6P0qd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CAC8606A31C;
	Wed, 18 Nov 2026 18:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TnA6P0qd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8816F1F000C4;
	Wed, 18 Nov 2026 18:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026300;
	bh=INJGJVvA0T/ZkMY7nfTFOncbqdaiqthxJ/mXQlV8cM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TnA6P0qdOFIOIqAkBvWjhrhxYMIWXTaoB+mj39jxt63ggT3cvg5muyDpRrHEMNBRU
	 j4lf0KnolEg3EmZWlAhKkxGUMbirfksAcVzbn6ILQ/MhuXYXtdVUEkR2UOBRCeIgWv
	 r7XnxLxr2xwyCzZ6RTwNveDm5s6GZq9hHldLfmLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1387/2151] fbdev: gxt4500: Release WC setup on probe failure
Date: Wed, 18 Nov 2026 15:52:02 +0100
Message-ID: <20261118150212.533346129@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit b71e0bb7ad40c005b167e9b48be3af5a3fa51974 ]

gxt4500_probe() adds a write-combining range before allocating the cmap
and registering the framebuffer. If a later step fails, the range is
not released. Add the missing cleanup before unmapping the framebuffer,
matching the successful remove path.

This issue was identified during our ongoing static-analysis research
while reviewing kernel code.

Fixes: 38fc4d45fae5 ("gxt4500: Use arch_phys_wc_* for framebuffer")
Assisted-by: LLM
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/gxt4500.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/video/fbdev/gxt4500.c b/drivers/video/fbdev/gxt4500.c
index 15a82c6b609ea..138f5efbf4f40 100644
--- a/drivers/video/fbdev/gxt4500.c
+++ b/drivers/video/fbdev/gxt4500.c
@@ -719,6 +719,7 @@ static int gxt4500_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
  err_free_cmap:
 	fb_dealloc_cmap(&info->cmap);
  err_unmap_all:
+	arch_phys_wc_del(par->wc_cookie);
 	iounmap(info->screen_base);
  err_unmap_regs:
 	iounmap(par->regs);
-- 
2.53.0



