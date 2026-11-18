Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041658;
	b=KC7WtlPmxB7CGC262bAVRMQbG1TlQM7RkXaz2PIhkJuew1vAeIM+qlp2D4YAj2EYfdQr
	 ZreyC2DVWz9IDwzeANcf7bU+aFWx6F4N2KI5EYawVq9DoiRtC8qD5ZQMNARMp2ZHYfEMG
	 bFfWV9dIqMqAyKjWXdoK3kqUdLYGB51PgI9L+IclUniwghJKw6ym3tbB/v7zHbJZJt12W
	 3suuINdwExyfbKhxtY0lB8k709OKV3SrRiATI4AOJOqOK3jEXn8yxuc3Wq/jPVnI446hj
	 hvNStscsSP6JubcCJduM25+qBDQ56V6DezBGUC/fyQojt406u9GJShdvDNGaHERVsMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041658;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=qYZ93W39gFfNse0oTj+zLL1I1Eljp/pBYwJOIZXpKUE=;
	b=MdDHQaH8paWX4eZCSPtD0e8zugQpe+4Nr6yhZjr4OgWhzt8gc154gf/MVUBtPq5xsPup
	 ZnZckxC4b32Mj5KeBeOba2i7nO6fhV139j2XYFbKBZiLEb2zm54ieA+R1MAvo+n7KVykX
	 24Ac+4yNVwol3Sdbd47OU4TIuQdam4F+XW3FwnVtAelf0IS6zZdKo0rgV0I9GckYVhL4+
	 Vz5HKqwlnQrLGmsvYzKwVTVs6iZgDberTuri8dz0CG7fpr4DyoZ79PXyFULRXaMALikSn
	 1gJy6kgdtEOKtprsiguJVsZWBTGfBPxAw2R5UpZWgIDHpK53GuG/hPE1cdAqEG/1kkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dHPXmi3H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A97D3606A31C;
	Wed, 18 Nov 2026 22:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dHPXmi3H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6541D1F000C4;
	Wed, 18 Nov 2026 22:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041657;
	bh=qYZ93W39gFfNse0oTj+zLL1I1Eljp/pBYwJOIZXpKUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dHPXmi3HhnpT1Rv7jNHBFkU5zkHzo4CwCDuZR6KIUCgLJdnYqVNWEBlzp320cjAL2
	 6Ce0wM22V0GtbDOo73CruODpvAHKhihYKI7BKSGVOdjg/P8uMQZvIjpZNKp2StH2YK
	 xznlbZ78chodxx+scsHunH70ZieCpE0mioxE/MZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2850/3318] platform/x86: hp-bioscfg: fix off-by-one in password length check
Date: Wed, 18 Nov 2026 15:57:52 +0100
Message-ID: <20261118150446.101696258@linuxfoundation.org>
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
index 5d4923b90ff38..aa03090c5d6b3 100644
--- a/drivers/platform/x86/hp/hp-bioscfg/passwdobj-attributes.c
+++ b/drivers/platform/x86/hp/hp-bioscfg/passwdobj-attributes.c
@@ -75,7 +75,7 @@ static int validate_password_input(int instance_id, const char *buf,
 	if (is_current && !length)
 		return 0;
 
-	if (length > MAX_PASSWD_SIZE)
+	if (length >= MAX_PASSWD_SIZE)
 		return -E2BIG;
 
 	if (password_data->min_password_length > length ||
-- 
2.53.0



