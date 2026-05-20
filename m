Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD0FD36A37D;
	Wed, 20 May 2026 16:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294878; cv=none; b=k90C85RA3/XRtERmJz1Z82Z8QoYSeAXsK59F97dB5ngPNZQaBaIvAXROBfrU91g4g57ZepWiLO6nNGtNNu33R/B/4pBER7qW8eHH57gdfpn513MDMA45KpGvD2sQ8i9hUmxjT+U8+TyF/jXqZgoVvGtNIQF2HrDnK/ycXon4Z+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294878; c=relaxed/simple;
	bh=H+QPOWCIaEZb9zz4277qJ2a6/Auw0Bb8NvAGcXxpUIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QIXK9U89XDJ20RjKCtzuLbhD8h6TWyJMKU1+mMumMxL5FNztNVbQqtCNpbSu1Worb4nv7Akszyew1NDI2JFritdgXJJfsvO14sGBI+7qa8hdrdgGVyIA5YkBfEunwM0h+4Jm2iyibKvF8QiYcYAfIi362m+49+o0BfewMhERkgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oOmH7WMz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oOmH7WMz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F3261F000E9;
	Wed, 20 May 2026 16:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294876;
	bh=xwNbSoZTlDwiNjMl7ePOu9U2LFbVCKi54b1j1/F0iCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oOmH7WMzE1uSnFyaxlsXXFdPwRFVop5ZMc2FcgtAHPpn08OUdFdQ+NuSNwzQXmX63
	 dxehsqSm7oHOvIPcFA9lXAEHoQyQBXbfzC0E+MPbualxpURAnhYDMt5Lle2IiXh1/m
	 Xavzj6wvH+smTXxSspTInMDpVIDTCe+o47ojDDI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Anton Protopopov <a.s.protopopov@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0169/1146] bpf: Remove static qualifier from local subprog pointer
Date: Wed, 20 May 2026 18:06:59 +0200
Message-ID: <20260520162152.114127361@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit 9dba0ae973e75051b63cbdd5b3532bb24aa63b3f ]

The local subprog pointer in create_jt() and visit_abnormal_return_insn()
was declared static.

It is unconditionally assigned via bpf_find_containing_subprog() before
every use. Thus, the static qualifier serves no purpose and rather creates
confusion. Just remove it.

Fixes: e40f5a6bf88a ("bpf: correct stack liveness for tail calls")
Fixes: 493d9e0d6083 ("bpf, x86: add support for indirect jumps")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Anton Protopopov <a.s.protopopov@gmail.com>
Link: https://lore.kernel.org/r/20260408191242.526279-3-daniel@iogearbox.net
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 71c078d18683a..bf5e146692e0a 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -18764,7 +18764,7 @@ static struct bpf_iarray *jt_from_subprog(struct bpf_verifier_env *env,
 static struct bpf_iarray *
 create_jt(int t, struct bpf_verifier_env *env)
 {
-	static struct bpf_subprog_info *subprog;
+	struct bpf_subprog_info *subprog;
 	int subprog_start, subprog_end;
 	struct bpf_iarray *jt;
 	int i;
@@ -18839,7 +18839,7 @@ static int visit_gotox_insn(int t, struct bpf_verifier_env *env)
  */
 static int visit_abnormal_return_insn(struct bpf_verifier_env *env, int t)
 {
-	static struct bpf_subprog_info *subprog;
+	struct bpf_subprog_info *subprog;
 	struct bpf_iarray *jt;
 
 	if (env->insn_aux_data[t].jt)
-- 
2.53.0



