Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017452;
	b=NCIFCWevmlGVWrCuZunAl6TlLrvU496/B4jhN77tdfUn6nKMjFWnkHp9UxERHtEikPIB
	 1xLfLdqEAq4vtft6CN+D0kBnV7jO2qzoErPPIdg8MPq8mWymkARYreltzUDbgOz2L/GOp
	 /2ePmt1kUmwxJdkEc4Eb/y/BbEcsctqvdRnqZcOHrYhDIcrKk7TwzmHfp3YjZOtEphYVz
	 5qcwN4z188lELlE45dK9Oh9wsSfSzfGpQNQKaRQhDPbTqgFrBODEjuqXwiKK1uQotOba3
	 861O+88RVo+cIDy1O9+fAhlDk6FnqziL8AE4AQUaFc5HWN1PjXSk1kjbrdy790/v5SQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017452;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1RATixfnYKRcUdiQ46QK581lLNSIxP1hLRuSwtb/C8g=;
	b=Jre1h4JbGY0bp+8ByN2pylbiBlx4K4bWJWl+71WKFEw5aGJnkmHYbFIFQYJDL5Zdvob2
	 IoNo0qnGK8JIdw8M5tJH8GGxlONSiVPFKhXduzrMi81asWRa092IJr6zqJnmOU4du9u8E
	 whoHfe5G0hiE4e5QL6d9/+hAwJOjWpjbWkOkPFIy3v3MzmeBPRkvVGleMPRkfg/MjU1S9
	 gHHcru654uwhQ3TVTKhF0p8QJbQ93G12Sl/0iCAAL5VzPODATl1EzOvf4oWZLUxEco03c
	 R/4qwV2GND3/g0vni2CzaWMj6M6KuML92gJyRNZMO3XjRCnrWJGSPV8wxhouP2nelzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ano7GRLR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D65606A330;
	Wed, 18 Nov 2026 15:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ano7GRLR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9794A1F000C4;
	Wed, 18 Nov 2026 15:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017452;
	bh=1RATixfnYKRcUdiQ46QK581lLNSIxP1hLRuSwtb/C8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ano7GRLRZKC2JmDtEohfQ0QvSXG25/He1k4ZgzJxdlA16/X947v9cHlOq3sNWhwSP
	 vJ2M3+GPKfjXqBFcOgQOWUNBS/5zzMaFftVDSPrI7b/UW9Rvo5K89YmYXBsxqm8ZSL
	 HTNaej2cNNTn8s4hAP/t3myA5Mb/VSKvZBY4AEiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0889/2651] bpf: Clear the insn array used flag with release semantics
Date: Wed, 18 Nov 2026 15:35:29 +0100
Message-ID: <20261118150319.869846934@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit a83512036e0809497ee3259ba7458de287949b94 ]

A program that fails after the JIT ran, for example in bpf_check_tail_call(),
has already stored its jitted offsets and target pointers into the insn array
maps it uses through bpf_prog_update_insn_ptrs() when release_insn_arrays()
hands them back by clearing the used flag with a plain atomic_set(). Nothing
orders those stores before the flag, so on a weakly ordered architecture they
can still be in flight when the next program takes the map: it is acquired
with atomic_xchg() in bpf_insn_array_init() and reset there, and the late
stores then land on top of whatever the new owner has written since, be it
that reset or the pointers its own JIT stored, leaving entries that point
into an image which is about to be freed.

Clear the flag with atomic_set_release() instead, so that everything the
releasing program stored is visible before the map can be acquired again.
This pairs with the fully ordered atomic_xchg() on the acquire side.

Fixes: b4ce5923e780 ("bpf, x86: add new map type: instructions array")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20260925175244.1136329-10-daniel@iogearbox.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/bpf_insn_array.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/bpf_insn_array.c b/kernel/bpf/bpf_insn_array.c
index 5874abd1f7438..61d6a076dfdb6 100644
--- a/kernel/bpf/bpf_insn_array.c
+++ b/kernel/bpf/bpf_insn_array.c
@@ -232,7 +232,8 @@ void bpf_insn_array_release(struct bpf_map *map)
 {
 	struct bpf_insn_array *insn_array = cast_insn_array(map);
 
-	atomic_set(&insn_array->used, 0);
+	/* Paired with atomic_xchg() in bpf_insn_array_init(). */
+	atomic_set_release(&insn_array->used, 0);
 }
 
 void bpf_insn_array_adjust(struct bpf_map *map, u32 off, u32 len)
-- 
2.53.0



