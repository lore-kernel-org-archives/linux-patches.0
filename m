Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060855;
	b=MW4bct/7gHOea3+AFI6HlqEbwWJMm4+9JwvAyoB/3uZHQJHAUB/kB2Tx6jUy3Zl345ri
	 +J0hJHf6hnhWxqZVDZQPPnUIxyWNbF99t0X/pq8isK6FK7ajEGo2XLsbPI4hFNO6jRkoR
	 sk6g7kmCe1jDoXehv6DlFI/9MM8XCkl25cDkcvJwqIKAiUJ9tO8eZBG+Q61QktJQVnR3h
	 uougjkl7th5p7C12ig6jU015Rl1N53bXP/3twl/nY98M44YGIREn+LK1p5E86/QKVyG/J
	 yARM8+4/jmfNEmrDmwHTLQiA5yDTbUe02elwWtiV6p/DFbimqEVfj2FLYtgIGbvwKYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060855;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nGFR/SsqHv5NZmAdRwMhNMd2Zl+NTmbwWUEYQwpBdZ0=;
	b=3nQirvY87UsCYbJKizyjJfZsUCBrCpOIUh71odfAC46mIwe1Re2RePLoRZlOwHg3Mphn
	 qjnTAg2e7zG8Euvmofu1dRDhHruPpyww54aBmzcMyi+3iAGotKJJ6JOGadZF4qURgfJ0g
	 tQSLn5jNixRG/bEFI5IDt+AfqCYIH8b+L2gfDUh6v6/EvzuO4HlpXvh8/EYQCOzSm/7Dc
	 tALkMWiP++5SKe3gE14ZGCbY2nT9vso+yg6T4X9jHsE/7bPLn4EDtBCqPSq9bnmo4nnf2
	 ZCURBub6c6nnCdbH9hD/8JBw+2OiJ8g8FSUKmlHdpZwvtg9S5gzdz/bgspA7MxX+Kuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UHLXRZIO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9A98606A330;
	Sat,  7 Nov 2026 14:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UHLXRZIO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10B241F0089F;
	Sat,  7 Nov 2026 14:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060854;
	bh=nGFR/SsqHv5NZmAdRwMhNMd2Zl+NTmbwWUEYQwpBdZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UHLXRZIOlXBe5K/hjvneB37O3s61mZoDoqOzNNZiSW/XT/CMpJDzDopUG9lGT3Lw4
	 W1YLSc7A4bln5mloAR/hTes4INdEw39pmdvejeBHPmdSzNUYrNGmj8BuDwklGkMSgC
	 S9eQeGgPgS4TYv3ADDdReT/GOsvCDY2gIvHt6Z/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Srinivas Kandagatla <srini@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0239/1536] nvmem: brcm_nvram: reject empty NVRAM partition
Date: Sat,  7 Nov 2026 08:37:35 -0500
Message-ID: <20261107135004.387985244@linuxfoundation.org>
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

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit fde46579cf8872138b296349c2bd8a3cd3f132e2 ]

If the partition is completely erased (all padding bytes), the trimming
loop reduces data_len to 0. devm_kzalloc(dev, 0, GFP_KERNEL) returns
ZERO_SIZE_PTR ((void *)16), which is non-NULL and bypasses the NULL
check. The subsequent cast of priv->data to struct brcm_nvram_header *
and dereference of header->magic causes a page fault on address 0x10.

Reject data_len smaller than the header before allocating.

Assisted-by: opencode:big-pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Srinivas Kandagatla <srini@kernel.org>
Link: https://patch.msgid.link/20260729094647.111468-13-srini@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvmem/brcm_nvram.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/nvmem/brcm_nvram.c b/drivers/nvmem/brcm_nvram.c
index 65f458af3a195..6a142f8feac39 100644
--- a/drivers/nvmem/brcm_nvram.c
+++ b/drivers/nvmem/brcm_nvram.c
@@ -84,6 +84,11 @@ static int brcm_nvram_copy_data(struct brcm_nvram *priv, struct platform_device
 	}
 	WARN(priv->data_len > SZ_128K, "Unexpected (big) NVRAM size: %zu B\n", priv->data_len);
 
+	if (priv->data_len < sizeof(struct brcm_nvram_header)) {
+		dev_err(priv->dev, "NVRAM data too small (%zu)\n", priv->data_len);
+		return -EINVAL;
+	}
+
 	priv->data = devm_kzalloc(priv->dev, priv->data_len, GFP_KERNEL);
 	if (!priv->data)
 		return -ENOMEM;
-- 
2.53.0



