Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051463;
	b=Tf/HmT1Cpi5nUcX9XUBDVxSatEPsID6JYGAFZBoTWEbaAXUDkV2HvAAW0hvm5Xtecd2s
	 Snk3RNE9hmtY+8iaVoRZLUIAAGewq4YNSj8mVkpS+Ck/CrRA4cco80mLm7LZgVNPLOW9m
	 N6vb/B2zgIRaq5pcWELcuoD4Qqa27s3+/tzyazOi4meKQOSd/huZBmFjKErNi3bzPXQON
	 3+1tm9lHDMPy7tOoBjo+1TJ6DciyMbEocaTVWCtPB3+rvazH1ObuOpVIrWlHc0f2m1Fzz
	 2WgF8poHecw37NlzSydFi7qYsDmn4bDzivHZCMR0z5KXhB3PAvP/tl6A8nqISQVcQww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051463;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wYDFVQaJysNwrDcpMcRz+n9Po1XFgLRI1IyBAdHK1F8=;
	b=DMhsgbCMCtwdbBqqHfGAQLTi7y9nXlE0+54hV8qxe2BCez+Gadf6AhoEDM1iKWPXr0eM
	 ftUvzGKpf3/5iRrRCeB450t/jbT5wZ1nJDWxwQ/GXaP2bgTdQ31k19fPZQi4OhYsIr1dF
	 G5jLI/B6bWDLLR1WAh8Smm4rzs7fY+UUPnqKlrYW8GspAcjAiszzvYnEGco+JkXfHXgJr
	 DKrN2aWfgr+5alHs56ff5ZPU/oavXhxSIXMSOx1JGQBB1dqVA+kKhTbFjLn7YsBNDoTfO
	 LcNv/aY6RX8+a49owN7rZ/Kt9A02oovTliKjendvVnBT0XH8C4lZVvX0jsu00MfsOxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G48ED1yH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F7B2606A325;
	Thu, 19 Nov 2026 01:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G48ED1yH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECA2F1F000C4;
	Thu, 19 Nov 2026 01:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051463;
	bh=wYDFVQaJysNwrDcpMcRz+n9Po1XFgLRI1IyBAdHK1F8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G48ED1yHfmjAG7E7z19fnuqrfpTc03xEuiGye46Ta5EjzZDiYqu3vS56BQ5VPC+rX
	 M3Ej3ze+/oLfImtT9HYzlStYaz2WEcFC0/FThzOwa1xdoygZPZYTzxEmcL6+cIp37v
	 HqaowpkcbDB2AWmGXlL2ZorpvSCAtiBdpGjUfdLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Huth <thuth@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0218/2214] smb: server: Free session data in user_session.c with kfree_sensitive()
Date: Wed, 18 Nov 2026 15:31:34 +0100
Message-ID: <20261118150018.887486523@linuxfoundation.org>
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
 fs/ksmbd/mgmt/user_session.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ksmbd/mgmt/user_session.c b/fs/ksmbd/mgmt/user_session.c
index b6b6572d402d3..07d9205ab97bd 100644
--- a/fs/ksmbd/mgmt/user_session.c
+++ b/fs/ksmbd/mgmt/user_session.c
@@ -151,10 +151,10 @@ void ksmbd_session_destroy(struct ksmbd_session *sess)
 	ksmbd_destroy_file_table(&sess->file_table);
 	ksmbd_session_rpc_clear_list(sess);
 	free_channel_list(sess);
-	kfree(sess->Preauth_HashValue);
+	kfree_sensitive(sess->Preauth_HashValue);
 	ksmbd_release_id(&session_ida, sess->id);
 	ida_destroy(&sess->tree_conn_ida);
-	kfree(sess);
+	kfree_sensitive(sess);
 }
 
 static struct ksmbd_session *__session_lookup(unsigned long long id)
-- 
2.53.0



