Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829456;
	b=l6b5dSDzV1OpHLyFuviIpC9a3D+0fuFczKNAHCmnq2eDeYXxuzF0UAOUK/4vmMqkQyq4
	 OUSXsm63oITBnR9ySKUsS6Eou0KP7VuksUzJCgzdRtaXgMtxkgbca7iQXFXZDbgsRMJ6Z
	 ETZah2+Da6qBUfiHUOKqN63GkIAS/DcbvTwVjcri9+k4e2z7zxme9V9t05E+6TEl+Ph8j
	 t4CI+RUOY6dTPXG4TMI6sN2lGAF3I21ZTGROaZUJUc9UL+4YqTMxKnBGPKBVB8QL96wAr
	 WUfskq/KkxwsDSkdg5QiVrMi0YZ7oD2uFx1oS5klJmIGRzyi6ygPONAHB32nXwGiIxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829456;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=d/yKohmDGRcmhSFX8OFJMZlFryO0LRYrsvJFWEd3BPs=;
	b=bQjhzb7QifFnJ6Pv8pyXHjx2hJHFzXKH4LSpvlkhKKv5jMLJ4hWV2EcXtOPCO6y2IqJR
	 FUDOd9mYMOzRvpFULcNVtRKLgSd8LGdlBVoDjw+9CzOcdaWR44OKuEaO2cfI0kBixbgi0
	 bbK3BcwIfZguWACIG/EhyNpMTwjn+9j3BOhOr/ztsOyq0nXRahwxKLIzTQCi0IKY8HIPJ
	 /OwGV26Z6Ev0tT/cZeLdwWzQfh9TGGoJM9YjDBY/SkFP2iUm/Bw6545ga4Fjoso2Yl8ZE
	 qN9VyXsOHBa7N8+nRVbDMZmNGVoBkgNpAzrGWn0DlX2X2d1bvcIstwzsT0KRfSPTVTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=11KuT9bP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D13D606AE36;
	Wed,  4 Nov 2026 21:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=11KuT9bP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AED21F00A16;
	Wed,  4 Nov 2026 21:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829456;
	bh=d/yKohmDGRcmhSFX8OFJMZlFryO0LRYrsvJFWEd3BPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=11KuT9bPZYCRCLxGtManCUULA9LkjLgpZd0eBHD3l9ZGYtvbz/K7LmwjLrj9qIWuB
	 EKz08TI6+WTuv+XxH8EJ0NUMyFwYMCp9PFu9EhFGMLxTk11ctf8ThIorW6yWt+Un6I
	 GghrjQO4N12FvQgSxEtEUU9Q8CJmABVCJC7Hz+a0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david@ixit.cz>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0098/1005] dt-bindings: arm: qcom,ids: Add SoC ID for Snapdragon SDM 850
Date: Wed,  4 Nov 2026 15:57:11 -0500
Message-ID: <20261104211046.379882746@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: David Heidelberg <david@ixit.cz>

[ Upstream commit d529495c991a2b7d07c01622e8b3cb5ec066acee ]

Add SoC ID for Qualcomm Snapdragon SDM850.

Signed-off-by: David Heidelberg <david@ixit.cz>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260627-sda850-v2-1-44bf46ade42e@ixit.cz
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/dt-bindings/arm/qcom,ids.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/dt-bindings/arm/qcom,ids.h b/include/dt-bindings/arm/qcom,ids.h
index cb8ce53146f0c..b7ff78cbaa8db 100644
--- a/include/dt-bindings/arm/qcom,ids.h
+++ b/include/dt-bindings/arm/qcom,ids.h
@@ -184,6 +184,7 @@
 #define QCOM_ID_IPQ8078			344
 #define QCOM_ID_SDM636			345
 #define QCOM_ID_SDA636			346
+#define QCOM_ID_SDM850			348
 #define QCOM_ID_SDM632			349
 #define QCOM_ID_SDA632			350
 #define QCOM_ID_SDA450			351
-- 
2.53.0



