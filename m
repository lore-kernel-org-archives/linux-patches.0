Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 107B5415F2D;
	Tue, 21 Jul 2026 18:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658496; cv=none; b=q+04yql2GXaYsaIp5ShD1cXBBURMoasjK//GH7aTvdANSe8UaeY3JapEPIFlRKMB0q6LHCopPzsLHqHFkEuRUci1EIW6M+ncCzyYR7+/O5EG+Qf7fRzhUtuRax+0nHqjxl4fZM43GZf5SvRMAdu2zVkkEFvNteEOOPhFVOx31t4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658496; c=relaxed/simple;
	bh=jDz/cuIrH3pKzr8LbYv7r1Ko48s2aZfEFi1StCNTEfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CgKKXcMnBZFqIgVulLghMffLYQO49bl0UrgKT1BP40YFglXRgFkWrsg839BgfH3z8ss175iw1nD46lNRrCk7Nz+xMW9o5sdJT6e4czOi72dMbWpmwOOYaFHAKZYTEESuywlC+M6dv4Aw5mTsOn/obmS3dNxCi15HCUSGae9noFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e2Hycwdj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e2Hycwdj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 750331F000E9;
	Tue, 21 Jul 2026 18:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658495;
	bh=KRchuBHD3vWAkJcaPBG4PlCtF47TZb1sZGvjPGAU3jQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e2HycwdjqDwDyoiXH26YoVI/2/heccv4vbheEE9QBisgVGo+uW9AJa81ZRVSljS0C
	 h5DBhNnk7+eFb81MHOQlhYQoIRXi4V9mL7ghO5NCwIZYQl01GOWjcJFEQ8vkZ9kyxD
	 SzDOdOIYGSUTUgbEIjVska7mO8bQmm7Ess7R4kTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ekansh Gupta <ekansh.gupta@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Nickolay Goppen <setotau@mainlining.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.18 1112/1611] arm64: dts: qcom: sdm630: describe adsp_mem region properly
Date: Tue, 21 Jul 2026 17:20:28 +0200
Message-ID: <20260721152540.430346948@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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


