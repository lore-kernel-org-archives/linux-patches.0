Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023726;
	b=0EfPYbms/A+f887Tbneci94y452Ls0PezEPoS5rB5r5UEdy+JYplePAlRIUY05sGGr9T
	 /XU2EEIy/wFfpTiczaXEgObITc3kIvhrtRQLIAnvroindITJN//9KCKWI5yTF5vLAgyXu
	 YgK4duhyu1wmVTiY7KaXGDPK5sprKvJqhlS5QPGswfmmGdW09/LqpxfVynTzCdF66QzsP
	 59wuBSA1mUefcL2bPeI+2zohfxKyGSOYGcmVvoLHRIWill0rEsBP4V79585j0DpDe93um
	 pWLk05zYxkmcRU7+n0VLoEmipDKMZEadAnXhijG7lWJz/uTKj9LVMLR7IqwVmrrw4SQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023726;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KLVRWUd5/IKKDM3TOs9elNfL/CvWVAInJtF8uYXelP4=;
	b=03+ZvPjcK+cCGEqJu06iYWdhmzENVwrw8jWc+wVqOl3kkk2t/IMhgmuplih/Gpg0CyUd
	 6xh1FdY1iwU/3DSZEmJPRevn5opdYAAIw9ek9BJ4r6AceXt/TdLjg82V/+78BO3bGL2MU
	 +QEZY5nlVp6npMKex4ybbrSiGeSVYlAYc/CJEzJUDDabhBxq/VwUOw/wnuYfxCou9F7Mc
	 sy0k8T+bmlFiVOzXdjadSKtzk3vrNuiSmzLaFMRkxA0I6Yz101WzKqT8mG1QTFBw0BJLz
	 XTEkEp3yIlUupmdDNnYsewojg0SaJMLgMyeP1X18rsYLWofku/HgIun1Eo++YLvKVKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fe02y02+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3A15606A32A;
	Wed, 18 Nov 2026 17:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fe02y02+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 033091F000C4;
	Wed, 18 Nov 2026 17:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023726;
	bh=KLVRWUd5/IKKDM3TOs9elNfL/CvWVAInJtF8uYXelP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fe02y02+jwHm55ma5rhTeejb/iOAWFypWJ1xr2Jqv1XGgXMNBwa6wxf5pLXbEwGlP
	 jURvtW1D3eLtJi5ABILTXlCKFgJPeGvHA/HPRwyglHfPsESS4MDYkzl6e1F8Zu4RpC
	 6KsWSs3XWPAZ8+P4wys4CQ/rUInX8uB9JSj7pjmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Mahe Tardy <mahe.tardy@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0431/2151] libbpf: fix log level propagation for light skeleton loaders
Date: Wed, 18 Nov 2026 15:36:06 +0100
Message-ID: <20261118150137.747742306@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index 1aaf2bdf26857..711a30e70ec22 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -8699,7 +8699,8 @@ static int bpf_object_load(struct bpf_object *obj, int extra_log_level, const ch
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



