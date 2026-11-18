Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024738;
	b=Behdwpccxz0yhA4qMkuq7+5Y3aha969wGdir9VWSyD7m8mVd2toPTMHqWF/q8NIKjlcl
	 Nd+yK5hR8WgjaGyEvjr/olIxJemrdk2dgpii8a6GjfX/dGDBK0LzmmKgJthMJaQcG8LDN
	 oJntJLhdt85Suf4ANqmDYkAFkFnxcGQxNyUi9ATgdsEZbFUEZ0+TPeSVLFzsVbdfkFPoC
	 Y6j6Pxzw+72ZKKV+B/s44OxuQw6EErhbzMYKhf2Gerivl7+psfxMiV3c7cMLPCmjWFsnW
	 NOPNoNQ9bTSOjDR1J4sb2gqbZ9UZ1pYNAeEl/DGvKG2tJt2QJ0Uu6jLQyv9+MnCT9IQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024738;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cGrPBLcSEc1KETVsx5u4ZnBayWjob3CrQ+SY6alrBhU=;
	b=g5Z4gStaXR9kRxA/UW+39hh63FUVAUaqZn36EU/k1wuUG/k5G7tNQno3gUdyTE+AFZhj
	 HZGExpW2Jcj5rc8+9sUHcC25IWXQvL1G9jMjhK2RfIbEvCDm4ZeqPGQRazjGttRLeSkFq
	 /KaSjsgzSH+gHCqL/63mpA6U/8aZ2zbUWbyD2mEjbo/RTUbIrwyvJOc5ITviDdbbclDwl
	 xzMr+kXsK5spjNWJqGEfAcu317JsZTPtiGABAG3+HAWTKJsrandIjZWzw0D+U30A/nhba
	 Hwdx908pNsXlj06rFNoXL2e1nw6+cewASyIebh4VBq3MXHY6wgr1ewWTsZoHZIH7H5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yXHaaWzU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 881C8606A32F;
	Wed, 18 Nov 2026 17:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yXHaaWzU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDD8C1F000D1;
	Wed, 18 Nov 2026 17:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024738;
	bh=cGrPBLcSEc1KETVsx5u4ZnBayWjob3CrQ+SY6alrBhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yXHaaWzUqsNAhdjikL4e57+pC0WqsjyfpWW6cMwu2+xxkcFXXqf+tf6QTzP2x1Ovr
	 Da4IWaqZDOIe/mVjZD2c8yOJ2ZncEt7iEa18UtnLlZjPr1xiFrBBQQfzW+11T/xefS
	 ffg6nQbggYmcagNK3TV5MrlhUOaJJqOLJ9sBkl9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0833/2151] perf build: Clean libperf-gtk.so in make clean
Date: Wed, 18 Nov 2026 15:42:48 +0100
Message-ID: <20261118150152.473615643@linuxfoundation.org>
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

From: Ian Rogers <irogers@google.com>

[ Upstream commit fb0da4af899ab1d6a66d29b21189bda3c68c2ce0 ]

When GTK support was made opt-in (first via GTK2=1 and recently ported
to GTK4=1), $(OUTPUT)libperf-gtk.so is only added to ALL_PROGRAMS when
GTK4 is defined. As a result, running 'make clean' without GTK4=1 does
not remove $(OUTPUT)libperf-gtk.so.

Add $(OUTPUT)libperf-gtk.so explicitly to the core-progs clean list so
it is always removed by 'make clean'.

Fixes: 4751bddd3f983af2 ("perf tools: Make GTK2 support opt-in")
Closes: https://lore.kernel.org/linux-perf-users/CAP-5=fV6+mzN3Lf_mCAJ4aP42JFZsF55ekvt8XrX505xOWwrmA@mail.gmail.com/
Reported-by: Ian Rogers <irogers@google.com>
Assisted-by: Antigravity:gemini-3.1-pro
Signed-off-by: Ian Rogers <irogers@google.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/Makefile.perf | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 3e3e266c5bc1d..84cfd7395d18c 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -1275,7 +1275,7 @@ clean:: $(LIBAPI)-clean $(LIBBPF)-clean $(LIBSUBCMD)-clean $(LIBSYMBOL)-clean $(
 		-name '\.*.cmd' -delete -o -name '\.*.d' -delete -o -name '*.shellcheck_log' -delete
 	$(Q)$(RM) $(OUTPUT).config-detected
 	$(call QUIET_CLEAN, core-progs) $(RM) $(ALL_PROGRAMS) perf perf-read-vdso32 \
-		perf-read-vdsox32 $(OUTPUT)$(LIBJVMTI).so
+		perf-read-vdsox32 $(OUTPUT)$(LIBJVMTI).so $(OUTPUT)libperf-gtk.so
 	$(call QUIET_CLEAN, core-gen)   $(RM)  *.spec *.pyc *.pyo */*.pyc */*.pyo \
 		$(OUTPUT)common-cmds.h TAGS tags cscope* $(OUTPUT)PERF-VERSION-FILE \
 		$(OUTPUT)FEATURE-DUMP $(OUTPUT)util/*-bison* $(OUTPUT)util/*-flex* \
-- 
2.53.0



