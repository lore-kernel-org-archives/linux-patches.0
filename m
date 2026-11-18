Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043369;
	b=eUyj4sm/4Bf57RQJOhC1+CeWjx4W3dUaWdOZQb28fsQvCKHt4HtkZtRGSHXiFt8qBcK9
	 gNthkiDVC/qUvRuvuyN7RiBjYTbCmoTecD0pzcnXm12ui3/xy+x+Xc58Zwlnop0yrlgRF
	 AzOVnYn20fMFd/TeD2QYn4Bjx4gZgrJ6fHT+gTdRe0r5j01/vfL1XzSupBp0eUrRctnVl
	 mio+mCtZvGMnhPsXewxsbtyQvSbNcXbUGD3/B5b9R0ahB9/8Fn2wrmqbBvNzKz97iwf9b
	 Vakvrc7BheA6sTf6IPUl9MshBSdvuFbmZcWNCeWK1Fm0fkobi+BmSSZ577jLvRAzbCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043369;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ye+kOc6OmiSQuXypz9ITX+e4VLTSbO32x+GkDjoE9Ds=;
	b=F+gPR9AtvH1Jr4UTxIJ7fkK1OJx9LgTgo166LsU4KPSym4vgjU7luYIMWWReK46Zsdhc
	 cHtWC0hPgnUUTrPv3soO+/R1+xsic3rdZ7Y5Or/mnqzKcrPU+gPOThoP/plXJ/ZQktgAt
	 4FtxH9RSEkQ51kWah8qSqMP5CgTtFr1cYlOOcSGlBJFxNLIINAS9F/oO/SRvqZMG6mJQV
	 835lucUQ3L0eAOAtp5MhSgLSPz1tF6G46TMB1Mm3Sxd3Vsj0SeAa1XmdFjxLfq1G69462
	 8dshPG1/AF+fPkWEtQGxXcP4EZRZBQ0naMMdaX0KznU9HvV1/h1NDYT6ntcJIpa4urA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rjZDcMNU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D43F606A31C;
	Wed, 18 Nov 2026 23:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rjZDcMNU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AECC71F000C4;
	Wed, 18 Nov 2026 23:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043369;
	bh=Ye+kOc6OmiSQuXypz9ITX+e4VLTSbO32x+GkDjoE9Ds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rjZDcMNUAWVknFbxVYs1McKwRwnNtLuTSzM4JSQ+Yzep5+YAxnvmcx/ryuvGpe/Cv
	 IVnySz6DtyYRX/5B6OxXqywo+LufZcF+5l8/rigfw4vZwEPsuxqk3gc3L7/gRuKFka
	 Jb1QB8BSKtcwf/4MOfpOOEcvJUWr01JO1XV8V4jE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Can Peng <pengcan@kylinos.cn>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0185/2857] wifi: brcmfmac: Set DMA direction for msgbuf packet IDs
Date: Wed, 18 Nov 2026 15:20:19 +0100
Message-ID: <20261118150208.010626135@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 45fbcbdc7d9e4..de47d6b7e02b2 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
@@ -310,6 +310,7 @@ brcmf_msgbuf_init_pktids(u32 nr_array_entries,
 	}
 	pktids->array = array;
 	pktids->array_size = nr_array_entries;
+	pktids->direction = direction;
 
 	return pktids;
 }
-- 
2.53.0



