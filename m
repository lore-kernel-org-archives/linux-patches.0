Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034244;
	b=Tbir9VWUD3H1Ze9QpOH4R2Yp2F9djso91Dnm5x+U5aBn0G62IGc7MYZj7dHPcHDZRspI
	 F8umm6e249r08QlOd1TgK7UK3Ee/K2HWffJ38ln2+nFkT/LKjUetNeRm+nNRGLI2n+vLu
	 AWsYKZGfhUktqofd+Olc9ddPGVtLyURsuTQx/f/DCJQuuFLsaIwbtBde+wCUCs3T8eyuX
	 vLd4ARaR76VIDhVddF6Sv28S2xyTdB7ludkbTNvVQP3mB2pxX9en5PMZn3wgcVZOs0eeE
	 cwX7d/+d5yHMC7iEpg0PHUIK0wGw3TDKVYraR8tustkgYfHHK/SBRtRUQW0cZ3DEnEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034244;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OOP+o8pjzD17F6eLQT+ZQ2AhWCe+gUiwBP1uOa/Xu9Y=;
	b=DrcbIwN7WA+Gl/THZg5I6JxKjFWmcc8KH1e6QLG6NXtLnt3UjcoC3N42TtbZJlJTsesA
	 IdCIVU3OVzN+ttYZONqBv8ZaG8pLy7wTD4i3feeLZW5V8U967CasNqLwEKqz5AMH/W0yU
	 F68RYByit7tZI68OBAw2JOnLfoa7PJlOUSZut/3TH5SQFhO0RSKeQVpu4MZvWMfYJqVsB
	 452kzR79VjI0Kq0fItDImu8ziSXzLVoquzBFaetNOdGrOBGOHBCfsB2nyCkpfyMAjaJvY
	 udv4l1U+Jbl/jlUCXqRjZhtc/NOy4zo+bt+Gx32WPZL8up+RorHsTUDM9mWGUZZACEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AWtGQGjo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB2F5606A333;
	Wed, 18 Nov 2026 20:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AWtGQGjo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E4981F000C4;
	Wed, 18 Nov 2026 20:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034244;
	bh=OOP+o8pjzD17F6eLQT+ZQ2AhWCe+gUiwBP1uOa/Xu9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AWtGQGjoz/awkgKnOyuxARCqflF50M0+vfVH53L987zPL2fpr1cVPIqdxIVrOpND9
	 eScgDnhwmucSc5oIofCwS7JMd5orOnmbYtmmFwHIhl7MbbkXfZZX8xyHUfGnB34pVn
	 O62jWz43gplqrxu3MinnBmcyaeVl2K8h6pKPCgOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Huth <thuth@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0302/3318] smb: server: Free session data in user_session.c with kfree_sensitive()
Date: Wed, 18 Nov 2026 15:15:24 +0100
Message-ID: <20261118150324.791467697@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Huth <thuth@redhat.com>

[ Upstream commit 9a4bd6507c21f66e84dc021705a4b9d84773111e ]

struct ksmbd_session contains some arrays with sensitive information, like
sess_key, smb3encryptionkey, smb3decryptionkey and smb3signingkey. Thus
let's make sure that this information cannot leak via the heap and use
kfree_sensitive() to free it.

Signed-off-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/mgmt/user_session.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/mgmt/user_session.c b/fs/smb/server/mgmt/user_session.c
index e55b95d22e169..590e9eb48a515 100644
--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -168,10 +168,10 @@ void ksmbd_session_destroy(struct ksmbd_session *sess)
 	ksmbd_launch_ksmbd_durable_scavenger();
 	ksmbd_session_rpc_clear_list(sess);
 	free_channel_list(sess);
-	kfree(sess->Preauth_HashValue);
+	kfree_sensitive(sess->Preauth_HashValue);
 	ksmbd_release_id(&session_ida, sess->id);
 	ida_destroy(&sess->tree_conn_ida);
-	kfree(sess);
+	kfree_sensitive(sess);
 }
 
 struct ksmbd_session *__session_lookup(unsigned long long id)
-- 
2.53.0



