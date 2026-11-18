Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047768;
	b=ibW+APQjEwaHaj0Ymuy6fzTPNL+1EWA9WH6ih1SC1N6IrGIBgg0r97y5iOpcDHYDTiQL
	 JcvW6HL1g+dr0WiCgCvMyNOziTJQicXXSDgIHhQHouQadVTejPESK0JU1d0Vs2BGx7ul2
	 dWIVJXWbI5ESRJWmTk2ikE5eT4n5HWFWH9l5zpREL6K4Zk9kszYe8XfypJ9cK8XVfu4f3
	 JDU0PbXUcCPcsIsJzt8hWmOvrAehqr3dnShEoUACR00Kle3p55iRzIaynL1EF8cKpaOUa
	 kJujSt99k/EzBMBk8WpK9vWJjEFFrK6UnFcBArThB9+LRGRc5M4UIzljHlRkSmbMhpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047768;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wrblg0kiBSoyx0sf+QISyyS5lmOOp/Zr6HJvx78eY6Y=;
	b=cGsvaBvHPaCjVYOUJjKc4uyYFv5AHt+/ABSTOZVuAizmExp486nVZ9H26aBxWbFxM1bM
	 4uetfzpxiEQwsHj5ZA3RPjP4lTQNqvfJrCYD1Y9bNT947xn0hXBdWK0QQPcEbsQYU5/Sg
	 z8F+2A2JKnLv8LkMdKM64CVVzS8WJEEtOla22e6iVI/mMvxmtLQf+Jb3+l4wGII6DOyCM
	 FpClPiMoxgm1O22m6MLT2GJ313c8uj6m2e0sTEKbypLAekaFBpDE9rUS3cxCakpW8G6Gb
	 0ey/uOGqrSym1RujWYxegeXMjogvwaWVHbQGqE4I73d6/1fivWHDrJkjt34uv0A5vzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pWiQB699;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC17E606A320;
	Thu, 19 Nov 2026 00:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pWiQB699
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1464D1F000C4;
	Thu, 19 Nov 2026 00:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047768;
	bh=wrblg0kiBSoyx0sf+QISyyS5lmOOp/Zr6HJvx78eY6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pWiQB6994xfvrPrDB7FLg0ncH3VSC5R2esvKjFDNijV/kSUOKZFLoOOQM6E9goIEt
	 tWOoTf+NS93VRhRbXtbCDW0dQxSZgWUuVJSpTjWFj4/XILsQlzCH6PHWZyXxy0C0yV
	 aRKNA8PzAOTT2hxpwGRm6A0wVn2NcLUKrB6/Aiyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Stephane Eranian <eranian@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1756/2857] perf jitdump: Validate sym string NUL-termination in code load
Date: Wed, 18 Nov 2026 15:46:30 +0100
Message-ID: <20261118150304.519498974@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 98bfe1142ccbaa5ffdca5dcdddd26f238ad33585 ]

jit_repipe_code_load() computes sym = (void *)jr + sizeof(jr->load) and
passes it to jit_emit_elf() which calls strlen(sym) via jit_write_elf().
If code_size equals total_size - sizeof(jr->load), the sym pointer
aliases the code blob with no NUL terminator, and strlen() scans past
the buffer into adjacent heap memory.

Add a memchr() check to verify the symbol name is NUL-terminated within
the region between the load header and the code blob before use.

Fixes: 598b7c6919c7bbcc ("perf jit: add source line info support")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Reviewed-by: Ian Rogers <irogers@google.com>
Cc: Stephane Eranian <eranian@google.com>
Assisted-by: LLM
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/jitdump.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/perf/util/jitdump.c b/tools/perf/util/jitdump.c
index 584932d1065e8..05561ab23f174 100644
--- a/tools/perf/util/jitdump.c
+++ b/tools/perf/util/jitdump.c
@@ -487,6 +487,13 @@ static int jit_repipe_code_load(struct jit_buf_desc *jd, union jr_entry *jr)
 
 	sym   = (void *)((unsigned long)jr + sizeof(jr->load));
 	code  = (unsigned long)jr + jr->load.p.total_size - csize;
+
+	/* sym string lives between the load header and the code blob */
+	if (!memchr(sym, '\0', code - (unsigned long)sym)) {
+		pr_warning("jitdump: unterminated symbol name in code_load record\n");
+		return -1;
+	}
+
 	count = jr->load.code_index;
 	idr_size = jd->machine->id_hdr_size;
 
-- 
2.53.0



