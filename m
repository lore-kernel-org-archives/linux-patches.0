Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA4572D0C94;
	Sat, 12 Sep 2026 19:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241833; cv=none; b=Op9vJc2Y8rLmkM19C/gngYSo+qxhlSklSY1XVUkZVtOWUZNv/+rVOEpEhd54fjQwqnS3HWI7yfd4XO/Uoy7SdEK+b32teNc8WO0K0kJXzF33QQlCrIswM1iiWo1+b/cWS1NkBWRCCwggyvg+d4YcoAzbzKqx7rEE/T/iEvamnsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241833; c=relaxed/simple;
	bh=+72hHMHJ2BikYiAmx3ybr4UhRQB6lcU6nrTJaVhzS3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hqw/lWAiAF1nnDCH0kRuI1JPiO6NlHtc1Y38NOME3xjaq+U89+Q5AdHh6Mc8cFXSoaa+NhRuXtP5KesZ8Z0uHfBnLBS9Qn1GzghL0cyXeuooZj8rIhvBB7TavZH4rotuQpJcUMaCnWM0vb3ERnNC8qZpZscjuJvmjgyGTe5MIYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cBqhjH4h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cBqhjH4h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85B6D1F000FF;
	Sat, 12 Sep 2026 19:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241832;
	bh=PuRhfDrY7jD/vOSZUXVXJ4SDfrvY2bYKU8VheLUTOxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cBqhjH4heiAqea6/wgjoGY3kDsUHUTSG17D24xr4RZEgGr06AT1AufPtX8gTDQNca
	 DObl29G9Me0xwIx+gGp9ncE+YRGLl0FyRLKJm8fPNTinKnh64SqeKI6v0mTUJq414E
	 N/3RDNHCYH3hIu7qqEHekVLNHzWfs62LtimCXtVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 5.10 217/798] usb: f_mass_storage: Bump local buffer size in fsg_common_create_luns()
Date: Sat, 12 Sep 2026 08:57:25 +0200
Message-ID: <20260912065522.091603474@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit 9f6f095beec82a80daa666a3b2186a5b95841e9a upstream.

GCC (Debian 14.2.0-19) is not happy about the buffer size:

drivers/usb/gadget/function/f_mass_storage.c:2970:48: error: ‘%d’ directive output may be truncated writing between 1 and 9 bytes into a region of size 5 [-Werror=format-truncation=]

Bump the size to get it enough for all possible values.

Note, although cfg->nluns is limited to FSG_MAX_LUNS (16), the compiler
doesn't realize this and complains about the buffer size.

Also note, the existing comment is wrong as size 8 for the whole buffer
doesn't cover 100 mil numbers, hence drop it altogether.

Fixes: b27c08c953e9 ("usb: gadget: f_mass_storage: create lun creation helpers for use in fsg_common_init")
Cc: stable <stable@kernel.org>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://patch.msgid.link/20260817161239.1448582-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_mass_storage.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/gadget/function/f_mass_storage.c
+++ b/drivers/usb/gadget/function/f_mass_storage.c
@@ -2840,7 +2840,7 @@ EXPORT_SYMBOL_GPL(fsg_common_create_lun)
 
 int fsg_common_create_luns(struct fsg_common *common, struct fsg_config *cfg)
 {
-	char buf[8]; /* enough for 100000000 different numbers, decimal */
+	char buf[14];
 	int i, rc;
 
 	fsg_common_remove_luns(common);


