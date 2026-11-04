Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831004;
	b=cUi/efdVdxI/o5FVAdTJ5OMN6hJ5Vhtfp3nXb3jK9OvJI3UEHK3M1/GXYKXl8SuI4q2c
	 fsAqyowH2qEKSl/58I7Un+Pl0ul90u/fUNOg3ikAVIn6rRSOZJz3gpRUJBju8sO2YqVmL
	 PZzXPEjAqKnygxpjCQJr+dWW6zHask7B2o10tRAY30EiJjTMBcFl/zLcQB/FKA03sJYFt
	 wW4fR5SKo5p347yewMyfB5OKzSyprataLWEzaT+mN1fa5xdLzTqOc5FZb0wcwoiUxDRKo
	 SaVEHpgAuxJE6HP67OSXQX2x+hgpDgUjosj56i4aHMFXG/qG7x2++gEju5G1wA0Z8Ag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831004;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s/eZ0xY5FMZ/NQdyAumXKbDZwUAn2fR+jxBAQ1DrUkI=;
	b=pTfZEoL7VEe+UKXMoDMrzYFaiGFYzwR1K8Z1mZGH+v5Ye3PtTczHLhCB5/thfaGLQ5oz
	 wUAQqNrTRGjhlDKbdCZBVuc7wpZFcmORFlpXtb3i5uPO/DPLv+Ow1k39r6aYEL1BUjuSY
	 +Zr3Xfh0RMna6Kroke2YX1v0H5GiY/VCTJWqn+Z/jk3DZTr+MLSu8Z1XRruEFqXQJyLfb
	 kPn3C3/kW9svZKrYDFQ3rE0Jnn8v1mANaefQcmwah/rVDW/gNl91Ioa/AdUnFGRUlhbyR
	 tUUQlV7KbugPhsaTQQNHGRrgBI7nRLJO5KWS9Lx12v8hQ63r3R3zdf2yQ9o2rxqJqdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="FpA/BiV8";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28B86606AB06;
	Wed,  4 Nov 2026 22:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FpA/BiV8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA89F1F0093A;
	Wed,  4 Nov 2026 22:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831004;
	bh=s/eZ0xY5FMZ/NQdyAumXKbDZwUAn2fR+jxBAQ1DrUkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FpA/BiV8oEGBPVRY/UsHiINAsKnM8L1hBzC491v0CGETsfQuzoMy29lQvmrmBAm/R
	 I/jgnsbageZAZsbEsKOretmWbqtYZikZO4x4dRgfE3MwNW7Y2Qc7VRqCEBFhWqZl6v
	 pT3yinB6cI1TE8ZcluH2Em130rpp4OAfW1CzIxjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Huth <thuth@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0424/1005] smb: server: Free session data in user_session.c with kfree_sensitive()
Date: Wed,  4 Nov 2026 16:02:37 -0500
Message-ID: <20261104211055.975672800@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 3a2591434b5f8..973db0466575e 100644
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



