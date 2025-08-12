Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C803E221FAC;
	Tue, 12 Aug 2025 17:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020842; cv=none; b=Iqc/lF24tQ1awYH249o5W7Mj3hVPeH80g/AvCzU5HEfvEnMTzmnNNnca/zdgesAZxkdziN5uUk08nAd4AsZIvmt4T3avwQwtLIEW8wLk7bWgy+wD4dtFVTtJ2NtZxxJOsdGH065UioTUbdRyRUMxvg9mS3Lu+BUoxq1XMMtEG9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020842; c=relaxed/simple;
	bh=qZBqCsmbbPm4MHKoG9OEBLAWUAnx96o90fY0kGltm/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gQI76lanuYgXheokeSKNxMxs21TOqrdt+MpVmy5Q8szbqKFyhnYLzC3qXZ0wKPozwEoJCx0eM88KN3gXhnZGGfiJuq/3TAIm8CJin2Jo0JrlMu/YYQLNSVofmf9dSiTNWsUvg5jwqoOqgSwi0DBHlTl1xpq4Ag5PEZpAe9NC7cM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CWYGaTJg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CWYGaTJg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37311C4CEF0;
	Tue, 12 Aug 2025 17:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020842;
	bh=qZBqCsmbbPm4MHKoG9OEBLAWUAnx96o90fY0kGltm/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CWYGaTJgSUwFGiroFVgqLhRzg+ieIUOA18gUneSxGynOWkPP4bycNh3TMvN3UYjFr
	 Mtjv3cgNLRR18nd3+ydMNGL3gjFQOoKRAlhcmJNJoVILx2AmQrEP5ZEgC8VBx9ca0l
	 0OdOKLUMek2vIQAHIj4V7daMbXr4CZh3R5/OCixE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 023/262] ARM: dts: vfxxx: Correctly use two tuples for timer address
Date: Tue, 12 Aug 2025 19:26:51 +0200
Message-ID: <20250812172953.956070603@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit f3440dcf8b994197c968fbafe047ce27eed226e8 ]

Address and size-cells are 1 and the ftm timer node takes two address
spaces in "reg" property, so this should be in two <> tuples.  Change
has no functional impact, but original code is confusing/less readable.

Fixes: 07513e1330a9 ("ARM: dts: vf610: Add Freescale FlexTimer Module timer node.")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/nxp/vf/vfxxx.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/nxp/vf/vfxxx.dtsi b/arch/arm/boot/dts/nxp/vf/vfxxx.dtsi
index d1095b700c56..d96148abf5bb 100644
--- a/arch/arm/boot/dts/nxp/vf/vfxxx.dtsi
+++ b/arch/arm/boot/dts/nxp/vf/vfxxx.dtsi
@@ -612,7 +612,7 @@ usbmisc1: usb@400b4800 {
 
 			ftm: ftm@400b8000 {
 				compatible = "fsl,ftm-timer";
-				reg = <0x400b8000 0x1000 0x400b9000 0x1000>;
+				reg = <0x400b8000 0x1000>, <0x400b9000 0x1000>;
 				interrupts = <44 IRQ_TYPE_LEVEL_HIGH>;
 				clock-names = "ftm-evt", "ftm-src",
 					"ftm-evt-counter-en", "ftm-src-counter-en";
-- 
2.39.5



