Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060927;
	b=P7XptXenoLmBlSwPW6XzHEFhigoH3hfYF/jzL00SeaiMIkV/2j56emUfyJH64ahdZ3rg
	 9zeoMj3YAXfnC5627+ZWqd5PW3xQJUm+wc4ynKMlJ9uvssP8TRJ+Xkgp4/8eAElScNSlS
	 TfMImkFRQKMr3jOGlp8Uyu7IvG/Z0MAAmZuBq9szcd+D9sm6qQiSOIDPFLOBtn6RuIq4s
	 Sws13I7/zMkxdbtJdItgChPMZe5FdfmoIghh8PH8QfSuOEHhudy4pYw8XSrjf8RdvD0V+
	 i778ieBSJEjeRx1esbMFGpTTXv1ZjAXVhabuIjWzGNAuCX/gtZVCRoAmaFLmAMuvEAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060927;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jtMWRufNN4POcWD3hPSOaU0WUoG8WQkSgvvZhMzXMnY=;
	b=UNZa1TrWdVIztJr+ar215Cx4C+HPq1t/GQVhC7ytuNQiqe/5+QKuMYHNXoSWgs91IdBM
	 WwH04AGEnmQ/64DCDD+9C7fjci50tz0kSIje6E+7lUAaZOUbIaqbtNOgD3b5s3SLYSZe2
	 N7pkDtsvEetj08Lgee7JQoqTFNSfC10bOcNM2sykPvVNWOsZwBVKO8TdM3n3OpffoWxvg
	 Vd4VCc7GxPwRfhif7/KPv5eykxhDKW1N19smK62edXY4+UKoxHmOqHouYA4ulgdk6bh7R
	 aAB28jTCbAdxDZAkoa3+dj1pn/yw2VHD0/MIW01s1JO9zAY+cRTx7xPBZBlAdhPBwVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=adqJPQ38;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47858606A33A;
	Sat,  7 Nov 2026 14:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=adqJPQ38
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C675C1F0089F;
	Sat,  7 Nov 2026 14:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060927;
	bh=jtMWRufNN4POcWD3hPSOaU0WUoG8WQkSgvvZhMzXMnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=adqJPQ38LycvIf4ExjlPjVj2q7+GqCI60N7Al2RtTVfZaxzJUiYQtCnupsaP6lLs8
	 jXu9iSUh7uyOkzB0o6WVMajEkB9RM8hp6dbY91Ot/a8yLl338KSV0ZBUygzp5EcJ9X
	 NU72/I2F8lsWTZ0jf0Ah5nIfwLpPHwEcF1fsSQSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Can Peng <pengcan@kylinos.cn>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0255/1536] wifi: brcmfmac: Set DMA direction for msgbuf packet IDs
Date: Sat,  7 Nov 2026 08:37:51 -0500
Message-ID: <20261107135004.847530659@linuxfoundation.org>
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



