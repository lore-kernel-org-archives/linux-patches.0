Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D7DC372046;
	Sat, 12 Sep 2026 10:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208685; cv=none; b=f4eJnlEOLAXdn+SBeDwuJZDaLJJQ4+xvLZiRg6T1Gv++BEgBGHQgkUca6AsrQgPZY4cIn+gWrGiFYa/b4sb/kt1X4nQEHFm3PpOlkIqC7A2gVXNY5nw13DU2Gzt6WM2iHt7ijgaRgf5P1k8e9wsT38OdSRfdhMAK1rLy2oCoX/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208685; c=relaxed/simple;
	bh=IVY9lexcXfkJ9IiZwbA1/jfAJ0BlS8xtt8OGX+3sLlY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d0J76ouPryYhySb7YLp28GoY8C1lBwxlVIAKbZ/bcONYX7x/cfCqH9ScXmFg6G2gsMGzibj4bQgQ26Dx63LiY4JhiDISNrYfr3mTvxUsgbhCQzwMma616hw8xeoZUWW3sO6pWVK4PbblIRfiR/0DdmIaXNxL5Oualn89co2BXZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2BoUfGyi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2BoUfGyi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB7931F000FF;
	Sat, 12 Sep 2026 10:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208683;
	bh=9Or8WzccAYElFi5hswrrOFnM4tsecNyOh1lIXXj0BZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2BoUfGyiHY82Pg89JApKnuuYlFByDul3p2T2YXEy+tzMtHg9nYHgVI9MFkf6MYjs5
	 c4z/SHuVHznJIif9893svk+M2KXJl4RzUU2KlOb0w39uRVppSrFlvGmoL8RGmYQWD4
	 uIqsDHmTRq+3gGBI3ZNtxVQXaxXJTjlSwhttBoWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0667/1518] arm64: dts: qcom: sc8280xp-crd: Fix the pin index for misc_3p3_reg_en
Date: Sat, 12 Sep 2026 08:47:16 +0200
Message-ID: <20260912065638.524632020@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit 0e05c183f3b97427f00d619132ba5984494f6886 ]

The correct pin is GPIO1. Fix it.

Fixes: ccd3517faf18 ("arm64: dts: qcom: sc8280xp: Add reference device")
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260701-topic-8280crd_fixups-v1-2-3fe92ee9636b@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc8280xp-crd.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc8280xp-crd.dts b/arch/arm64/boot/dts/qcom/sc8280xp-crd.dts
index 490e970c54a24..5b2692bb1564e 100644
--- a/arch/arm64/boot/dts/qcom/sc8280xp-crd.dts
+++ b/arch/arm64/boot/dts/qcom/sc8280xp-crd.dts
@@ -182,7 +182,7 @@ vreg_misc_3p3: regulator-misc-3p3 {
 		regulator-min-microvolt = <3300000>;
 		regulator-max-microvolt = <3300000>;
 
-		gpio = <&pmc8280_1_gpios 2 GPIO_ACTIVE_HIGH>;
+		gpio = <&pmc8280_1_gpios 1 GPIO_ACTIVE_HIGH>;
 		enable-active-high;
 
 		pinctrl-names = "default";
@@ -921,7 +921,7 @@ kypd_vol_up_n: kypd-vol-up-n-state {
 	};
 
 	misc_3p3_reg_en: misc-3p3-reg-en-state {
-		pins = "gpio2";
+		pins = "gpio1";
 		function = "normal";
 	};
 };
-- 
2.53.0



