Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033797;
	b=3mAM6u0ZA9MOp7t3K5WDPCtYg1eJKJrxImON1u/TmcGmKLNnm8Zet1RR6EJC/27cxeqB
	 1WRg8gIG6EhjEEp08woi40OUr7xw2Ra1LMOxvl+5kckOLKsuDFqCbqPTgMOJzL95On1h3
	 FEPBzYkXv/G/eQx3dU8LesCSYJVFi6T7j+Zj1eq+vpbcZoRLa1EI5m/ISg1YvouxPeDt5
	 B93rk7Nk2/uqRsXEor8cqboPoRL6YvnRvWRQZEfFgpQRulXpRc/xcZW/mtYZXb1dPro+K
	 h/mQWh22hi2dlZVoR2xIryk5OsqWgqq7GapsKF+H//4mzCXV9lRnR8XHIhk+JiPPGzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033797;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0W1rvrB7ksVSpFmJsTQ2pBxxQORQVmMeSq1W57Ftzrc=;
	b=rcwrJEdOuK4VZcxCuHlsyp5gJgPChp9LeXnf8Q+yr3icfGBasG3ZOJ8gPmOF4nSzyL/5
	 R4UUUKVa6AL0l06xdqlU7liMVxcZqefjq6/X7J030VaCFDjiECqJYPhgjpFJ3FyyU2KBR
	 DTg4fUfXUIte09j7DhjnSfunahKep8omQgUqz4+i/8harr36Pweunb0vkxBa5LZOcvOzO
	 Mmpu2yL5h/dUWOWYe3IjGm+vF4azuGICkaT1v131GUfz2j4FUbxOqljcZ1+JRiSbQ13Bn
	 LgPxq4D8hk9rh13YlEEwTvHRxgsknXzEY0ZFDf5XoqaeDP/xwy9zx9+u+Gr8w1p3MFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uQqrTka7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51081606A325;
	Wed, 18 Nov 2026 20:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uQqrTka7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B6331F000C4;
	Wed, 18 Nov 2026 20:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033797;
	bh=0W1rvrB7ksVSpFmJsTQ2pBxxQORQVmMeSq1W57Ftzrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uQqrTka737mAK6MyQDSrx1VgInWNk3eaYc2swPLhYsj5hw0fJK+8k2VyYIPgzHUOn
	 e9aPkqmHugcsyCk99VQYcCmxqLvRKE5y0loPOmkyRLBdZNvblG7hO610LDVWLsZ1OX
	 tmVAFDDf6/659OvgPScb/Y8AlTxds2t9hi9k6aOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0142/3318] driver core: attribute_container: Unwind device_add() on attr failure
Date: Wed, 18 Nov 2026 15:12:44 +0100
Message-ID: <20261118150318.725932164@linuxfoundation.org>
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

From: Yuho Choi <dbgh9129@gmail.com>

[ Upstream commit 8cfe7ad274bb42c4653b645267410d4a3a23db98 ]

attribute_container_add_class_device() first calls device_add() and then
creates the container attributes. If attribute_container_add_attrs() fails,
the helper returns the error with the class device still registered.

Callers use an error from this helper as a failed add and do not call
device_del() on that path. Undo the successful device_add() before
returning the attribute creation error.

Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
Link: https://patch.msgid.link/20260608172717.88657-1-dbgh9129@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/attribute_container.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/base/attribute_container.c b/drivers/base/attribute_container.c
index 01ef796c2055a..aa93a0756e16a 100644
--- a/drivers/base/attribute_container.c
+++ b/drivers/base/attribute_container.c
@@ -455,7 +455,12 @@ attribute_container_add_class_device(struct device *classdev)
 
 	if (error)
 		return error;
-	return attribute_container_add_attrs(classdev);
+
+	error = attribute_container_add_attrs(classdev);
+	if (error)
+		device_del(classdev);
+
+	return error;
 }
 
 /**
-- 
2.53.0



