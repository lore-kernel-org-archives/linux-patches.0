Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B14BB35DA41;
	Sat, 17 Oct 2026 18:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260218; cv=none; b=b7ltiAKpCbgUs9cG6C+F1bVQDrbdWS5iB38KrNDcRHWImxU3szkPB02k7SY9hiqNNoax4zHcb80engjW1sO558zd44T9IJNhTsJJGKdsFbqdf25IXeO4EErXsr/zFXp0rKDTLevtYMEWTM7XAJDZ9v4v5Wcp9JaBbA5Of3/50c8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260218; c=relaxed/simple;
	bh=dXPBPJVV9Nf6zhu/C1qKma+j8phdef1Cp9nhIyQp+wU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L7GOc4WGhidxzYqCOyjCQBfqiG9af38uy4BtS++GRHm/51jNh6plklNrrahoAfBhjF18CMFYkDHLtAXUPN+CNVuotSzJS6hLweu+yBHj/8q+hww72ni3Fgl5SUmj/lU+Wi2xe0rfTwwAfcGSIWzvuQSiDlBsDeUXtHvhskqcyFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=htHjkfil; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="htHjkfil"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0740D1F000C4;
	Sat, 17 Oct 2026 18:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260217;
	bh=0Obb0zwGJ9lO7kt5Nw1JtfEwIydcbVPuure2wY8UEIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=htHjkfilh6rwX9voYrinuzANmdlFS1jMUtfLdHanO0F+GsImejvTA4wxR+tWC09T0
	 O813LfCqbDisaV3xNrl8R7HG63uEaanRJYyYu/0aDTvaKWalBxTiitQE+aYsjb0pf9
	 C5SJ7ezimg3rulo2ZlAlStdMltrPAobwNQ0Bv4yc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hari Bathini <hbathini@linux.ibm.com>,
	Song Liu <song@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1472/1674] powerpc/bpf: rename powerpc64_jit_data to powerpc_jit_data
Date: Sat, 17 Oct 2026 18:02:24 +0200
Message-ID: <20261017160508.948396048@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hari Bathini <hbathini@linux.ibm.com>

[ Upstream commit de04e40600ae15fa5e484be242e74aad6de7418f ]

powerpc64_jit_data is a misnomer as it is meant for both ppc32 and
ppc64. Rename it to powerpc_jit_data.

Signed-off-by: Hari Bathini <hbathini@linux.ibm.com>
Acked-by: Song Liu <song@kernel.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20231020141358.643575-5-hbathini@linux.ibm.com
Stable-dep-of: 369e4635d048 ("riscv, bpf: Fix memory leak in bpf_jit_free")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/net/bpf_jit_comp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/net/bpf_jit_comp.c b/arch/powerpc/net/bpf_jit_comp.c
index c8e74a3bb1f9e..877e7ff387856 100644
--- a/arch/powerpc/net/bpf_jit_comp.c
+++ b/arch/powerpc/net/bpf_jit_comp.c
@@ -39,7 +39,7 @@ int bpf_jit_emit_exit_insn(u32 *image, struct codegen_context *ctx, int tmp_reg,
 	return 0;
 }
 
-struct powerpc64_jit_data {
+struct powerpc_jit_data {
 	struct bpf_binary_header *header;
 	u32 *addrs;
 	u8 *image;
@@ -59,7 +59,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *fp)
 	u8 *image = NULL;
 	u32 *code_base;
 	u32 *addrs;
-	struct powerpc64_jit_data *jit_data;
+	struct powerpc_jit_data *jit_data;
 	struct codegen_context cgctx;
 	int pass;
 	int flen;
-- 
2.53.0



