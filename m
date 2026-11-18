Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029550;
	b=BSOIH56g52bXkIHSznt4HT+qzcyH/oN2LaKFrq0HH+FxcVnemvWH8OF4ertQ0CtoW3MS
	 UNYOpURJ5bqaw6ElpYujf9viJci+DppXTO4etG85hGUKY7zJDwezHSv7cve/dslNVaXMa
	 Yd3fhJDT+pFu6Ufooykh0KY+x76+hc3TwRTv9ehSZnuY8chZ5k1JnKrgmtMvzUwonZQN8
	 9QABSSGCwVehP5dwVOxI80c3P+yQvN5WKBXUPKq2IknrzSt2n9BAh3tKwyWghtjOdT5mH
	 DEm3Le9kEXsY7DdOP9yoAkW8ozHn2aGTvdn7WpkyVtK6wzBeLauGVovhAK23Iqs3QOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029550;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=P1bdpiNWGRO3dFNuWu/KLPrmdJK5WS4xUJMcyVSMICw=;
	b=yDoka/1BRrXhKzyhMcxbG2VVHG+wQ6XaFzjt7pTisB0qSq8B+6tPwjPBOdtC+/Y3gWth
	 TLpJ5osJ/1iHNKUqP2JBxuoroawwPRrSBm9zJs8PPWMbZDl1nkd+9Iyv5PBUUHLSjmI/z
	 JNY152c601KB7ffrUpRxEvZc31yRc6OQQmwFCGm8nK+kS9IFKMgiRykSiIDntOIsw7Cqm
	 lsMJTwaC3+WqopUzbswhlgeKEva3nFecutf1mdKB4F+IOFqsfPemYQMahKnswj/U0Irng
	 8AokVkHfTtUpI3+zTE5S5GImXA9sNIort+xvunO/NKlfgzMeMgDfVYYyK0UVgKLVpMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HnLOl854;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7BBB606A31C;
	Wed, 18 Nov 2026 19:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HnLOl854
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 248461F000C4;
	Wed, 18 Nov 2026 19:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029550;
	bh=P1bdpiNWGRO3dFNuWu/KLPrmdJK5WS4xUJMcyVSMICw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HnLOl8547qm+Pkb3lam2dYB6NuLmbsqf6Dv6ew52I4e6gxkgnAxeeeJCYwkl2lw8t
	 S4Bx0YFIlaywIztZ6vzMOTBDRCcB/KEkoWdUtCFRUUf7zLOXfsPngPkZIpzmPFtFlz
	 XR+SeFWWQRzmAbiIjrb8PkxGQjo5wvdZsOAV0C90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Mahe Tardy <mahe.tardy@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0391/1756] libbpf: fix log level propagation for light skeleton loaders
Date: Wed, 18 Nov 2026 15:41:58 +0100
Message-ID: <20261118150024.259613539@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Mahe Tardy <mahe.tardy@gmail.com>

[ Upstream commit e18e82ba9ed53f60acce5f9995ee357a9f7ab91d ]

bpftool's -d option is documented to enable bpf_trace_printk() messages
from the generated syscall loader when used with -L as specified in
commit d510296d331a ("bpftool: Use syscall/loader program in "prog load"
and "gen skeleton" command.")

However commit b59e4ce8bcaa ("bpftool: Switch bpf_object__load_xattr()
to bpf_object__load()") changed bpftool to use bpf_object__load() which
call the internal bpf_object_load with extra_log_level to 0 instead of
bpf_object__load_xattr with the user request log_level.

All the plumbing was still there to generate the bpf_trace_printk()
instructions from the generator but was now unreachable because
bpf_gen__init() was called with extra_log_level to 0, leaving
gen->log_level at 0.

This uses the obj->log_level field introduced in commit e0e3ea888c69
("libbpf: Allow passing user log setting through bpf_object_open_opts")
set from reading verifier_logs in do_skeleton(). This preserves both
object-level and explicit load-time logging settings.

Fixes: b59e4ce8bcaa ("bpftool: Switch bpf_object__load_xattr() to bpf_object__load()")
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Mahe Tardy <mahe.tardy@gmail.com>
Link: https://lore.kernel.org/r/20260907170536.9996-1-mahe.tardy@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 68de6bc7ad74a..e43dad57c1125 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -8590,7 +8590,8 @@ static int bpf_object_load(struct bpf_object *obj, int extra_log_level, const ch
 	 * permit cross-endian creation of "light skeleton".
 	 */
 	if (obj->gen_loader) {
-		bpf_gen__init(obj->gen_loader, extra_log_level, obj->nr_programs, obj->nr_maps);
+		bpf_gen__init(obj->gen_loader, obj->log_level | extra_log_level,
+			      obj->nr_programs, obj->nr_maps);
 	} else if (!is_native_endianness(obj)) {
 		pr_warn("object '%s': loading non-native endianness is unsupported\n", obj->name);
 		return libbpf_err(-LIBBPF_ERRNO__ENDIAN);
-- 
2.53.0



