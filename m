Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07B83221FAE;
	Tue, 29 Apr 2025 18:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950515; cv=none; b=FM9pgD3XkG84pI9qUare26Qpy0PUfdqqdwh1Hn6NTWlxbxkM1GGC+8CmJuapL5zoXU/oHV67atdxwKrkOMxVdBNzqZWXBIpuxXQkNw5fczBESdw8e67Ye2aZvWo6+3AdqiXIpedpZ8RQoMF4xHHSFTeK/cnbcJRFbG3crEokwjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950515; c=relaxed/simple;
	bh=n0paTPXnDZR1ua8Q/VUIroce7mcZsrcbQVpZWNGovik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IgbkwXMAzjlfxuWJjw+7ZAdX25bJ0e6Owa1lkd4DcZyuKK9KZJP5SXsmEVuulBBbyLgYckyFl5k6WdoGic7CbZ1UpZ6ewZF8vzHqPBh9O1G5uA3+B/hGzBbFbBDrvxyiZFTJvXpn+X0q2FZAhFY7c1Mg5zuYPoTtB7YscXC3Zpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wr7J6gZl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wr7J6gZl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2199C4CEE3;
	Tue, 29 Apr 2025 18:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950514;
	bh=n0paTPXnDZR1ua8Q/VUIroce7mcZsrcbQVpZWNGovik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wr7J6gZlBpyKm4csrHyewjNazBImB2B52Y1ihmwcoB17g4MC2wCwQfYPgOprrq9w9
	 HzlrTG0LnEaUmIkF+72+VzB/dKprIXNOLIDqqbmZ/gnNf9SbEpSLBSlzm9Gr/8/Ud2
	 Nf/i18dIu84nxemucKlbjiDb8jYiKKSIy/AnBfaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 119/204] crypto: ccp - Add support for PCI device 0x1134
Date: Tue, 29 Apr 2025 18:43:27 +0200
Message-ID: <20250429161104.303754866@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>

[ Upstream commit 6cb345939b8cc4be79909875276aa9dc87d16757 ]

PCI device 0x1134 shares same register features as PCI device 0x17E0.
Hence reuse same data for the new PCI device ID 0x1134.

Signed-off-by: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccp/sp-pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/ccp/sp-pci.c b/drivers/crypto/ccp/sp-pci.c
index 0caa57dafc525..b1e60542351a6 100644
--- a/drivers/crypto/ccp/sp-pci.c
+++ b/drivers/crypto/ccp/sp-pci.c
@@ -577,6 +577,7 @@ static const struct pci_device_id sp_pci_table[] = {
 	{ PCI_VDEVICE(AMD, 0x14CA), (kernel_ulong_t)&dev_vdata[5] },
 	{ PCI_VDEVICE(AMD, 0x15C7), (kernel_ulong_t)&dev_vdata[6] },
 	{ PCI_VDEVICE(AMD, 0x1649), (kernel_ulong_t)&dev_vdata[6] },
+	{ PCI_VDEVICE(AMD, 0x1134), (kernel_ulong_t)&dev_vdata[7] },
 	{ PCI_VDEVICE(AMD, 0x17E0), (kernel_ulong_t)&dev_vdata[7] },
 	{ PCI_VDEVICE(AMD, 0x156E), (kernel_ulong_t)&dev_vdata[8] },
 	/* Last entry must be zero */
-- 
2.39.5



