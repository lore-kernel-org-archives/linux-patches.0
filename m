Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00298364EAA;
	Thu,  8 Oct 2026 17:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791479532; cv=none; b=Cof2Q3JKTSMOXItNU/ODqGyp0Nw2u6sEeUpiVwlGSnp3bKY1NdUFaQvB8XnIz+3dsKYlZFVT2/60T8qoykbd5d3e2M/NI6CZKzqzoviciqpvLoHuHap3aCKwlPEhvbZ0aa8UxqxgdNXrLmLlo7JmDN1VZerIJUw1G0uQyKjjMto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791479532; c=relaxed/simple;
	bh=P28ojFz7RA7nhw2sMlWjvF7SYbVOPAyg3OPGn4C7gEU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=QH3w8i3gdjw3HJy4gdBnmfCz8q7QdX3st7l+gbuSpyYIHMh4mWM18z30LPWE8jy0Sm3ESCac95kqsFeAU0DWKhEh1yh7jHZ/9dR5y49GSdwI8wK/NlO3EG3u3oWxa0TSWLtly8xXDtiRHxB6tEVAAhC3FVZI+v3vVUKZEGf8m8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=XlXdhU/8; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XlXdhU/8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=Ib53W/id8Ca06C76erYCzQHO3f0GbCh0EqPrtlVOKVg=; b=XlXdhU/81WApKUskzstvcZML/I
	pNtNNgZGYCutJ4SCGV83UglAIBgLWOfF2VzVfYbsNI1nepbrWsg4w96f8pKyFeMvf1ges2qmpz183
	5SrxUaEdItrzhjvEBFq/LLq4eM9HLGFnUSN29UvK3wh2G2ujyCeFAKI18ajIoxqz10L2dHRKlvE50
	Azaypu6fGHzM/54juz0wtxqb2AJx5u3f7ieAbZzMtdHZzjaSrBMKfH73VDk1S4u2Vx9wUkR2Xseoa
	gXjTwJukmYscZoYTHvckpURsHETXBSpy1/uczA0b73MKEsSnvDah0NfJv2ASnVa+IYa8A/I3IuaOK
	Q8jXN2Ww==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xErf2-00000004lFy-3QQR;
	Thu, 08 Oct 2026 17:12:04 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-pm@vger.kernel.org
Cc: patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	kernel test robot <lkp@intel.com>,
	=?UTF-8?q?Iv=C3=A1n=20Ezequiel=20Rodriguez?= <ivanrwcm25@gmail.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	linux-doc@vger.kernel.org
Subject: [PATCH] docs: power: supply: fix inline strings
Date: Thu,  8 Oct 2026 10:12:01 -0700
Message-ID: <20261008171203.3080111-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Consistently use `string` to quote code symbols.
This repairs the docs build warning:

  Documentation/power/power_supply_class.rst:211: WARNING: Inline emphasis start-string without end-string. [docutils]

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202610050416.L69x2Wpo-lkp@intel.com/
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
Cc: Iván Ezequiel Rodriguez <ivanrwcm25@gmail.com>
Cc: Sebastian Reichel <sebastian.reichel@collabora.com>
Cc: linux-pm@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: linux-doc@vger.kernel.org

 Documentation/power/power_supply_class.rst |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- linext-2026-1007.orig/Documentation/power/power_supply_class.rst
+++ linext-2026-1007/Documentation/power/power_supply_class.rst
@@ -97,7 +97,7 @@ AUTHENTIC
 
 HEALTH
   represents health of the battery. Values correspond to
-  POWER_SUPPLY_HEALTH_*, defined in include/linux/power_supply.h.
+  `POWER_SUPPLY_HEALTH_*`, defined in include/linux/power_supply.h.
 
 VOLTAGE_OCV
   open circuit voltage of the battery.
@@ -188,7 +188,7 @@ CAPACITY_ALERT_MIN
 CAPACITY_ALERT_MAX
   maximum capacity alert value in percents.
 CAPACITY_LEVEL
-  capacity level. This corresponds to POWER_SUPPLY_CAPACITY_LEVEL_*.
+  capacity level. This corresponds to `POWER_SUPPLY_CAPACITY_LEVEL_*`.
 
 TEMP
   temperature of the power supply.
@@ -209,8 +209,8 @@ TEMP_MAX
 
 TIME_TO_EMPTY_NOW, TIME_TO_EMPTY_AVG
   seconds left for battery to be considered empty
-  (i.e., while battery powers a load). *_NOW is a
-  momentary reading; *_AVG is averaged over a fixed period.
+  (i.e., while battery powers a load). `*_NOW` is a
+  momentary reading; `*_AVG` is averaged over a fixed period.
 TIME_TO_FULL_NOW, TIME_TO_FULL_AVG
   seconds left for battery to be considered full
   (i.e., while battery is charging). Same now/avg distinction.
