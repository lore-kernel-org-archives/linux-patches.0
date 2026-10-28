Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216397;
	b=fvPgse5ctZ4Azsr28GocUhAkrSA97xHOrLGkK/J38ojU9I5410Mne1uUrvEUHLsvWAnD
	 NMcrtxHV67jbzOqUMgGkrl3IvE7+21AVOTPdIKBqnEBs5t7egd0uKHozuA2+ijttEAE9F
	 1/gYADnMd7lzxz4idVRb5sM1Xjqm7H2/JtpxlfIODQLiw2DDo4JbVwO2Ud82/zBLUAQcv
	 iFG7YSPpBk1mYZ68eQtEaavlibPXKHz9p+sg0ezb0VqUl230/Q+DhUNGJnZ0GWEYxtmrV
	 AEEKN3Wj/p1imQK0r5EdkUA4IzcnCwIfeXFvhsXMCrKRGss0WSRUYoAKOG3rsyLPHPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216397;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=siXCiQo1aD3YXqRegpHb7OsFxL4iLfXPzhbOA1Z7daY=;
	b=KcJ/qCUICK34eq3PmflCCfWP2SzIyjJyOJw9VnfXam5/Ky8irK3ahlSZacI2VxTeSPgh
	 jUmh9UjxI58XKfUpPSKp98P9HkO/GKEN+CnbTBSLffsD6v6PlLn+T9DGVCs6Zq4mnzrmH
	 Ye7tAkdr11gGwVWceq/eX3+TasutT1BG09aZn5ZNwRyCZTKYFoiwJWl/J0i3GT5HIcoXL
	 OC2B9jBEpUI/eSGdI2kI4CgAGdj8rf0Z4jz3+T1L11e4yqSG8Gxj5U2HEw52DumKynxeR
	 OETx9cDktFcwxfMXTRhRB2if6vdfZVw0DQhhWTRfPBkdZp3HFl6LHzs+axHhitb9TmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Se2kP3W6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3893606A31E;
	Wed, 28 Oct 2026 19:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Se2kP3W6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DC971F01825;
	Wed, 28 Oct 2026 19:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216396;
	bh=siXCiQo1aD3YXqRegpHb7OsFxL4iLfXPzhbOA1Z7daY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Se2kP3W6ZJvthpLMfWFI8DRI42QGPue1ohMh4SuBXOKh+IgOntU2V6kF1MJ715LXO
	 rpcyvrTY6BpjqQrBXZqUAS4bWJU1lAbzJimnzvKLa8slBue3K3p9RbpDINOk+Fo+ji
	 yxWdY6+74fGglOPtm0fpRM0Y5Ps5Wg5E4KEm7HAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1541/1887] smb/server: fix null-ptr-deref in ksmbd_ipc_tree_connect_request()
Date: Wed, 28 Oct 2026 18:00:37 +0100
Message-ID: <20261028170534.533014350@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: ZhangGuoDong <zhangguodong@kylinos.cn>

[ Upstream commit d2ccf905f47d2344270749f4dfa905afcd3edeb0 ]

See the procedure below:

  ksmbd_tree_conn_connect
    ksmbd_share_config_get
      share->name = kstrdup() // fail
      if (!test_share_config_flag(share, KSMBD_SHARE_FLAG_PIPE)) // false
      // do not check `share->name`
    ksmbd_ipc_tree_connect_request
      strlen(share->name) // null-ptr-deref

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/mgmt/share_config.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/mgmt/share_config.c b/fs/smb/server/mgmt/share_config.c
index 7db7345f1af94..cb89e54c4da84 100644
--- a/fs/smb/server/mgmt/share_config.c
+++ b/fs/smb/server/mgmt/share_config.c
@@ -161,6 +161,11 @@ static struct ksmbd_share_config *share_config_request(struct ksmbd_work *work,
 	atomic_set(&share->refcount, 1);
 	INIT_LIST_HEAD(&share->veto_list);
 	share->name = kstrdup(name, GFP_KERNEL);
+	if (!share->name) {
+		kill_share(share);
+		share = NULL;
+		goto out;
+	}
 
 	if (!test_share_config_flag(share, KSMBD_SHARE_FLAG_PIPE)) {
 		size_t path_len;
@@ -217,7 +222,7 @@ static struct ksmbd_share_config *share_config_request(struct ksmbd_work *work,
 				share->path = NULL;
 			}
 		}
-		if (ret || !share->name) {
+		if (ret) {
 			kill_share(share);
 			share = NULL;
 			goto out;
-- 
2.53.0



