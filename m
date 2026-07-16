Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77BDF2DF137;
	Thu, 16 Jul 2026 13:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209122; cv=none; b=PSThv5NZ+tgsjLj4q5NC0PHatt1ikafmqN00q1TlNC7JMJg9FF1ADaKl4gpGF+F8KwDYOt6MeKuteAB7shKbwSPzQumG3iFGMrF04DCYq8rcCVSio4WkSXi9bnf91OMF9U7vAxcBEaNQwUxprXdGRF+9HdZGGJ+Mlpu2Enskm04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209122; c=relaxed/simple;
	bh=y6MLFsSW98rIK/V6YTg/uS3HRpfNcuqHtUv/1OyKnbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VUxvHIL0eY5npCyv9/2RKc05n1KgY6oAIQkpi9ldL1XbOlP6VmWQrmYkctaKdSeV7TkR2EDClpbfIuxCZNJqvJV3q4Ahorw4G0SjnsZnc0qTwUelwKZIIK/9EQWIPJNlAW6wP264DZMWxeEsR5Tze3ICq4saETNG93mYnJS973A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AWEEURNV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AWEEURNV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE1681F000E9;
	Thu, 16 Jul 2026 13:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209121;
	bh=0uvX4G82DmVkFrHvyIOaoAYOzz9EfukamJaXgysH7SI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AWEEURNVLeeXDj+p9ox5Tsa1Igcl7AmDLBlmpJtaZ8Yy55oGNnvjdd0QwAxfD2owD
	 HyMze8pHbXeu1/D9x4b2bJ+79q7kDLhhhkpr0fr5RdkUETYIu/sjNHPhcrely63M76
	 XcReQ59cyWNVsf2+VsXHi5RNKkMPR82C8mh8UJSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	David Heidelberg <david@ixit.cz>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 7.1 064/518] iio: light: al3320a: add missing REGMAP_I2C to Kconfig
Date: Thu, 16 Jul 2026 15:25:32 +0200
Message-ID: <20260716133049.184453452@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joshua Crofts <joshua.crofts1@gmail.com>

commit 9efcc9ba9b2e940cc01e63d132ae741e4c5d09c7 upstream.

The Kconfig entry for the al3320a is missing a `select REGMAP_I2C`,
causing build failures.

Fixes: 1850e6ae7f91 ("iio: light: al3320a: Implement regmap support")
Signed-off-by: Joshua Crofts <joshua.crofts1@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Reviewed-by: David Heidelberg <david@ixit.cz>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/light/Kconfig
+++ b/drivers/iio/light/Kconfig
@@ -67,6 +67,7 @@ config AL3010
 
 config AL3320A
 	tristate "AL3320A ambient light sensor"
+	select REGMAP_I2C
 	depends on I2C
 	help
 	  Say Y here if you want to build a driver for the Dyna Image AL3320A


