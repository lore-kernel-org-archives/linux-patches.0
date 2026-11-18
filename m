Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036591;
	b=oJVYmavIdPXgH5ZQH3FR+7zbCFdZMVSTZXzFWJ4/7yu/scWFp0w4Lj08lrqpOAoOdzUi
	 oeXGgJGkoEej+PZC5wrZ61I5ESYGg9t4JqqVbbS80vRB+UV50zr+Ltka8dtGJ1w4agUoF
	 3ulM/JOw13EAHz9G3hDAH7M6aOZ4D4h7lXa5qNYtBVrTAhijHmtKuB5zPms9VDNlKEwG7
	 EqCKrYmz2YAyq9sbGUnWNQER/zk42/fhasQwsq5F7wQ/Gx9nVmTnjoYlpuDG00Vo6Oy35
	 Rmqv22Orv1E/IpH9mO1A+NRM6xhjlsjrYgj0luGwbFMDKBtosZhNMzc5UjvNHoIDcbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036591;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=9OoY9/1jnd7znCz6G3rZwBqt4UQHpVgNy6K5PvyQieo=;
	b=W7dAdGitchVLY3ajIUaAQkUfSEemcc2qtVakw4MkOBvm1uFKox1V1KqrmG/JXBowo8j3
	 Gw8TRCJCg5VuoEwp5jeRgFFTlNka0oArGqScfEccFsyt8RsL/dUjzaX/nsKxVOaF9DgYx
	 BGUaqDMAhO2lsjJMsiBBpUNGD84WQJTh3mi+VJ7AKqbQdq/q0rNz/uWOSOShZwg4QqpKe
	 m6Z0SyUztGc8dNimXe+4x/XOQ5wBaz0N9h18C82mQLbYLd2wUcZMOpjbjtRYT2JHftKPM
	 BHoetpQYPvgZbxwGoMimvG1W2kwvriHCwmf3QFI43Jzb9NGKzdcNcIfqAaBMy0S7o8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oxUP4Ene;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE063606A320;
	Wed, 18 Nov 2026 21:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oxUP4Ene
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48AC41F000C4;
	Wed, 18 Nov 2026 21:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036590;
	bh=9OoY9/1jnd7znCz6G3rZwBqt4UQHpVgNy6K5PvyQieo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oxUP4EnesM5pDq+e+RxFe2xdsVfZDRr9AClRCtJrVxej0ZOEYBh8E1eF/mfNXS53f
	 cWlCTJOG40/EA9gEJJULrrsHZniS82BVkaJrcsv7HU5f0qDrE3IILdu2QM2q2cSscJ
	 WeZZc95J45Iem4omc9KYcyKWCdpuwzRT/Mb+99Nw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1107/3318] platform/x86: hp-bioscfg: NUL-terminate the SPM auth token
Date: Wed, 18 Nov 2026 15:28:49 +0100
Message-ID: <20261118150353.205278426@linuxfoundation.org>
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

[ Upstream commit f2769668959f6411ac69e83080a240f8a8785e05 ]

auth_token_store() copies the token with kmemdup(), which does not NUL
terminate it, but hp_calculate_security_buffer() and
hp_populate_security_buffer() use it as a C string and read past the
allocation.

A lone newline (echo > auth_token) is worse: kmemdup() of 0 bytes
returns ZERO_SIZE_PTR, which passes the NULL checks, so a later
attribute write passes it to strlen().

A userspace replica of the two helpers under ASan reports a heap
buffer overflow in hp_calculate_security_buffer() for the unterminated
token and a fault at address 0x10 for the lone newline, and is clean
with this change.

The token is a string, so copy it with kstrndup(), which always NUL
terminates and allocates at least one byte.

Fixes: b2715aa2e135 ("platform/x86: hp-bioscfg: spmobj-attributes")
Cc: stable@vger.kernel.org
Signed-off-by: Muhammad Bilal <meatuni001@gmail.com>
Link: https://patch.msgid.link/20261007134711.473857-9-meatuni001@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/hp/hp-bioscfg/spmobj-attributes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/hp/hp-bioscfg/spmobj-attributes.c b/drivers/platform/x86/hp/hp-bioscfg/spmobj-attributes.c
index c9ed2134d39fb..46882298e92b2 100644
--- a/drivers/platform/x86/hp/hp-bioscfg/spmobj-attributes.c
+++ b/drivers/platform/x86/hp/hp-bioscfg/spmobj-attributes.c
@@ -307,7 +307,7 @@ static ssize_t auth_token_store(struct kobject *kobj,
 		length--;
 
 	/* allocate space and copy current auth token */
-	bioscfg_drv.spm_data.auth_token = kmemdup(buf, length, GFP_KERNEL);
+	bioscfg_drv.spm_data.auth_token = kstrndup(buf, length, GFP_KERNEL);
 	if (!bioscfg_drv.spm_data.auth_token) {
 		ret = -ENOMEM;
 		goto exit_token;
-- 
2.53.0



