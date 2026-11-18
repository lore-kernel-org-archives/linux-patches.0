Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057511;
	b=L4ZcH3jOV/Zb5NjcRgx6cP9UA8BvWUeHQrCQ4k6pZAyNscih0TKC1PTbeQGl+W9DECrO
	 aIbazVRFsOAc0PT5J+FEBmNPQCLzXyftI9I+aG0W1wMegjjqnKC/OQI1GLobEZ3Fhpiz8
	 P8xqZz8Hddb6ZmScPpw+2QR7vevSPDnTb4EsI3y+gE7sP76ksQzabENxVZd1Mgb3lgu44
	 ROasaLDKwEpMpQAEuGsm7eA3s9pEqXk0Kmn7W9iiAXzlBwL9jxhjhXazYwHuZ5QHDz1hR
	 tTJq4U0ErUKWooOMcMxGh+wE0bYcqcEPyhQO80I8CE2B6EpLaCnJVsBROe60Xq2YOVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057511;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=38LXD9hTP27ACiwe+JiETkdJ8e8FwDec09XArSPh1gs=;
	b=sugnhdwpbYT2WYTCsawwm39nk2QmMfvOobPMGykh+S3J4iXs+1ofF5u0CEIYP2G0Vvos
	 5TRKcWiJ0aSKmapnrVV6iUjW/Ht7VwK1Bv9nGlyRPwbQozmyYBNs0c6DPQnFE/zpnh83P
	 JcNDkuvM3XOXehEFO1OsbgxYWlp18dwlnQy7tAv306KNJ/xl4wKVR/GqJoh4hgD/gHXLy
	 3RoBsZZnJJwp5mo6evN1As4McZPa8PyOXV7ElPGb85dnUsc7+jKo0u+kCAfk1doSPM1Dw
	 9NUMWRRwHa2xVjnTbDeHo5bILMZOX1R7lIZglZ/zSOPJBtzRiILL+IaFs9fM8R9LawQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oatKbRqA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 731E060A260B;
	Thu, 19 Nov 2026 03:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oatKbRqA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C48021F000C4;
	Thu, 19 Nov 2026 03:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057511;
	bh=38LXD9hTP27ACiwe+JiETkdJ8e8FwDec09XArSPh1gs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oatKbRqAz8cI1/buqegCDUxIqndw5DeQl2uJMxEzulEzHaSVG7MnigLAZXsONpuQw
	 GOQ+c7cpK2jOVFX9RaBxI8XbWSzgi4Mw8Ae4Auw9fD0OvWXzJZpOARWdkffaGyaG5v
	 Q5yVE1k5ebu9clay2a4A6a6SuXWQzLDSAh9IyMc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Can Peng <pengcan@kylinos.cn>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0139/1848] wifi: brcmfmac: Set DMA direction for msgbuf packet IDs
Date: Wed, 18 Nov 2026 15:36:17 +0100
Message-ID: <20261118145917.126597563@linuxfoundation.org>
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

From: Can Peng <pengcan@kylinos.cn>

[ Upstream commit f0ba5fd51ff23077ce66cb9be79d41a4b7c19c5e ]

brcmf_msgbuf_init_pktids() takes the DMA direction from its callers,
but never stores it in the packet ID state.  Since the state is zeroed,
pktids->direction remains DMA_BIDIRECTIONAL for both the TX and RX
packet ID pools.

All msgbuf packet ID map and unmap paths use pktids->direction.  As a
result, TX buffers requested with DMA_TO_DEVICE and RX buffers requested
with DMA_FROM_DEVICE are mapped and unmapped as DMA_BIDIRECTIONAL
instead.

Store the caller-provided direction when initializing the packet ID
state.

Signed-off-by: Can Peng <pengcan@kylinos.cn>
Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Link: https://patch.msgid.link/20260724092530.674624-1-pengcan@kylinos.cn
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
index bd3b234b78038..cca042d88887b 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
@@ -309,6 +309,7 @@ brcmf_msgbuf_init_pktids(u32 nr_array_entries,
 	}
 	pktids->array = array;
 	pktids->array_size = nr_array_entries;
+	pktids->direction = direction;
 
 	return pktids;
 }
-- 
2.53.0



