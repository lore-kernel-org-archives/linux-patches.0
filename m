Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E2B1EB9E0;
	Mon, 21 Oct 2024 10:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507041; cv=none; b=TVmdaHPYji1EPupou5JzVnZUqSo1Bfc4CkKFXP/CBHn3K1cQioqalzHd939Kd9sJ33+36GLED0sRsHckAGvRpHC1bWXacw0tMh7bkLQ14Ks8uLe+o9Mu7SJTlr5HfsLjN3gPe2EzIXexrgpHTEaHMRfpFPSaogar66jAyyybrSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507041; c=relaxed/simple;
	bh=iqFjCN275NQEt8X8OCSiQTWc24M/YnN1LyULYltA7c4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DwFzH27mkSIGSayIl7i+FI9KhfFHRZrCQv1yuhHY+Sl3nvx+MeQW5LaCV22bM31Nb6Hh56mxnMCrK8Zfm/5xXhj8ItPQGYUfoUu/FlST0hq2/yNYbwysKNLQFEf1mHbBJ6b04dJ8JppPgPp0vsncEp52wnlTqKH5z13yiF2JYZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yhiQqopn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yhiQqopn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ECAAC4CEC3;
	Mon, 21 Oct 2024 10:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507040;
	bh=iqFjCN275NQEt8X8OCSiQTWc24M/YnN1LyULYltA7c4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yhiQqopn02wKLMOS4RB24/NLhnc2ipy6RdDZtCdsNni5hqzZIk8pYqFPTQaUd5p83
	 m+twcp4UpuwzZI4eZ6AKFxV0DZiSEW3PbJ4sttMTdxto3pzGkP4QUxWGX6XnnnTeT1
	 RoQhd2pCWNsCB6g37L9JrHGJVjk+PiQIyb9m33nI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 070/124] iio: dac: ad5770r: add missing select REGMAP_SPI in Kconfig
Date: Mon, 21 Oct 2024 12:24:34 +0200
Message-ID: <20241021102259.442187573@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102256.706334758@linuxfoundation.org>
References: <20241021102256.706334758@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

commit bcdab6f74c91cda19714354fd4e9e3ef3c9a78b3 upstream.

This driver makes use of regmap_spi, but does not select the required
module.
Add the missing 'select REGMAP_SPI'.

Fixes: cbbb819837f6 ("iio: dac: ad5770r: Add AD5770R support")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://patch.msgid.link/20241003-ad2s1210-select-v1-6-4019453f8c33@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/dac/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/dac/Kconfig
+++ b/drivers/iio/dac/Kconfig
@@ -224,6 +224,7 @@ config AD5766
 config AD5770R
 	tristate "Analog Devices AD5770R IDAC driver"
 	depends on SPI_MASTER
+	select REGMAP_SPI
 	help
 	  Say yes here to build support for Analog Devices AD5770R Digital to
 	  Analog Converter.


