Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3231E1EABCE;
	Mon, 21 Oct 2024 10:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507070; cv=none; b=e0rEAJbeEy0My6CvMfYr/z4v8SQvVJCUd40JsHGL+Ul3GwZMraYRwKVdrZXjda5ryxAZ39KN68PVTRDXooLVQQqCCNu2mxl89eOA53Wrk5LWIXbY8OLA771ryHv7ElJS/ittWLtInzs0RFrgd2QHdroyitL0VhEAOk+Igo8ik4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507070; c=relaxed/simple;
	bh=IK7hgFvD88uX9dsVpOqCIKCy2d45ZxKHmAFfoThwtXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=POxAA7jvFWzH5iymcg2KL7AO8Ab/AzOAdV5lIclt/tmCaPLm8OmjysPG4oUdIFobKEWwj8MF7Yj0RAe3mEdaDnJK030FxvpMCvqjMGcXXpTz2yUwMUICkWmWMkypgfnj/V+DI4oTDYUJEnzCnr09CXucIye9zM8FZNr8L+8W4yI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e2iGo/7+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e2iGo/7+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A830FC4CEC3;
	Mon, 21 Oct 2024 10:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507070;
	bh=IK7hgFvD88uX9dsVpOqCIKCy2d45ZxKHmAFfoThwtXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e2iGo/7+KvHcqsU34zyxy66jvkDwUVT2JDmI2BBtDx2WWP6xSAoEe80c76uRq0/Et
	 aWZgHW4M0AhoIYGnQvUt7e/RlXOtY0UXSjNE18QflkE7hCK1opi5ERjuWr+WG5JGfr
	 O5TOMQtiyNhhP6UbZjg644IkYUKd33C9U0etSN+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 079/124] iio: frequency: adf4377: add missing select REMAP_SPI in Kconfig
Date: Mon, 21 Oct 2024 12:24:43 +0200
Message-ID: <20241021102259.787625738@linuxfoundation.org>
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

commit c64643ed4eaa5dfd0b3bab7ef1c50b84f3dbaba4 upstream.

This driver makes use of regmap_spi, but does not select the required
module.
Add the missing 'select REGMAP_SPI'.

Fixes: eda549e2e524 ("iio: frequency: adf4377: add support for ADF4377")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://patch.msgid.link/20241003-ad2s1210-select-v1-3-4019453f8c33@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/frequency/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/frequency/Kconfig
+++ b/drivers/iio/frequency/Kconfig
@@ -53,6 +53,7 @@ config ADF4371
 config ADF4377
 	tristate "Analog Devices ADF4377 Microwave Wideband Synthesizer"
 	depends on SPI && COMMON_CLK
+	select REGMAP_SPI
 	help
 	  Say yes here to build support for Analog Devices ADF4377 Microwave
 	  Wideband Synthesizer.


