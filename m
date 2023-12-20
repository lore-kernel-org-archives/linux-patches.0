Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C22482F4;
	Wed, 20 Dec 2023 16:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hi+y1SEp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43FCBC433C7;
	Wed, 20 Dec 2023 16:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703088746;
	bh=qlRFwdmSJMFktWgB3t0dmCUP/JypCHdbe9iQwTzEIA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hi+y1SEpJdGgH2obbDBHa41M5NP+iCwDonVKq+CwQJwf1MVkLZ4csfHTjm++NnL/W
	 0sB87X2Z8n7Iwy3wtNK8qFVJyTfcIiow5RkSWwNIyY4Y+de2uZ74wT4VOHM68f4wJv
	 IuyUpcVSK+wDGmLH4CYProj4as7MxDSQtuRhqmLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 044/159] ksmbd: remove unused ksmbd_share_configs_cleanup function
Date: Wed, 20 Dec 2023 17:08:29 +0100
Message-ID: <20231220160933.364151522@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 1c90b54718fdea4f89e7e0c2415803f33f6d0b00 ]

remove unused ksmbd_share_configs_cleanup function.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/mgmt/share_config.c |   14 --------------
 fs/ksmbd/mgmt/share_config.h |    2 --
 2 files changed, 16 deletions(-)

--- a/fs/ksmbd/mgmt/share_config.c
+++ b/fs/ksmbd/mgmt/share_config.c
@@ -222,17 +222,3 @@ bool ksmbd_share_veto_filename(struct ks
 	}
 	return false;
 }
-
-void ksmbd_share_configs_cleanup(void)
-{
-	struct ksmbd_share_config *share;
-	struct hlist_node *tmp;
-	int i;
-
-	down_write(&shares_table_lock);
-	hash_for_each_safe(shares_table, i, tmp, share, hlist) {
-		hash_del(&share->hlist);
-		kill_share(share);
-	}
-	up_write(&shares_table_lock);
-}
--- a/fs/ksmbd/mgmt/share_config.h
+++ b/fs/ksmbd/mgmt/share_config.h
@@ -76,6 +76,4 @@ static inline void ksmbd_share_config_pu
 struct ksmbd_share_config *ksmbd_share_config_get(char *name);
 bool ksmbd_share_veto_filename(struct ksmbd_share_config *share,
 			       const char *filename);
-void ksmbd_share_configs_cleanup(void);
-
 #endif /* __SHARE_CONFIG_MANAGEMENT_H__ */


