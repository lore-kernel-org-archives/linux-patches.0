Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017438;
	b=o5CKEp44+5OGB4jkrr5HOoAjtbizsa8p510PjmAd7+MILN7JaVH+ICzzZRuFhwL4eWmj
	 nuXxU64Mr/DwvLFo+BAeaWO0o1jbZlq6QpqxC2BDzxfx27Q4vsF3Vy8mVa8yMBy/zEFeD
	 P1/nOkX6EypRrySM9hLRa44zXh7YkzemcQlxJGk8v5spTKDWqvEEnjzcEB2M7t17A7toW
	 WClw4pz0R5xMcjWuR3cvgOX+dWduXoaGDwlqVWSts0yqDkU/e4jMBJVLdo+06cogPp/5+
	 0+nzMS4Z0boNswh/7mJFSlklmQRS3RU8Eim6XMSajN6BtDPrFnQmG4YcU7ydNGxPdrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017438;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hZIiBUCEQdoRiXdd1J290vHgVgA8kxQPBc9HupEyUhU=;
	b=fhyVIZ1TK0X7niLt4jzuMhz14xsarPjHsvgvEjiXA+iVdRh0vGfnbYNwAsdo7bahZ735
	 +0EsM2r/l9Xd5V+tNZNPrDn15FZEDFOBZs3UE6aZJISi3GY9CU40/jEXvltnj1vmLtfGj
	 +bijMdKE20+K76etqNSNiLgvjt0J/upnpMrUd7qsx1xjefd719e+FO/VDqQHfD8OCSURp
	 W195MhxnwC3oqE5Dxb2XnDzGEISbcln+WvQmCNLbAMVtP52D8cjW/a1u8XPsfGlLcC7Kk
	 P2MJdx5Wb8ljgTZpQHI88k7xK1sHT+Scii6wJFAKvJmtdvhg1DMVdfAnsYKSqMDsatA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x+m+fM8r;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 244B5606A31C;
	Wed, 18 Nov 2026 15:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x+m+fM8r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79C2C1F000C4;
	Wed, 18 Nov 2026 15:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017438;
	bh=hZIiBUCEQdoRiXdd1J290vHgVgA8kxQPBc9HupEyUhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x+m+fM8radnQJPrlAu4pk9VZOq180FA4mczXMzlGvitHQUhQ+xfRrrFMZzTTpmz7S
	 7F2GJsay/NVzfYu20/DN5/Scz5SQ1zB34in9owPB+4WQRhN06/DBpuzQvdFj6WWhZc
	 MdOABgHqsnmju1JziZ3vpo4o3FQIBBN2CCH9PYrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0885/2651] bpf: Rebase the exception callback subprog when dead subprogs are removed
Date: Wed, 18 Nov 2026 15:35:25 +0100
Message-ID: <20261118150319.717315862@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/fixups.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/bpf/fixups.c b/kernel/bpf/fixups.c
index 64f088bc6f256..f8d9b30815f69 100644
--- a/kernel/bpf/fixups.c
+++ b/kernel/bpf/fixups.c
@@ -478,6 +478,9 @@ static int adjust_subprog_starts_after_remove(struct bpf_verifier_env *env,
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



