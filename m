Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BEBB423A85;
	Wed,  9 Sep 2026 13:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961682; cv=none; b=oFbprzr+AWJP1VFIIaq0n8/rAcDdhrKWP1xCQVUtd72Ik1Sp4MFHda7Dmj39H9vd0AolieGb9dwsyHd/UEpxTpairEf8fJ/ynNPZvClQpiH5Dnur2Mbk/o/hdQMCUG4AbtUSvVbtMFwjpYm+RUabKtKMhDxA8YPeBG0eX+0KLZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961682; c=relaxed/simple;
	bh=5QGTaF0btTt+rQoKXwfr3jKeREOJd5lG+QFLHfQGFOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PPUWvySqu1XIROEmnC6snhnAr9L6M60EanL8kPWWNyQLIYZ1CHFZEanx0MDwbEgRyHD5mVBsRvUFiQdDmYoN0t3OhHh3Ou9wIH2A1BGWDtW5kB5ZpAiX+kG0mzl0jeNYWP6k+oeWmbVyd8LrVara6RYZazMys0S5KwOOqONwG0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=glqouSIW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="glqouSIW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A55C01F00A3A;
	Wed,  9 Sep 2026 13:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961681;
	bh=29VpfKbWMsHHBaJaMw47bXOdL7iBwblysZzTHi8dZdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=glqouSIWwi/UO+UspSzBba2Qau41mzxMrZ+6TPkXXTF/FPAuuQNc+lsJUgV67oYd5
	 iWk4GovRcU+X69Oaa2a6hdXpXej2b2qWsm9KtJv//qQPZAICecNJj6nSHme/ILThT4
	 lbXaYCPWdkPEE6lFa7uTojMswlu5JCVcPU4AssOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 7.2 031/556] usb: f_mass_storage: Bump local buffer size in fsg_common_create_luns()
Date: Wed,  9 Sep 2026 15:35:11 +0200
Message-ID: <20260909134231.598831992@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2961,7 +2961,7 @@ EXPORT_SYMBOL_GPL(fsg_common_create_lun)
 
 int fsg_common_create_luns(struct fsg_common *common, struct fsg_config *cfg)
 {
-	char buf[8]; /* enough for 100000000 different numbers, decimal */
+	char buf[14];
 	int i, rc;
 
 	fsg_common_remove_luns(common);


