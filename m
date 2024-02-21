Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A815C79DBF;
	Wed, 21 Feb 2024 14:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525791; cv=none; b=LdC54y1pFNIe0lExh/OFA2dZM5eGU2IDsdqpOvM6sBPCE81xeyMC7JF8To04ro8tzcBrEDzZa6QXWhPC+V8ItiGfhKOmjBRoJ8a3VtFcTewZTwRi9pHh+CeKs6g5FFvjxcIgYGXgTjVTyBNRpTCyJzS9eoPjZ30536dEofVU1RE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525791; c=relaxed/simple;
	bh=P2IOd4ywgRN+1nK8iDRrg0O29GgZ8d5h18U9SS4LIvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gYDxu7HIU36WGPB2Ijs/PeyyLvJrYODNeSABJmMKiI5kKutXy58eNyZaAYEMHzYC0cVr9S9TpJ/QLO/BpKXyutiquDx9TCbiiThW4z05ziS4BUdo6EdvSPuCZV5GbduvKFZ7bvgS31jGVfYBfukjHbSAVEwbGdwHJC3yMnYahcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jcZiADcV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jcZiADcV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 153B3C433F1;
	Wed, 21 Feb 2024 14:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525791;
	bh=P2IOd4ywgRN+1nK8iDRrg0O29GgZ8d5h18U9SS4LIvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jcZiADcVTOuGlppGVTon5N9Mb9s8AEZQdx3bWLPviOUNqkNeBCHd4zrprVjvNQjZn
	 bhvdSfy61qPPB0Dy75MQMBCQ3yDCSAyZDwSX89RQ/n1Yz5c/Xv2dfRse+XunK7mvh7
	 HVKq57+qMoYzGs6cZ9Xj0m6TtZFoZedVZh16cLUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Rowand <frank.rowand@sony.com>,
	Rob Herring <robh@kernel.org>
Subject: [PATCH 5.4 266/267] of: unittest: fix EXPECT text for gpio hog errors
Date: Wed, 21 Feb 2024 14:10:07 +0100
Message-ID: <20240221125948.586943869@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Rowand <frank.rowand@sony.com>

commit e85860e5bc077865a04f0a88d0b0335d3200484a upstream.

The console message text for gpio hog errors does not match
what unittest expects.

Fixes: f4056e705b2ef ("of: unittest: add overlay gpio test to catch gpio hog problem")
Signed-off-by: Frank Rowand <frank.rowand@sony.com>
Link: https://lore.kernel.org/r/20211029013225.2048695-1-frowand.list@gmail.com
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/unittest.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/of/unittest.c
+++ b/drivers/of/unittest.c
@@ -2258,19 +2258,19 @@ static void __init of_unittest_overlay_g
 	 */
 
 	EXPECT_BEGIN(KERN_INFO,
-		     "GPIO line <<int>> (line-B-input) hogged as input\n");
+		     "gpio-<<int>> (line-B-input): hogged as input\n");
 
 	EXPECT_BEGIN(KERN_INFO,
-		     "GPIO line <<int>> (line-A-input) hogged as input\n");
+		     "gpio-<<int>> (line-A-input): hogged as input\n");
 
 	ret = platform_driver_register(&unittest_gpio_driver);
 	if (unittest(ret == 0, "could not register unittest gpio driver\n"))
 		return;
 
 	EXPECT_END(KERN_INFO,
-		   "GPIO line <<int>> (line-A-input) hogged as input\n");
+		   "gpio-<<int>> (line-A-input): hogged as input\n");
 	EXPECT_END(KERN_INFO,
-		   "GPIO line <<int>> (line-B-input) hogged as input\n");
+		   "gpio-<<int>> (line-B-input): hogged as input\n");
 
 	unittest(probe_pass_count + 2 == unittest_gpio_probe_pass_count,
 		 "unittest_gpio_probe() failed or not called\n");
@@ -2297,7 +2297,7 @@ static void __init of_unittest_overlay_g
 	chip_request_count = unittest_gpio_chip_request_count;
 
 	EXPECT_BEGIN(KERN_INFO,
-		     "GPIO line <<int>> (line-D-input) hogged as input\n");
+		     "gpio-<<int>> (line-D-input): hogged as input\n");
 
 	/* overlay_gpio_03 contains gpio node and child gpio hog node */
 
@@ -2305,7 +2305,7 @@ static void __init of_unittest_overlay_g
 		 "Adding overlay 'overlay_gpio_03' failed\n");
 
 	EXPECT_END(KERN_INFO,
-		   "GPIO line <<int>> (line-D-input) hogged as input\n");
+		   "gpio-<<int>> (line-D-input): hogged as input\n");
 
 	unittest(probe_pass_count + 1 == unittest_gpio_probe_pass_count,
 		 "unittest_gpio_probe() failed or not called\n");
@@ -2344,7 +2344,7 @@ static void __init of_unittest_overlay_g
 	 */
 
 	EXPECT_BEGIN(KERN_INFO,
-		     "GPIO line <<int>> (line-C-input) hogged as input\n");
+		     "gpio-<<int>> (line-C-input): hogged as input\n");
 
 	/* overlay_gpio_04b contains child gpio hog node */
 
@@ -2352,7 +2352,7 @@ static void __init of_unittest_overlay_g
 		 "Adding overlay 'overlay_gpio_04b' failed\n");
 
 	EXPECT_END(KERN_INFO,
-		   "GPIO line <<int>> (line-C-input) hogged as input\n");
+		   "gpio-<<int>> (line-C-input): hogged as input\n");
 
 	unittest(chip_request_count + 1 == unittest_gpio_chip_request_count,
 		 "unittest_gpio_chip_request() called %d times (expected 1 time)\n",


