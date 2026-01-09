Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A4E835A943;
	Fri,  9 Jan 2026 12:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960957; cv=none; b=Ktu9pB/ntzP/48YL3k8o7n+Mm1Kd6o9C5wLKf3SZhWdsjcCM0DJzlsDi0cCSNcONZyll2gm3kYTNv0DFGnTQuAckCP8VXAdPEwCi1LRgJuG40uYa70et8Vex6lk64EdD3ISd+jHUQ5VnpBiGGdGL1Ozik0ZpEYJQc9+R5SjUSLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960957; c=relaxed/simple;
	bh=MLRzOcwe52rOz00AychhaKP/WI1J/UZhOGiTEdjhGR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K75BlrVw4kyEwpv1iR/4NGTGUmnEEVOPZjQzwfUCVZuDQ5wLwXfA5iX47+fwBo51ssIYIS5DRbAPDjLuhaljgkvj4lgpmtJ3MypxLPOV6UZHGgYeObVCphJTXUOCbQ4RMD3EVpYpC6xo9hSPxoV+YQO9ckX1rkJWjyLhNAd46js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HXI4ouVs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HXI4ouVs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 828E8C4CEF1;
	Fri,  9 Jan 2026 12:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960956;
	bh=MLRzOcwe52rOz00AychhaKP/WI1J/UZhOGiTEdjhGR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HXI4ouVs0ddKy3Qp2vs7QCpI8u2r1tJxJohNIiiGRyAJkB5OMkqwLGAuyPOtK2wfS
	 YGitJJO1Aa1la5VXCGl06mank3H4fdvrHTQ2kRGGoYEMsMIQZDhUBMmFhwEHleTLlH
	 hQ72giIhXc4G+PJ/c52iK8Ujv7g0gaO5cstFq95Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Hitz <christian.hitz@bbv.ch>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.6 567/737] leds: leds-lp50xx: LP5009 supports 3 modules for a total of 9 LEDs
Date: Fri,  9 Jan 2026 12:41:46 +0100
Message-ID: <20260109112155.330979030@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

From: Christian Hitz <christian.hitz@bbv.ch>

commit 5246e3673eeeccb4f5bf4f42375dd495d465ac15 upstream.

LP5009 supports 9 LED outputs that are grouped into 3 modules.

Cc: stable@vger.kernel.org
Fixes: 242b81170fb8 ("leds: lp50xx: Add the LP50XX family of the RGB LED driver")
Signed-off-by: Christian Hitz <christian.hitz@bbv.ch>
Link: https://patch.msgid.link/20251022063305.972190-1-christian@klarinett.li
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/leds/leds-lp50xx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/leds/leds-lp50xx.c
+++ b/drivers/leds/leds-lp50xx.c
@@ -56,7 +56,7 @@
 /* There are 3 LED outputs per bank */
 #define LP50XX_LEDS_PER_MODULE	3
 
-#define LP5009_MAX_LED_MODULES	2
+#define LP5009_MAX_LED_MODULES	3
 #define LP5012_MAX_LED_MODULES	4
 #define LP5018_MAX_LED_MODULES	6
 #define LP5024_MAX_LED_MODULES	8


