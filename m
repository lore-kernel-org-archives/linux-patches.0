Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 634353368A2;
	Tue, 21 Jul 2026 17:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653987; cv=none; b=HSoa7aDOE4ejGR464Z/v+GuLTkFpRgO89KjtM6bfmfk9jd0NoZUwIPFKPzKHHj4QqatazuGGi8TDnn7DFowt2hRZii5AYhAcXyatJ+y2wGu9L0rLOdqr3CpFfDlJJEQd3UTltHuTEzImAtj3R+2JVnxAeSw6ec/1eTyx4NEkr+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653987; c=relaxed/simple;
	bh=WT+I4GW0U5FLe41Cfm/7PYWQz4nkyfCuXtWdBFI/uIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TamQHK7HEjaC6yEZwNl0zA6A/6NgJ37XWCKaFnhmwks4od+eqW85I2miWy6S/TiPbv8+iuY6Okqq9MCVDamHiwO8VEnzz8Mal8ED+/e5lnzTEhjP/u5OAvyK1W5I20R5nPgnO+Zlfz7jLIJb5s9ea/TK1cByrTosLtRQaRcGXqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jZO1/eoV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jZO1/eoV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C47EC1F000E9;
	Tue, 21 Jul 2026 17:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653986;
	bh=wawyXhEwcBg/aJ/U/xSvDEkMyNgDkacNYfOfrei4BGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jZO1/eoVghbLLTwZlc2JRRznetb5qxnjCroV5dGAdaa7dq1Y20jF723nmVSuIMtnF
	 E6bQc8wzypRofWmT33ErhBgoM3crmkgdCNzEvJbhQZA9xznTpmVnNf5UD8YHYWk4HG
	 y0U0N/2E8xBm/wihGvkJtHvUoBZJ86CfRIIbcqz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ekansh Gupta <ekansh.gupta@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Nickolay Goppen <setotau@mainlining.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 7.1 1535/2077] arm64: dts: qcom: sdm630: describe adsp_mem region properly
Date: Tue, 21 Jul 2026 17:20:08 +0200
Message-ID: <20260721152628.980811776@linuxfoundation.org>
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

From: Nickolay Goppen <setotau@mainlining.org>

commit ce414263e9ebe5080381a50cbdf9065c29816202 upstream.

Downstream [1] this region is marked as shared, reusable and dynamic so
describe it that way.

[1]: https://github.com/xiaomi-sdm660/android_kernel_xiaomi_sdm660/blob/11-EAS/arch/arm/boot/dts/qcom/sdm660.dtsi#L448

Fixes: b190fb010664 ("arm64: dts: qcom: sdm630: Add sdm630 dts file")
Cc: stable@vger.kernel.org
Reviewed-by: Ekansh Gupta <ekansh.gupta@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Nickolay Goppen <setotau@mainlining.org>
Link: https://lore.kernel.org/r/20260429-qcom-sdm660-cdsp-adsp-fastrpc-dts-fix-v5-4-16bc82e622ad@mainlining.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sdm630.dtsi |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/arch/arm64/boot/dts/qcom/sdm630.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm630.dtsi
@@ -494,9 +494,12 @@
 			no-map;
 		};
 
-		adsp_mem: adsp-region@f6000000 {
-			reg = <0x0 0xf6000000 0x0 0x800000>;
-			no-map;
+		adsp_mem: adsp-region {
+			compatible = "shared-dma-pool";
+			alloc-ranges = <0x0 0x80000000 0x0 0x80000000>;
+			alignment = <0x0 0x400000>;
+			size = <0x0 0x800000>;
+			reusable;
 		};
 
 		qseecom_mem: qseecom-region@f6800000 {


