Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208844;
	b=4YS4L9IlPjz35vGiFiGAPT59BNSPloJuylStnBIeraOv0TQ+WgnKvwPoJFlT49GUkL/A
	 zf/r5P96vaDfw3x8IjDjJLHsRSzjHwe6nr+DK4OnUNISHt89ROYuiy4c4zIgvM4ODBUCs
	 er9CUnLnt288k2TIVS0qUJ7LVDUA1U4VJeyuZNlsPDYkQSHRTRfa73sI+P6z4za+tcqtb
	 BCqjw+q2klT19Ss/rRs+s37BDejZxNymghz73AegCa1DnYz2anqtbrYvnp75RQ1/d54kI
	 RA7W7gAbz6gq9N1vOiEXSIIxEbYK+I7tvVmxFG3IRuRZRXoQ5K86oRbbpVal7/CIJRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208844;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DxOr/FaBMLWKer7RSA3oJjqRRp79iaWeDXfFMIx4fPI=;
	b=2oN5xT8FFCv0rjwfG8M3qscEiLZUsWD0J3VJExB6saDR+iX/RXsIl5yXi1U3OgV9WaFE
	 ZOqnsCP2IrxDWkvVzV2JpvP/+NevTEN3RK+m+NupRBNh7FCVMCyvGD73UAyKrPkMA0+vG
	 jZNNmzQi6ABnW7B0UBA1AKkY6LxOGUkpNd4oKKmvDO7faZpvYRMv0TVhioM/CGRLYGK+K
	 KU9bnGU3fLLwd89Dd99MAA75J0OJ6Z3l6Y/QhT7vgx9ymSSr7iYHbXxVOgJPQzOCWNdGH
	 l9kzMZSIH5I/eUT9sQ2qaOY0e9Z9E1ZhliNXiBlXmEEriOoriYLzmRVHrxHaRrISBjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YzKKlhGE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3FC8606A31C;
	Wed, 28 Oct 2026 17:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YzKKlhGE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42EA31F01825;
	Wed, 28 Oct 2026 17:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208843;
	bh=DxOr/FaBMLWKer7RSA3oJjqRRp79iaWeDXfFMIx4fPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YzKKlhGEGo5XE0ryGzytLb1gMqljF9jgL41JbWf6cdjhBPkQB4TDs9UWWEBwbCAQf
	 zXqgm7WF8Zi11bw0li4DMmPHNeXnVZLIWoIF9RAZorWkiFBOUPGvtCmPmaFlo/UyJY
	 FRIzZkBw09zr/Gpjs6IMZeoLVg64TxbkYItkwkFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>,
	Roman Demidov <roman.demidov.nn@gmail.com>
Subject: [PATCH 5.10 262/516] wifi: wcn36xx: fix heap overflow from oversized firmware HAL response
Date: Wed, 28 Oct 2026 17:56:54 +0100
Message-ID: <20261028170009.699730897@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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
@@ -2835,6 +2835,10 @@ int wcn36xx_smd_rsp_process(struct rpmsg
 	case WCN36XX_HAL_8023_MULTICAST_LIST_RSP:
 	case WCN36XX_HAL_START_SCAN_OFFLOAD_RSP:
 	case WCN36XX_HAL_STOP_SCAN_OFFLOAD_RSP:
+		if (len > WCN36XX_HAL_BUF_SIZE) {
+			wcn36xx_warn("HAL response too large: %d\n", len);
+			break;
+		}
 		memcpy(wcn->hal_buf, buf, len);
 		wcn->hal_rsp_len = len;
 		complete(&wcn->hal_rsp_compl);


