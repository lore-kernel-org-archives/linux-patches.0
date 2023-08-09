Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 981E017AAD
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:33:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 195DAC433C8;
	Wed,  9 Aug 2023 11:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691580819;
	bh=s8u8dyQQwuhWxeLoWM4J+lN0kjVzfsJzRqc/4VxNzkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KV6NkAdfYK17R+8leKAY/E+uHQpzxsLNnaAzjUPLKuMzo5TxTVTx7rtg65eb35ewb
	 lSbEz+sjvcDE0a5IEMix4skG4m2pUAT9RfUWWjMgy9KbQiltnc4htjArxZIqif88Ni
	 CdXYJWWgiOCokwwdj6noHD2WNwpPZhPwXNcMnK7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 5.4 151/154] driver core: Annotate dev_err_probe() with __must_check
Date: Wed,  9 Aug 2023 12:43:02 +0200
Message-ID: <20230809103641.838614095@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103636.887175326@linuxfoundation.org>
References: <20230809103636.887175326@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit e1f82a0dcf388d98bcc7ad195c03bd812405e6b2 upstream.

We have got already new users of this API which interpret it differently
and miss the opportunity to optimize their code.

In order to avoid similar cases in the future, annotate dev_err_probe()
with __must_check.

Fixes: a787e5400a1c ("driver core: add device probe log helper")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20200826104459.81979-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/device.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -1872,7 +1872,7 @@ do {									\
 			dev_driver_string(dev), dev_name(dev), ## arg)
 
 extern __printf(3, 4)
-int dev_err_probe(const struct device *dev, int err, const char *fmt, ...);
+int __must_check dev_err_probe(const struct device *dev, int err, const char *fmt, ...);
 
 /* Create alias, so I can be autoloaded. */
 #define MODULE_ALIAS_CHARDEV(major,minor) \


