Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020436;
	b=BZwDTI25rB+EOSOkupN20qHr4/4FgkvUf7YlODmvOLlSAHTc6SOPYitO13DJiq1K6Uah
	 9JsBd2x70wkQcbZCRCoTvZG2/CCiuoNbiwD0SeVpUJA4JVSnrmn5EqJrvwe9AxCDe8VVC
	 Gp3OThg1j3ZJNuNAZJCzoG5k5+k94j0gdEoJRNjsgnIaOhXH4XckFBfO4M09Fhuhg/AYk
	 cZXZU05MWQz7nfoaLMfJWqe0hQyqzcZPnqT/jygs3gw3cCUDb31kwnD7HP+i8kFXJR1NX
	 skMV7GetOgWudWPYOnjlycFPzFuqNl7U84qX3N9PcLR0qPHblE6hRaJ4EYjyPwLmdBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020436;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=i4oCukIDLWHb0lo/asQVuDaJ2QZwqC3SRseDhXUYF9Q=;
	b=C8U0o0htBhcYUQHDaoP7jc8nALCBRjZSBpPc+a0OFubIiOZuyItNdlGcxacvA2GIEWxQ
	 1x4pV/h/4HzJZBhdFqPxF+++ESOhOhfAnxLMTTOAoLAWp9ecZOfaRfGZ5yINQCjkM9Q3F
	 yWPLI6hGolvrI6lz3sWXt6spTci9MyRDaFfUqkqdIueEzWSyUO3WIJMtcpmhIr/fd+xmR
	 5axd+AUWlVzRL0tZOOSKdARuANnsRou6J7iPQpM+DHbumWPZK37KH/OBd5v+VV6Obsp4w
	 KqlWXB66RpGHU1t6HP7fRbecT1/PLZfo2l2EnN+lt9l9ap5z3n7jNGJjWl+Jx80Cqhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vpnCM49W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 389E8606A325;
	Wed, 18 Nov 2026 16:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vpnCM49W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 837E01F000C5;
	Wed, 18 Nov 2026 16:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020436;
	bh=i4oCukIDLWHb0lo/asQVuDaJ2QZwqC3SRseDhXUYF9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vpnCM49WgnyzEcM45NhKHgMA9iCokZhfpQWkxU+TW3c3K4JClhd8e3JuNAQyhhq16
	 NMLgVomeRts2IYMjpu3xeUg++KHkV75bWPn9/d7IloJl7S8BSv/9IkXUH00GOMGEMc
	 vwn0+FqaqOVnaoqAMFvsz6W9Z0VoPVpL48MwvjSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>,
	Kees Cook <kees@kernel.org>
Subject: [PATCH 7.3 1924/2651] selftests/exec: report the skipped binfmt_misc_bpf test on stderr
Date: Wed, 18 Nov 2026 15:52:44 +0100
Message-ID: <20261118150355.992852856@linuxfoundation.org>
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

[ Upstream commit b36b990c50b1f581b9a7f35ae256f5542415fa69 ]

The exec Makefile announces that binfmt_misc_bpf is skipped with
$(info), which writes to standard output whenever the Makefile is
parsed. The selftests install target appends the standard output of
"make -s emit_tests" to kselftest-list.txt, so on systems without the
BPF toolchain the runlist gains a line that is not a test entry:

  exec selftests: skipping binfmt_misc_bpf, needs clang, bpftool, ...

run_kselftest.sh and CI systems that parse the runlist then treat it as
a malformed test entry.

Use $(warning) so that the notice still appears in build logs but goes
to standard error.

Fixes: 277d787feb2e ("selftests/exec: add binfmt_misc bpf-backed handler test")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Link: https://patch.msgid.link/20261014200135.1364053-1-sashal@kernel.org
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/exec/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/exec/Makefile b/tools/testing/selftests/exec/Makefile
index b640af8f02b51..bb10d9523e7fc 100644
--- a/tools/testing/selftests/exec/Makefile
+++ b/tools/testing/selftests/exec/Makefile
@@ -63,7 +63,7 @@ TEST_GEN_FILES += bpf_interp.bpf.o nix_origin.bpf.o transparent.bpf.o
 TEST_GEN_FILES += loader.bpf.o interp_bind.bpf.o
 TEST_GEN_FILES += binfmt_bpf_interp binfmt_bpf_app binfmt_bind_interp
 else
-$(info exec selftests: skipping binfmt_misc_bpf, needs clang, bpftool, vmlinux BTF and libbpf)
+$(warning exec selftests: skipping binfmt_misc_bpf, needs clang, bpftool, vmlinux BTF and libbpf)
 endif
 
 EXTRA_CLEAN := $(OUTPUT)/subdir.moved $(OUTPUT)/execveat.moved $(OUTPUT)/xxxxx*	\
-- 
2.53.0



