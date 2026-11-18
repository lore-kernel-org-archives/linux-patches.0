Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015457;
	b=dICyQLJgos0+JIknE/EJvR5HrKw/YL3N4F6ytm8FvHdGYISVJs1bZOLSGxmYvurATjiB
	 9sRETpfC+aM8TEpo3hT7rgCUc1hcjbf0LJuavpyAGTVv71Hw2ppgvyfptO4FV0FuBhB/K
	 mlv1iOhcKTvGdhg/9yP/PTiMrTmjvRE12gjL3oVCUKl8KFTeMB6rvhh4Re8bw7DDiNF7e
	 uG6hPAUrlEh+0DiZn+ed32gm+Hrs3cCI06hldBTwdOSLcjLA3IzzIh60n8MFQaO+FlVte
	 KCoEcDBGUq0Y9R84JDparGRujEwXbiCUAVFkeYEpTBpnF5IqumkfMPAbl2SPJOl5kEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015457;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=2nE2u7dKvPJNB/Nz8+wDqbBAeDXMADipuouwqhxQ7aY=;
	b=3TredCbaMfkdfvOoyRy7BVN68ebpHkDfK6UA0TNkJJ2cx0JcvN0UNNL4SjOsRlvQCBYa
	 lIA2raKpDQbZnPDd9M+s98n6fcSl9h5H/CuWbsOPePJLmQ6B1h9WpIf0tdqVTzpzEvKwr
	 5jw9ce1XqePX6VIhvovyPoLGFSYkQPXpZ/v4v0eTE0As4ujFNx8kBtLB2Vams4p0NBali
	 9l7zUiNjRAkIJvWGjTKl2E0yJo9XbK++qg/o3jo7ZqYLz6zQDWd6US9rKenP9M5YmRCtZ
	 JJce5Fo3iW4zMXIyDvOMjWNsW6BLc/13i9gNYQwPfeytjCuHSkYCBUWiCr5X6m071aw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Da+Rsdbr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79591606A31C;
	Wed, 18 Nov 2026 15:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Da+Rsdbr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 930B61F000C4;
	Wed, 18 Nov 2026 15:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015457;
	bh=2nE2u7dKvPJNB/Nz8+wDqbBAeDXMADipuouwqhxQ7aY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Da+Rsdbrq+Y2cZUjgePkb4GPvcE13Xg43gYahnD4XSVXD4nvRSs1MlPyOONMMQx9x
	 YdRkCJIuzIGWzjCgQpmHpgNxKF6NQes9sEgmMVqiQ5f+ayo5fO5EMVAh0s83FgDuUe
	 nUkBxbhkmRKZNOmjR75a61Cvj0gltaBNH1VaNYKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0180/2651] libbpf: Move section-defined program flags to prog_flags
Date: Wed, 18 Nov 2026 15:23:40 +0100
Message-ID: <20261118150254.345143962@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Toke Høiland-Jørgensen <toke@redhat.com>

[ Upstream commit d6b633b585f348053dd27044b1b39972c748c1fa ]

The libbpf section definition modifiers for XDP frags support and
sleepable programs stores the flags bits only in the private section
definition cookie from object open to load time. This has the
unfortunate consequence that API consumers cannot see (or manipulate)
the flag between object open and program load.

In particular, libxdp has special handling of frags-enabled programs to
make them compatible with the dispatcher. This doesn't work on XDP
programs that enable frags through the 'xdp.frags' section definition
because the flag is not visible through bpf_program__flags()[0].

Fix this by changing how libbpf loads the program flags from section
definitions: instead of using the private section definition cookie, add
a setup function to the default section definitions that stores the
flags for sleepable and XDP frags programs in the prog_flags field of
struct bpf_program.

Exposing the flags this way means that any use of
bpf_program__set_flags() will override the flags unless the caller takes
care of updating flags in a non-destructive way. This is unavoidable
with the set-only API, and any user setting flags unconditionally is
already broken in the sense that they will also override any other
current and future flags.

In addition, prog_flags survives program type changes through
bpf_program__set_type(). It is the responsibility of the caller to
ensure the flags are cleared if they are incompatible with the new
program type.

[0] https://github.com/xdp-project/xdp-tools/issues/587

Fixes: 082c4bfba4f7 ("libbpf: Add SEC name for xdp frags programs")
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20260901-libbpf-frags-flags-v3-3-4eb6f14968b0@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index bfa64ae6c94df..3bab7008f93e4 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -7886,6 +7886,19 @@ static int tracing_multi_mod_fd(struct bpf_program *prog, int *btf_obj_fd)
 	return 0;
 }
 
+static int libbpf_setup_prog_flags(struct bpf_program *prog, long cookie)
+{
+	enum sec_def_flags def = cookie;
+
+	if (def & SEC_SLEEPABLE)
+		prog->prog_flags |= BPF_F_SLEEPABLE;
+
+	if (def & SEC_XDP_FRAGS)
+		prog->prog_flags |= BPF_F_XDP_HAS_FRAGS;
+
+	return 0;
+}
+
 /* this is called as prog->sec_def->prog_prepare_load_fn for libbpf-supported sec_defs */
 static int libbpf_prepare_prog_load(struct bpf_program *prog,
 				    struct bpf_prog_load_opts *opts, long cookie)
@@ -7896,12 +7909,6 @@ static int libbpf_prepare_prog_load(struct bpf_program *prog,
 	if ((def & SEC_EXP_ATTACH_OPT) && !kernel_supports(prog->obj, FEAT_EXP_ATTACH_TYPE))
 		opts->expected_attach_type = 0;
 
-	if (def & SEC_SLEEPABLE)
-		opts->prog_flags |= BPF_F_SLEEPABLE;
-
-	if (prog->type == BPF_PROG_TYPE_XDP && (def & SEC_XDP_FRAGS))
-		opts->prog_flags |= BPF_F_XDP_HAS_FRAGS;
-
 	/* special check for usdt to use uprobe_multi link */
 	if ((def & SEC_USDT) && kernel_supports(prog->obj, FEAT_UPROBE_MULTI_LINK)) {
 		/* for BPF_TRACE_UPROBE_MULTI, user might want to query expected_attach_type
@@ -10106,6 +10113,7 @@ int bpf_program__clone(struct bpf_program *prog, const struct bpf_prog_load_opts
 	.prog_type = BPF_PROG_TYPE_##ptype,				    \
 	.expected_attach_type = atype,					    \
 	.cookie = (long)(flags),					    \
+	.prog_setup_fn = libbpf_setup_prog_flags,			    \
 	.prog_prepare_load_fn = libbpf_prepare_prog_load,		    \
 	__VA_ARGS__							    \
 }
-- 
2.53.0



