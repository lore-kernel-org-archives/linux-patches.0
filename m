Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060667;
	b=CqCOKzuxUjXn1Ukz497pxFX+S/xLkZo18a3nwdk55azSewNUQOSR7YZ2u3s7kdXOpUqu
	 valoSF9IXfwkMCF97hZIGk4W/n7SN25WuZFJFWv1XNS+IQ11dUsjDIZFyLc5P0qEgHeFT
	 gK7KWjDBJWeKBlUUwwoMJmlLHmXloLpuSiJnHZLAbIhmcZNB2tlHYIrIo7Mg6+oH1bjAb
	 uxHQOFgOnEAUmVV2ypFL5U2U55Zhy/q76ha2UhGy/r1yjK5JR+dUxZWnmjUZHZRLZbV7C
	 hCa9yJhA6EdO7ngEYqU3JNk5s45fzvJtB1GH7SegW7iXIju5DelIYnpGjpWtpDaanKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060667;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FQx5WahsHAYAXly7ybnH3lLef3IIW/9MI9ZSPdN5Z7I=;
	b=EcFJZ6K++7Y7nMMvDhDWUDqSmQqBORBKzcqW8/mHl8JbkoYby9lOr9IR3djTeOZ7rGeh
	 BJw01f2QWyyYNJcZnqJ+dVMJMosA4CWF+9NOoiHmkt6RjNRrszvpqMAkD5n5gmkJSthPp
	 TVMXHaCQ1Qa0irWHxAbWIaSYkrvUW9hRTDQNZBBugnpZAS8bU37m5HrdAKgStRC+bil8e
	 yvCJDXPMvaPjP02Ayro/B85m54ohnGCdhuaUGsHx6WPHNwF8zcEu4J6zIuQqknRduDBOd
	 U3HWfaZsa9xrqH7DnNABSczV/OBzLAatIZPoJuVMbOU36EEuaKL0OQzqb5XmGdhkBdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=csJtFiQ0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87E67606A325;
	Thu, 19 Nov 2026 03:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=csJtFiQ0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76CD51F000C5;
	Thu, 19 Nov 2026 03:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060667;
	bh=FQx5WahsHAYAXly7ybnH3lLef3IIW/9MI9ZSPdN5Z7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=csJtFiQ0SocdUsajkNrQIflI8mY08rbt5ggPAWpGVwdnQPhgiy2l67CMBBxta9Xrl
	 TL83dXurYtaNV4fpYykDItrikcmD8Ggh6dYbWSNPfGKwqhzdfg31u6h63f9gH4fVq4
	 vFruLbF+BOCtfFut1o0IIZDD3GjNc/1TL9aKrL7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Slavin Liu <bolin.liu@seu.edu.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1279/1848] crypto: atmel-sha - reject initialization without a device
Date: Wed, 18 Nov 2026 15:55:17 +0100
Message-ID: <20261118150013.155520027@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Slavin Liu <bolin.liu@seu.edu.cn>

[ Upstream commit a9a2152d292fd0bc73814eb4a127278ee7dd3f6a ]

A transform may be initialized for the first time after the last
device has been removed from the driver list. Return -ENODEV when the
lookup is empty, before the debug message reads dd->dev.

Detected by static analysis and reviewed with AI-assisted source auditing.

Fixes: ebc82efa1cd6 ("crypto: atmel - add Atmel SHA1/SHA256 driver")
Assisted-by: LLM
Signed-off-by: Slavin Liu <bolin.liu@seu.edu.cn>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/atmel-sha.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index 75ccf41a7cb97..df2c1a3d5bc2a 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -429,6 +429,9 @@ static int atmel_sha_init(struct ahash_request *req)
 	struct atmel_sha_reqctx *ctx = ahash_request_ctx(req);
 	struct atmel_sha_dev *dd = atmel_sha_find_dev(tctx);
 
+	if (!dd)
+		return -ENODEV;
+
 	ctx->dd = dd;
 
 	ctx->flags = 0;
-- 
2.53.0



