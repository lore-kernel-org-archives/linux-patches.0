Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030319;
	b=jYGJIkyQSP432ClZjPYQSASnOOpveSb7uP57adoFnLlx3pONxlMTIcW3QHcqPb/wNRoh
	 HKivce5Rur0VoPzyRaUFd5HN5RMIb7A3xqN/Ciazx0SiPIrpXt40PuBd4jUXMz3zYKuAI
	 X4b0C18+6KpxZ3g2AJPDp1pkolTd4LWq+iOrasD1JGFBXzNQLfdVROEIZY6yNwWnhmN/t
	 INu66oJVflrn+ojoXtOcdz9JSCOX4gACsQmJV9jyMtGqa8+FlJOtJ4lxIWmrR8dUQDfoN
	 kosGowkhQIWiOTjWgw3f3uxCdQNRQv39xhnCdgCCV8fnoGjopNv2+t6DQeSoY7d52Tg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030319;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QbGrR0rx5YFVc40h0/q07KyFbvUZbR+bwOxo2fvF48Y=;
	b=2mnt2TMEM2hEq6qbrpOhG1S36bIvOn88yLQwl4dbY1LKXp/zP3foYaFIBvRlRXlNG7jD
	 wHqpHVHDFM2w7FO4V1BeWuXPORoJdJiPZWCUTtivHqbFlu6F0rpc2hpNqn1YctM1EcsJd
	 SRoOert+fSQh39wHy83OBMML5/K33OjkRyBR9AMKbo3v0JcNcS0BTV9WZXWXDKpC6s4v8
	 8W7Fcd1zO0Yg6dsg7C7S76qGbS3a1zjTmu+eKFytM/iiq6oDVqJAIuOj6ibvHBrYdwp4V
	 l/o1ROZ5GesXHERL3/35J6xTyC6gbsaKtSfbxI6708ibTdb2x0SfJNK+JtN12Ex2EJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uD6Tu+dS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4487B606A334;
	Wed, 18 Nov 2026 19:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uD6Tu+dS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E5D61F000C4;
	Wed, 18 Nov 2026 19:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030319;
	bh=QbGrR0rx5YFVc40h0/q07KyFbvUZbR+bwOxo2fvF48Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uD6Tu+dSDnlUNwOdB8ISbsVf3lseIwDtgF7HCx2IxWofcZvWod6RsFJryg4M1yY+9
	 vdvPHOHdUkeFgniPntv8DHlq+rkGGG8AvtT2CU8rMgSF34r1HwBR7cA6oS5ZzhKD01
	 GXJmMXujxQqH9BLjQ4WYKPT3ZZm9w8SPf+43ayMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0663/1756] perf build: Clean libperf-gtk.so in make clean
Date: Wed, 18 Nov 2026 15:46:30 +0100
Message-ID: <20261118150035.467131643@linuxfoundation.org>
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
index b61c355fbdeed..839880b1a42cd 100644
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



