Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26816431A4E;
	Tue, 21 Jul 2026 22:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674156; cv=none; b=Yn96c+pHqKZa7zvhL+CaPb0vdxDRc2cFwybnGS99nNA4LZ5VwBafXshFyMsqVMp2YvJCqtuwh5QZ94x/RjCHladuD3arlyvuOyV7ZmmxVftm0SeyMh2YonHveRA/EnG1Ie/L6FJAqtKs2uekhDOIGEtSDf3mFWadQTGBcFm83/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674156; c=relaxed/simple;
	bh=lDQhazO78t3vemLsiSMoj8LoSJT0HaIV7hXGkpB4FuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p6MPAkhOvw0HbUbdJpnSKAlfaUm0nGoCcDlftsahoOc4JmC0au0edyCE67YQskDxhtpZ3POtcfQLxqS4zJTkM/1dUhtW9zEd6FMkLLtSPDquU5RLMqSEVfHwH3XdKBnO/eidk4ZgXZ8bPCwWiLD5i5IyU/vl81AMayAbmEwkE5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cIcFNl10; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cIcFNl10"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 569B81F00A3A;
	Tue, 21 Jul 2026 22:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674154;
	bh=B34cEeseA5yNj8721KOMDSb5cFwP8y4wtLHgs0WtDrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cIcFNl10oweGOpYSiNs3cXZG/ws6TTUPS+w29k68GXcekOIbA5OfxJ0Ov91e4h682
	 9VuE1PCV2me3+iQln/5JVekiojYG0KUGOfV+GVQ6lX/VnVytPRzJUuV41WRY9Ef3C5
	 0jK4iZKSAhR7ikFmL8VK+xy4tHwL9JMKxxy1qIIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ekansh Gupta <ekansh.gupta@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Nickolay Goppen <setotau@mainlining.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 5.10 433/699] arm64: dts: qcom: sdm630: describe adsp_mem region properly
Date: Tue, 21 Jul 2026 17:23:12 +0200
Message-ID: <20260721152405.461383937@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -391,9 +391,12 @@
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


