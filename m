Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622789;
	b=HM5hVFAmB1ai/05OchTBX2ZDVFSM/BBeS4DAJni4TaVWkj0Lev6IOnMFjq63qfACD5eQ
	 LyXFj2KjL3XoKji7vG2dkU/mnfBmaPF7+TR9Zab01nAZHCydExGZk47NblE/rYRQLcUut
	 KVZg1EyEbLv7osY2HN2lFVJ9ngjAOnC9t9Knz4qYA2DmC+a7ErZhzrDxWYSkzMQ90ayQA
	 C6w0aCU4q0WKS7lRHZLJ8msrsac56+H5q1T4g5hTUuauw5V4shbVYqZalQKossnMBYLIb
	 Ksqq5GDoMHKxL+pJ4y6OqmDO1R8PgzJG+jZ9ysHs+AdOejhrniBJzylYozVu2KCkeLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622789;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0K4venPjmVvuXREigx/aA1iLTkqgpIi93jFEvJzdTvg=;
	b=bB1cKA749Ipl/aVD+XgCQoT+JRD3HMWtMjhFVcBogVx+YyMxRpCPLuw9KrRPSv87mgtr
	 4E80CqDdigqIzOTjQ5t1lkPwWFkm5QxbhFbWG18OWOTWdRi+FH5l6DCnmyGLnqFTCYUk9
	 L7+Cxg2BZ9ikNBRPtwsgci3WC5ms6kJUOZmqjrnZSHVcLJ4VXH2kXqILmYBABhE2VHihA
	 uQQYogVvAXD5H5JxRLSiclaWxi8uJEQ9vVBxdNM0fcV80LIAJ85ckYVr1Fp4TL1uWV4D4
	 H/CRbLO6GQqCmuC6wwoXMJ7PwWacHf5W/HUYJcK1aVSrq3JnjpDXT5DvSTKP9Nm6czA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ygP2KCmJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33808606A323;
	Wed, 25 Nov 2026 16:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ygP2KCmJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 857751F000C4;
	Wed, 25 Nov 2026 16:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622789;
	bh=0K4venPjmVvuXREigx/aA1iLTkqgpIi93jFEvJzdTvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ygP2KCmJhNTAUEeyjaXd7jND3FqUup/37izzZHm3qa2DwVylU1i5ZsCrG13G1DYjP
	 mija0AjduTWQ2a7ojWLJk9q9bHEGFpu9DzUHDLVXd1TQKEoxzKG7J6t0WZdVvRObFR
	 mjlL6HH3Vb67b181uD6NIlb+RlWri/XbTypbRiR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiqi Zhang <zhiqizhangg@gmail.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.18 650/990] bootconfig: Allow keys with the maximum supported depth
Date: Wed, 25 Nov 2026 15:33:37 +0100
Message-ID: <20261125143837.317826639@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
@@ -302,9 +302,9 @@ int __init xbc_node_compose_key_after(st
 		node = xbc_node_get_parent(node);
 
 	while (node && node != root) {
-		keys[depth++] = xbc_node_index(node);
 		if (depth == XBC_DEPTH_MAX)
 			return -ERANGE;
+		keys[depth++] = xbc_node_index(node);
 		node = xbc_node_get_parent(node);
 	}
 	if (!node && root)


