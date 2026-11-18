Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017695;
	b=4jij4byi9w5i2scBKiByNC+6OhIDsxksgAwIxkLUolzsGJK1I6qxJj6p5TOMjx2mv6gI
	 wLhWbgbZUed2es6dSlkTKT9Qd1xKtHurV5zO1eXa9RtFLinLHRJjSts446nXVS9kiBDCv
	 sh6dih/s0P/JB+BsjHRZXkXiZOnmbprD7m6NJ9P7jvMDe0+ptl/D5S9QIK6ibG0lc3gee
	 8uDn5Pe1B1U9k3xOP/wf9sY+yWkZu9wDnpeWvQOAUQNHAqDpdrFzGxJtUJkrsEA92jVOf
	 ZWvwkNQPYBxF8cW+5nvD2/AGIvgucdVSBUzsGrwH1eAeXse35XcxqSjb6T8Uab568FA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017695;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=a3qfem2BGrihybs0Arow2D5xR+HT4R/s0svzry8u+XY=;
	b=SLvXYK+H94KxN3Y0sZRJk/EIFMPq6l31laUiwEBUwDb8CXUkoHYGeP/xFW3Yd4oLtVCN
	 eC7SotU15AJzZ/syB4o9eEgB+jUnf2H6XPvUW2hAN7joJgDc+qXd3wmzB5H1bmn94oxkW
	 MBdMnBNQ5t5IZ7MbDPwtgrkmi3zkRBW0zu0Blx8VZoYYjQrwNZ+9zXzyC6QGgjk0bkU4g
	 nhWSWNObpAIENbjZmLrFfayywOuYN5kJn6QqKT84mQDLrvztsADLXf7BWjCGkquym9p5S
	 7p7yC6l2C4tHBrt0eLyUQycN/cVc8pEqI4xJx5tEkeUFaS/jXw05A0m5oaqDm11Nl+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hGCgHFv5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8BFF606A32A;
	Wed, 18 Nov 2026 16:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hGCgHFv5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 437721F000C4;
	Wed, 18 Nov 2026 16:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017694;
	bh=a3qfem2BGrihybs0Arow2D5xR+HT4R/s0svzry8u+XY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hGCgHFv5VV9dnB138jkBNZXJtKpVbdjZzz2kowMlvQzR8QK2TFDOLawK5G0KHFOvL
	 LQOP/fkJ1p74+CezrFpwvySiis09kzydqoRZZOnhtTanjVmfjBt2Pd5BXjuiTy0mzH
	 5T9QymV0icwwSNN4m2tyO3q0D0PeW5LGuBnnXmyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0976/2651] perf build: Clean libperf-gtk.so in make clean
Date: Wed, 18 Nov 2026 15:36:56 +0100
Message-ID: <20261118150323.037888507@linuxfoundation.org>
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
index 3f757b086071f..f1ac45f1ddd5b 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -948,7 +948,7 @@ clean:: $(LIBAPI)-clean $(LIBBPF)-clean $(LIBSUBCMD)-clean $(LIBSYMBOL)-clean $(
 		-name '\.*.cmd' -delete -o -name '\.*.d' -delete -o -name '*.shellcheck_log' -delete
 	$(Q)$(RM) $(OUTPUT).config-detected
 	$(call QUIET_CLEAN, core-progs) $(RM) $(ALL_PROGRAMS) perf perf-read-vdso32 \
-		perf-read-vdsox32 $(OUTPUT)$(LIBJVMTI).so
+		perf-read-vdsox32 $(OUTPUT)$(LIBJVMTI).so $(OUTPUT)libperf-gtk.so
 	$(call QUIET_CLEAN, core-gen)   $(RM)  *.spec *.pyc *.pyo */*.pyc */*.pyo \
 		TAGS tags cscope* $(OUTPUT)PERF-VERSION-FILE \
 		$(OUTPUT)FEATURE-DUMP $(OUTPUT)util/*-bison* $(OUTPUT)util/*-flex* \
-- 
2.53.0



