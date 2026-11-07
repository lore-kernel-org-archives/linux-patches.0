Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063860;
	b=Sko6U0o/1DWIDEI3z8nXpHuNxbkxRRaCfo8F/YYPoRby5G+eiLEeDKvmvM08nnutnCBs
	 HApLPtREawxWV86OMq5RWRxjmWrnx8tB5VXlSkW0vQzZFNA0RNhJXg0GDyL7OM+G8EJbE
	 l1GU3rdiCBTjF1N01vvsX2rGUm9aQ1F6fjm+muCWyThiCl2haW9HwhKMzVRSxJNPgGjpq
	 VgATbHbZhiJlV3lCoGt4upqkd+YsJ4Tt5yg0HfZ+rX5Kp//YS0QoLL76NPGZaXDcJTPHx
	 3UDpQtKqNSzTtEYShVtJnAfsFbUnGVZMy91sIfYdf1NE7OUQCQmWc8h9go9AeOsvp8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063860;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5h9vuvEqUCqSsD2awmeSgm7Ub1uIHVBE6QXVF38Rmzs=;
	b=wafuNkWCdHIyqvQrDH1+k++4U72GYP4h5vcCGT9+AdhXpVOZwfFdZzO/hyVODzqqqNCe
	 JVsE2hUZ/q4PcrE/UFV7N+dkKVURYdMwS3+u+rvUk73tn720TqL1LDo5ifFpetw78nk5C
	 dLxDdhaMRxb/JhMrrpAnTU4TMdNx6SZgClJfjw119vwXKk4ozvaXq5oR5l8BELuKHHAuw
	 oEFA9BLnofXimGFfn2VoQM1aqv73NczWl80uzNtrzQ98oqcb5CDpS0orS3oPwexqGe1lM
	 IgrH99hYSBQtq5/GncFOuMgyn7/JZ+WHBHqcSh47pDZiYBdPAZ1YXKrQVhf8CNO4RXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ukYznIaP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E25D7606A9CA;
	Sat,  7 Nov 2026 15:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ukYznIaP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FEEE1F0089F;
	Sat,  7 Nov 2026 15:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063859;
	bh=5h9vuvEqUCqSsD2awmeSgm7Ub1uIHVBE6QXVF38Rmzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ukYznIaP9ANNVKVctQp2NejAF+Jr0ii4T29e82HukeiE8MuYQvgnxVVCCnwfIXhHN
	 WFum5Rhejzrab7KPLq8vG/0YJLfTq5FX98ERsr0CRAi8/gxS6ulTlNwWHNTyHrHqym
	 mWPSJeCDQTRVRs5x3hKx/+Eare2YZUxEBS90b1eM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david@ixit.cz>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0067/1257] arm64: dts: qcom: sdm845-google: Set i2c3 frequency to 400 kHz
Date: Sat,  7 Nov 2026 08:39:23 -0500
Message-ID: <20261107134941.246327059@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Heidelberg <david@ixit.cz>

[ Upstream commit a317bee7cd894188d99b4edd841744f70ed9cd8c ]

The Device Tree found in the downstream kernel for this device doesn't
explicitly set a bus frequency, resulting in 400 kHz being chosen.

This upstream DT also lacks it, however that results in a different
default value of 100 kHz. Set it to 400 explicitly to match the
downstream kernel.

Cc: stable@vger.kernel.org
Fixes: 10f91b0dfaf6 ("arm64: dts: qcom: sdm845-google-common: Enable NFC")
Signed-off-by: David Heidelberg <david@ixit.cz>
Link: https://lore.kernel.org/r/20260902-sdm670-sargo-nfc-v1-1-bed1cbbffc46@ixit.cz
[bjorn: Updated commit message based on suggestion from Konrad]
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845-google-common.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-google-common.dtsi b/arch/arm64/boot/dts/qcom/sdm845-google-common.dtsi
index 9e952f9862f24..f73d4ea57705f 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-google-common.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845-google-common.dtsi
@@ -392,6 +392,8 @@ &gpu_zap_shader {
 };
 
 &i2c3 {
+	clock-frequency = <400000>;
+
 	status = "okay";
 
 	nfc@28 {
-- 
2.53.0



