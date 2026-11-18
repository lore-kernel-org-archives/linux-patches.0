Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031107;
	b=MBkV8VxTwo5K9r+GQTzdULKpgem3xpzsLyuB/Ywyk00Ui0R41h70zU8ycklBJ3N+7ZjD
	 ucrL1T4G6pe/jYDkvx9Xn/kytxbFUTO/mwZ0bUbCkM+Jm2Ufq2bs4ZE6iJMMk7e2KvGEc
	 fnaBtiu+Z5/S3i3ZbzqH/3m9vU7yRTVF1w0LkzibI813moGHC8fcyjfXl0rl5G6zp0CYA
	 iN4puEzTXPH4vHHGwC6wqHcbN91G/n/xR657f93QGxtUmekBGn2BVFtEGbJEgwScMkJW3
	 sa9VK7PAvQgvh2lixTJ8nlfyETKdLClJjGjgOdMcM+GBwFid984OFjW2xJUJ4JQO84w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031107;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YW6MqhmaVvONGBTnTejuLF/4BrtC6ZmViNE75UZ38f4=;
	b=lpvsQ0Mw4463tpTSuYFyH/YpHfYD6acrraD9WCMHmfk6KxmOkHrtiN4X1h4ul8nSxSiF
	 Zjh47jhbbhYgMigqir5CdPbOhfn8YvgbxK5EFVTVKqIje+p0wqb/XKqyR5NROIZflXMGv
	 S8uPPnEIo67s9mzzY+zYKEnH/+4ZiHMLnHD5KMiQGbu59I06YhRz7ZsjAj7V5bM89ZwUl
	 dJNSTjv/TCOmiTtjq3wP9rGVdX2j6vG/tqI6VsGusmlDT8Ufp7JRi3BpeI90i1KnIheDl
	 dEfYkDYCtnXxGge9kSZ10rpzmQGBdxP7A3OUVcBwBJmmo5FtMUdGhmPUqZNnQteevJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IIMBb7CN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AF92606A325;
	Wed, 18 Nov 2026 19:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IIMBb7CN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B09A21F000C4;
	Wed, 18 Nov 2026 19:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031107;
	bh=YW6MqhmaVvONGBTnTejuLF/4BrtC6ZmViNE75UZ38f4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IIMBb7CN0lgLmncJOA8j+I//qsWPK6EvtayxeRGTNzjez2mD010dkdM4WGq2Zw9Cn
	 zN6L8EkPWBobeJY++DSiz8TauaLrx4KraRGF7rT1QKXfWo5c4PgIIpWeG0ptqtPzSL
	 7+em+NLJ+agxY8q/8I/ICE6/iI+GeYS1NEtVkWYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wilson Felipe Pereira <wfelipe@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0941/1756] init/main: fix false-positive kernel panic on environment variable overwrite
Date: Wed, 18 Nov 2026 15:51:08 +0100
Message-ID: <20261118150047.483846072@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wilson Felipe Pereira <wfelipe@google.com>

[ Upstream commit 51e766bcd35e706d8df29dd0fac98871fdced261 ]

In unknown_bootoption(), the limit checking for environment variables sets
panic_later *before* checking if the variable already exists in envp_init.

If a user passes exactly MAX_INIT_ENVS custom variables and then
overwrites the final variable by matching its key, it causes a
false-positive hard panic on boot despite not actually exceeding the array
bounds or increasing the total variable count.

Swapping the order of these checks allows the duplicate check to break out
of the loop before the panic flag is erroneously latched.

To verify, boot a VM with 31 custom variables (filling the array up to its
limit of 32) and then overwrite the very last variable:

  ENV_VARS=$(for i in {1..31}; do echo -n "var$i=$i "; done)
  qemu-system-x86_64 -kernel bzImage -append "$ENV_VARS var31=overwrite"

Without this patch, the kernel crashes instantly with:
  Kernel panic - not syncing: Too many boot env vars at 'var31=overwrite'

With this patch, the kernel safely overwrites the variable and boots.

Link: https://lore.kernel.org/20260818045357.4123784-3-wfelipe@google.com
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Wilson Felipe Pereira <wfelipe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 init/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/init/main.c b/init/main.c
index 92397b5a3a6e3..79ca15273730f 100644
--- a/init/main.c
+++ b/init/main.c
@@ -537,12 +537,12 @@ static int __init unknown_bootoption(char *param, char *val,
 		/* Environment option */
 		unsigned int i;
 		for (i = 0; envp_init[i]; i++) {
+			if (!strncmp(param, envp_init[i], len+1))
+				break;
 			if (i == MAX_INIT_ENVS) {
 				panic_later = "env";
 				panic_param = param;
 			}
-			if (!strncmp(param, envp_init[i], len+1))
-				break;
 		}
 		envp_init[i] = param;
 	} else {
-- 
2.53.0



