Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034264;
	b=1vgJjYoxoasv6+07+YPmGoYFyUUqIAw9Dy8nmPbVY6bjOgHL1UW4tFNRnoEPfMED3DcF
	 MO6Zd8toKifHWt3ustunIV8ii8yQ1dXJExathC5z9tRxDAgHXHt37vaJTI6DaMKO1gSyT
	 KBrgCIGU/XsrfASWwcOiRNYT/P5mcDUg9DWo6jxrK+Dy6bd1gvNGB2MsJjRk6IiMkCJEO
	 sMV5kycIWl1ctuisfLfOvCzOsetErKLz3zfaTdiQJdmQ5uG/k8dMgqC716J6hJcfCvuqB
	 qRJKjitSfh2LnUq6VN1DCA6RxaAQRYLwZo0IxoPdxicSDdxq56Y21X7ZF2414L897UA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034264;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cPkeWlNaOrbNe9dnmsSOwXTgMeNWx3Yguc3nN0vLE24=;
	b=iB4htlvNacoBbeylJuKdzTtEidcot4N8Rfmjl5Aw4sXNAA9LNGSYMnbbQ1CMXNR+GNBg
	 o07Qi2hoEd7XjFLcCzVIJ+RT+jzNjb0gaf9xQMTMZyaZ4cH88tedPsTKA6SdrWTFul2rW
	 K/6XPj7LKzUliOYgkUcOn7MhUgpS4qPteJ2Zg7LOPQf7brWJq9TOiap4TmyNMAZWh+LNT
	 NhnXipofklh7RDqS5ugqMb2kw8gr+lJOtH/O64hvfZxfC9sv4CRFkojuSlfFNZlsacMOi
	 raWmdRUxhNFrWxiKrcDzGXl629AvjlNkfoFsj7SJIzl4YcZe8eDymEoEVvN2WyqqWVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l+hgigGt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D10EF606A325;
	Wed, 18 Nov 2026 20:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l+hgigGt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7C691F000C4;
	Wed, 18 Nov 2026 20:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034264;
	bh=cPkeWlNaOrbNe9dnmsSOwXTgMeNWx3Yguc3nN0vLE24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l+hgigGtHcNzyfxBkFgBxuuuyVLarDlRjGsqOSd04Bk2c92OFzQ9sgMaWS9ivBhlG
	 kYX8X/3idYutGf2pg9H5RPO5jxLWPXnEboUuT8wDVukjT4JDIWFOPzCZdgP6zvlG9h
	 8cZDqAyYm3XwVIbysIoxT3XoSqqbEhlJdapC552s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0308/3318] rtc: ab-eoz9: add missing MODULE_DEVICE_TABLE()
Date: Wed, 18 Nov 2026 15:15:30 +0100
Message-ID: <20261118150325.024964683@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 7490b8356e52e09c196645912f2c054f79aa5f3a ]

The driver has a match table for the i2c bus wired into its driver
structure, but the table is not exported with MODULE_DEVICE_TABLE().

Add the missing MODULE_DEVICE_TABLE() entry so module alias information
is generated for automatic module loading.

This is a source-level fix.  It does not claim dynamic hardware
reproduction; the evidence is the driver-owned match table, its use by
the driver registration structure, and the missing module alias
publication.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260704152528.53258-1-pengpeng@iscas.ac.cn
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-ab-eoz9.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/rtc/rtc-ab-eoz9.c b/drivers/rtc/rtc-ab-eoz9.c
index 79d5ee7b818c5..5129a4c2fbfe1 100644
--- a/drivers/rtc/rtc-ab-eoz9.c
+++ b/drivers/rtc/rtc-ab-eoz9.c
@@ -571,6 +571,7 @@ static const struct i2c_device_id abeoz9_id[] = {
 	{ "abeoz9", 0 },
 	{ }
 };
+MODULE_DEVICE_TABLE(i2c, abeoz9_id);
 
 static struct i2c_driver abeoz9_driver = {
 	.driver = {
-- 
2.53.0



