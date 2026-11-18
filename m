Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043569;
	b=DfNQydk6Xyo94J7h9UqTAk2D3sslxDQvStFq95oWuG+EoGQ49JpqoI5y1cj68IBxNeIb
	 cPgfKfnti4NDQbOkBCnks8kyb+/2YwXnLfjBapIk9BDultg4cOd4f8TLdu3qOoUh8urqZ
	 +vIqO19keiABAdUIVXNMrsBhYJGAEIU6jylH3k7ZuBwi7oXXbk7n7YrhbB/36gN29HQ5E
	 oBezY0aHq9UBHcMgAJs7+d/efzHOL9zArYLXdcvZuElCAEjdbOHphT24TM4F4qXudFzaP
	 DcD3VeSQ1Ga1Klumas9p2neoogzJyPLrei406JZYh7R+lMAOfguDEGCCN7dYbdcoNsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043569;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YXbtf1COYJzsJ+shwHEduXhPJ4Apzf135kAKUj4Nt+o=;
	b=iDCSfowojKmMD+FnEnnt8BkZlXdu360CJdOI8ZQS2FXWh8maeTexC9sJvPKbk+K4NqgA
	 YrfuJZ94l/MwqilI79p8hGH9LrwJBTHoIlqjlBMU6eBL/3g7AuA8dFV/2+7utUSlVninA
	 ifL3Osc4mHOBQse/fJ32wDKijL+CUs7qLiGcFIS2AVUqhF9hjG7+sqHce8a5RV+OpJVCF
	 z+yVUAxNaLSCq2tOKa2EScc9sAgVQjF4xAmnw7/AL4OrlPdBiQjmQKUCabcs/y+yhXD+5
	 eIF6LdQHOiljEql6C0QXqAraG4v+wmLbYgVmdH6gEOo8LeRgfc/kObHRjDZqs39eX/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="N7j07I/2";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22881606A325;
	Wed, 18 Nov 2026 23:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N7j07I/2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77F511F000C4;
	Wed, 18 Nov 2026 23:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043569;
	bh=YXbtf1COYJzsJ+shwHEduXhPJ4Apzf135kAKUj4Nt+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N7j07I/2h5D7p4qAqwk/gI3w0/sJpQEcafZxUTdmKcdnqkc10j9zr72lIpD3Y4QNz
	 97/tQ5aUrH0PbumTRPYPOTwD4wpKfwMwhArH4enaX4v7AeseGeMw1kn4zvBMRE8tbz
	 A+8fbHvSYingFcCGFboU3O/SovS+Zo2e46nvSdjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Huth <thuth@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0257/2857] smb: server: Free session data in user_session.c with kfree_sensitive()
Date: Wed, 18 Nov 2026 15:21:31 +0100
Message-ID: <20261118150210.684984535@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
index 09c19d1f71e38..39d24dc253a04 100644
--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -168,10 +168,10 @@ void ksmbd_session_destroy(struct ksmbd_session *sess)
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



