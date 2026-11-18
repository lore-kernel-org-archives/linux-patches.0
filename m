Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033738;
	b=KneJ281qyvDQoBe0mZmPu4RP1jVcVaDEiExTjHIMYfstdqiZrIEDD+sJdfsxr0FsX1XC
	 +oq8iIZWWjCY6pBv6+sfSLKmfvMMIeFI8P1HwHbFa/2GHv1KSovNZ42cEKwEqisAlJvw8
	 m8RAWihJkT9dTCi1UwuRihuDXZGst+1t8zDpu64e5JQmDMmfrCvjRwjcBIK4rQBPHGQbm
	 WxDRXFaMAzrSVkek3ffZtXyQoJnD6a77MWJ/Dn/J4O7G4OOTYxbnWmhy4J8syo4BSuZaA
	 EWFFLtppmZT7mfKvzX65WWP2jqNSuTmvC2oa7OptR5ifwCuqLPiTQrkSschXcWscKbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033738;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=d/WZZUI1jz4gtzv0s7/QgKK7LbUBMrSqxm60qdtazqw=;
	b=UxOvUYe6ndeb8XKpifvLPh4ExMpGdAFAygm2Lqehdwnmc6Hi3LzUZXsqyTjND1sewstD
	 JgYBfRrYFM3sZYWobCLpFsTief/IJXSESwVdsFt7ZNoBH6HApO9zwwRFtfON7bnyCAkC+
	 jYugpm4j6uR9UId7+cDHMZwuwRTRKmnqTItg0ho4nkSniB4NzpSNByw9+YudpO7rVa6XU
	 +loLL7ma4JSu/W3ZmUf0xwmIzCqTVLOKQwwnuvcncL7pBFZS9b8u9SQKCjex7RWuU3zSf
	 XL3+HXF2VLyJO8Z1uI/I2/QsdBVivywlggtRnwi91RigFD0KMx8P42t9V3e8oMuHKbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Amy1t+nt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D5B2606A332;
	Wed, 18 Nov 2026 20:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Amy1t+nt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 848821F000C5;
	Wed, 18 Nov 2026 20:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033738;
	bh=d/WZZUI1jz4gtzv0s7/QgKK7LbUBMrSqxm60qdtazqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Amy1t+ntjXxWVqEOetUlvxIGZGiopR1+ghqUYx+/kYH0M3uVzGimbB9dhl6W4widv
	 pJ//g5ceCX2+rdl3dGPumhonexAvdmK5c+raWqgorK0CEoeTH9tkLsQgLo3a6VTx2j
	 5pv1OGo1TdbM3F5NOWO++QcH+c/iT0eBuTK+9rHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david@ixit.cz>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0069/3318] dt-bindings: arm: qcom,ids: Add SoC ID for Snapdragon SDM 850
Date: Wed, 18 Nov 2026 15:11:31 +0100
Message-ID: <20261118150316.091022953@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index be12e1dd1f38f..32dc6fc24d412 100644
--- a/include/dt-bindings/arm/qcom,ids.h
+++ b/include/dt-bindings/arm/qcom,ids.h
@@ -183,6 +183,7 @@
 #define QCOM_ID_IPQ8078			344
 #define QCOM_ID_SDM636			345
 #define QCOM_ID_SDA636			346
+#define QCOM_ID_SDM850			348
 #define QCOM_ID_SDM632			349
 #define QCOM_ID_SDA632			350
 #define QCOM_ID_SDA450			351
-- 
2.53.0



