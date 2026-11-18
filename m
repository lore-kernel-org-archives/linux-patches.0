Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059470;
	b=wnyhzZV0dYow5xELiPNP7emBYFfX5jphYPXj7yFGA7lzd6i23ZEQKipes4lqPyAA0LYA
	 0ZPrgFF+boXPKcsJrl/dW/bklaNvFvPNqYO7t8EdNRGcj0TT9Rvoeof1vJO4P/UyhufaE
	 ra5PYjhA8fvgboAno6lJcmRXLC1eNYIsINHRzFYN4EbqJZxQve6WO0Vs0e9P7keDAzI7r
	 0J2LKSodviKiYBW/gK/9WW1tvnp6759hYQ3u27wXtw/MftxMzHdYGfNJ+PxWko8DEOKbN
	 Zna9Q5ovL3MFDm9ejYF1oNTx7ZrTz45kezyhpjKc+Cx6oDiPuI0CVXGrxDxWjhCUHPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059470;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MiXzcQSGnsDU/1OVYiXX6Fkjruii+DdTxTvbyt9hwQQ=;
	b=JV3OIP+O67iNJvfNcqIWpsXtOYiDtSZACJMbZ/o7UxOXu3/8QDbi6T0TlH5YAYe/61+S
	 VxemUhvUjnEFndSumYNeH3TOnt2GGXeI4b9zdxaOE38/upEzQ98k5O2zOGfsynQA7UvQS
	 Mdr/kP2wwVtKvxDi4OUU+zuVHApJCkg213oU6REdqAGsv9WIaErq4mUz9Y+dUSCDuZ6Ue
	 d/QARGP+zeTBCcP53qwH9xm6kgSqXL5hPMxkorAQocqbWwn19hNUe3nIlUTdH53ot/4+f
	 wRFzhA/w/SmkLnfOqoVewO4YKtsbjm6jkwbD4EdYUcWfVapy44vzXAVJlZ1qdw93c+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DKiqKTQJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14A74606A31C;
	Thu, 19 Nov 2026 03:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DKiqKTQJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62EF61F000C4;
	Thu, 19 Nov 2026 03:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059469;
	bh=MiXzcQSGnsDU/1OVYiXX6Fkjruii+DdTxTvbyt9hwQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DKiqKTQJ7sp6nSRRiiWxruAeYSylBztTIPSyaIMeL4//VzzWYj6DUN8ZilQk7BTGG
	 kjlkTdqSJR+SOkqlwCV26t3KbY4uOHCLdANxK/RXRD/v+oq+ExIY24caCC7LRtHMuv
	 Nlhxk+OXPIRAlN4HuDOIJIekrPijc1wHFcnVe3sg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chung-Chiang Cheng <cccheng@synology.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0854/1848] splice: report related fsnotify events
Date: Wed, 18 Nov 2026 15:48:12 +0100
Message-ID: <20261118145952.302839728@linuxfoundation.org>
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

From: Chung-Chiang Cheng <cccheng@synology.com>

[ Upstream commit 983652c691990b3257a07f67f4263eb847baa82d ]

The fsnotify ACCESS and MODIFY event are missing when manipulating a file
with splice(2).

Signed-off-by: Chung-Chiang Cheng <cccheng@synology.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Jan Kara <jack@suse.cz>
Message-Id: <20230322062519.409752-1-cccheng@synology.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 79b496ebe382 ("splice: avoid stale f_pos writeback on error")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/splice.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/splice.c b/fs/splice.c
index 8237ed720a35f..c4d3ac181a9f6 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -30,6 +30,7 @@
 #include <linux/export.h>
 #include <linux/syscalls.h>
 #include <linux/uio.h>
+#include <linux/fsnotify.h>
 #include <linux/security.h>
 #include <linux/gfp.h>
 #include <linux/socket.h>
@@ -1079,6 +1080,9 @@ long do_splice(struct file *in, loff_t *off_in, struct file *out,
 		ret = do_splice_from(ipipe, out, &offset, len, flags);
 		file_end_write(out);
 
+		if (ret > 0)
+			fsnotify_modify(out);
+
 		if (!off_out)
 			out->f_pos = offset;
 		else
@@ -1102,6 +1106,10 @@ long do_splice(struct file *in, loff_t *off_in, struct file *out,
 			flags |= SPLICE_F_NONBLOCK;
 
 		ret = splice_file_to_pipe(in, opipe, &offset, len, flags);
+
+		if (ret > 0)
+			fsnotify_access(in);
+
 		if (!off_in)
 			in->f_pos = offset;
 		else
-- 
2.53.0



