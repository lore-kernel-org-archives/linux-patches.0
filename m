Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01208174EC9;
	Wed,  3 Jul 2024 11:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005615; cv=none; b=YgE6AGrfgBQGiNBJWEjb9MlyqwSCoeqomZ/HSYtCX2Q601OndLXZ9wvnvyBv4ZIHldn0+AGaYASH5J/aLJUoosvm3csxTNNemvbhL/tuRRwrPyL0/hxi4T1EbjmWk/tv6CXKYaeTOmIX6aCw2Ny94/1GjGTxues3HUsvFTwrwk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005615; c=relaxed/simple;
	bh=dXDG4PtQvf+CXUoOaWQ72qNXdRkXAnguWDGVv/ac2NY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RSX5hzNmW2Ydesn0iqSHH9bXq0ZXWqth/2iCRH7pAXrUsW6LwbiBC/zeSgdwSeCaNr4J+qSFv5zlI+VzYW+kfAP/IWEnRh3w2XaZ4Q1y+R70qMPahWjIAE3Frq/hoppm+V9Inaa0qXhzhtT0vXw1dNImK/yaZ739RoHAOTY9Ri8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A2UUdTZ5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A2UUdTZ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78B94C2BD10;
	Wed,  3 Jul 2024 11:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005614;
	bh=dXDG4PtQvf+CXUoOaWQ72qNXdRkXAnguWDGVv/ac2NY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A2UUdTZ5hGxwINnIwGt6yCBPXl5gKjy3eSPkBy7BcGnIKjUk41xDiQAZSgS1C6git
	 qlflYW0CvJLXub+/culYJwJjXb/dHlygV3lUL2jIWJXt7Xom2QOMVc6ae19mVdr+Kr
	 vpV3Xv9LWju2iAdTtlYTrEICdte7jwW3myxyfDsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 111/356] iio: adc: ad9467: fix scan type sign
Date: Wed,  3 Jul 2024 12:37:27 +0200
Message-ID: <20240703102917.299431946@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lechner <dlechner@baylibre.com>

commit 8a01ef749b0a632f0e1f4ead0f08b3310d99fcb1 upstream.

According to the IIO documentation, the sign in the scan type should be
lower case. The ad9467 driver was incorrectly using upper case.

Fix by changing to lower case.

Fixes: 4606d0f4b05f ("iio: adc: ad9467: add support for AD9434 high-speed ADC")
Fixes: ad6797120238 ("iio: adc: ad9467: add support AD9467 ADC")
Signed-off-by: David Lechner <dlechner@baylibre.com>
Link: https://lore.kernel.org/r/20240503-ad9467-fix-scan-type-sign-v1-1-c7a1a066ebb9@baylibre.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad9467.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/iio/adc/ad9467.c
+++ b/drivers/iio/adc/ad9467.c
@@ -223,11 +223,11 @@ static void __ad9467_get_scale(struct ad
 }
 
 static const struct iio_chan_spec ad9434_channels[] = {
-	AD9467_CHAN(0, 0, 12, 'S'),
+	AD9467_CHAN(0, 0, 12, 's'),
 };
 
 static const struct iio_chan_spec ad9467_channels[] = {
-	AD9467_CHAN(0, 0, 16, 'S'),
+	AD9467_CHAN(0, 0, 16, 's'),
 };
 
 static const struct ad9467_chip_info ad9467_chip_tbl[] = {


