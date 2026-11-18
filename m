Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056566;
	b=23jkWlW06pH6e4FuL03XNtWth4/T4a2jhvgUiLHpwof6bhGBIHRIN01GpQVUU6fF7KvQ
	 u34l7GmGsek1bQUad7c/L8eeISKOqhLCOaSZQAS2tkb2ZtZzyE1s/ZAq+qNuOESy3Vkg9
	 9ao162wAjfR6wY5lwP87rRKmJxoadJT9tUsCGrPfLoloqR7jy5Z/W2UGrUPWR/QSOoHUP
	 sPicQZIpbHlaOYDaNA+k9Ez4RVndFfWWy/1zbRL1qO3aEiKf9oa1i82IoRImJaMFMna6x
	 TVRn0bUcwX4J8lBpVnA4xaKtCZfAUrk1+WCf3JF4vwat2uWkzXrOoHTuS7b9zi8VlPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056566;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=d+bLFQgLbOvbxiVOpZBQ8i2WCOCQWnTRHp8VFVpHPDw=;
	b=ej78aZk+JMZ4WoA3JwT/+pvxM6/yc5KLavKWXOGNb5LnbLWWgJJme2BbeUjRwQdURWez
	 +hPtdxIORJwmo2sCVPCXBWl9i7ghv63bX6NmSuafR5JBV8IsizmJcPPsWASRgZu/bsnB+
	 yAhX3hjFqJMTlQN5Tg6PWa0EzKo1g7IczDxjnRadh+gfid8wlpaGhN3PpFylM6Lh6/ytn
	 wL3zeH+DUrn8Yuu8J4U3qEp7NgRFZqjcs2CVtUwqzWKpI+FPXxr5C1f96jfMSMoi2v4Rh
	 0mw67Cj89ukT7w8zRvIL6pv2DbFvz6s0cQ7OHCaVuCrZeMiRqcws5l/rOT7G87ey//Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="t3Nn/LPO";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 618AB606A325;
	Thu, 19 Nov 2026 02:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t3Nn/LPO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF1FC1F000C4;
	Thu, 19 Nov 2026 02:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056566;
	bh=d+bLFQgLbOvbxiVOpZBQ8i2WCOCQWnTRHp8VFVpHPDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t3Nn/LPOK0kJ80O/ni6it0/NGnv5z3mUECJNokqVvqSjxjphV+GWiyvZlHewFGiIH
	 dDxKb6FEUkR2besSIiTNtxcOAwljKTapV+MLdCM2nkKzm3/kbTDIdftL7supn+3/av
	 00PjJBSTHl/TlGyRwbl7V6eZBwa7JqR+EBznMwMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2031/2214] bpf: Dont take a program with a target program for an iterator
Date: Wed, 18 Nov 2026 16:01:47 +0100
Message-ID: <20261118150132.005287389@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit b83bacf2161d0f8583e3f1e9c90402638992ad82 ]

bpf_iter_prog_supported() goes by the name of the attach function.  Commit
7cc639dc45c5 ("bpf: Don't take an extension for an iterator program")
keeps out extensions, for which that is the name of a function of another
program.  A tracing program with BPF_TRACE_ITER that is loaded with
attach_prog_fd gets there as well: unlike for BPF_TRACE_RAW_TP,
bpf_check_attach_target() does not mind the target program.

If the function is called like that of an iterator target, bpf_iter_bpf_map
for example, its id in the BTF of the program is cached as the id of the
target, even if the load fails later.  Programs of that target which are
loaded already cannot be attached any more.  And the program itself can be
attached as an iterator of that target, with a context that the verifier
has taken from the prototype of that function:

  BUG: KASAN: stack-out-of-bounds in bpf_prog_66d4234e2e50f5b6_ts26_forged+0x12a/0x20b
  Read of size 8 at addr ffffc90000d9fc48 by task ts26/104

Refuse every program that has a target program.  That covers extensions.

Fixes: 15d83c4d7cef ("bpf: Allow loading of a bpf_iter program")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261017230950.802052-2-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/bpf_iter.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
index d7345a3eda04a..15f25156071b5 100644
--- a/kernel/bpf/bpf_iter.c
+++ b/kernel/bpf/bpf_iter.c
@@ -336,10 +336,10 @@ bool bpf_iter_prog_supported(struct bpf_prog *prog)
 	bool supported = false;
 
 	/*
-	 * The attach function of an extension is a subprogram of the iterator
-	 * program that it extends, whatever its name is.
+	 * The attach function of a program that has a target program is a
+	 * function of that program, whatever its name is.
 	 */
-	if (prog->type == BPF_PROG_TYPE_EXT)
+	if (prog->aux->dst_prog)
 		return -EINVAL;
 
 	if (strncmp(attach_fname, prefix, prefix_len))
-- 
2.53.0



