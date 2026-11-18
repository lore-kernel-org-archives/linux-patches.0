Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031959;
	b=d8G3KljBKLPQT55vgwAEO22CxwkUdwV+ZYOY4z8K/OTISKQ+IwFHW6CZOeLSM74/MbJQ
	 ZVsIaFGmqKDkRQyhwDcHkh++4F5XO4eKU+Xg5vG3oTg/CYA+kYaTocla/U63mZtZHI5Xc
	 xQaGgPND2Umj+mn9Z2y/NnH1ZQPTVV2bR9JAvTgrMQ5U2Wbd1bciAebphMKwF/ZiwR005
	 k0tkz+W5B3/dp/Fj1S+e5gjkcjBXGaaM/0NLzkfN2rO5+fqf5Jgle9GZ6jBdBjhhTnUUZ
	 S9IEQeGDXNVZfrxSngRJZXhRGl8PkETTYSaZRdJteLI2mz0bmgtG/Xu3qrkl4vQRvDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031959;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=UFWAFqeNRPgXE9REj7rcT94ciiSOrBLf2UoT/nRRGP8=;
	b=IeNX/P6hK0aVW7hCkuwoxryYrvLr/pt5gbblr8VMJqlkvgr2VBZjUQ3OGeiEKK56q2c2
	 oIkk0aD94mnT+9onfHpuU0+7N2GWBjZSj8uT5+Iv1XlZjTmh+lSCeIoulr/ff3x8FooC5
	 fjcuD5XPh9mF3V0HmrEYOQVEZcAx75b0kyJeek8elhoInqViyO0ilxmf0q6BUZIJqHvPG
	 kUPRJTqlgADPy3udqp8cy9JM88AC72px5GZVAo4oA4+QDAQzUTLP/P5kECVrBQdGHKHx4
	 O4rWH7wmOAnvcUbAdgaL2ERhQvI8txjtmeXNYQ4rpIStiXNjK1g+lIXu0kY2OqvvfOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wRkCBhj6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 002BF60A260B;
	Wed, 18 Nov 2026 19:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wRkCBhj6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 111791F000C4;
	Wed, 18 Nov 2026 19:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031958;
	bh=UFWAFqeNRPgXE9REj7rcT94ciiSOrBLf2UoT/nRRGP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wRkCBhj6Z9eB8UshInv28b/MbOW8f0q2UxLbU+nuiyabeUk87XgN5989cCeeTwKQU
	 ERs228R3UC0BWO4sRm5xywti3QTKsCtrED/uMhDeP7wIUE+0VFfP3rUTGi6eBar3Nr
	 SR2S4KiCn3T8LEa6qpb/FjHpP0N5MYCOafhK6nY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1190/1756] platform/x86: hp-bioscfg: fix off-by-one in password length check
Date: Wed, 18 Nov 2026 15:55:17 +0100
Message-ID: <20261118150057.259397222@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 52bff847d4297..814a4e8026cb5 100644
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



