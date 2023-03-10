Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BECF881F
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:43:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1DB1C433EF;
	Fri, 10 Mar 2023 14:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678459414;
	bh=nmBdanEHMTbExyB7ERQ9GpBI50Fx8n+sAvs+/M6tljY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kgm463ANkzgSXn21fhIQWRujUn/gb04yohWwMDjX5oXQ6wQHFZCnPV6en4qjNi5xa
	 NDXVrXFCHrXjQDKxOrVQdyycqf3a3v1jeFw4AKwgT6xKaoY3XqosF8AeYDFbOF5c/s
	 r37g9Vs5OBirnHGpmdu/wsay+aAz8GTWL8tujJhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Slaby <jirislaby@kernel.org>,
	George Kennedy <george.kennedy@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 323/357] vc_screen: modify vcs_size() handling in vcs_read()
Date: Fri, 10 Mar 2023 14:40:12 +0100
Message-Id: <20230310133748.918084596@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
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
index eb7208f07345d..90de3331e4a51 100644
--- a/drivers/tty/vt/vc_screen.c
+++ b/drivers/tty/vt/vc_screen.c
@@ -296,10 +296,8 @@ vcs_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
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



