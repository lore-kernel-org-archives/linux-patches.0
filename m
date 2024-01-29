Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5982F6F06C;
	Mon, 29 Jan 2024 17:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548462; cv=none; b=igo3P3fdYD+5OQGgLSOENPXnFJje+NmtjgZvqncb6/3jaxihp3anm4BFCsBOII4sgMoR214o0A0WrDyy5v5hUFELx3yxnglXhgykvuUOuCEAnhNTghTgh5zRvl1krVfy8Jtr4AddL9TBYk4ykp13LBgdqqdxLTV/sgrERN4K1aU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548462; c=relaxed/simple;
	bh=cFj73Qj2Ss8rRxv2qxDNd+LF/Od22ce5T6ObFs6V7Ec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UlfjG/sNcWPRe38v5jdxZ6xooZatkZn6w/x/n8sbi4nBZv1x0p1WU9G64dMWWPvF1LPZFDhOWK49w8463SqpvacBnQsInCEXyjCgOZ8QjUt0QZviI/kIWg5awEgnkB5MgOMUTryT+BB5tgz2T8q3qidnzow0q9mA2pz5M4uHno4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RKDHnoWw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RKDHnoWw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 211AFC433F1;
	Mon, 29 Jan 2024 17:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548462;
	bh=cFj73Qj2Ss8rRxv2qxDNd+LF/Od22ce5T6ObFs6V7Ec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RKDHnoWwXdRZ/IXAlt74Cfqbr7R9eUjPUu+D5XOgkCOVd48anRpWtiJx0tovBwB6w
	 r8DjMm2Iw5+gsYbhPU0XolK/2lnIRJNjAfU+NwVpKrzIsC6LCXjLjKVeZ6D01USD5P
	 Cml0V04vn7t2dS9WzlwD9bWtSfs2YBNbe/BUhuiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Cercueil <paul@crapouillou.net>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 6.6 075/331] ARM: dts: samsung: exynos4210-i9100: Unconditionally enable LDO12
Date: Mon, 29 Jan 2024 09:02:19 -0800
Message-ID: <20240129170017.119301418@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


