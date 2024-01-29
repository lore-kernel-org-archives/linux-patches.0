Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42D09158D71;
	Mon, 29 Jan 2024 17:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548062; cv=none; b=BuE5FbX24ugu7BsasTOi/xSDzaYj4RMR/TqHuO2oIdwwxRuYoOWX+ydhzC8FRH4mzsOBW2MzLES+W8krddymywvg6PYEhp1uUCJOEa8yUKryowk4iehaP48fqcrjg9xfZkwtM0utmfp68KIs8t/NfLc8xVWxzZD0l48SwS2tVyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548062; c=relaxed/simple;
	bh=IOch1ZMga5vIYHf6JjgXJ3xBiT3YzUypIS0y+4/J9aQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eYw++rq3M+CXYeDpiP1mKtAq3AoAch/scLXd7DnydIdnf6E0g46xaBZiFa52yxjrzqH3ZKCMDMm5HwfG/BLQVCkku4vfCH3fVOrCzZDrDDcrwftjKDk/PcusXggkcA1UyjbQI76070xT57uVOrsf+YBDEwgywNKCzdmXU3Xnszk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xObuVcLE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xObuVcLE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B353C433F1;
	Mon, 29 Jan 2024 17:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548062;
	bh=IOch1ZMga5vIYHf6JjgXJ3xBiT3YzUypIS0y+4/J9aQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xObuVcLEeHakognLsIz1RiaGSg+m0jsdNEKv+p5M3rR5nR/N5e3HeMBWeoFyedES+
	 eFCuE3ipIXXumIbjJpFqAiXRsTWr2rUkKhCmkof7plPJZgee321FfHl9CV6+B48AGa
	 c4z9/vToTVtCe8792BnF87h/532z21otgUOQ0Avo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Cercueil <paul@crapouillou.net>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 6.7 068/346] ARM: dts: samsung: exynos4210-i9100: Unconditionally enable LDO12
Date: Mon, 29 Jan 2024 09:01:39 -0800
Message-ID: <20240129170018.385517434@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Cercueil <paul@crapouillou.net>

commit 84228d5e29dbc7a6be51e221000e1d122125826c upstream.

The kernel hangs for a good 12 seconds without any info being printed to
dmesg, very early in the boot process, if this regulator is not enabled.

Force-enable it to work around this issue, until we know more about the
underlying problem.

Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Fixes: 8620cc2f99b7 ("ARM: dts: exynos: Add devicetree file for the Galaxy S2")
Cc: stable@vger.kernel.org # v5.8+
Link: https://lore.kernel.org/r/20231206221556.15348-2-paul@crapouillou.net
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/samsung/exynos4210-i9100.dts |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/arch/arm/boot/dts/samsung/exynos4210-i9100.dts
+++ b/arch/arm/boot/dts/samsung/exynos4210-i9100.dts
@@ -527,6 +527,14 @@
 				regulator-name = "VT_CAM_1.8V";
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
+
+				/*
+				 * Force-enable this regulator; otherwise the
+				 * kernel hangs very early in the boot process
+				 * for about 12 seconds, without apparent
+				 * reason.
+				 */
+				regulator-always-on;
 			};
 
 			vcclcd_reg: LDO13 {


