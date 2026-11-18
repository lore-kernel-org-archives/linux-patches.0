Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044019;
	b=inLzgXAV4jryLBnJyPLWfdGNyWJe0WOqrBFFiB3Y+4kqoWmdBRnFDTxwl+1s3MEl6YRy
	 dq8kmpYdkeN7B63NWDL63P0Pmz9Dx0uV//w5Wh0ScFfGAu0d44NSy4wWo3OqU/KRh+OQa
	 6d7gz9hR9vJZ81qcohuIMjt6BsaIZwoRW1V2qZCY8lSxTbzpLHjX6Mc/DTYnNGx2hPcCV
	 ceoJI4ntz1MFgecQZamWO4reUV/k5rWYOtuurCtlmbVdT4aFa+Mq8zM8DpB3qHrGWfHfy
	 AUvStTqCp/X3ybxWODRWdbIlVyD90XcJdPA0g84BFhKNhuXjgmEfC79U3GUxyNZqvcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044019;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=ffVJH0NuW2tIQZ5KhN5gIsoti/M59/Td/cVjTlleEwQ=;
	b=gX0stJbdCAZO73bq/GHTj/PqjDMSVUBxJ+mBzEEGpxrYe2hegm2Ept/Jj6Z1koRtEpeR
	 e2WQoU5uzNxltLONIBuvT2C4FDniMjevUoUWa44sPgNworoa7Bexu8h0UUHVsq476jlZS
	 zlxeZ7p1H/3fBjXHyKzb+IkUJj76qZleFF8YcPuhBwwwmJ+pOHpU8pfq9PvS66DwRVO54
	 TNm4y/HV1VEgfx7ZPEEqumZbCaN1k6EBTeLxEr87lkZLysD29yaC0t9Tp88Hr7HKwRtZz
	 Z6nkf+Yaze9E3zHWzDNNnJ6Dkg8MhiN5aE8H5OWmdTvP14l+5dqc0XLC0oRwOf/tOng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rMLonkTa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 942CB606A31C;
	Wed, 18 Nov 2026 23:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rMLonkTa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7FEC1F000C5;
	Wed, 18 Nov 2026 23:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044019;
	bh=ffVJH0NuW2tIQZ5KhN5gIsoti/M59/Td/cVjTlleEwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rMLonkTaMLxQbxPKXt0+nmAvjj4uTZO/Uihz8/W/YO9yp/7jI+0Nt1hCHYr41Y6Sw
	 9M9YBfe447NMFSpoXLf+88IDsLMzt+B5P/J1Bl813RazZr3iOtsQQnezUQ1jmd7ql8
	 U/ZqFtM4SpIV+IHQZcnqv31zHgb2y3PNn1G1fnHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0363/2857] platform/x86: think-lmi: Fix current password length check
Date: Wed, 18 Nov 2026 15:23:17 +0100
Message-ID: <20261118150214.499437208@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/think-lmi.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/think-lmi.c b/drivers/platform/x86/think-lmi.c
index f32f960b9a5cf..d1cc9c1ebe9a2 100644
--- a/drivers/platform/x86/think-lmi.c
+++ b/drivers/platform/x86/think-lmi.c
@@ -396,14 +396,13 @@ static ssize_t current_password_store(struct kobject *kobj,
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
-	strreplace(setting->password, '\n', '\0');
+	strscpy(setting->password, buf, pwdlen + 1);
 	return count;
 }
 
-- 
2.53.0



