Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024996;
	b=KwhggxoiYZMjIpJ8X1xI5Q0tNqaRctUZ6JX5yLCbiSx90qHsVPlVDcvBP2znLIdBdRJO
	 70nZCxdJr4A3JidqKWytgzdaTqycgxqFhxK8WlGb3ZmGQyvIQunxES9Ss1yjqFyqHNxSb
	 Qn9dA6E1OUxqtDoPDZgF/eytF6k+dspC4+oNuc1pIjG5LN9ex1TH4ahd8tZnc/3xsFUMV
	 13owovnuDv9chyOgh92z87o1sE/d6snlvs24zD5z8yUzDasTgHWw1fyYrRXJ/5rbB0iGJ
	 TIP9rRKB91+qZFtQfNj//aF3USbVD3I18X1cJwnpoWdonwNozHwp0l1ZIVo9AObQntg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024996;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Lo0NqNpwf+IbQc1kehie2XrqEp0hF53Xr3/9OUbhxAQ=;
	b=AG4JRHxEXpLx/wBxpTIu8GAFkb8myPQHM3G7sANVM+lRnXXMemHusG6JQoiy9Uy2MH2l
	 rXgGMngU/7hZYaYMWKreok73iAQGj7L5o9p3A8OtNp33AJM9G3wWTJ7YI+kBt79COLFOT
	 rVcnLJNdTlnn8EDOq1LfFsE2VFHMRBdWaq9k+DA0qVXLNk46v3wCh8elHgy0uuKw3WWZg
	 JnWcb/dvLq8lXEg1IuQf7kt3v4785djDYhicF6/PG/EwOWZrOpOV8DVuEvzkQQX8e6XgN
	 TYVW4nLxSWUeBdntH/HAfJoHboos/91VsVkTDErG+/hJYTQKchY6eXPZm2fOCWtN+lQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="YEcC/scd";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C87F606A31C;
	Wed, 18 Nov 2026 18:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YEcC/scd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E240F1F000C4;
	Wed, 18 Nov 2026 18:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024996;
	bh=Lo0NqNpwf+IbQc1kehie2XrqEp0hF53Xr3/9OUbhxAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YEcC/scdhnYGSAbNQ9Mie4yAAtkZLUsmm4XrGn01PP9rlvZpZg1JEXzu2BAnngGxh
	 ZH+DuuUnTOl7HQ2u4iIrrG94U/gGp9NCS/XLEQy62mWuBqo9/PjlBfPnGj5q8sU7Iw
	 wPY6QAd5D6DQ64DM5gDp8Wrs3x9wnHyuTIXmM4JI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danish Khateeb <danishkhateeb03@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0924/2151] serial: 8250: Fix section mismatch with CONFIG_MODULES=n
Date: Wed, 18 Nov 2026 15:44:19 +0100
Message-ID: <20261118150156.121887122@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danish Khateeb <danishkhateeb03@gmail.com>

[ Upstream commit c44a4925cdac02af781ebfae96df68a7bf3580b0 ]

Without CONFIG_MODULES, __init_or_module means __init, so
serial8250_pnp_exit() and serial8250_hub6_exit() end up in .init.text.
They are also called from serial8250_exit(), which is __exit, and
modpost warns:

  WARNING: modpost: vmlinux: section mismatch in reference: serial8250_exit+0x2a (section: .exit.text) -> serial8250_pnp_exit (section: .init.text)

The exit code never runs in such a kernel, so nothing breaks at runtime.
But a function that is called from both __init and __exit code can't
carry either annotation, so drop it.

Fixes: a300273c458c ("serial: 8250: hub6: Add cleanup code")
Fixes: 4cf187f9dea9 ("serial: 8250: pnp: Annotate init and exit functions for conditional discarding")
Assisted-by: LLM
Signed-off-by: Danish Khateeb <danishkhateeb03@gmail.com>
Link: https://patch.msgid.link/20260926163506.487201-1-danishkhateeb03@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_hub6.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/8250/8250_hub6.c b/drivers/tty/serial/8250/8250_hub6.c
index 76c9302e25cbd..0e37d09021578 100644
--- a/drivers/tty/serial/8250/8250_hub6.c
+++ b/drivers/tty/serial/8250/8250_hub6.c
@@ -52,7 +52,7 @@ int __init serial8250_hub6_init(void)
 	return platform_device_register(&hub6_device);
 }
 
-void __init_or_module serial8250_hub6_exit(void)
+void serial8250_hub6_exit(void)
 {
 	platform_device_unregister(&hub6_device);
 }
-- 
2.53.0



