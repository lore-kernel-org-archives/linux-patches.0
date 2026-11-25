Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625192;
	b=Ls86kmeRSysBy+cvMy8OP3zVC/hMQa+n/rw2iLGpDmDq2AEyuMgT/bqz1sGCKtwo7GpG
	 osEnDzEkzMi5LtD1U2/dlkLwdYxFsSQRcAHBJMN0xZ1IL2R+pRNsCUDOqNrNLKmrz9p2l
	 8Jv/4JqYclXPX4XG4kP9VjhLryUNSMBH+Aq5k8vI6QKCqOcdIsty7keDuxofwxTN9nNMj
	 ftdux2DxdsdhlRSmYclkNnwinrruktVTM7ggtTidwC7QLG1dhDcy5uOzcB8zIczsWywFH
	 XwutOOfCJGNonUdTGIOsyAAUT+VTqGpU7EexHlhndW6LkIMXSGOIcyZoKh8uFj0rT5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625192;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JJ3yMbcG4bH2EvOqAHuwlRGtnwFa8FR19CvqB/bk1KI=;
	b=VuefuXjxkK8Uykj8vrW2B0CF6OmqB4wrU/KdImwXv0j8PVDBeXVgyfTOMsuI0I0zzG6R
	 mx+aCxiIYdrxXAuY/Vjyxa+MlptKrDZ8iQsL/y63QGgKVs6WRF2MEvdqjgACyAtv3AgNW
	 BUeDvq4gPGnrJOIDgFJKuRWbzR8hIssxATt8h6XPSkcKE2KwFRzmmsn+mRipAR+0++HdM
	 ry2OU5/R49CmLg3bspifN1iQIlyHBG2vR4yCn4arA5Bj3ijKWfIT3lJJFgDsh/dzanFn9
	 CcSK1oq2YLwS+0upE8wIQs3EId3CjHgJtw06hDRMkZMja9enD/Iikx+jpJJIFQPs4VA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bjUu2STL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86083606A31E;
	Wed, 25 Nov 2026 16:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bjUu2STL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 757E01F000EB;
	Wed, 25 Nov 2026 16:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625192;
	bh=JJ3yMbcG4bH2EvOqAHuwlRGtnwFa8FR19CvqB/bk1KI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bjUu2STL1UNZqxig4EJwVatrqC4Ku5aLxKvZCEyaEAu5fZr+phvmtELgcXIbpjL1D
	 kmB/xpUm3TXOyAzM/WraQAO61OX3iI+fFVtQ80J1/Tq8vS8rTgUVlHov0gFJO9H7l5
	 mckaCDfyl8sQqa3OKhRbr7iOe9C/GhtqMzYZ7h28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 436/816] bpf: Rebase the exception callback subprog when dead subprogs are removed
Date: Wed, 25 Nov 2026 15:33:04 +0100
Message-ID: <20261125143859.283513779@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit 8608ec8e981974b18834e2d67ed39638a9ec2e63 ]

adjust_subprog_starts_after_remove() compacts subprog_info[] and the
func_info when whole subprograms are removed as dead code, but leaves
env->exception_callback_subprog alone, so an exception callback declared
through the exception_callback decl tag which sits behind a removed
subprogram keeps its old index. jit_subprogs() then takes the exception
callback from func[] at that index, which is past the end when the
callback was the last subprogram, or another subprogram otherwise.

Rebase the index along with the entries it refers to.

Fixes: b9ae0c9dd0ac ("bpf: Add support for custom exception callbacks")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20260925175244.1136329-4-daniel@iogearbox.net
[ sashal: Applied the hunk to the fixup code in its older location, with the surrounding context adjusted because this tree lacks the later func_info_aux handling. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 8666fb0ea3b75..ffd1f13925c29 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -20092,6 +20092,9 @@ static int adjust_subprog_starts_after_remove(struct bpf_verifier_env *env,
 			 * in adjust_btf_func() - no need to adjust
 			 */
 		}
+		/* The exception callback is live, so it cannot sit inside the removed range. */
+		if (env->exception_callback_subprog >= j)
+			env->exception_callback_subprog -= j - i;
 	} else {
 		/* convert i from "first prog to remove" to "first to adjust" */
 		if (env->subprog_info[i].start == off)
-- 
2.53.0



