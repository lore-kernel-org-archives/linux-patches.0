Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619336;
	b=L1LZXMek5xOCBhPmROjak/0AzmlckchZYDkxsURO2BbOwjWqxs7fSnDSRUwZOWAgbmgd
	 Zs5Wkb+4WlGT6fp+SynGRzb9ZZlsH4yHW9SVq/+BAMpam3YMDhRVs/KxnwqRGFphyoXoT
	 vY4+24PSNBzxZUFZgaQZD1ZCAFiKhzdwQx65QtsVOTWAzcYaf6U4+MjroNYDZS3/1+AP6
	 9J6XSNmMepOmbXbsAD8HMaNqWpK2n781h6elKx9c0nvmVy2eZOeFMBDB8CpVtxXrg2FzU
	 34L+Hj4/SRSs+ztyAiBlcqA9TRiOBDhRhkl6ZezSDoLyDFXy2gV/MLKXJedjsliJpjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619336;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M2i4KIHdTmMm7z9d9BRWhIPmiaeqMOWJjaMSqBDlrA0=;
	b=IDM8ypJEx1p7qiFJTZzhRlNoAwMhkb3CFdFpAitAnLKhhR6ubjFpdvUnlw1HOxrQub9h
	 8k4a7uewALksoTndvDTPzIM3q+4Ym26r86W58H6Gq4C5mUDUd3yH8n9gdeiIJmQefS0HB
	 J5dOLce+lmeR7DZb8OIQ1wObN2QqAegYIfTmdpwgNmH8Uu8CSbEgM6r4uOFQmp+xsEDrA
	 GyNt9ydRpSJqOp5yjE1Ve/9wU5ANdhg0juZ2XqhUVQXZX1uDEeLOiYpEXlh3p5uiS8iUY
	 lqrjV0AjlAPqtVYoFWOYesmG4oxEfesVO50YhwAj+PYtwNhwW2PIMAnxTOzODe914YA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="jVz/8+1S";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF4B6606A6A4;
	Wed, 25 Nov 2026 15:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jVz/8+1S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4B9B1F000ED;
	Wed, 25 Nov 2026 15:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619336;
	bh=M2i4KIHdTmMm7z9d9BRWhIPmiaeqMOWJjaMSqBDlrA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jVz/8+1SAx5kdE5h8JsZNnDswEaWR3YHArFi2/Ff2WXYVcGSfK1LGfNbo8+dFmlAT
	 7S9Mke+jzYSqyDrCv4wFy0UlcqfUScXytV/OX0y9af3ZEKeZoyfM2omP8i1Hr5OG1s
	 VJLMkn9aFOinIuyr531jdHSke8Mjka5/IbwZtcik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiqi Zhang <zhiqizhangg@gmail.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 7.3 0565/1005] bootconfig: Allow keys with the maximum supported depth
Date: Wed, 25 Nov 2026 15:31:43 +0100
Message-ID: <20261125143834.988280279@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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
@@ -431,9 +431,9 @@ int __init xbc_node_compose_key_after(st
 		node = xbc_node_get_parent(node);
 
 	while (node && node != root) {
-		keys[depth++] = xbc_node_index(node);
 		if (depth == XBC_DEPTH_MAX)
 			return -ERANGE;
+		keys[depth++] = xbc_node_index(node);
 		node = xbc_node_get_parent(node);
 	}
 	if (!node && root)


