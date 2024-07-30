Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C5A51A616E;
	Tue, 30 Jul 2024 16:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356894; cv=none; b=mszCB7wlqtkhRq2xbGf/zU0M2B5d0JDc0ybIGVMxttlBht5vKI4Cgt++gBfnD2BCTGBbDvcJT/Mrhe3Xf807sWwaLwW/rWT3PQ9xmSqsh0mgp9DMCiBPB6zfIwyK/lAorTdMhQ3OcylrSYsq5i0nu5afqKnqHO7uLS11UaYfJW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356894; c=relaxed/simple;
	bh=kodcwVM/UT6p/xeuxVHE0yJgWrm4iPwqt8Xs1U1cCBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eyjaX0DG4fu6W1q+ztlhIPU91VP2RCGwB9erv7fCFOiNA3JOkAcOdEA/Q14znWSapfLLfOu4aNKyiJqD1b3jdwrmnfj2LSk0KDK7wE1xQQ+usy5S51K1GXlkmXCXFNnZWSM+KQo6Tw4Kx2+DQ4bD+vbVnQFGDjOBObHP4fGjahM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kvvhG+8d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kvvhG+8d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A648BC32782;
	Tue, 30 Jul 2024 16:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356894;
	bh=kodcwVM/UT6p/xeuxVHE0yJgWrm4iPwqt8Xs1U1cCBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kvvhG+8dVOqeWzuaqsFOCJM8bmO6De39xPqHzS5FjuB8tY20RMOhTkSuMbSeFoWaV
	 ZVQKsY4ZadZdCR7cQ4FFMxCuqhgaLEmtjRU8N8dI1w9uMki2wVOhaKjv2517633r4L
	 9O3gGmL5sa6+HOJ9U4XKWRzw4gB8aGnUsBjNvyfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Xu <dxu@dxuuu.xyz>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 197/809] bpf: Make bpf_session_cookie() kfunc return long *
Date: Tue, 30 Jul 2024 17:41:13 +0200
Message-ID: <20240730151732.386975940@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Xu <dxu@dxuuu.xyz>

[ Upstream commit 2b8dd87332cd2782b5b3f0c423bd6693e487ed30 ]

We will soon be generating kfunc prototypes from BTF. As part of that,
we need to align the manual signatures in bpf_kfuncs.h with the actual
kfunc definitions. There is currently a conflicting signature for
bpf_session_cookie() w.r.t. return type.

The original intent was to return long * and not __u64 *. You can see
evidence of that intent in a3a5113393cc ("selftests/bpf: Add kprobe
session cookie test").

Fix conflict by changing kfunc definition.

Fixes: 5c919acef851 ("bpf: Add support for kprobe session cookie")
Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
Link: https://lore.kernel.org/r/7043e1c251ab33151d6e3830f8ea1902ed2604ac.1718207789.git.dxu@dxuuu.xyz
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/bpf_trace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index d1daeab1bbc14..bc16e21a2a443 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -3527,7 +3527,7 @@ __bpf_kfunc bool bpf_session_is_return(void)
 	return session_ctx->is_return;
 }
 
-__bpf_kfunc __u64 *bpf_session_cookie(void)
+__bpf_kfunc long *bpf_session_cookie(void)
 {
 	struct bpf_session_run_ctx *session_ctx;
 
-- 
2.43.0



