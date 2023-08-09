Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E906C1775C
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:33:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6856BC433C8;
	Wed,  9 Aug 2023 11:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691580799;
	bh=Yz7ZkxljlRSc4Nzsq5B0rzk2A5SrO/KItKKYqrfWLlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ijKCo4r6YppTGO5FxDYEVVbOc28D+QoCuoAftayN330Zcsj6BY3JygGL4+2yCTif9
	 r6f5+4GOmsphRG7cJuxOdyo3RZ905+qWXw3TB9kEXaa9jCWca6QchafHYzOnHaL6cg
	 vdeI2P/X5FhPRTr9uLmoKZFQd7yTRvDCg7asfk04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 5.4 154/154] Revert "driver core: Annotate dev_err_probe() with __must_check"
Date: Wed,  9 Aug 2023 12:43:05 +0200
Message-ID: <20230809103641.927763946@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit f601e8f37c2c1c52f2923fffc48204a7f7dc023d upstream.

This reverts commit e1f82a0dcf388d98bcc7ad195c03bd812405e6b2 as it's
already starting to cause build warnings in linux-next for things that
are "obviously correct".

It's up to driver authors do "do the right thing" here with this
function, and if they don't want to call it as the last line of a
function, that's up to them, otherwise code that looks like:
	ret = dev_err_probe(..., ret, ...);
does look really "odd".

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Reported-by: Krzysztof Kozlowski <krzk@kernel.org>
Fixes: e1f82a0dcf38 ("driver core: Annotate dev_err_probe() with __must_check")
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/device.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -1872,7 +1872,7 @@ do {									\
 			dev_driver_string(dev), dev_name(dev), ## arg)
 
 extern __printf(3, 4)
-int __must_check dev_err_probe(const struct device *dev, int err, const char *fmt, ...);
+int dev_err_probe(const struct device *dev, int err, const char *fmt, ...);
 
 /* Create alias, so I can be autoloaded. */
 #define MODULE_ALIAS_CHARDEV(major,minor) \


