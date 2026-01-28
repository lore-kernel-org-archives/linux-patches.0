Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5A3223EA92;
	Wed, 28 Jan 2026 15:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614884; cv=none; b=V2vtrqDKTW9/tq66qS8gpjpVMGmYgjUf5NVc0LSF6WhnkEQ3oVKzrLCvDJ58zCxa1s8ETH1bmmUDfhH6UGKoymJ4TZF4JP5hLCUw8wOaYGAi2/hZf2valbCd1BSTYyFtA1AwYnK9ZcnbpUkEhl1IsaF1EriVyVPrgxeYMSL7F1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614884; c=relaxed/simple;
	bh=m+F6vlEhJ4BAyYs8n8Rz/GrGAAuyfnBumLg/bBlDIwk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CWz8udiEfUGwrVu9mnCSYtu8pkX3LGUPkFaE++4vNwgQo2VZ3vJ8d6NyXZC3QmabVJBJmvBIlp0TFXdymtLqqENxS/UWyF5FS6+7/1/Z3unYvmeauEn1dX5cnn4yukYXX24+l88o+BxOWEk0oBMkb3tpJoJp/XtDrj4IVDVmmtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qHjGObKQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qHjGObKQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC1CFC4CEF1;
	Wed, 28 Jan 2026 15:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614884;
	bh=m+F6vlEhJ4BAyYs8n8Rz/GrGAAuyfnBumLg/bBlDIwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qHjGObKQWibivkutfTQ4mqRNWlGiIgsJ25wvo3npDoBupCE3H1JllREOf4gXHFoc7
	 1zDfiJLPvqJAA9iI7vxEC0ySZjnCYKMyp1QahlzAN5S6MALmdLNS1sCCZgnGVaS/DO
	 REEuCUsvYjywvMxoWAg4YpZRpLvVwbOGcfp+NoQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 008/169] dt-bindings: power: qcom,rpmpd: Add SC8280XP_MXC_AO
Date: Wed, 28 Jan 2026 16:21:31 +0100
Message-ID: <20260128145334.314444847@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>
References: <20260128145334.006287341@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit 45e1be5ddec98db71e7481fa7a3005673200d85c ]

Not sure how useful it's gonna be in practice, but the definition is
missing (unlike the previously-unused SC8280XP_MXC-non-_AO), so add it
to allow the driver to create the corresponding pmdomain.

Fixes: dbfb5f94e084 ("dt-bindings: power: rpmpd: Add sc8280xp RPMh power-domains")
Acked-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Link: https://lore.kernel.org/r/20251202-topic-8280_mxc-v2-1-46cdf47a829e@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: 5bc3e720e725 ("pmdomain: qcom: rpmhpd: Add MXC to SC8280XP")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/dt-bindings/power/qcom,rpmhpd.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/dt-bindings/power/qcom,rpmhpd.h b/include/dt-bindings/power/qcom,rpmhpd.h
index 73cceb88953f7..269b73ff866a8 100644
--- a/include/dt-bindings/power/qcom,rpmhpd.h
+++ b/include/dt-bindings/power/qcom,rpmhpd.h
@@ -261,5 +261,6 @@
 #define SC8280XP_NSP		13
 #define SC8280XP_QPHY		14
 #define SC8280XP_XO		15
+#define SC8280XP_MXC_AO		16
 
 #endif
-- 
2.51.0



