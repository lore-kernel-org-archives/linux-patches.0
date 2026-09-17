Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4596F4DE72F;
	Thu, 17 Sep 2026 15:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659714; cv=none; b=avXgEQJsSgL6uTZTImb0uvrQjjAUBllzqLXwJK0QfLZNQuubmew0rhBtZbpxj1cVGRa7jQZOVbbFI6cASW9W8AcyCK9N4/Y1cOkhV/QouAh8+n6wkgIYndngVYY2P07QxqZOvVfXpei6QbiLG/2RfJTLa3lbovPSiDrV8rfGSxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659714; c=relaxed/simple;
	bh=ZGj1tBrgtrYNkCupfAShV7qEiKWIEABj/qJXyYfzc8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b/wKnw2JZhWjsxZSiBK8LEYqrPHR/pU5Sri9WA7SUNIQ9cxAH3T3rQzPnX+cNwNyOsh4o07ZmdgvnA0S95WwHBxG14KP0YfJOrBysLEflQqDxOYoiS8Ue3I2l7/1Y5IAPtl8kEdL3H9GS3hIZR6MmxCkonNQDfJQkFk0ZStXN8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AJNegeCN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AJNegeCN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B3331F0089C;
	Thu, 17 Sep 2026 15:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659705;
	bh=LaFxZCmyBGy4S7S4337Ii4Yw2hNsCL4Mc7IBC7Tw0fI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AJNegeCNHYbU05nOP4DioDsNqQ+jnkgv4KcMBx2R7+D0q+BXnRSncCJowOU4uvtPu
	 8K68ckY02JTt3axP6EJ8AycNmorGywnfwktP1ypot4ppQFl0fv3pKBduM8u+8ARFui
	 R5pmZlsGtER0Go2cTsU7SWcJfgR76Ax8vMKxCjr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antonin Godard <antonin.godard@bootlin.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 329/733] Documentation: hwmon: replace full-width colon by a standard ASCII colon
Date: Thu, 17 Sep 2026 16:10:37 +0100
Message-ID: <20260917151359.716848848@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 29527a77fe882..b27657d330563 100644
--- a/Documentation/hwmon/gpd-fan.rst
+++ b/Documentation/hwmon/gpd-fan.rst
@@ -67,7 +67,7 @@ pwm1_enable
   at full speed. Write "1" to set to manual, write "2" to let the EC control
   decide fan speed. Read this attribute to see current status.
 
-  NB：In consideration of the safety of the device, when setting to manual mode,
+  NB: In consideration of the safety of the device, when setting to manual mode,
   the pwm speed will be set to the maximum value (255) by default. You can set
   a different value by writing pwm1 later.
 
-- 
2.53.0



