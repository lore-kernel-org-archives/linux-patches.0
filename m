Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053750;
	b=X0udeGsIfxOAoF06q1UtlGww6vgXqhn0lrSDwRGL/UTvTtYBVcRO9t1MII0sZiMXCVD6
	 LQuHNlv0LhTPov6nO7fqNzlu4g782Jzv1/Vs41RqhyHA4HNJ4fYufbGj9k9nr10wcAqhe
	 kFodP+FR/sdDQylefCwObsw7kyKGwAW4o6fk+WCmc1y0nZYKwZm1j4oGNCB7d2zfT6Jt9
	 lJFUvoTdcwNrHYREb2cVtC3Yl3fxy73SnEZAuOxaGwZOEkSFz/J2e63CqDFvHXY8EQVJK
	 V+oUJt7Zcs76Q6Ds5NupJr0iKuTa3KLSo374RxJrB/OJjIKrmMCjzZFphZI+ZkSqAsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053750;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rRLbNXYR5A7u1A0tPWA4Btws8PKg3Cr75g4lRr1pxZg=;
	b=fDco3snGe7QxQNwLTHI3ICc6BWd7rfOQHq412D35mETum021M0s+Un6NumsdHnQXuPcU
	 AzgyT0SNIufdgciy+qI890ps8OjSitaxDbUqvQq9Gu3x/iY4gXFzvJezg+UnMq4tcWffV
	 Nl/CuvriLODMIY3ytViDHBt70aSSoXT3NRxbFzLBnsb3gGKWHaZNkWKYiJ5HPZbb5Y55W
	 M2BD5sRmjJyRRBiGumKi+caOHlGtdR2MFwUpWjfs0ibeiYEeEIx/VXCHq6dgBQPy5Eije
	 +IG74TRNPrK7QpmEXaxA/Qypg01nb8+rwuTj/EVU9zE/pnufjNa79ecOLxbNTRcHagA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tTelycG8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F491606A31C;
	Thu, 19 Nov 2026 02:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tTelycG8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7024D1F000C4;
	Thu, 19 Nov 2026 02:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053750;
	bh=rRLbNXYR5A7u1A0tPWA4Btws8PKg3Cr75g4lRr1pxZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tTelycG8TPXsKDwnwUXJqCx/YNcSlECjdF3lOIMwzpha2YY0Db9hyDm3fVH7AvOH4
	 uEYnXp7FgOGUMLlkqiCvl7Ezi1sJH7HorN4oMEqOnjt//kM01uiEbd9i0GNxR88zik
	 Duvsw6MHbGSZcS7UvCV1qXvE9pJ9ZixecX0rbpY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chung-Chiang Cheng <cccheng@synology.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1022/2214] splice: report related fsnotify events
Date: Wed, 18 Nov 2026 15:44:58 +0100
Message-ID: <20261118150053.245522372@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a43152bb106fc..b939b101fd832 100644
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
@@ -1108,6 +1109,9 @@ long do_splice(struct file *in, loff_t *off_in, struct file *out,
 		ret = do_splice_from(ipipe, out, &offset, len, flags);
 		file_end_write(out);
 
+		if (ret > 0)
+			fsnotify_modify(out);
+
 		if (!off_out)
 			out->f_pos = offset;
 		else
@@ -1131,6 +1135,10 @@ long do_splice(struct file *in, loff_t *off_in, struct file *out,
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



