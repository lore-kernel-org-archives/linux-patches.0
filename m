Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062684;
	b=bJ2aELvdrYLeKXC5mTd7F+w0YCMZi6tA1M80zmJBLconcWjGb5EGzZrYkVLzfxPRslhV
	 OWPzy4dNYiKF9xRbieFGbTZ7f4/HBkj7RDzL29tk3lYzqp+r+sj/pfpyr4wCf99x4BuM6
	 Zo9ouPfqQD6FDYGnDlcN1EfLsdNjVy+Q3zEEmeO/ucjdUa/8fUs1R0Rs6ovA3lmxZq8UK
	 gkSWOGgiYNcaG7iIfIler/ke36aTA2I/+lU5VdnlHWexoOzitvheUSs4rAhMpzvsEhMZg
	 Pcq0qpm3VSNeTZT8NDG9CB/fC8uqiuWfxz4c2DwfPlEm5LQTVP3+y9Wjd1qUQwG+D0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062684;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2tMzF+pybJ9kzWZrVPCVe2cxKgpHjgdCAHsIJ30EQYg=;
	b=VK1S1WBAXOuJExnmcfi3hZXG6jxcbxFijW/FN6+bATgDu0H+4JjMDMp5j+EFMOEHFqdo
	 irO3J8Ydk9mooTnqsi6qCWm2WGNUIQrrE3n4V8kZPStMMyTioVR62Amah0t6XIy3kBl/C
	 BewQEG1fe0TYsKBCiPAAYXOVmUplndyZoRJMcgGQAVFE20Rdnz6RZ0WlRDsWmwbvZMOKv
	 pTXOubpSxwJzgzti0nSJfTlPLtb9U7wJMuzxuPkClpAwg22HnxeqeHXysUcmPbDSwa7VJ
	 WMTyOgLL9saCfcFWB9v/+4yaqSYCftnWV7JxOISphcwZH9r5SSQUeob0xImrL+36LSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ZzGVIR/L";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01E15606A332;
	Sat,  7 Nov 2026 14:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZzGVIR/L
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A30F91F0089F;
	Sat,  7 Nov 2026 14:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062683;
	bh=2tMzF+pybJ9kzWZrVPCVe2cxKgpHjgdCAHsIJ30EQYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZzGVIR/LxHXYbcLBndXFkgtuY2drLE6m/pW32fegKyGv8oNdHssQCPS04H4gkI3Zb
	 DkCSBETYznt7hQNOUSTwZQ6nJoMc+mrtOAR1FXOW5/EqmpEOi3mkc/UJo3A3WPFmhP
	 a8q4oocFykWEJ30Axqnw+Rht7hULzupTn1HvCk08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Perlow <jperlow@gmail.com>,
	Aditya Garg <aditya.garg@linux.dev>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1533/1536] wifi: brcmfmac: map msgbuf RX packet IDs bidirectional
Date: Sat,  7 Nov 2026 08:59:09 -0500
Message-ID: <20261107135040.940453397@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Jason Perlow <jperlow@gmail.com>

[ Upstream commit 7ed5dce55fa8393972b1bf2bf5af1c818c5e7dc2 ]

Commit f0ba5fd51ff2 ("wifi: brcmfmac: Set DMA direction for msgbuf
packet IDs") maps the RX packet ID buffers DMA_FROM_DEVICE. The
BCM4364 firmware also reads posted RX buffers, so with VT-d
translation enabled every such read faults ("PTE Read access is not
set") and the firmware crashes and resets in a loop.

Map the RX pool DMA_BIDIRECTIONAL again, as before that commit. TX
keeps DMA_TO_DEVICE.

Fixes: f0ba5fd51ff2 ("wifi: brcmfmac: Set DMA direction for msgbuf packet IDs")
Cc: stable@vger.kernel.org
Signed-off-by: Jason Perlow <jperlow@gmail.com>
Signed-off-by: Aditya Garg <aditya.garg@linux.dev>
Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Link: https://patch.msgid.link/20261021172238.10004-1-aditya.garg@linux.dev
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
index f850e64108c41..24f083f42bb75 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
@@ -1639,7 +1639,7 @@ int brcmf_proto_msgbuf_attach(struct brcmf_pub *drvr)
 	if (!msgbuf->tx_pktids)
 		goto fail;
 	msgbuf->rx_pktids = brcmf_msgbuf_init_pktids(NR_RX_PKTIDS,
-						     DMA_FROM_DEVICE);
+						     DMA_BIDIRECTIONAL);
 	if (!msgbuf->rx_pktids)
 		goto fail;
 
-- 
2.53.0



