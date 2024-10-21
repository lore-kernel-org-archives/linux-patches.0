Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08D871EF089;
	Mon, 21 Oct 2024 10:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506675; cv=none; b=L0yNY2A3Z4nFrz4+W2my3T3F2HGX3oNOOSegfM6oX/1VGFPcg5GaKgPB4E0epzUGw01tHJjBcKD2H1F4QTrypgfR9p7KOhRdDrctHJubKCslHjJXPSfQScVZODtxZ2lSEoLcdH0sGVfhUhjkKT0ZNtaIe/3Vkdi9bX6GnA4KjHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506675; c=relaxed/simple;
	bh=UUwgi0Mer6NSC0TW0xNtGm2TT2EgEdEo17ONIpEm7NQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uI4aBM384v0wQQhV2daDbkDE2ZqjZTBsfN5RL0s5jPDhxLG1ftznjTNyUSJhNYI4Y2ft0ZksenWiDKHlKdKliAO0UhwiQxW3ckNL+uxPKdSjJjiePJF6a56j1Cq6gOUnANs2dhfG3BcTyoMK44JMgrso/n4BqSnoTAb8Eue+1Jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n1YmwOmw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n1YmwOmw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 665E8C4CEC7;
	Mon, 21 Oct 2024 10:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506674;
	bh=UUwgi0Mer6NSC0TW0xNtGm2TT2EgEdEo17ONIpEm7NQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n1YmwOmw0hNDTdzSBn//zuvmmlpKj81ib7mbo6eyGnCkLeVyg+MtPVUh3/0snh/Sl
	 drhuiA7wtMBt+9xF2BwW5P3hu3cPvmhGVqXzUcphB6V7AitdHKFLWXv5JutxGWfsOT
	 RF5kOUUnGt2fvij545XLspezseduiKHhoxn00/KY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.11 084/135] iio: pressure: bm1390: add missing select IIO_(TRIGGERED_)BUFFER in Kconfig
Date: Mon, 21 Oct 2024 12:24:00 +0200
Message-ID: <20241021102302.611923565@linuxfoundation.org>
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

commit 3f7b25f6ad0925b9ae9b70656a49abb5af111483 upstream.

This driver makes use of triggered buffers, but does not select the
required modules.

Add the missing 'select IIO_BUFFER' and 'select IIO_TRIGGERED_BUFFER'.

Note the original driver patch had wrong part number hence the odd fixes
entry.

Fixes: 81ca5979b6ed ("iio: pressure: Support ROHM BU1390")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Acked-by: Matti Vaittinen <mazziesaccount@gmail.com>
Link: https://patch.msgid.link/20241003-iio-select-v1-12-67c0385197cd@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/pressure/Kconfig | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/iio/pressure/Kconfig b/drivers/iio/pressure/Kconfig
index df65438c771e..d2cb8c871f6a 100644
--- a/drivers/iio/pressure/Kconfig
+++ b/drivers/iio/pressure/Kconfig
@@ -19,6 +19,9 @@ config ABP060MG
 config ROHM_BM1390
 	tristate "ROHM BM1390GLV-Z pressure sensor driver"
 	depends on I2C
+	select REGMAP_I2C
+	select IIO_BUFFER
+	select IIO_TRIGGERED_BUFFER
 	help
 	  Support for the ROHM BM1390 pressure sensor. The BM1390GLV-Z
 	  can measure pressures ranging from 300 hPa to 1300 hPa with
-- 
2.47.0



