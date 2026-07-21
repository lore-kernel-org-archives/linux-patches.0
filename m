Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45D4146D549;
	Tue, 21 Jul 2026 19:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662685; cv=none; b=YaWkniglbNbbrZjT7wNkeooOkSLo8HcSvQ9OztugHp3sGc5Me+LcHnCCSBaLb4yJByraVuoeAq4TIpS4nl9osS5enuLE+vRfbATNwtuomxOK7OWC3Vl8K0FgJb/GJeAfyzl2Y7i8MQxgYksA9cn1oa9vYhncy1ocUqB+6K0SaHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662685; c=relaxed/simple;
	bh=z2+iHPM0+Q10NWjs3zanSSfawibkq7q83MKuqnUm0lk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FByqbtdCZihgKeHvgOUYbtVUqhy6ZoL7k3kCyxMQrqNq/dzxhHMa0xu+ydgZSC8BiyoRBwPitAOf+VpQH4FfwOvL2IlQHxmzGdyQ1b8C3705QrbHN6/OkdgAq3yTOA2K48sPEwMs1hRRiCt3ZNh/yQGIobznN5vbAai95Bwm8gA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yg2my6Vk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yg2my6Vk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A5801F000E9;
	Tue, 21 Jul 2026 19:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662681;
	bh=I/obBGBZBNmW/3+1/LCmdPScfhnGzjL01YBOYfDwmnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yg2my6Vkv+UZjP6uaItqWUsoISrbnUI4bcjqdfDMTo89vvnlIm+AAeWp7sDxXuBKL
	 yZPn2UUd72KmhN81kB+GyA1Blmzx7szJJ5NCrqgcaWsEgdWqBCn0+qmFikPVsUqX4V
	 H/6UaDl5gPG7kMOhDnB0XQVOg2PTCac4oTwsrTa8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Johansen <john.johansen@canonical.com>,
	Paul Moore <paul@paul-moore.com>,
	James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0536/1276] security/apparmor/apparmorfs.c: conditionally compile get_loaddata_common_ref()
Date: Tue, 21 Jul 2026 17:16:19 +0200
Message-ID: <20260721152458.117328170@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Morton <akpm@linux-foundation.org>

[ Upstream commit d62d9bfe050f44f772d05a32079dba3e3523ab2a ]

Some config did this:

security/apparmor/apparmorfs.c:177:28: warning: 'get_loaddata_common_ref' defined but not used [-Wunused-function]
  177 | static struct aa_loaddata *get_loaddata_common_ref(struct aa_common_ref *ref)

get_loaddata_common_ref() is only used if
CONFIG_SECURITY_APPARMOR_EXPORT_BINARY=y.

(Or of course move the function into that block if maintainers perfer)

Fixes: 8e135b8aee5a0 ("apparmor: fix race between freeing data and fs accessing it")
Cc: John Johansen <john.johansen@canonical.com>
Cc: Paul Moore <paul@paul-moore.com>
Cc: James Morris <jmorris@namei.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/apparmorfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/security/apparmor/apparmorfs.c b/security/apparmor/apparmorfs.c
index c12406e62e58cd..4120480193a5d9 100644
--- a/security/apparmor/apparmorfs.c
+++ b/security/apparmor/apparmorfs.c
@@ -174,6 +174,7 @@ static struct aa_proxy *get_proxy_common_ref(struct aa_common_ref *ref)
 	return NULL;
 }
 
+#ifdef CONFIG_SECURITY_APPARMOR_EXPORT_BINARY
 static struct aa_loaddata *get_loaddata_common_ref(struct aa_common_ref *ref)
 {
 	if (ref)
@@ -181,6 +182,7 @@ static struct aa_loaddata *get_loaddata_common_ref(struct aa_common_ref *ref)
 						      count));
 	return NULL;
 }
+#endif
 
 static void aa_put_common_ref(struct aa_common_ref *ref)
 {
-- 
2.53.0



