Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EE0F40BFC;
	Wed, 20 Dec 2023 16:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mcPudXp3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2244FC433C9;
	Wed, 20 Dec 2023 16:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703088653;
	bh=ImBiG/QNSLDj44Sw7pP36cvFXKUchnSgcNxhb7DVb9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mcPudXp32UajTLoO5a7bIIZL2eIOSNxywoMa/7DYt54SI073/nJXUuXEFApfeS6PX
	 Foi47NIk2XML24gdgKidtat4vRnttdb/6u2coJNvu6wmQXPp4r97cxNSHEfAAlpE3F
	 qqxp8C+bDQn6PmbEZ7JLv6dVo8mW9uxT+m1SsCs4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Marios Makassikis <mmakassikis@freebox.fr>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 010/159] ksmbd: Remove unused fields from ksmbd_file struct definition
Date: Wed, 20 Dec 2023 17:07:55 +0100
Message-ID: <20231220160931.765061169@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231220160931.251686445@linuxfoundation.org>
References: <20231220160931.251686445@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marios Makassikis <mmakassikis@freebox.fr>

[ Upstream commit 305f8bda15ebbe4004681286a5c67d0dc296c771 ]

These fields are remnants of the not upstreamed SMB1 code.

Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/vfs_cache.h |   10 ----------
 1 file changed, 10 deletions(-)

--- a/fs/ksmbd/vfs_cache.h
+++ b/fs/ksmbd/vfs_cache.h
@@ -96,16 +96,6 @@ struct ksmbd_file {
 
 	int				durable_timeout;
 
-	/* for SMB1 */
-	int				pid;
-
-	/* conflict lock fail count for SMB1 */
-	unsigned int			cflock_cnt;
-	/* last lock failure start offset for SMB1 */
-	unsigned long long		llock_fstart;
-
-	int				dirent_offset;
-
 	/* if ls is happening on directory, below is valid*/
 	struct ksmbd_readdir_data	readdir_data;
 	int				dot_dotdot[2];


