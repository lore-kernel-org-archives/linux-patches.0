Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705518;
	b=ZsYw5xwBwVYIjGGGTGLHCDLt2l4U+JOuuWPNXGmF4V378x3mbB0l2aLpQNv3tatFwYts
	 bAlJlTAVylShtDmTgH59YbRm7ZUZGJbt7dUa5/WTHl/M4MJhZCoUEGWp0sDgD31XTIdXr
	 UlTqc/omFlXmWoeFgEDaLWfi7VhYnUmJET+qL0fqtTAJ/t0FVSb5pxGuHkbcMcxQT3LzQ
	 dTkcK8gdAac2Ip0AwynpMDG4E2U6phP95MJQmgvOre7hKnU/9UYdXkkXq4uhxbI0foD1/
	 Ekj1lz/9VQXXWLKTVwWXVdMUE8TghhdIQFZoTofMuJRUN5mOWYJMRi8ZfvtOQmdQtvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705518;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5vzmVsxZ0p00PWcgiRFsmD4IfLMXh/NhpNTY+nOc9S4=;
	b=tYz/5QWVE5ltAgSTjEiuXlze1owrCfWw55lEsKB1OzC/BDVwhr/NuGtFk6h/cMLnV9hg
	 ulGfvEtkj7EFveEBoQ4KQEBz42qnNQsBVJzPJ04dAfIWU3w4tzKpSDuCZd6N1wCyMjjQl
	 boP3+uI2ueCUcM0A0S2cP4xKKy9vyrdVhwtsigy/wZxe4t8lj4wjpB1VqqLSnwDVV5vEB
	 cSvAiR6e4fsssJoJUy1qEWicrIVJ8ofmbpVRSaeg48qxA/z2Jkz/Ex49Rp0c+4JAD4ANQ
	 p05icXtjkEpxCGttzIFDSwD1VO48KuEqoGOlh3og9O+VGCM1+qQ5NvTe1qS8QZySIlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zY+hPTSK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4818F606A321;
	Thu, 26 Nov 2026 15:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zY+hPTSK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DD941F000C4;
	Thu, 26 Nov 2026 15:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705518;
	bh=5vzmVsxZ0p00PWcgiRFsmD4IfLMXh/NhpNTY+nOc9S4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zY+hPTSKpF2LHdsAiCK/l0nSrCTTl95ExYYkszBVHMc1SnqCzLJdzC8u22TWWm9Fg
	 IRmHNe8c+DJfxyJdS0rSalQOfwx/mhgVqbOxf/CjTxFmJIfxulehFOfMZsxFboPC2J
	 LRIBUuL7p8YvNH99ZlR4WFiIqv2+H/V6PobNThok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiqi Zhang <zhiqizhangg@gmail.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 5.15 170/319] bootconfig: Allow keys with the maximum supported depth
Date: Thu, 26 Nov 2026 15:38:58 +0100
Message-ID: <20261126144010.584747381@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

From: Zhiqi Zhang <zhiqizhangg@gmail.com>

commit cab697164b47eecfa2f146024f5d661f99a1a1e7 upstream.

xbc_verify_tree() accepts keys with XBC_DEPTH_MAX (16) components,
but xbc_node_compose_key_after() returns -ERANGE immediately after
storing the sixteenth component. It rejects the key before discovering
that there are no more ancestors to collect.

For example, a.b.c.d.e.f.g.h.i.j.k.l.m.n.o.p = value can be attached
to an initrd successfully. However, bootconfig -l stops listing and
prints "Failed to compose key -34". In the kernel, the same error
propagates through copy_xbc_key_value_list() during its length probe,
so proc_boot_config_init() returns before creating /proc/bootconfig.

Check the array capacity before storing the next component. This lets
exactly XBC_DEPTH_MAX components be composed while retaining the check
before any out-of-bounds store.

I found this issue while reviewing bootconfig's depth handling and used
OpenAI Codex to verify the failure and develop the fix. I reviewed the
change and wrote and ran the regression tests.

Link: https://lore.kernel.org/all/20261104073742.21202-2-zhiqizhangg@gmail.com/

Fixes: 76db5a27a827 ("bootconfig: Add Extra Boot Config support")
Cc: stable@vger.kernel.org
Signed-off-by: Zhiqi Zhang <zhiqizhangg@gmail.com>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/bootconfig.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/bootconfig.c
+++ b/lib/bootconfig.c
@@ -236,9 +236,9 @@ int __init xbc_node_compose_key_after(st
 		node = xbc_node_get_parent(node);
 
 	while (node && node != root) {
-		keys[depth++] = xbc_node_index(node);
 		if (depth == XBC_DEPTH_MAX)
 			return -ERANGE;
+		keys[depth++] = xbc_node_index(node);
 		node = xbc_node_get_parent(node);
 	}
 	if (!node && root)


