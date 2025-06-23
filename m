Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E8E930E84D;
	Mon, 23 Jun 2025 13:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685672; cv=none; b=kNk1h/LFgq6FuA8esAuudsgdwndqgRZMlmr0NnSQGzb3u4YFirq6ewDCXaDNtleQaKGiJQNyq3OZVTvK0tS2Jo70LRvXZxCEK6DOMlyW6S6wTJRetZKFzszyaGPN6AJYYENxR3FdF0BYhI9vPz/rPh8QxOLYZHwskfPfXVSklJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685672; c=relaxed/simple;
	bh=RRmkdQy/gZqKnjyostdrtQHKYJa+W4AR1adofNgv1fA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W/FKoThQfd9X9R3eL5UCogzj0PBokg8KQtUDVahQE8i5nETbNqAMEoPDRKDAiisBMxOPx8JPiAOJOeAFDYa5IvaPyBtvgT8x1K8v8pImjdde3i1MDMO21Cgd9r0OD9T/n9LoRFfONKKTqBKtzjRkq0xan2vYocozJHZZVjbTu74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0ZAQDoSg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0ZAQDoSg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1014C4CEEA;
	Mon, 23 Jun 2025 13:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685672;
	bh=RRmkdQy/gZqKnjyostdrtQHKYJa+W4AR1adofNgv1fA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0ZAQDoSgzoqRFm3O6wlpiJlg0QkszWHJlEW0F3GtC6H1OfCLBSzsAYgF95IhND450
	 8y1jIJd8q3W6MSyu+sQGC6uDkeJOdjVLTNDCivWQeRJ4oq/FAZ4hkC8XRNnTDNC+9W
	 QYoPNcQ3aUAvWVMezTpgnkfQbxlBl+5ZU3wRq8XA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 067/355] ARM: dts: qcom: apq8064 merge hw splinlock into corresponding syscon device
Date: Mon, 23 Jun 2025 15:04:28 +0200
Message-ID: <20250623130628.845053508@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit 325c6a441ae1f8fcb1db9bb945b8bdbd3142141e ]

Follow up the expected way of describing the SFPB hwspinlock and merge
hwspinlock node into corresponding syscon node, fixing several dt-schema
warnings.

Fixes: 24a9baf933dc ("ARM: dts: qcom: apq8064: Add hwmutex and SMEM nodes")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250318-fix-nexus-4-v2-7-bcedd1406790@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/qcom-apq8064.dtsi | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/arch/arm/boot/dts/qcom-apq8064.dtsi b/arch/arm/boot/dts/qcom-apq8064.dtsi
index 3f1002c34446c..ba6cc81684c86 100644
--- a/arch/arm/boot/dts/qcom-apq8064.dtsi
+++ b/arch/arm/boot/dts/qcom-apq8064.dtsi
@@ -211,12 +211,6 @@
 		};
 	};
 
-	sfpb_mutex: hwmutex {
-		compatible = "qcom,sfpb-mutex";
-		syscon = <&sfpb_wrapper_mutex 0x604 0x4>;
-		#hwlock-cells = <1>;
-	};
-
 	smem {
 		compatible = "qcom,smem";
 		memory-region = <&smem_region>;
@@ -360,9 +354,10 @@
 			pinctrl-0 = <&ps_hold>;
 		};
 
-		sfpb_wrapper_mutex: syscon@1200000 {
-			compatible = "syscon";
-			reg = <0x01200000 0x8000>;
+		sfpb_mutex: hwmutex@1200600 {
+			compatible = "qcom,sfpb-mutex";
+			reg = <0x01200600 0x100>;
+			#hwlock-cells = <1>;
 		};
 
 		intc: interrupt-controller@2000000 {
-- 
2.39.5



