Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051319;
	b=nsbjJaoJKF0vIGIiTZfwPl+xAk/oe49Dltg/jL9TXVlJZoHoYz2y+gn6I13V7hMPOHXA
	 BpCjcG6zu5aNoEvE992r63lPoFuoW+LIZ4HQmJXOC36vKLVDwSHFlnw3zA/B+Ecz0Jgms
	 oUwImoj6iTsFjqTxHSKNu4lneQNR3n9BdBcShpM18lnBIASMmfH3NPdh8BUgtBWlLNCjC
	 0/nU84mXGmZvByn2fSwXI4YxTbNiWsM7hQ8gk/lAdHBTB/aEwchrVXkfRrW3/jSlmWfWy
	 fh9nEXw16hvNklUfRSL4Cz18aIt282jqp1prwXW5Y4VLhqkatFQXrq3VQ5xI9k06F5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051319;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=I46snWDZ/pVzBz0OVJ99LD8mjwZXLm35DzSvp+r45OQ=;
	b=rwV1wiYTB6fgcWKIK7DyU71GQqoqluACjURhb+T/rvfyRORoM85e1OmoBZWfMEojdIlE
	 XYEmCO1qJXJWL4Dra1m7uHFAK5glilkq9zKbmQ2A+cjPBDYndCs7eru8l0rKfd8MO7SDr
	 W1EgzG/qc2YWzb4Jj/CA2GHLLW7/W0r8tI495DYboIZxrmHdc56Jxv7ooZM+UUGFvZ2Vj
	 zfi2VeBBsjM8EOkYke/Qjm14d/qPFzo9x7ychFE0Q8Msjie9kwxzJb7cR3Z9+Z7BO7P6D
	 i3ZVor6QVBpnorsrSUAE6iiOqc4LFslxOSa1PL39KDI9xR20nLvpOHOYJWtxkfv33Kg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vpz57HgU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4083606A320;
	Thu, 19 Nov 2026 01:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vpz57HgU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 059361F000C4;
	Thu, 19 Nov 2026 01:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051319;
	bh=I46snWDZ/pVzBz0OVJ99LD8mjwZXLm35DzSvp+r45OQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vpz57HgUiFnzpuyXAs9xE7ZuDPe9zA1OFS03Td3QWaMUmHheg1UhVXjvcYvLPaLyV
	 coHtjoPNanFeuQ44NcETFFgymdUPeskzkYMgz/vyMnBsAJqF01+PVk8fq6xlhFrtNF
	 ARPk/AJIsZflYPJGuA0zX8/VtZi1wgBXSuMOpwBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Can Peng <pengcan@kylinos.cn>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0165/2214] wifi: brcmfmac: Set DMA direction for msgbuf packet IDs
Date: Wed, 18 Nov 2026 15:30:41 +0100
Message-ID: <20261118150016.709443559@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



