Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AD575208D2;
	Thu, 17 Sep 2026 17:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665858; cv=none; b=jVP85nuyczsrWewEyajM1eEZzNp0y79ju720n3HSKV9Pg92KQZ60kBjPTvHwbsZBrgyxwovEUFGpMFlL6Htxkceq/INFz5bcBYigUmSy9CkFp+rW2YMRm6tJ4otjuucnh2Z63X8965wMHf+Q0yTKlWt68gh2d7MU05iQgJhiWiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665858; c=relaxed/simple;
	bh=ciHoykVn8drx3tMdKTfXttBCMBGBgXFawP1+en4Z3es=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AS8qC+rM+mapKdold2IVxm98SRC7zzJJ9HuM86ewPlCfL5xhOE8/lgQQ+tU3Px+PQ/MS489xzXhnCnOa10AeypIbwQ8fXWH+ovY9mbrTepvWnbP2clKgK6A7WMLb3379QKNfwKXX2k3yKCRNqDp1FaISAYgZ+e3ZQE4YgaXyl/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SpucGEM8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SpucGEM8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 696D21F000FF;
	Thu, 17 Sep 2026 17:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665857;
	bh=RxRzTKNoUS8FTaCdcYsdFLqRv8mvVTLjqWVNMcnlVVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SpucGEM83DBb8yOUZAycI7g5vSVBmd1Me0sGP72VDtbXQW4Nu9hGWcREbdGnF+jVx
	 hNiHewCanTcUsPQjU2bhlPMzDaBxcUL7kBizRN+qNbclmKy/WEim+k76z7nhBRd2Ac
	 DVIOBOsdwJrA4y3mHeDf94zwYTC4Oj3YczTORO20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antonin Godard <antonin.godard@bootlin.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0843/1250] Documentation: hwmon: replace full-width colon by a standard ASCII colon
Date: Thu, 17 Sep 2026 16:10:38 +0100
Message-ID: <20260917151614.806350321@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antonin Godard <antonin.godard@bootlin.com>

[ Upstream commit 013c5a93e8062014177d68af799e8867cf03958d ]

It prevented the pdfdocs target to complete, prompting the following
error:

  Latexmk: ====Problematic refs and citations with line #s in .tex file:
  Missing character: There is no ： (U+FF1A) in font DejaVu Serif/OT:script=latn;l

Fixes: 69001f21ded78 ("hwmon: document: add gpd-fan")
Signed-off-by: Antonin Godard <antonin.godard@bootlin.com>
Link: https://patch.msgid.link/20260818-doc-hwmon-remove-confusable-v2-1-c1dff1ec01cd@bootlin.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/hwmon/gpd-fan.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/hwmon/gpd-fan.rst b/Documentation/hwmon/gpd-fan.rst
index 0b56b70e6264d..3aecda2d82d82 100644
--- a/Documentation/hwmon/gpd-fan.rst
+++ b/Documentation/hwmon/gpd-fan.rst
@@ -64,7 +64,7 @@ pwm1_enable
   at full speed. Write "1" to set to manual, write "2" to let the EC control
   decide fan speed. Read this attribute to see current status.
 
-  NB：In consideration of the safety of the device, when setting to manual mode,
+  NB: In consideration of the safety of the device, when setting to manual mode,
   the pwm speed will be set to the maximum value (255) by default. You can set
   a different value by writing pwm1 later.
 
-- 
2.53.0



