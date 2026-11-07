Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060694;
	b=cmlYCTz+Hgf56NXn5Sw/Rn9nkDEivulSoPhnZqJywx6uVwuczQtTke24ccTahbiXbpP5
	 GLQz5hcM8Kr4kD/e/xh3XKdCQkpViFYFXIEZWld0wrzOtOnOyynxgOfavH0u1GnWbG/J1
	 iPSgzRJ9Z2pb86IfjN39542UGEIIvxQQFfYVlsNY3H6cR3hCjK0PYc8SEwNXg8VXUUS2w
	 IJ27F4xuDX8ewvxcLC0g0sP1QSkjJSTUQ/GF3sVTRMNED2dGNqT9UtE8GHt6tktSHOvjc
	 qcOzoq54kFwnIn0QCg7Lqlb3C6vAsa4m6w9E4N0n8qU5lfWTrkpymXiKKFphaqETwPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060694;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=03imVWkU0wRFn3p/nzhMfmbs2zK6/3bL0AsPALeqcxg=;
	b=V7ZALp2M+B6vW7CCqNCRAPf1Li7AsQHvnNM/4+1IT17Bi66ibL1Fmvo4FD0vKYWSA5Vr
	 QC24OvM6KR60sxeZmNPTNNa7BfngL+6trt5C3C9yvfdDIVdV7nXGKzujL9iHiH5l5h454
	 dbnmLqVTcdCMbWH1AXgEX03CI0vOxpTEjsA4ppeFuOgxBjc58QzuLrP+n9ncIP7ii6vJz
	 UDq2C4N5efz+IeU4R0IBV8Gk13GpG4DhnfxBVBy6ALSPydIekcz5TyLat1KUXD98q7Ppq
	 yPD1MeO66uOLzEDMvtSJZwLNUGZhCBOdDY/TV0ruAS3P0eWMM2k4baesXNi/dNAC5xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MenNV8iQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C30B9606A335;
	Sat,  7 Nov 2026 14:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MenNV8iQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 185B11F0089F;
	Sat,  7 Nov 2026 14:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060693;
	bh=03imVWkU0wRFn3p/nzhMfmbs2zK6/3bL0AsPALeqcxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MenNV8iQVo20B8kKZvJb37StScVn0+4LTnqbgk3ySXqPXTCgIAjoyuvHEeglPRVdE
	 cmVD0ICg5GUrsadot42kFYI5jal1oiBsxZiAGH+4zkIEBI1J/2EwRxC6AiKxLpvtOJ
	 AzV/uqlJEs8ibm6742feWAZFa2kAiZ8ZeM3KtXto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david@ixit.cz>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0083/1536] dt-bindings: arm: qcom,ids: Add SoC ID for Snapdragon SDM 850
Date: Sat,  7 Nov 2026 08:34:59 -0500
Message-ID: <20261107135000.006659304@linuxfoundation.org>
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
index 8332f8d82f96b..17a0c27b02f14 100644
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



