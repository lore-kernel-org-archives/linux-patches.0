Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B5D345198D;
	Mon, 31 Aug 2026 13:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183266; cv=none; b=Ug+8x9eS9R1am5cfkCMV4LU1/EzYHzm4+jMylnphi0VV9PKzJixQC+Toj+u+SkXIL+N6tQBywq9ld8K4+ZhrNs2sqbqlC9a+6IMleqCbgsN/m56/wLA3EsoAd96VaOtwlq0F0Wh3RmsRpFQXN8nxqlnjoooIq84FyRQdhym8JoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183266; c=relaxed/simple;
	bh=TLfYzGUIswu7v7i4IyLCKYCaudwZUkNJeYDprQrSV3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bPC8O2/tS1V/5cg1eXFCw/HfhkuRuit8G5fjucagZlTjs3TW6oRP3HtcMA2mvuOv6vLj0eVmy38eoMYIPRgumIS3mlXDPNU/cOJP5dFiIy5DqjjMK8kJH5khQB/+Y+aixqNgyCruVCxgcCzO4XhrJijLe5jQUgvUIXIKAYhKaCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GEdX9lkb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GEdX9lkb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBFED1F00A3D;
	Mon, 31 Aug 2026 13:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183264;
	bh=XoRoi6gG2L4vd/lsErEQ4O/Q6peYNr+LJMWT8TDS2ks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GEdX9lkbk/1II8R6iEIsJbIgTgp/J5xXLedjM2cRo51i+5S7XdYsmYzIk8Ddkf863
	 EMo900ER4mOn4xZZMeFpkF4CoJzZL+w98BwzyhFW1Jze+3xk90xMggW5L6s29JzW9k
	 RQmezr805+IV7OQ95dv04rnd25ozaMtpCPBhMMwvvPdJiVUcDNSnzFhnpeS4FfF6Sj
	 WvMUhgk2nmDJe62YZxAI48Ghk+K6ABQnrXKRDyHn5Ck5y6uAJTRWbiMJguxAf36DFk
	 nXsX8lNVZFMzF9pWKSLeI44ufY7Eg8AWUDlnUTIkYao0x6eCwfnoFMlsy0rUkyQdOv
	 phEDsm4GXzJ8w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	andrii@kernel.org,
	eddyz87@gmail.com,
	memxor@gmail.com,
	bpf@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] libbpf: Also reset {insn,data}_cur on realloc failure
Date: Mon, 31 Aug 2026 09:21:12 -0400
Message-ID: <20260831133314.4125787-44-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit d2f7bd066ed492aeaf82864fbf1f06770f9d9f9d ]

realloc_insn_buf() as well as realloc_data_buf() free and NULL
gen->insn_start / gen->data_start on -ENOMEM but leave gen->insn_cur /
gen->data_cur pointing into the old, freed buffer. Just reset the
cursors to NULL alongside the base pointers so the freed state is
coherent.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/r/20260529094119.307264-3-daniel@iogearbox.net
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The background search for the commit hash finished: `git log --grep` did
not turn up **"libbpf: Also reset {insn,data}_cur on realloc failure"**
in this 6.18.44 tree. The matches were unrelated "reset" commits in
other subsystems, which fits — the fix is not applied here yet.

The earlier analysis still holds: this is patch 3/3 of Daniel Borkmann’s
gen_loader series; patches 2 (hash skip) and the endianness guard are
already in this tree, but the root cursor-reset fix is missing. It’s a
small, real userspace memory-safety fix on the OOM path and should be
backported.

**YES**

 tools/lib/bpf/gen_loader.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/lib/bpf/gen_loader.c b/tools/lib/bpf/gen_loader.c
index d41defa1936d3..4e2d25e024af4 100644
--- a/tools/lib/bpf/gen_loader.c
+++ b/tools/lib/bpf/gen_loader.c
@@ -63,6 +63,7 @@ static int realloc_insn_buf(struct bpf_gen *gen, __u32 size)
 		gen->error = -ENOMEM;
 		free(gen->insn_start);
 		gen->insn_start = NULL;
+		gen->insn_cur = NULL;
 		return -ENOMEM;
 	}
 	gen->insn_start = insn_start;
@@ -86,6 +87,7 @@ static int realloc_data_buf(struct bpf_gen *gen, __u32 size)
 		gen->error = -ENOMEM;
 		free(gen->data_start);
 		gen->data_start = NULL;
+		gen->data_cur = NULL;
 		return -ENOMEM;
 	}
 	gen->data_start = data_start;
-- 
2.53.0

