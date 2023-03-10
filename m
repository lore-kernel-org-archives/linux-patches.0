Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B303848D
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:26:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FE58C433D2;
	Fri, 10 Mar 2023 14:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678458371;
	bh=h8x5Ys3GcAwhkVCB6D8L7pZJidYLCZKoqGpbrnPzUhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yEBCZqBHtBC72XqyQ4jhRkN65xOwMKKfRQ6MbLuuIJmi1aymT9dHXZ5wLW5nHZLtT
	 MlC4IAEJPuyQtBbBEG3nrCNSxjaVPrTHnPEj7QjvPT9voZdPbiGlm4BQKlKKXNVLnk
	 WqH9QostPxIFL+KhBOTzGap+N13MYwPTy5O35GjM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Slaby <jirislaby@kernel.org>,
	George Kennedy <george.kennedy@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 227/252] vc_screen: modify vcs_size() handling in vcs_read()
Date: Fri, 10 Mar 2023 14:39:57 +0100
Message-Id: <20230310133726.146605026@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: George Kennedy <george.kennedy@oracle.com>

[ Upstream commit 46d733d0efc79bc8430d63b57ab88011806d5180 ]

Restore the vcs_size() handling in vcs_read() to what
it had been in previous version.

Fixes: 226fae124b2d ("vc_screen: move load of struct vc_data pointer in vcs_read() to avoid UAF")
Suggested-by: Jiri Slaby <jirislaby@kernel.org>
Signed-off-by: George Kennedy <george.kennedy@oracle.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/vt/vc_screen.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/tty/vt/vc_screen.c b/drivers/tty/vt/vc_screen.c
index 5b5e800ab1549..28bc9c70de3ec 100644
--- a/drivers/tty/vt/vc_screen.c
+++ b/drivers/tty/vt/vc_screen.c
@@ -278,10 +278,8 @@ vcs_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 		 */
 		size = vcs_size(inode);
 		if (size < 0) {
-			if (read)
-				break;
 			ret = size;
-			goto unlock_out;
+			break;
 		}
 		if (pos >= size)
 			break;
-- 
2.39.2



