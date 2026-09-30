Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E9413264C2;
	Wed, 30 Sep 2026 17:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789753; cv=none; b=hPxhPEL/bF/bAxIL24kg3J8xn885fFzCH7xCjN+qHleq6zc23Z0Osw1kkFXOGVfchBK03qjEp4ND1WeHDoga/+dCgthyvSb0XwTVctL2yBHj88SiLRtEedXQvJnUJwkolorwNmcKDY0VunYmRuhTeBKajNHMCGXGBLMiUhW88KI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789753; c=relaxed/simple;
	bh=vXXPYQycrzYq1oJffixlCN1WQQjVmTAf7KEMHBwSMLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gIJQ9ljl6gHqxSYnR012VWR0zmY5Uh32tTs44SCe8CJn1DCpdd327P7CUVHgWculrAaycfXDOW4bPQwyTCIwiCx/Y6Y06fI6nuoWsFeUIIVeumFXClfxiX5aVbdanF0+v/rERbpdS+xE3/K+/3QHnh2daADwF7SvisZ9/O3Pi/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wz3Sfggu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wz3Sfggu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89FB11F000FF;
	Wed, 30 Sep 2026 17:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789752;
	bh=4d0+GWhYYNtnRLRtM11q/+Y81i2fhGWVsW96woelN4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wz3SfgguRqsPwLCo9Tt+3uV6cjXidNyNGRW1kddYO24IDZYfZ+RntpQUE7/9Aa2bT
	 Zl+QcrSEoXN2ixriqP3zdPPCobZewxXnrulptdyW1WPVhXffkBmCEnMq4GJ4QCguky
	 ibAACSuGIXs2rqeoSewXFjhkB/50BNtYRwJPiQkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 586/877] platform/x86: think-lmi: Fix certificate thumbprint sysfs output
Date: Wed, 30 Sep 2026 17:24:57 +0200
Message-ID: <20260930152427.293843640@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

[ Upstream commit 4f3183f5ae9b8ddfe338d79a96146a05342bbe50 ]

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
[ adapted upstream loop changes to the older driver's three direct cert_thumbprint() calls. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/think-lmi.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/platform/x86/think-lmi.c
+++ b/drivers/platform/x86/think-lmi.c
@@ -671,14 +671,18 @@ static ssize_t certificate_thumbprint_sh
 			 char *buf)
 {
 	struct tlmi_pwd_setting *setting = to_tlmi_pwd_setting(kobj);
-	int count = 0;
+	ssize_t count = 0;
 
 	if (!tlmi_priv.certificate_support || !setting->cert_installed)
 		return -EOPNOTSUPP;
 
-	count += cert_thumbprint(buf, "Md5", count);
-	count += cert_thumbprint(buf, "Sha1", count);
-	count += cert_thumbprint(buf, "Sha256", count);
+	count = cert_thumbprint(buf, "Md5", count);
+	if (count < 0)
+		return count;
+	count = cert_thumbprint(buf, "Sha1", count);
+	if (count < 0)
+		return count;
+	count = cert_thumbprint(buf, "Sha256", count);
 	return count;
 }
 


