Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061108;
	b=Afm7qupOLOxf6/bUrTP5/f0TywnSS51hzULPJczKS40YMl/f7B7DeTgGMDOUuUkAgVAx
	 VmkGiqtFU4WgQFBqzw5UtKz5jvmUsE7mylk82kfl1lghJ/XmtC5IygM/MeLOxUN8hgzY8
	 JIy1ZF/jCUwXKaq30xG17cjY4QVeLJ2+QsW3vlPusOgceEc8T9lgJGunSHA1gxtNu+adw
	 Q4v3qHiXm0mrlwLRxHY0BplPFXMCTDlslB1zeRBVBBJhHfZODxjje1deVCQBp3I99tQKX
	 6wQj5D9cNtzNWm8UPJi9YbapscemG9LmIHpfwz7I0oN2+TeZeqTq2yJhopEJFtIscsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061108;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VwaFIhwwf+gQWlsmyOhhz9syAe4pFe/A4qeIA6/V23U=;
	b=Z0dWneiDS7QvZxVmyqj5agJnHYH6VbPv6vFW4JneVZgSPXmBQP5NVwP67NQvHuHMZYkd
	 NgKHE2aThrnmwUAr8Tnm+D88voD1s2qHhp3pqWA4MUk4v+IORTbk2Ek/M1ls1cXWgSgxA
	 tVxuYiXu6JU4h5UBrtB3/4ICEFivhyLCWHKUndl2Hb0DF2S0urjRNEWYU/9cRv3Ah8X14
	 0/Yu90bzqLpTkn0ua+hmmWWtUfdYNFkr6ogHSIS0FByN3+ZdGAw+LZuSBToWEmEdQg+/x
	 2NFlE6VVa0ddLWxSbJ+GWIooYGOLTp2bdMo/I5FjfjlAmlEAQSJtsZZ+FhkzBI/7yQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bbfCDUko;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53455606A326;
	Thu, 19 Nov 2026 04:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bbfCDUko
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66FB91F000C4;
	Thu, 19 Nov 2026 04:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061108;
	bh=VwaFIhwwf+gQWlsmyOhhz9syAe4pFe/A4qeIA6/V23U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bbfCDUkog7bu3bxYuHaQg7AA0Z2KlDPn3AS9ImbMoR241ZyARqqxQgQrWyAkn5rYy
	 +BDB0/Wa0K4qWg8AxsubKFyI4O4w4lzXXIZhIrbMa0DHMHvJB0S48Q7eK7aDEbKxJ1
	 WmFpzLXZJfoz70nto7ZYr3WMhI1bVvVEZHzC+uxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <blum@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1436/1848] hwrng: intel - return -ENOMEM when kmalloc_obj() fails
Date: Wed, 18 Nov 2026 15:57:54 +0100
Message-ID: <20261118150019.616686645@linuxfoundation.org>
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

From: Thorsten Blum <blum@kernel.org>

[ Upstream commit a0590c556cdbf88373d38494a23f1503d39b0ab2 ]

intel_rng_mod_init() incorrectly returns -ENODEV when kmalloc_obj()
fails. Return -ENOMEM instead.

Fixes: ee527cd3a20c ("Use stop_machine_run in the Intel RNG driver")
Signed-off-by: Thorsten Blum <blum@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/intel-rng.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/hw_random/intel-rng.c b/drivers/char/hw_random/intel-rng.c
index eb7db27f9f196..995811c2acb71 100644
--- a/drivers/char/hw_random/intel-rng.c
+++ b/drivers/char/hw_random/intel-rng.c
@@ -349,6 +349,7 @@ static int __init mod_init(void)
 	intel_rng_hw = kmalloc(sizeof(*intel_rng_hw), GFP_KERNEL);
 	if (!intel_rng_hw) {
 		pci_dev_put(dev);
+		err = -ENOMEM;
 		goto out;
 	}
 
-- 
2.53.0



