Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026618;
	b=sS38jLPiFWvSOuBco9mmGpNlECeSm1Ir8SG3DKERjXFiMQfBN8dluXsa2twfe8HYGfpk
	 joGsBJoXks5FmcwxVZXdzFTcCel/2c6p0oresdkkXMoqAzkkYLQfsa2fR5tjb3KIIZb/p
	 AC8nBk3ijxfMsCxDIamZ/8xA7/gYRH98R0evwMktJCDxnJx58nsTzSwCcyDe5CLQzhs2t
	 khsd/y6rZRInb/dKty7q5v9b/Lf+inznrzRrRiPzJy465JTHJ2we+4HDoQUYUlmKY/fKT
	 /VYL9ZnSlP89kmBn3zyWkQ7iEWDNJcOFryjW26Bcz0VLc+M40s1LVylCDgMxqgwBrqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026618;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=ZJa41AFR1bLLC+HVTb8t3Rt1Y2EPFwljVi2t3RTvYOw=;
	b=3PDhuOF/7/R1/SbCUxDsvgiAB7UGLnTsweUi5DsIIX3Dh0TpTZCZ9Pu8Pr8ZQggk6YX6
	 pefeSsnlsYlNr9OLRvlJp8burmu/BsNlQ1ai6J2DKvggQw8Gl3uoLrvC0E6jvrTTrsm7C
	 egrpCdlOHTdvGCprofZXJ3f7pqfRSKXNhc/mvIWH6creTeetFqcDRqhixyfef/NQGsCw+
	 JnGyJ92tfroUIGacn2jMnhFaPC8p4Jz9mhMAXckAdhvAHTWbUZIymIL50MmCS83nJqMtx
	 d0Ifp+FenEalueNAfiFGNRYiGeuvyh/aN6uQl9ZGUtd8lJm8wYs2aqFc+YIRkUZs0pw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tU5I9Lvu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12EF4606A32A;
	Wed, 18 Nov 2026 18:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tU5I9Lvu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B7C91F000C4;
	Wed, 18 Nov 2026 18:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026617;
	bh=ZJa41AFR1bLLC+HVTb8t3Rt1Y2EPFwljVi2t3RTvYOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tU5I9LvuCLQX5p4OpVHLu94hk+J6KHeODeCoVwqCWjhFYqAffS6RYNJvnMPgSI34b
	 4l8LcKoCAumrCdqbfZTdHX8DvK3MlTYFKUxa4GCKwkMjG4mJywx2SDav+UDDfkusG8
	 i07ipuvajUg0CCjc5oINs5OtmmAZtyO0xz7HaLgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1498/2151] platform/x86: hp-bioscfg: fix off-by-one in password length check
Date: Wed, 18 Nov 2026 15:53:53 +0100
Message-ID: <20261118150216.441620644@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muhammad Bilal <meatuni001@gmail.com>

[ Upstream commit 0c22178524864af85ea380be4b2d36078c0edc9c ]

current_password and new_password hold MAX_PASSWD_SIZE bytes including
the NUL, but validate_password_input() accepts a password of exactly
MAX_PASSWD_SIZE characters when the firmware limits allow it.
strscpy() then truncates it and fails with -E2BIG, which
store_password_instance() ignores, so the write reports success with a
truncated password stored.

For example, with a max_password_length of 64 or more, writing 64
characters succeeds but only 63 are stored.

Reject lengths of MAX_PASSWD_SIZE or more.

Compile tested only.

Fixes: 8646a3b5ee3a ("platform/x86: hp-bioscfg: passwdobj-attributes")
Signed-off-by: Muhammad Bilal <meatuni001@gmail.com>
Link: https://lore.kernel.org/all/20261007134711.473857-1-meatuni001@gmail.com/
Link: https://patch.msgid.link/20261007134711.473857-6-meatuni001@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/hp/hp-bioscfg/passwdobj-attributes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/hp/hp-bioscfg/passwdobj-attributes.c b/drivers/platform/x86/hp/hp-bioscfg/passwdobj-attributes.c
index 97990191b71f3..938e70e806445 100644
--- a/drivers/platform/x86/hp/hp-bioscfg/passwdobj-attributes.c
+++ b/drivers/platform/x86/hp/hp-bioscfg/passwdobj-attributes.c
@@ -74,7 +74,7 @@ static int validate_password_input(int instance_id, const char *buf,
 	if (is_current && !length)
 		return 0;
 
-	if (length > MAX_PASSWD_SIZE)
+	if (length >= MAX_PASSWD_SIZE)
 		return -E2BIG;
 
 	if (password_data->min_password_length > length ||
-- 
2.53.0



