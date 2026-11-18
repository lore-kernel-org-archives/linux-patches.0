Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046879;
	b=NM7knp74xAaTW6f/SsGFbWrK/RE+IVg1rxn+w8nVJ/Lwz0Hn9r5GR3llw67rAzL1OaHV
	 8riV077E23veaidcno6tXn3WNYvcuYPsA1GyXz+taswLnB42Im3zhemPRzrHSL6YwDuif
	 76RVxdqnEH5K+9b01xyl34RabyUAeMz0uAaqXSO5L+7WC10LRSV6CSRUCLAeAJSdMYnrC
	 Un6C/6PjkwJXQpDVE/0tURGUUcsdtiHvnDHczFeasxwEfB7GzNlKb1jzVS6cfWlisp5yC
	 0q3JXcL7YqX3exfa7OXP7/UOnuSg5KgO05cVM0/WjkSfHukdkxleYw1dm3Xv4hywobg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046879;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hcetzXjVLdO/OlW8fN1/sZUOZKJjdtxWpTc85CTQSYU=;
	b=3rObzYvviib16XJzl+PIu8Uf/yU+P/BmrWl7FEiDBoIqePm+JiSYRFXP6gxzOsOIi1hc
	 Nt0m6p7IgE+jEivkVov+E0NBGeOI8fCSwDz9NxVUsryOimq+tHZR+A1NBAskFhHkllqYM
	 mx9qmTqsLk1nygA2FI3ADtIdGJIYXEJ85qyZAFmVACQijNv8lvDdd2jBnNSGde9j36kIa
	 ClcjwXGrXiUTXbSJruxzyQGR+Nt95/LyDRiqTdJaedb1vkl1XqlG9ZVeIn+8URl7jXVLM
	 4CaBQMP3cs7SQ7E3qFdsWG7/zCl72AQ76Myzg5CYj7N3De6AIuRo+KQVNRPezpvLmww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sDhB4qvp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B36B606A331;
	Thu, 19 Nov 2026 00:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sDhB4qvp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED9681F000C5;
	Thu, 19 Nov 2026 00:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046879;
	bh=hcetzXjVLdO/OlW8fN1/sZUOZKJjdtxWpTc85CTQSYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sDhB4qvpdAXE79RUMwtU30ISVfVUt0aLcyi8ZIp0wEcIeaajBAXvTuqNWe26JHgTP
	 AscYobcn8zo9NjQxmZ8DYMxnxMyTV82UPnMv11yZA+ghPVz9lmFljqxaJV3L++2hEi
	 4R7450C2CUUHhs/0cW8kT6l5cNTTtUNX2qTjfVFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Azeem Shaikh <azeemshaikh38@gmail.com>,
	Justin Stitt <justinstitt@google.com>,
	Kees Cook <keescook@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1439/2857] init/version.c: Replace strlcpy with strscpy
Date: Wed, 18 Nov 2026 15:41:13 +0100
Message-ID: <20261118150253.125806624@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Azeem Shaikh <azeemshaikh38@gmail.com>

[ Upstream commit 8ebab155ea18a6d6c47b17287a0ab4633334f6eb ]

strlcpy() reads the entire source buffer first.
This read may exceed the destination size limit.
This is both inefficient and can lead to linear read
overflows if a source string is not NUL-terminated [1].
In an effort to remove strlcpy() completely [2], replace
strlcpy() here with strscpy().

Direct replacement is safe here since return value of -errno
is used to check for truncation instead of sizeof(dest).

[1] https://www.kernel.org/doc/html/latest/process/deprecated.html#strlcpy
[2] https://github.com/KSPP/linux/issues/89

Signed-off-by: Azeem Shaikh <azeemshaikh38@gmail.com>
Reviewed-by: Justin Stitt <justinstitt@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20230830160806.3821893-1-azeemshaikh38@gmail.com
Signed-off-by: Kees Cook <keescook@chromium.org>
Stable-dep-of: b6bec5b63a5b ("init: fix early boot crash with bare hostname parameter")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 init/version.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/init/version.c b/init/version.c
index 01d4ab05f0bac..221ccede8902a 100644
--- a/init/version.c
+++ b/init/version.c
@@ -22,10 +22,10 @@ static int __init early_hostname(char *arg)
 {
 	size_t bufsize = sizeof(init_uts_ns.name.nodename);
 	size_t maxlen  = bufsize - 1;
-	size_t arglen;
+	ssize_t arglen;
 
-	arglen = strlcpy(init_uts_ns.name.nodename, arg, bufsize);
-	if (arglen > maxlen) {
+	arglen = strscpy(init_uts_ns.name.nodename, arg, bufsize);
+	if (arglen < 0) {
 		pr_warn("hostname parameter exceeds %zd characters and will be truncated",
 			maxlen);
 	}
-- 
2.53.0



