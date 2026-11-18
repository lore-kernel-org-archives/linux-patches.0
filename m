Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054657;
	b=HtqcU00Ard2NQF1Emz0A5gt82zoED0p4CkTd17qq+cE2eiOiRTXl0j1ucoxppijch3cH
	 BCAzPhYPR12OXCz4Xc0TjkOxb2L+Nx+x+bPLcuJrly1+D8b2lOK/CGHB/2DfOzCCY2Rb7
	 exsZhiE+dtd1fHU678aOYifiAtdLCPv3mgprTLAmATBNcnwTdvIM0Ue1axamuNgaFPQRF
	 o4MSyduRM/TvNkhgsR1vV/an6pmlEeKWinDMCDnrJFU3l1gDxgxLKFpXd2DOwd/QRR0Hi
	 rrIUrqyvNxBb8bgzhvamnL9bscC4aM0BHi3xLeDhwcoABaDeGIwGdzJYuWvlsEbdwvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054657;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ak4OSZ2dcjNX50HFIR2DfVWpEr1KiDQqD0elEkdDvnA=;
	b=klxEWYAX1VQQxHuIG1O+1/bd3DISHi5BFrv0KQdPy9zbm6MzcV6wvOL0/EloQZ+SgvWN
	 MpaX+ZYq4HSusJDNKSX5/vlJKnXbiFYNeBFVRvmQ3ENf/Q4Up3t3lur4x6eowczky0QtB
	 6D3e8BGio2w85BWxPmfg1C6jwOqf6FMfZQNwseGJVdrV1vs+4VSn6Ee4xnxc0q8ogsRM1
	 F1WFBBWwQqJOyRduPnX3x2A7VvP3MhT7WcSeKX5Phk0hdRfsQtK+BCRZv/VHxR5/A95B4
	 VDbBp8wUWxNWdKHvVvVnIUIag2N/5EMQKQP3bTbkyzsNay7Fx3XzzO+KMGK8mVy1qoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V9YDsiVj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1880606A320;
	Thu, 19 Nov 2026 02:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V9YDsiVj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13A8C1F000C4;
	Thu, 19 Nov 2026 02:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054657;
	bh=Ak4OSZ2dcjNX50HFIR2DfVWpEr1KiDQqD0elEkdDvnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V9YDsiVjzyaaWRAQaTeA8knfEnvh7M1NdVY4hwOATP72KKGYbXUAMUuyhYmF2dab8
	 OIAHjLCVFXzLS6++bj0kKWwzfUej+fE18X2j015mTi1rnwKM4nKMZPakd73X/RDAiv
	 eoItAySGCqlfUA2/BAmGSeovT33T1nPT3vUK1fZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Stephane Eranian <eranian@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1353/2214] perf jitdump: Validate sym string NUL-termination in code load
Date: Wed, 18 Nov 2026 15:50:29 +0100
Message-ID: <20261118150105.559794601@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 2a14161702449..e23ba5866ffce 100644
--- a/tools/perf/util/jitdump.c
+++ b/tools/perf/util/jitdump.c
@@ -494,6 +494,13 @@ static int jit_repipe_code_load(struct jit_buf_desc *jd, union jr_entry *jr)
 
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



