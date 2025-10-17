Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00D4632E14C;
	Fri, 17 Oct 2025 15:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714464; cv=none; b=skMsR+9jpeOgA0wgNksT+N/kubYsP3Gyi+5XbPyWxm5nKm5Obgjo8636MMK4ErsQwebf9ULooY57R7AYNvrENlaI63GZAEnZ46yIqpVvKdBA3M7hphF0p3U87iRFI68nxfQzhWC+0oozqFyBcTDQZiSh+mT634u7ZyLgTb6Vvns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714464; c=relaxed/simple;
	bh=EcDLBk68gkQkRq9XTynlSOvuMiKK2IypmfeLhGYfQzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KaKPa75pe6Jjxa1bChdUFCSzVRmgiNzYXwVXCbv3XvhdrF41FaXw9JUwuPGUp1ceixvA6PtjUH8uYLgd42zgpl2OIKrtGSMAKLCa+FZEPv0pNKZZp6LpJ/HMU40e7SD3G8mOejDrx0Dz26ETYSeWhh9uCttgYGWB2r91qOnP8kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QVnk2pS6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QVnk2pS6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84DA2C4CEE7;
	Fri, 17 Oct 2025 15:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714463;
	bh=EcDLBk68gkQkRq9XTynlSOvuMiKK2IypmfeLhGYfQzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QVnk2pS6QQYMN8sFQZ+xDRqMktpYULocDOG3LDKlqxr1Nk2CCbDhmQYxuBpawnyGk
	 zL6kowfb/F6ECiI/fdJ2Wyt6kgcmXPCseQi8MC0FYDdHvNDd72EBktPyXDZgKL16Cf
	 t99i7YYqgtC3N/j+x5d5Dd/BOwpKcuEUiOK90OWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 6.12 154/277] pinctrl: samsung: Drop unused S3C24xx driver data
Date: Fri, 17 Oct 2025 16:52:41 +0200
Message-ID: <20251017145152.748862217@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 358253fa8179ab4217ac283b56adde0174186f87 upstream.

Drop unused declarations after S3C24xx SoC family removal in the commit
61b7f8920b17 ("ARM: s3c: remove all s3c24xx support").

Fixes: 1ea35b355722 ("ARM: s3c: remove s3c24xx specific hacks")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250830111657.126190-3-krzysztof.kozlowski@linaro.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/samsung/pinctrl-samsung.h |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/pinctrl/samsung/pinctrl-samsung.h
+++ b/drivers/pinctrl/samsung/pinctrl-samsung.h
@@ -393,10 +393,6 @@ extern const struct samsung_pinctrl_of_m
 extern const struct samsung_pinctrl_of_match_data fsd_of_data;
 extern const struct samsung_pinctrl_of_match_data gs101_of_data;
 extern const struct samsung_pinctrl_of_match_data s3c64xx_of_data;
-extern const struct samsung_pinctrl_of_match_data s3c2412_of_data;
-extern const struct samsung_pinctrl_of_match_data s3c2416_of_data;
-extern const struct samsung_pinctrl_of_match_data s3c2440_of_data;
-extern const struct samsung_pinctrl_of_match_data s3c2450_of_data;
 extern const struct samsung_pinctrl_of_match_data s5pv210_of_data;
 
 #endif /* __PINCTRL_SAMSUNG_H */


