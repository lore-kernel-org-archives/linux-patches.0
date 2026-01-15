Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3332139E199;
	Thu, 15 Jan 2026 17:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497699; cv=none; b=MzlcdkfL8zQXmKRfPDqIAlW1Hqt9NVhIC5YjoTj7EKyuK/YjF7gx2vZN2Kykwam08qGX6L19yCNIlvszDdxLsBiXGmdtHXG+zUIHZhLihUXlz44YCrHmIIeNxDF475z8vglqEcuOUu48wCphJEIkBLnjqJRRxOsWB7Nq75Bwsis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497699; c=relaxed/simple;
	bh=FPG8zGzni/mL8mSYAlEzBvK5v9w9lAtDqaZoLbscZw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OM8sVRWBOGfMzul1LlDLtErDrKgeKnQ2bbFQbkeK40qL8i5gJyQ0C+aOKmwPOnOEWvwp+dgpqOjSCj4WBiTzqUM+uDnWt67IUCPLoTvNuzgpMM1KZV/AXOSEoQ+JkbnfGx2CcvEV69ZazgWAYLlhM1zyURASXFhcAOQvWH4nhZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V9fE5qGg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V9fE5qGg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB53CC116D0;
	Thu, 15 Jan 2026 17:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497699;
	bh=FPG8zGzni/mL8mSYAlEzBvK5v9w9lAtDqaZoLbscZw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V9fE5qGgkuOfZmT80iKmar0U+Y9KpaqOxOPFdevYgPybtgR3XUnTsqhoinCfh9ndF
	 /QXzdA68njSqbEo+Sn15lAilmXt9MvC0HadUbdEZcpm7WI1g2peuz6US9XmtceI8CD
	 1Y3OZpL5Tus2TuHB1LcW3pxPpyXRLX9HMW2Zy51k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	"Daniel Thompson (RISCstar)" <danielt@kernel.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 139/554] backlight: lp855x: Fix lp855x.h kernel-doc warnings
Date: Thu, 15 Jan 2026 17:43:25 +0100
Message-ID: <20260115164251.282065234@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 2d45db63260c6ae3cf007361e04a1c41bd265084 ]

Add a missing struct short description and a missing leading " *" to
lp855x.h to avoid kernel-doc warnings:

Warning: include/linux/platform_data/lp855x.h:126 missing initial short
 description on line:
 * struct lp855x_platform_data
Warning: include/linux/platform_data/lp855x.h:131 bad line:
   Only valid when mode is PWM_BASED.

Fixes: 7be865ab8634 ("backlight: new backlight driver for LP855x devices")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Daniel Thompson (RISCstar) <danielt@kernel.org>
Link: https://patch.msgid.link/20251111060916.1995920-1-rdunlap@infradead.org
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/platform_data/lp855x.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/platform_data/lp855x.h b/include/linux/platform_data/lp855x.h
index ab222dd05bbc2..3b4a891acefe9 100644
--- a/include/linux/platform_data/lp855x.h
+++ b/include/linux/platform_data/lp855x.h
@@ -124,12 +124,12 @@ struct lp855x_rom_data {
 };
 
 /**
- * struct lp855x_platform_data
+ * struct lp855x_platform_data - lp855 platform-specific data
  * @name : Backlight driver name. If it is not defined, default name is set.
  * @device_control : value of DEVICE CONTROL register
  * @initial_brightness : initial value of backlight brightness
  * @period_ns : platform specific pwm period value. unit is nano.
-		Only valid when mode is PWM_BASED.
+ *		Only valid when mode is PWM_BASED.
  * @size_program : total size of lp855x_rom_data
  * @rom_data : list of new eeprom/eprom registers
  */
-- 
2.51.0



