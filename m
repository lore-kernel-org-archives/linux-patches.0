Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211280;
	b=nAvyUCkrcfwZGcCh0bqQKZtS8UucRj5sDBJM0s8eQ8AyU+7uT4d5zEgfbU2S1DOqnSa6
	 3g6LaWSl00fkGOfuTXbW4oJFH0xz2l6KZhZH/83VTyPo1pmZzarHd1EnprkyEbjs4uttq
	 0ffpQiwbEVZCZQHnbAjUFCMfAxtUbP0YI1N5MuVEACb1zLUvKCaZI1quiv1NjMMvT1+Bw
	 SKFu760JlWPBNVsHgBmaLRtJ7CDm7hmFNazRAf4mDGGQw6knxcjwBDwEEn77C2Ac6n7nD
	 73Uh/H5YlFuDLArhlx2RBq7z9qg59oMd4pxjNUZJWhG35NpCv6s9zSSlJGUOthPoW3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211280;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yi5XPZ4jwZQaGoUoUTWkamGMMMkkmZHISPnZbVqJoaw=;
	b=DspK8VlaNhjzEcpFIyE53CU0qeEE4vZeUTp1/u1ItEM5smEvH8rRn2wiTROKfumFwkL0
	 pQV1KCUIDUqSEjCIez0mnwSYUHjaUieTMpJMlma67U3VSXEYulD1Trg/i43NiOb+9Q4Fu
	 ll/ioCJakvosVBeBlXjFzjrfIe5xzmJTdP1KA1Za3/NsEIFw4z0nChFapyYnqd98gl5Mz
	 Fhzhx3eV6MCMDWVLkoogxFEibOOnJWwO4Ru2fiUDNbKCsEKRLodsEGMfyYYv832+N8jP6
	 O39chIGWT/SZupLfnhecIxchdAUHZuKjrCsFzhFuoroQv/krdikJjLTbtuqEJMUhyHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xKTYDe8N;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3284E60A381E;
	Wed, 28 Oct 2026 18:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xKTYDe8N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 842E81F01825;
	Wed, 28 Oct 2026 18:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211280;
	bh=yi5XPZ4jwZQaGoUoUTWkamGMMMkkmZHISPnZbVqJoaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xKTYDe8NLQLiC30X7cTCSsf9g8RNmlo8CmgKinBxu58FWZr3X5Aw3Zh9pye4AyZbV
	 JXgyMM1F09o7XFzMqmGmKoE+hnzUnzu3AmTJ0jql6D60VLjxLekzkzXNu4HAUKG1yn
	 YQ4Tv2Sarn4lF83AxL/kcvzD15LLj/KC31Kw1OY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>,
	Roman Demidov <roman.demidov.nn@gmail.com>
Subject: [PATCH 5.15 278/571] wifi: wcn36xx: fix heap overflow from oversized firmware HAL response
Date: Wed, 28 Oct 2026 17:57:05 +0100
Message-ID: <20261028170014.600491739@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

From: Tristan Madani <tristan@talencesecurity.com>

commit 88a240d86d3d64521f9194abe185ac71cc74d0bd upstream.

The firmware response dispatcher copies all synchronous HAL responses
into the 4096-byte hal_buf without validating the response length. A
response exceeding WCN36XX_HAL_BUF_SIZE causes a heap buffer overflow
with firmware-controlled content.

Add a bounds check on the response length.

Fixes: 8e84c2582169 ("wcn36xx: mac80211 driver for Qualcomm WCN3660/WCN3680 hardware")
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
Reviewed-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
Link: https://patch.msgid.link/20260421135018.352774-2-tristmd@gmail.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Roman Demidov <roman.demidov.nn@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/wcn36xx/smd.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -3174,6 +3174,10 @@ int wcn36xx_smd_rsp_process(struct rpmsg
 	case WCN36XX_HAL_GTK_OFFLOAD_GETINFO_RSP:
 	case WCN36XX_HAL_HOST_RESUME_RSP:
 	case WCN36XX_HAL_UPDATE_CHANNEL_LIST_RSP:
+		if (len > WCN36XX_HAL_BUF_SIZE) {
+			wcn36xx_warn("HAL response too large: %d\n", len);
+			break;
+		}
 		memcpy(wcn->hal_buf, buf, len);
 		wcn->hal_rsp_len = len;
 		complete(&wcn->hal_rsp_compl);


