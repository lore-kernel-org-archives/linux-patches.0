Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE57343F8DE;
	Tue, 21 Jul 2026 22:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672262; cv=none; b=c/jfpeK9ygCx8qa8/BWnb3dO/3B5Otc7fBweZuIRqggCmp99Aes20z5IB1FqihgnfDAKivKcl6the5FQBWAG9ak0dGWsaDQU+vQpC5wJ2rgnZQstvUnHdcqaNhuPIi0sf+Fwi9afp1T00vhhlUKOcPEc+fwzlrezcGCQ6OnOlBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672262; c=relaxed/simple;
	bh=xdV8Antb7NJxnDZZTG47Qop3flPNuGAz2FsU0DkNH2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q7grvJi3TZOChaFIhNLl0OSN+iuluJtq9yraZ8muIArHQfytE+/j8C3M30wvLbN9oe7UB8fSVqMFn5HWcCalZY2TvU+HR9hLKEhFDPrEMA89EQ/JpWg2fsKH1gKj5e0YsyPaZ1SDzDOQTyuWgXtPxDZHWMXghjh6+j3zUfkoO+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gqtPuvEI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gqtPuvEI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 304441F000E9;
	Tue, 21 Jul 2026 22:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672261;
	bh=n4EiJm80v8qoR5Dl27gJh+J1/AR8QwXzLImpCOHw5OM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gqtPuvEI6qRAlk3GIelsDklE+QA9fZVMkXXEtQJe/fSmJz0vfU5FnoO5gL7QsEL4H
	 jZPC5w9LGT/di597jN4seiyZMgXuMi90T6Xo+3KP8KFUMJgC6Rtti1LWM10UgGlikG
	 Jf1iee85t0qo72Xlea0zQwyl4R9ojRfI3HqHa/JU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ekansh Gupta <ekansh.gupta@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Nickolay Goppen <setotau@mainlining.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 5.15 558/843] arm64: dts: qcom: sdm630: describe adsp_mem region properly
Date: Tue, 21 Jul 2026 17:23:13 +0200
Message-ID: <20260721152418.599669811@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -397,9 +397,12 @@
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


