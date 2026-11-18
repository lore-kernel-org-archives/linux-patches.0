Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025635;
	b=m869FGEErxShrTezdCGH7gHkqv8rjy1eH1rz+/V4h/P0ZWdh/cwlAtyQvCZd4mGC13cU
	 bitCoKh79IaioVxOcPBn7F+J5pt4AKYRxCGk9Fx6K5atR8mp590LjGI/9MbSjt2n28grV
	 m42vV5ibQvVzHu0kPd0girmcR369AhKmjY2wVyxmXFmHJ+L4MXf91H7EHStzdGky8gWKF
	 OqEVK46biew/9yz4caS8r4CdsjMzS2s4fx8uINeraFg+tPS16rsCGFGcy2xjhXceII1e2
	 qy8c7gfK15JQpvRwyrhP+eJ9cciqPCSDdzpbu9VAdJDQRP9oMWa1+aclLIq0vwLU2hA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025635;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=J8MyNeCRtuJaH9VvW9RwTGFnUBJQpqraRgOiun4xsP4=;
	b=LQgSoEb8IPQMfGJsyo1VM1BGBVRMZe5f7ZUdZgG0sC5Amu9DjRWOYGC7Mm1aVTWmzLbD
	 6D5cpP3UuAOcRKP22xyi53Lba2ZHH3Kq+TmrrST7fNU5J3OH3LuevXSk5cH+5fcLqL/SL
	 qC1/lDVVP8+7v+wAOkd2wXMoMbBmVk37L80tVDT5tz4f1leHoho+NlApM/Sl71A2qYjHU
	 ArHeo988FOcMymQJ4QKOoH7yh+USeNBYOQ/i4oG4qmKZ9M/I8YWQjgqUvOg26tL4H2hBK
	 JJnEH0HAIeDk2JrHavgo1cTxb5XzuWyor0oQjk0t1z4sYZA1tbpyRz8XBMknKXjrCsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Vb/FJrfy";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3C7E606A31C;
	Wed, 18 Nov 2026 18:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vb/FJrfy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16F7C1F000C4;
	Wed, 18 Nov 2026 18:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025635;
	bh=J8MyNeCRtuJaH9VvW9RwTGFnUBJQpqraRgOiun4xsP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vb/FJrfymhzqkmA5YOTUBEH4cA5glC8QYNaRqLKy2Uaukc0sTaCUUCfMzaGGXU8FT
	 ISj7tGmQ1lRm89HrBXEPL73RHOABHLYZUrlaMvCNLKO7sDbKJpolP8sHkABwSylg2m
	 1LeO5aC+Yx4usPzDhPskbqedKIXF5MI+1rQ70E6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Zahka <daniel.zahka@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1147/2151] net: psp: drop psp assoc clear in sk_clone()
Date: Wed, 18 Nov 2026 15:48:02 +0100
Message-ID: <20261118150203.967003951@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Daniel Zahka <daniel.zahka@gmail.com>

[ Upstream commit c135ee9f4975f9f05465a5fe5eb0970b0a47c55d ]

Unwind the change from commit 1d2929d0850f ("net: psp: do not inherit
the Rx association on clone"), now that assoc state cannot exist on
listen sockets.

With commit 8cc3aef0cb19 ("tcp: Do not allow buggy transitions between
ehash and lhash2."), and the change in this series restricting PSP assoc
operations to established sockets, this state should be unreachable.

Signed-off-by: Daniel Zahka <daniel.zahka@gmail.com>
Fixes: 6b46ca260e22 ("net: psp: add socket security association code")
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260930-psp-defeat-v2-3-f266e7447129@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 486989dfaaeee..83a0bcacb44f3 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2472,7 +2472,7 @@ struct sock *sk_clone_lock(const struct sock *sk, const gfp_t priority)
 	RCU_INIT_POINTER(newsk->sk_bpf_storage, NULL);
 #endif
 #if IS_ENABLED(CONFIG_INET_PSP)
-	RCU_INIT_POINTER(newsk->psp_assoc, NULL);
+	DEBUG_NET_WARN_ON_ONCE(rcu_access_pointer(sk->psp_assoc));
 #endif
 
 	/* SANITY */
-- 
2.53.0



