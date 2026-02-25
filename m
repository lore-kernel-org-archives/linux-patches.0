Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E4F4285419;
	Wed, 25 Feb 2026 01:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983889; cv=none; b=mML+HXBqwzHi8ubp45P1k5th9mKGBUCy0lN0JMrhT0LDR4tEAquNJAciYjHysv+apPbMuviFqkXQbAmkf/a4YyKl3iNRsYN5Mi7Y/lqp5jkvULdYLCDCUTQlKA5F4JQR+rkCbTnDBCRCAFz903p74xV2a1vlLVyJfo4t0EyAX5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983889; c=relaxed/simple;
	bh=cQhU8V1KP+BrbAyoqCQue4bR7RUYhkwfAJVEO+16+4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GvEB20xNFBTACV7bBkSFAvYVBk95gvuqYDLwRtJS6g4/KKWYx50gCPSkU6bOy11UDppv3ZkJL/96cI12UElZXYxs7q0fGcY2vL/T3b80Yj9+RJLyRz9pgH54BSpCjfPsQB9aWMbxyi4VSZGjcsKWKS5OqedFZ0ftT9k/OPpqnKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ybzms/hb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ybzms/hb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC00CC19424;
	Wed, 25 Feb 2026 01:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983889;
	bh=cQhU8V1KP+BrbAyoqCQue4bR7RUYhkwfAJVEO+16+4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ybzms/hbe2Q3ar06PkpmFi3J8+bdLCShqoTigYM222vcwyP7QZgoJx609NYu8IINs
	 nDJ12CUfiC+39oh2kj5+IdK6t7Hpk63vQdQibUJAX/Y7dJFMTGydSGcR56cEpXJI/s
	 ML5EZfg+3kTaGKh8Jiw4oYxuRNEmFEqSLAct6JY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Casey Connolly <casey.connolly@linaro.org>,
	David Heidelberg <david@ixit.cz>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 135/641] arm64: dts: qcom: sdm845-oneplus: Dont mark ts supply boot-on
Date: Tue, 24 Feb 2026 17:17:41 -0800
Message-ID: <20260225012352.411222368@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Casey Connolly <casey.connolly@linaro.org>

[ Upstream commit c9b98b9dad9749bf2eb7336a6fca31a6af1039d7 ]

The touchscreen isn't enabled by bootloader and doesn't need to be
enabled at boot, only when the driver probes, thus remove the
regulator-boot-on property.

Fixes: 288ef8a42612 ("arm64: dts: sdm845: add oneplus6/6t devices")
Signed-off-by: Casey Connolly <casey.connolly@linaro.org>
Signed-off-by: David Heidelberg <david@ixit.cz>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251118-dts-oneplus-regulators-v2-1-3e67cea1e4e7@ixit.cz
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi b/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi
index 51a9a276399ac..35d105ff689b9 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi
@@ -160,7 +160,6 @@ ts_1p8_supply: ts-1p8-regulator {
 
 		gpio = <&tlmm 88 0>;
 		enable-active-high;
-		regulator-boot-on;
 	};
 };
 
-- 
2.51.0



