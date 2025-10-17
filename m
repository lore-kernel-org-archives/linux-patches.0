Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 276652F12D1;
	Fri, 17 Oct 2025 15:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713753; cv=none; b=rTXr2YZTf5Q7+4zqy7bNlA9KBkniXD9qQDtv9Yr4BMyRsyUj1Vq3OI4B/Y2NOwrKpcoRYmpIc98z6Nm66p4/72jzhV5My2YunVw87RbIsEfLnpAjc3I4Xi6vPVBqYmhD46gJEipEKcLUZZ/kTXWUWhx4GVSROD2rZywp/BPmywA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713753; c=relaxed/simple;
	bh=1O515QJVWDsTHWkaC5+VWPx/LF7ork42pIXMupK2nKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AeZvr2rnOWdZkAhl6M3Ev4N9QkDolY7wNBEhbpGGct5pGjg+DY5XilQDWBM7CqCGXdvbZUpPmsFr69ZxWOQWtBBZHc8jW2W5ZmcidiiiXFYOC0TrFegiBueCfX583HOYI6KzP6rtBatOCF0rb+xsXco8jiBOn6FIz94LJJYB0cY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=opWBkllU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="opWBkllU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4467EC4CEE7;
	Fri, 17 Oct 2025 15:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713752;
	bh=1O515QJVWDsTHWkaC5+VWPx/LF7ork42pIXMupK2nKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=opWBkllUH3vPNt4qCmnvmo8UYOwO/c5TM3N3C4Bx4zQDXBm7sqg9hswIVfKRtNtZN
	 yEXvMjP4USehA7R49JN7FwnGTpfD+fcovL61isYIvGOf2J0VzVlRDwXBHzE4lCCvX3
	 JJhyu1VtOnykh4RL9ttbJbCXBBe96LSsXs+AcU2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 6.6 107/201] pinctrl: samsung: Drop unused S3C24xx driver data
Date: Fri, 17 Oct 2025 16:52:48 +0200
Message-ID: <20251017145138.675969047@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -352,10 +352,6 @@ extern const struct samsung_pinctrl_of_m
 extern const struct samsung_pinctrl_of_match_data exynosautov9_of_data;
 extern const struct samsung_pinctrl_of_match_data fsd_of_data;
 extern const struct samsung_pinctrl_of_match_data s3c64xx_of_data;
-extern const struct samsung_pinctrl_of_match_data s3c2412_of_data;
-extern const struct samsung_pinctrl_of_match_data s3c2416_of_data;
-extern const struct samsung_pinctrl_of_match_data s3c2440_of_data;
-extern const struct samsung_pinctrl_of_match_data s3c2450_of_data;
 extern const struct samsung_pinctrl_of_match_data s5pv210_of_data;
 
 #endif /* __PINCTRL_SAMSUNG_H */


