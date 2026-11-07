Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061020;
	b=LvlrBGuf9w8TNI5NkelcdtvtBzgVEPS1kk5QENUhXOVWZqre3qmlhd1y5y3Kg2Ye7uKE
	 cyFdM+ZFBVz9qyo8Wr8CmqWZdiMHJcgXc3gMV/0wd/rXg0OHeu6NjCgeAvXUHP0mzig1H
	 K/T6uiaH73eQsE8Rh3Bq7HlNihHsRpagWW0KqwObxhi4fP2TX8vBn5Lx3QtCVkg3uVuaJ
	 p0BDGKWfdGFI12ezR/KTU4NuRtExPblbw9t7MtTbQ75E7sftk4iLUSgLU89a7Gubl5oZx
	 olJI4cMKd0/Pbeg2AS62He82T5aqJtMuF098Qrt78qpcQxYmqmu7uuU58ucWhT9maQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061020;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Yypc5MMmOkKGc6fLSaWXS9zKNAun9tOtDFvtyN43SmA=;
	b=gQU7+dN2xP7TSEwntmJ0Efutn80fYj7yIvhsY+9DvRsjjZs7xcyHXoRv8r/2wedE9l6k
	 EzO6UTrkugicEXb00kcoQ6tW161MLUdFB6fo9z9jMeFWG1kN+tsVW4n9BxiicFYfpe1bS
	 kvcVA74sTg6wfMfeR65oD/9rAtBLHEGO5a43qlR3gsYiVtn1IjrDDTkehMoeaauvxichp
	 4mrFQXk+MlrjUCmzrzDiEmF3m1LgeYHJEoeuHk58Ljaat25AkvIlnvz2B4YO/WrYYj9jg
	 q7FQab3G6ERtiSxe94ZxY/5w0CrMOqGTo3Tw4pYjETFkqPJZvfkhbrNWcTL64G8msLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hV+ObElU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C61A0606EEAB;
	Sat,  7 Nov 2026 14:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hV+ObElU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DA381F008A1;
	Sat,  7 Nov 2026 14:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061019;
	bh=Yypc5MMmOkKGc6fLSaWXS9zKNAun9tOtDFvtyN43SmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hV+ObElU20RfSANrMtOT0UK2PS5m8i3ZYi65bIdMHKOUXKNaPvq2mK0qTGkiQJ12T
	 J5MJTWADEBBmth6NwNIOwNmaz7/0IUojBBm8Ubm/CCK7ag6Cv8lYnnPVifOgadfAKA
	 jUxhWJGdWuh4Eevu9oNEdnOVnhiZr+7J1mKdeJNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Huth <thuth@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0358/1536] smb: server: Free session data in user_session.c with kfree_sensitive()
Date: Sat,  7 Nov 2026 08:39:34 -0500
Message-ID: <20261107135007.715784054@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index 0c65a862f8589..1dd955a977be3 100644
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



