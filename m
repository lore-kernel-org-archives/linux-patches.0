Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7D22347532;
	Fri,  4 Sep 2026 05:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499866; cv=none; b=WR9GEzqvk1ctW2EcBYBAm52hOHkuDx9HXUhPR6kDDtu3ppdvLSZOuq7/ZAi1u13YgXLSUOjEPikL94SdBV2UY3HgBL6vdEaNaCsZd2ykQb19p96VWScbsI1XKYI0if5C0VtUos/2wLH/QXriK2tvECt86rbv/5fF6jiPfjC4/VA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499866; c=relaxed/simple;
	bh=DVepi4LHITKxyqJYa/9a6ITi+Asbys2L7O3prcV/z2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QIkUgXlabBxWrysJ7aSFGK4QI0XLf5/iSh/F7MhNSKw4B79HYxw/4QrpJqF+esI/JaqKq9yojPhniDQblubB2LcZW7J3I9Ls8nGtyquyxiWrxIqRP1dW7ooFB7Ym5TDv/DKFX8uIOJJ/6NhlyTmGtcuyc648NHU7QAzv5Lx4HfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H6tXqH0J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H6tXqH0J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EB7F1F00A3D;
	Fri,  4 Sep 2026 05:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499864;
	bh=0l32yumRM7JNCEBVjzWzitZKKX5XUgxFkX6+hGXGCPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H6tXqH0Jx8Ol6h7LYn+ghPwjybLiiIbu9l2tGKhwy6Ucn1H/UUKJkIziPi8+BPvCe
	 2dKqAf40ODMA4Wle42maowwS/+mritXf5opEoL8UQiFnm8rQJyqUeGs2NhUEidpvHf
	 mXCb9G37KTI3mBXKh7BjE21zsQa+mEN9MoD2m4nY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 7.2 568/713] platform/x86: think-lmi: Fix certificate thumbprint sysfs output
Date: Fri,  4 Sep 2026 06:58:56 +0200
Message-ID: <20260904045816.550236085@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

From: Thorsten Blum <thorsten.blum@linux.dev>

commit 4f3183f5ae9b8ddfe338d79a96146a05342bbe50 upstream.

cert_thumbprint() already returns the accumulated output length, but
certificate_thumbprint_show() adds that value to count again, making the
next line use the wrong offset. Errors returned by cert_thumbprint() are
also ignored and their negative values added to count.

Assign the total length to count instead and propagate errors correctly.

Fixes: b49f72e7f96d ("platform/x86: think-lmi: Certificate authentication support")
Cc: stable@vger.kernel.org
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Reviewed-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Link: https://patch.msgid.link/20260810120556.149416-2-thorsten.blum@linux.dev
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/lenovo/think-lmi.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/platform/x86/lenovo/think-lmi.c
+++ b/drivers/platform/x86/lenovo/think-lmi.c
@@ -745,6 +745,8 @@ static ssize_t certificate_thumbprint_sh
 		return -EOPNOTSUPP;
 
 	for (i = 0; i < ARRAY_SIZE(thumbtypes); i++) {
+		ssize_t ret;
+
 		if (tlmi_priv.pwdcfg.core.password_mode >= TLMI_PWDCFG_MODE_MULTICERT) {
 			/* Format: 'SVC | SMC, Thumbtype' */
 			wmistr = kasprintf(GFP_KERNEL, "%s,%s",
@@ -756,8 +758,12 @@ static ssize_t certificate_thumbprint_sh
 		}
 		if (!wmistr)
 			return -ENOMEM;
-		count += cert_thumbprint(buf, wmistr, count);
+
+		ret = cert_thumbprint(buf, wmistr, count);
 		kfree(wmistr);
+		if (ret < 0)
+			return ret;
+		count = ret;
 	}
 
 	return count;


