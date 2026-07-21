Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D7F2471264;
	Tue, 21 Jul 2026 18:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659323; cv=none; b=TDudIvbIX+tLl1JjNsncf3JauJ+ZR7b7BZ/SUWeRZqIHsr72ekLDFbgD2DLfNugb2YDdt461xEM/H1RJAqwoaJ8j4J7sUERi2X1uInFeZEBUnLNd6l4GXcUf6X/aXGlYRC+cpgK6keUGD0aeu2fpSqGWlIIwYYLLn+GW8dEXwg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659323; c=relaxed/simple;
	bh=sXQQOrFOX9ck6jJIVXLTSyWXZ6/BmxM/IIW6BEaaUxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rPnK1p/l6bnRca6Dz5X90zahPlCzM7OCTfT/Sxc3QCTuOYZetie46TH/tQRcvSaCpRg3F678dYpuhf4IcGOdyXHO/f3t8B0dY1ln4hyin1iUO6ltzwBFN9K59+npuJTzMmn9IfDUavv9L9FbIOyECGjjwlVp35XW+bicN5RfpQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eX6ydB07; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eX6ydB07"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7E211F000E9;
	Tue, 21 Jul 2026 18:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659322;
	bh=0StqpUFRv+fVHOZJrOylgF0D098eUrfDISYg3XTGNyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eX6ydB07d8P0BtqwJcKPXgK1TN0BoQA2Byv8zLZqxJFjm3EfNEJ8SOrI47Dx8r+Yj
	 DQuHTJIK/h3A8Cjzi28dkLXnOpXoCcKsVNjBpO2229ByTnUWrhAAptS0KVDeBWh9C0
	 eEfAerwWEKDw126sFooM1KNdPA4mmU/CcVIq2OwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.18 1440/1611] hwmon: (max1619) add missing select REGMAP to Kconfig
Date: Tue, 21 Jul 2026 17:25:56 +0200
Message-ID: <20260721152547.837275071@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joshua Crofts <joshua.crofts1@gmail.com>

commit 943a749bdffdd2132fab9240db890e07d93e1fcf upstream.

The Kconfig entry for the MAX1619 sensor doesn't contain a
`select REGMAP` parameter, causing build failures if regmap
isn't selected previously during the build process.

Fixes: f8016132ce49 ("hwmon: (max1619) Convert to use regmap")
Cc: stable@vger.kernel.org
Signed-off-by: Joshua Crofts <joshua.crofts1@gmail.com>
Link: https://lore.kernel.org/r/20260629-add-kconfig-deps-v1-1-8104df929b1a@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -1213,6 +1213,7 @@ config SENSORS_MAX16065
 config SENSORS_MAX1619
 	tristate "Maxim MAX1619 sensor chip"
 	depends on I2C
+	select REGMAP
 	help
 	  If you say yes here you get support for MAX1619 sensor chip.
 


