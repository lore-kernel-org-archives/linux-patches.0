Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034233;
	b=y7eKiLE9stUy+hHNAi6o0tvz8T9zKA2H9/xaM2gcu1FnOrvRso5bbDT6agG+hSt5WQc1
	 FLPo1OsGlZWG6sNROMVnoGzstqmdf0Q4ei+GuUdTnUhAzsQEdPZU6UNk3zCvSBsvCQ28t
	 ftUHxr/GlhQ/Lu1Wx3qRk7Fw4ZojnU46BBeqaxNcFwQkhLFQ9wTIGUVf6Jnt3AJCkL7Wq
	 rzA/vdahf1CQT10NNF6b4iN7h1b/0JB+T5sIxlw2Ss8FMfhErBcpTfSsDTCr9GSjFAJOh
	 jvkcg+/fuAC54UCCIo5EO32JIXkLbgSM1bwgsztFpyUh0ShN/Ig8P1lxoPVOHc8P/7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034233;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=f38mtNC7mUiYcUEo56RsGbtktoK33Pu89hQolykLWL8=;
	b=a8+Z1jZq613BMqQGJCw13eRLzr1+2oWvI3B1UjLl+/243LaW0DqMjhTZlGEnvZopdmGl
	 o3TVYUvGTZrzmo5bWE+VCX4R/hStzjSG6LOL6yFGK6h+cQNYBWhehIpi7B+99ohnWLqpj
	 FYpzIvr+PKNbJb8M1BX9LK/TH/gOYOUERrFcADXOE/wuw/unlgu8LLMVYXIuk09uelmxj
	 Ce0pLzEax3lhpUxT1D2xIsoUrTRPvcRI6H4SlCy2+Cws+8Q1/D7Pj5L9o0iUtMnuc6O+9
	 Ks5fePuezXeD++yrnqV0DkT0rpLhKjJbD7TLsypvriIMVcFskXQR9fcEy3XcUXBGgSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="vtf/bhAk";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D33EB60A2600;
	Wed, 18 Nov 2026 20:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vtf/bhAk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 348511F000C5;
	Wed, 18 Nov 2026 20:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034233;
	bh=f38mtNC7mUiYcUEo56RsGbtktoK33Pu89hQolykLWL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vtf/bhAkyIY6hzP+OQ4bVfgLSrANZX7aOVXfUHmQSBHMRA8kFLYLH4rtVSg+w/z3L
	 9w6O3GZHTDobPLdnTt5UKxN6hsG9q68J8WZN3hvIgiTdRpXQRfKLtLZKKqyH0cqI51
	 pZlGYvhj5xCLtBrmpcnB2843INQEha6d9pnzFRNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0298/3318] ksmbd: reject blocking compound lock requests
Date: Wed, 18 Nov 2026 15:15:20 +0100
Message-ID: <20261118150324.621452845@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 16a7f7c2ecf3c893b65f0fb78fa7a7171ae0ba9e ]

Clients set SMB2_LOCKFLAG_FAIL_IMMEDIATELY when a LOCK request contains
multiple lock elements, and servers reject requests that omit it.
Accepting such a request can leave earlier elements locked while a later
element waits asynchronously, enabling prolonged partial lock ownership
and avoidable deadlocks.

Return STATUS_INVALID_PARAMETER before processing any element when a
multi-element lock request contains a blocking lock. Unlock arrays remain
unaffected.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 2d18b5de63f68..0ccfc8d745d35 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -7685,6 +7685,13 @@ int smb2_lock(struct ksmbd_work *work)
 	}
 
 	list_for_each_entry_safe(smb_lock, tmp, &lock_list, llist) {
+		if (lock_count > 1 &&
+		    !(le32_to_cpu(lock_ele[0].Flags) & SMB2_LOCKFLAG_UNLOCK) &&
+		    !(smb_lock->flags & SMB2_LOCKFLAG_FAIL_IMMEDIATELY)) {
+			err = -EINVAL;
+			goto out;
+		}
+
 		if (smb_lock->cmd < 0) {
 			err = -EINVAL;
 			goto out;
-- 
2.53.0



