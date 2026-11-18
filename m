Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043859;
	b=zaiUTfV1IgVNcf/LM7HCLbshPCjfXbO87s7QlX7XH3uKuJAwQOFlWyJTGyCqlHXcghht
	 nWHLNVKxwT8O2ZgRRrwP5GsbUM5jsThyodFezpezUI5ptQJvfrk2e842gfDDRjyxbkaEP
	 W9XJCixUlBDrnah45i2tJrpoT+G8WDSYA8itheyFLvYqBXAyfLhCSKPY0WTKe3xIcyoLS
	 mrdjPEblwAlif3Wp/dmnoIv9ABENryHxTajThX1Cc4UaOS46Iml50rZO38CptwsnN8ahv
	 lwoNDu47luODqie9laxspuEMgx19V9+vZMXzdzroz4fNx2wYuFnU0QnFDLguPc91RXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043859;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=AFx/rsew+knZcxyEAt7f+3bbyAeWrYrHg3+lz9yv7/Y=;
	b=QIuljD/+p7xn3SPLuCyo2aqzkAf1VjQYEThfQkq4z3KHnizavfur36JiolNx0dATEXv5
	 HpNvRMOewBUSJwR6pdNj19Pjm5MShNx8rScgSpiFPau5OmHGBi281LO0983DMgX350O7O
	 lDJ00f3CMt/sPjaVOoYcYlv1iLhxkVy41+iktPuMNHGF/tIRvI7nF/wje8ActQgIWCO9G
	 SQ4dlAJLGysvCtqWxJOkNxuzY/zJM+R4STB+Cah4BhjvKjtUoFRORbPS1fq1x+AV1JBdF
	 D1v1Ggq8RqW8LmswXcScXUMi8WGBog6ZOYu+Oc4/Y43Coq5Lr2YOTwsPlBdon2gA5WQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ogZT8pJK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 915F7606A31C;
	Wed, 18 Nov 2026 23:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ogZT8pJK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 973E01F000C4;
	Wed, 18 Nov 2026 23:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043859;
	bh=AFx/rsew+knZcxyEAt7f+3bbyAeWrYrHg3+lz9yv7/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ogZT8pJKTNd9Hg4IiGY/YawMbU3nDlmCd1iODU6IpGcmMvk3tbPKQiixjzT6b7SfP
	 dJ/4FjTAhOe4cfyqkX6Id8Z7QZySGISPz2dFdvk0QGz3b9Tj/W/O7LGM/3Hd1eNQGs
	 cgZ5HQV/U+yzRMUfnLTxcV4ulcrPftDbI16UjoMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0359/2857] platform/x86: think-lmi: Fix certificate thumbprint sysfs output
Date: Wed, 18 Nov 2026 15:23:13 +0100
Message-ID: <20261118150214.365341513@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/think-lmi.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/think-lmi.c b/drivers/platform/x86/think-lmi.c
index e7605bc97f2b0..035cce8db9eff 100644
--- a/drivers/platform/x86/think-lmi.c
+++ b/drivers/platform/x86/think-lmi.c
@@ -676,14 +676,27 @@ static ssize_t certificate_thumbprint_show(struct kobject *kobj, struct kobj_att
 			 char *buf)
 {
 	struct tlmi_pwd_setting *setting = to_tlmi_pwd_setting(kobj);
+	ssize_t ret;
 	int count = 0;
 
 	if (!tlmi_priv.certificate_support || !setting->cert_installed)
 		return -EOPNOTSUPP;
 
-	count += cert_thumbprint(buf, "Md5", count);
-	count += cert_thumbprint(buf, "Sha1", count);
-	count += cert_thumbprint(buf, "Sha256", count);
+	ret = cert_thumbprint(buf, "Md5", count);
+	if (ret < 0)
+		return ret;
+	count = ret;
+
+	ret = cert_thumbprint(buf, "Sha1", count);
+	if (ret < 0)
+		return ret;
+	count = ret;
+
+	ret = cert_thumbprint(buf, "Sha256", count);
+	if (ret < 0)
+		return ret;
+	count = ret;
+
 	return count;
 }
 
-- 
2.53.0



