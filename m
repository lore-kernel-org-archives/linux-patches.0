Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82192222581;
	Mon, 23 Jun 2025 21:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713974; cv=none; b=fuxJyJCAV86WQYnpXBdk7V3bXRWWIxy3HJM70MBxdedGwpj2h9YA1HgoBkWL0Y28/UXSKAnwxqI7D/mExscsN9p7wUTjq6aIwqySmpnurHLRDD+Jp1KpFllLKkI+Si8YnQQxsy2WBnT/dO5cY+IidZQoQ77ceDLkBoPCqB17hoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713974; c=relaxed/simple;
	bh=pG3HCB/1tcCzUhFlUkDN9XKomjFm5vRN4ViOZIMphzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uSjCiU6ADTSkO/usfPqDgblB2uk+UJekXgXrPxIhCv24xmIP7O3p5Jchorh7BrX4h+aBBf801U+xKlP+L+j/p0g20gCBmYJvTYbzuYCOBnrMVVSfRcuQGHtSxv2bCEYvzS+xp8WRgnMV3o5Bt2XBlOzKdSQSPSk03IPDRnOVSeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1VN2xhjg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1VN2xhjg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16B9BC4CEEA;
	Mon, 23 Jun 2025 21:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713974;
	bh=pG3HCB/1tcCzUhFlUkDN9XKomjFm5vRN4ViOZIMphzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1VN2xhjgY2JIuWgkRdrojzuaZkQS/8CfEw44fQbKZp4M3Ht7tsQPqOKZlg+ChubJI
	 XNOHBeLlAKNaNbq8lvN25+/lrA7hWcsi/OgOxYOIg2W5xs+lggCX0IERh+NnT592Gl
	 rasCsjSJBqQDZhup0sVww3IGq0PwoMzeZsNtRYjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Gow <davidgow@google.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Justin Stitt <justinstitt@google.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 5.4 219/222] rtc: test: Fix invalid format specifier.
Date: Mon, 23 Jun 2025 15:09:14 +0200
Message-ID: <20250623130618.883340111@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: David Gow <davidgow@google.com>

commit 8a904a3caa88118744062e872ae90f37748a8fd8 upstream.

'days' is a s64 (from div_s64), and so should use a %lld specifier.

This was found by extending KUnit's assertion macros to use gcc's
__printf attribute.

Fixes: 1d1bb12a8b18 ("rtc: Improve performance of rtc_time64_to_tm(). Add tests.")
Signed-off-by: David Gow <davidgow@google.com>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Justin Stitt <justinstitt@google.com>
Acked-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rtc/lib_test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/rtc/lib_test.c
+++ b/drivers/rtc/lib_test.c
@@ -54,7 +54,7 @@ static void rtc_time64_to_tm_test_date_r
 
 		days = div_s64(secs, 86400);
 
-		#define FAIL_MSG "%d/%02d/%02d (%2d) : %ld", \
+		#define FAIL_MSG "%d/%02d/%02d (%2d) : %lld", \
 			year, month, mday, yday, days
 
 		KUNIT_ASSERT_EQ_MSG(test, year - 1900, result.tm_year, FAIL_MSG);


