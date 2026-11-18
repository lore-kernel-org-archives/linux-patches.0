Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016214;
	b=GPiUHzXo6VCfmDIfTmDIsiIhMFgz/t1kBMopz6ezFsZWBLIrmXswff1RL/m/9aZWwqwK
	 n4HVQfQRKs3mlw0Io6V6u6XE7TB146Ak5mekmT4DHpX4e50c5rEyDb/H/9ZaEA8PTPp3d
	 jqg4Z3ax6N97RHCWNfi3IETQlP4g4DMCvdnNdoM6MsisHRkHRKA5ClkCNNi2G9T1A+x5o
	 9xWMAoTpGHLkZxAy52dTrM4J0YxV4Nzb2oJRPXRfL+FfefJRCiDuzwX+7UzJ9CN4l/l9E
	 3zhAFmmGIbC5SICZ4HZjSghToSppxCbKCB2USur9AhcPeRTNGjX/yBQz0gMDdU1IfDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016214;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GtwkAGclQvqpkvU2BDm/IeMlmicsbgY62YPDFw73fm4=;
	b=1LYhqwqhePtmQUy0N5WdZY1k8epwjShwVTt5Qg2hfeL/7t/WOCOwDnxsIJcs3WECefc7
	 Aq/YUQQXM9RuhaEXew2E8Qn7DEv1rdFEyEYkjzn7rSqIEp+ns5aM9JB+Jfjc9cl4mWBp/
	 iBFlbnKVNTbnESzHEBV2HEZjCWsolkTNEJD6XlGGuZ4TgDPqXZKY5hOVannt3yncXc6p0
	 Oa+J3a6zAPjVBQpymDMrSCUYQ8+KOr2zOiO0BIUcLzeuufQI2IeD0LTjcgGQWxz5TIBT8
	 4LT5+bzVyMKFvEHfxed9M7EeLkLjedSOEiOubpiAprllElu4flgQRKgFPwRWjaj/7pg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wvgogTpz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE546606A31C;
	Wed, 18 Nov 2026 15:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wvgogTpz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C1101F000C4;
	Wed, 18 Nov 2026 15:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016213;
	bh=GtwkAGclQvqpkvU2BDm/IeMlmicsbgY62YPDFw73fm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wvgogTpzYgIz+Z3OvFlM0GqulKEmECq9/hrm7YNBUKIiejy7OLIKh+IQU+wheeAV5
	 02A0cy5Bg+6SiG6ysZZJf12mXNBZMJYcAs7/oZJ4dWUkaJtUXK5/i6Xd8IkgEcX9W1
	 c3KrX0C15UydzOWgSvxU1ME0gQJzwsnrSdNNAhqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Mahe Tardy <mahe.tardy@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0449/2651] libbpf: fix log level propagation for light skeleton loaders
Date: Wed, 18 Nov 2026 15:28:09 +0100
Message-ID: <20261118150303.974455286@linuxfoundation.org>
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
index 3bab7008f93e4..5dc99096487f7 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -9151,7 +9151,8 @@ static int bpf_object_load(struct bpf_object *obj, int extra_log_level, const ch
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



