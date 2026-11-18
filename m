Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034582;
	b=zRxOLC47za8s2sWdoPoQPs8w1YtK0ZmIKMqWYIZdgXLNR6VL1RndgwhbHnFMuBzi5/cu
	 UPARLTqNTQE6LZ28xr6rVqKef2B9u7UHjnwGGiYOJuikz6D7rJ7d6ZN3odVHx9pCXmTGI
	 kE4RfsXh7+QHp9W8U/3/GCZuRLEemzGAygc/JuPnD5a6KXME7ph9F6EL/aANOTLXyDfHh
	 SIGHcmfUY+RS5IjJXwVveTCCQjtvac8Ox93x4eFSeXFsdhSaIIDSnmtQFkJ75WaW81xps
	 nNZSNSC2UHGiPw928cI6j/4Si8rkTHuZtqKC0uRekrNTGQrylTXnOxGRUDPodk7gv7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034582;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Xl15ap3oyXSbG5B4q+iEsBW5T3DSiTpOFOwnFW2cFyE=;
	b=SOZ1wnqGyuQcyuBIC+bwaB9/qMJflIyD367Y/poC+IDO7qR84EJ8Y+1oq1+n1dtbl/bV
	 sQtN7rXNwivrxunjbWmsgv/kmnKi1NclhFHQekWZhI67NAxw1zn8wBvd0HuTT51MSCz17
	 KpCYceT6/gv0W60bJd/V++WUzSxpJ9+kU04AzqGTXeVHHEcKDyx04RfpF9q9JbArFv0P5
	 /lKEIceIZ4fYMuHFGW+q2NWzET3LuaYDHEDTY6v5gp/+9n9e61ZyzIJRp4NFYOi6yqjsj
	 uDPoNdKe10++G9qVH6Ttc05ucxmIqbFwI8a32upKAVGV1S5JYI+pOJ2uf2g/8CQ+vxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FKGSBBig;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64475606A31C;
	Wed, 18 Nov 2026 20:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FKGSBBig
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7E7E1F000C4;
	Wed, 18 Nov 2026 20:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034582;
	bh=Xl15ap3oyXSbG5B4q+iEsBW5T3DSiTpOFOwnFW2cFyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FKGSBBig+CaCdii5NHlWSeEVWUB1FL9m/AHzE3+YwknVxQ1nbPRza1pSY3I3DDWLb
	 fWnuRZrgpbKrk6NeMYUxD1iroedQM28Gr2xQc1sEauoOGpz+aUvDgIykOFUGA+/i/R
	 v6NLntefLlR74YDJ1KNlgli7AAw2iEiTCektvjEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0419/3318] platform/x86: think-lmi: Fix current password length check
Date: Wed, 18 Nov 2026 15:17:21 +0100
Message-ID: <20261118150329.121118619@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

[ Upstream commit 54745d563114b74f6fecebce68cd020d06c1772b ]

current_password_store() checks the password length before removing the
trailing newline, which can reject valid passwords that are exactly
->maxlen bytes long.

It also passes ->maxlen to strscpy(), which truncates passwords without
a newline.

Use strchrnul() to measure the password length up to the newline, then
copy that many bytes and add a trailing NUL terminator using strscpy().

Fixes: a40cd7ef22fb ("platform/x86: think-lmi: Add WMI interface support on Lenovo platforms")
Cc: stable@vger.kernel.org
Reviewed-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Link: https://patch.msgid.link/20260818151635.37094-2-thorsten.blum@linux.dev
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
[ sashal: Adapted to the older file location and replaced upstream's strreplace() context with the local strip_cr() helper, which is dropped from this function since the copy now stops before the newline. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/think-lmi.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/think-lmi.c b/drivers/platform/x86/think-lmi.c
index 866c09f415e2a..60fe2e762e35c 100644
--- a/drivers/platform/x86/think-lmi.c
+++ b/drivers/platform/x86/think-lmi.c
@@ -403,14 +403,13 @@ static ssize_t current_password_store(struct kobject *kobj,
 	struct tlmi_pwd_setting *setting = to_tlmi_pwd_setting(kobj);
 	size_t pwdlen;
 
-	pwdlen = strlen(buf);
+	/* Strip newline; setting password won't work if one is present. */
+	pwdlen = strchrnul(buf, '\n') - buf;
 	/* pwdlen == 0 is allowed to clear the password */
 	if (pwdlen && ((pwdlen < setting->minlen) || (pwdlen > setting->maxlen)))
 		return -EINVAL;
 
-	strscpy(setting->password, buf, setting->maxlen);
-	/* Strip out CR if one is present, setting password won't work if it is present */
-	strip_cr(setting->password);
+	strscpy(setting->password, buf, pwdlen + 1);
 	return count;
 }
 
-- 
2.53.0



