Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 886FC2D9ECB;
	Thu, 15 Jan 2026 17:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499081; cv=none; b=qz85YDgiViBbEO2zCjWixlC6XQciTMuyyCg0qhldTOZ+CmH0sooRgq+BYMs3rTLvkcoArBWeLz0Jo/YbjfUSrHqWv2MbcmBW/g2lWMDZWEnrliGyGEEXSQjj5l5+t/zgH992e8BRX+u6lYbEre4Q1o5FTzKHStWRPZXUuWaDEvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499081; c=relaxed/simple;
	bh=M/YUrDQzfiwagd5Wys3YRQJmYXAUWAmuAEFdCZ5oe7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f3SSOgmpixfMzF1OavGt+45kBbP5N/A1LJoisBqGFVLXDB3+1GXuimwueuLUftK1MNeZxLNKVLgdX5ncdhRI6StG55pvDIYdFlV5q0SnAtPH5T8zhrKxR1I3hclNz2X60DRAnnV2RCTmkUvrs1xI8U+teyJT36KMGnxbHNEiJgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1BSGNAY/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1BSGNAY/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 168A4C116D0;
	Thu, 15 Jan 2026 17:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499081;
	bh=M/YUrDQzfiwagd5Wys3YRQJmYXAUWAmuAEFdCZ5oe7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1BSGNAY/15RtresUk3o8vbT1e8dyGwsUukyYKJcWB1gpNyetvAZJn5AVvGv4opdXw
	 I5It+EQm4dBIEn0oO7vbG4R2B5xfATcdZv+Ajd10m54K5uxwsQ4IBdclxsquCfnYyh
	 +WYswbNXRjK6bN32bBHw9sPKrodbCrKoDu+phjco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	"Daniel Thompson (RISCstar)" <danielt@kernel.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 102/451] backlight: lp855x: Fix lp855x.h kernel-doc warnings
Date: Thu, 15 Jan 2026 17:45:03 +0100
Message-ID: <20260115164234.608167101@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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



