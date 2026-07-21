Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 410CC46AA96;
	Tue, 21 Jul 2026 15:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648263; cv=none; b=jcpmthI2RXgtCoNYRri9KdWRYHSNKQFmZ7cPbSKltf4+TR4IAMIObTwgzTQvO3NhyIotk6Iuu7dX4+0zgb2NJbRKRhCg5o53WOsvaQ4MQyZT52ChoNn+wdUoFBnVvmZXUO1lVMgld25AGD1ZpG8dvH90rhiizXOv4c+CWrrH7iQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648263; c=relaxed/simple;
	bh=74w90/9hRJqkQpYwOij1b1r2IhXtbMjmbvnorbBzjQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cXXoam0CU4dildrtSkns1v+VaRJVV0Yi+Q5VAdf+wMSOX3hUO4g4vATiJsVvdZBS9lhR8PpBVBI3GuqSfKKdXfi8NEU3LDel/1UP1iXCq/dTIkFpdkRSnNEN3WQZrG/Voib6A1Z4+rEiCtZQ0S3i4AljOsrbQbHNjY5ntfa7qNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ppn4wV5j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ppn4wV5j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5B591F00A3D;
	Tue, 21 Jul 2026 15:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648262;
	bh=FfqcKNd8SowhKGrmDvdhPT9y0viBf0SYqgre4JvmuGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ppn4wV5jA/K9BYYXYSx5jUUNJ32EjmzDjdbLfnYpbKECKVg8/jcAfe+v/HmKrCPJz
	 KG4QvsgGyb6SC2WDkPg3fGySYvSth2ALgk5NSU8imspaEL0SKek1f6Oozr2rOZ40sI
	 AeiBGVwIKLRdXWZN0GlEuHTmGVYWkerszSb3e+EI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david@ixit.cz>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0090/2077] arm64: dts: qcom: sdm845-shift-axolotl: Correct touchscreen sleep state
Date: Tue, 21 Jul 2026 16:56:03 +0200
Message-ID: <20260721152554.814279640@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Heidelberg <david@ixit.cz>

[ Upstream commit 0689aa70fe28ba13eb1d8b10d50e08157ade9670 ]

There is no suspend state in the mainline kernel, use the sleep state
intended for this purpose.

Fixes: 45882459159d ("arm64: dts: qcom: sdm845: add device tree for SHIFT6mq")
Signed-off-by: David Heidelberg <david@ixit.cz>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260403-oneplus-nfc-v3-3-fbdce57d63c1@ixit.cz
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845-shift-axolotl.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-shift-axolotl.dts b/arch/arm64/boot/dts/qcom/sdm845-shift-axolotl.dts
index 7d81198bc499ca..b5fc93f0315fd0 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-shift-axolotl.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-shift-axolotl.dts
@@ -448,7 +448,7 @@ touchscreen@38 {
 
 		pinctrl-0 = <&ts_int_active &ts_reset_active>;
 		pinctrl-1 = <&ts_int_suspend &ts_reset_suspend>;
-		pinctrl-names = "default", "suspend";
+		pinctrl-names = "default", "sleep";
 
 		touchscreen-size-x = <1080>;
 		touchscreen-size-y = <2160>;
-- 
2.53.0



