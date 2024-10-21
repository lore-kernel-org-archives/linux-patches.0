Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 505241E909A;
	Mon, 21 Oct 2024 10:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506662; cv=none; b=e681O0dYI75zSjlNgNW0Q2wGc1N8nKeq4BnYbNAa8IGfYjCkQFSt7AgDVUQMhL3jidMaeGOtOD8VFY+qaSVWcWOYUsTQktX7K45Mtojg6nLkU9xijDAC9Qrh/FZa+DyrAL7CV6MK0Dnfqvxijuvdinddf4QIICT17XjqeGW0qE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506662; c=relaxed/simple;
	bh=ZMX00w06d8mCFMMIFA7kEjqxtQ3MfhicHXhj6yD0bys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EMBgFVfQMfRVDIigg07vZuQoe8dSh2ryzeudi7+YzKztaezDwkPOS79zENlccGMWpygDn0acPBSVYQptQBk9hhpkzioa9hSHTZsVa3PTBAGs/26UuSrawDVKLNkhjIo2lo0BYRGvKbtFDm3gSDhfqDOe1d5/4FFaVFVHV1Tjihw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m/vjfVd4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m/vjfVd4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3E0CC4CEC3;
	Mon, 21 Oct 2024 10:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506662;
	bh=ZMX00w06d8mCFMMIFA7kEjqxtQ3MfhicHXhj6yD0bys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m/vjfVd4HeEPckWWjDZfH140dwfYllzji48f678fz/VF/aYjF0Jy/Qc05yvqkuQPi
	 WfkZQSR4dBZfpMyMt98MxusQGe9M/l8ZhgRhpWeNf/xdrRH3pO59S2LhJxhvTuWvaq
	 ycWzgdgac635jWQ3BuhmP0n3BrACe3w3e69DqToM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Gustavo Silva <gustavograzs@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.11 080/135] iio: chemical: ens160: add missing select IIO_(TRIGGERED_)BUFFER in Kconfig
Date: Mon, 21 Oct 2024 12:23:56 +0200
Message-ID: <20241021102302.457052403@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102259.324175287@linuxfoundation.org>
References: <20241021102259.324175287@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

commit 3fd8bbf93926162eb59153a5bcd2a53b0cc04cf0 upstream.

This driver makes use of triggered buffers, but does not select the
required modules.

Add the missing 'select IIO_BUFFER' and 'select IIO_TRIGGERED_BUFFER'.

Fixes: 0fc26596b4b3 ("iio: chemical: ens160: add triggered buffer support")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Acked-by: Gustavo Silva <gustavograzs@gmail.com>
Link: https://patch.msgid.link/20241003-iio-select-v1-9-67c0385197cd@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/chemical/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iio/chemical/Kconfig b/drivers/iio/chemical/Kconfig
index 678a6adb9a75..6c87223f58d9 100644
--- a/drivers/iio/chemical/Kconfig
+++ b/drivers/iio/chemical/Kconfig
@@ -80,6 +80,8 @@ config ENS160
 	tristate "ScioSense ENS160 sensor driver"
 	depends on (I2C || SPI)
 	select REGMAP
+	select IIO_BUFFER
+	select IIO_TRIGGERED_BUFFER
 	select ENS160_I2C if I2C
 	select ENS160_SPI if SPI
 	help
-- 
2.47.0



