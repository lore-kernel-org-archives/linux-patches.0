Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017449;
	b=jjiQHXdbYESPVQOXhxCHsl3F2bF1jeWIZIo0LlcGe64EYyQowcEgnNWEt1Avn8mWDFDz
	 wEOXCMA079PgU6l2GbKbhatFSMU67wRlIEB9i2LpoxhBZ+EKFK2hmqMC7VvsJEU36vK6L
	 jEQDdcPGqjpDuPMdB6FubrtwgRRHPDv/LbG8qDal48qxgxEDUDhgqiu4UYHZuF9l1JNvU
	 yYyg9bskTld0QVNBu/RsfhxprGcMUOcXBNMsdS/glPSsm5tfOa3kIbrx8IkjBCHqdWDIt
	 kqmtkHO1aO1609ZsS4Xxq0vttEzScHVVey2pUkfB6i/l6G/TYmqfUuBGoYYEfKJgayw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017449;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3p+FzR9irV1C70gZ5z79gmaMNC9BMc2qCD3Puu+wcRo=;
	b=DtY+T5crjA3kYvEH9hY8pCR1Ue1LvUjYQiytCcDkVVPwGf6lw+YDmczMljJ69lZg8R++
	 /vsaUJQjDtSPplhZHYj4qge4dzAeEgG1+5GsFBgnXyTf+DYh1h+Ezaa6EIdU5K32o1jRx
	 P0VOZJibMDXPOqqRCI7A4dh1FKFHphmFb72I7uFyoUBb1HA+yImeTBnNgD1mK6b2QPsjM
	 dBnxfKugn3DsgTpJEAEoRqWOlOeXHb1rImNp6KM9JE7gu/qywvar9Dma6E0QcGKi/Eif7
	 Q5ndjUHZkeHor7/ZRwJWCb7BK3HPPWBqT0m6Mm4ZqPecb8v/RIdW6GSgisOs4BN7/1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GnLcUXDY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B39D606A31C;
	Wed, 18 Nov 2026 15:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GnLcUXDY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D08E21F000C4;
	Wed, 18 Nov 2026 15:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017449;
	bh=3p+FzR9irV1C70gZ5z79gmaMNC9BMc2qCD3Puu+wcRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GnLcUXDYOJUw+GaIVfIss2xYh+g0qzB4f14tGbmTF/X3EOYrgON/FIq0CNzGsf2kE
	 JSCvzr9Lu+elm/nQTQ/LMx0rfYeD+ZfCNtl0a+qYNyO6hqW1DhcH/Lb9fMFViDORvr
	 doOpGY7k5JSW/I6zC/vqI0jeXub9ZgqfGlcBOfvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sandipan Roy <saroy@redhat.com>,
	James Burton <jamesburton@meta.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Anton Protopopov <a.s.protopopov@gmail.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0888/2651] bpf: Clear insn array jitted pointers on map reuse
Date: Wed, 18 Nov 2026 15:35:28 +0100
Message-ID: <20261118150319.832027861@linuxfoundation.org>
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

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit 9aa11c4656b7bd8a32869296603f117a49eadd6e ]

An insn array records, per entry, the xlated offset, the jitted offset and
a jitted target pointer in ips[]. bpf_insn_array_init() runs when the map
is bound to a program and resets only xlated_off; the jitted offset and the
ips[] pointer are left as the previous owner set them. A program can be
verified and JITed and only then fail to load (e.g. bpf_check_tail_call()).
By that point bpf_prog_update_insn_ptrs() has already filled ips[] with
pointers into that program's JIT image. Thus, the map is handed back for
reuse with the stale pointers intact. If the next program reuses the map,
the stale pointer survives in the now active program's jump table,
pointing into the previous, freed image. Fix by resetting the jitted offset
and the ips[] pointer alongside the xlated offset.

Fixes: b4ce5923e780 ("bpf, x86: add new map type: instructions array")
Reported-by: Sandipan Roy <saroy@redhat.com>
Reported-by: James Burton <jamesburton@meta.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Anton Protopopov <a.s.protopopov@gmail.com>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://patch.msgid.link/20260925175244.1136329-9-daniel@iogearbox.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/bpf_insn_array.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/bpf_insn_array.c b/kernel/bpf/bpf_insn_array.c
index a2f84afe6f7c6..5874abd1f7438 100644
--- a/kernel/bpf/bpf_insn_array.c
+++ b/kernel/bpf/bpf_insn_array.c
@@ -199,12 +199,16 @@ int bpf_insn_array_init(struct bpf_map *map, const struct bpf_prog *prog)
 		return -EBUSY;
 
 	/*
-	 * Reset all the map indexes to the original values.  This is needed,
-	 * e.g., when a replay of verification with different log level should
-	 * be performed.
+	 * Reset the map to its pre-verification state. The xlated and jitted
+	 * offsets and the jitted target pointers are recomputed by the verifier
+	 * and the JIT for this program, so any values left by a previous owner
+	 * must be cleared here.
 	 */
-	for (i = 0; i < map->max_entries; i++)
+	for (i = 0; i < map->max_entries; i++) {
 		values[i].xlated_off = values[i].orig_off;
+		values[i].jitted_off = 0;
+		insn_array->ips[i] = 0;
+	}
 
 	return 0;
 }
-- 
2.53.0



