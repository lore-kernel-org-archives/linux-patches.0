Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 341CD1DE4CD;
	Tue,  8 Oct 2024 13:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393656; cv=none; b=cD0TLf7X4b0LIZuC0jBjssEUpvbOrjk31w2G/MiaMMQfaK1Ht7soV8C84fpoaQUtWCUd0DImkHKAPD0ugz7gpSe2pATkndqNclHN/L+O2PkUMZ9lC4MyAWBkqFeax3CDdCxUlzRxPr1TVE8wjZ9nXWCZrKLhjIJnYig9nHRqImU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393656; c=relaxed/simple;
	bh=5JqyM5/rqLPRl7KZVVrY+A2h/m+6Fi8mpoRe0Y1BwNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nlGBUOCr9kAKHsERbRhSN+jXYh0HzKYrNFBbMHxiGrBD6xEGGCqRA9BadrZ/OO1yAqWRwz6xx+OdC3CPBhCDAl9jR/r1UsiiTn1098lCnCMpBnyUK1GuMIREjUqx/skqFyfmpX3EUTq8oDkdvIh9w00W7JXVFUM1/lSbiVSutJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SsS+E3EV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SsS+E3EV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48F2CC4CEC7;
	Tue,  8 Oct 2024 13:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393655;
	bh=5JqyM5/rqLPRl7KZVVrY+A2h/m+6Fi8mpoRe0Y1BwNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SsS+E3EVRw2+yzXqjnOOds9VHXS2SuOjBltyQRwIp1/3WNjmjEUEL0VzxOLyQaq9T
	 SgQwpGE8ZPhQWf+yPEVsx7DhyR31zEoZTPNxIpiZKqBbEMTxE91sfdkXUiVogrcVgf
	 rw1y3Sx4b1k91TPkL9f2dsjedMbm1p7s3blW5WcY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Virag <virag.david003@gmail.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 6.6 216/386] dt-bindings: clock: exynos7885: Fix duplicated binding
Date: Tue,  8 Oct 2024 14:07:41 +0200
Message-ID: <20241008115637.907869725@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

From: David Virag <virag.david003@gmail.com>

commit abf3a3ea9acb5c886c8729191a670744ecd42024 upstream.

The numbering in Exynos7885's FSYS CMU bindings has 4 duplicated by
accident, with the rest of the bindings continuing with 5.

Fix this by moving CLK_MOUT_FSYS_USB30DRD_USER to the end as 11.

Since CLK_MOUT_FSYS_USB30DRD_USER is not used in any device tree as of
now, and there are no other clocks affected (maybe apart from
CLK_MOUT_FSYS_MMC_SDIO_USER which the number was shared with, also not
used in a device tree), this is the least impactful way to solve this
problem.

Fixes: cd268e309c29 ("dt-bindings: clock: Add bindings for Exynos7885 CMU_FSYS")
Cc: stable@vger.kernel.org
Signed-off-by: David Virag <virag.david003@gmail.com>
Link: https://lore.kernel.org/r/20240806121157.479212-2-virag.david003@gmail.com
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/dt-bindings/clock/exynos7885.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/dt-bindings/clock/exynos7885.h
+++ b/include/dt-bindings/clock/exynos7885.h
@@ -136,12 +136,12 @@
 #define CLK_MOUT_FSYS_MMC_CARD_USER	2
 #define CLK_MOUT_FSYS_MMC_EMBD_USER	3
 #define CLK_MOUT_FSYS_MMC_SDIO_USER	4
-#define CLK_MOUT_FSYS_USB30DRD_USER	4
 #define CLK_GOUT_MMC_CARD_ACLK		5
 #define CLK_GOUT_MMC_CARD_SDCLKIN	6
 #define CLK_GOUT_MMC_EMBD_ACLK		7
 #define CLK_GOUT_MMC_EMBD_SDCLKIN	8
 #define CLK_GOUT_MMC_SDIO_ACLK		9
 #define CLK_GOUT_MMC_SDIO_SDCLKIN	10
+#define CLK_MOUT_FSYS_USB30DRD_USER	11
 
 #endif /* _DT_BINDINGS_CLOCK_EXYNOS_7885_H */


