Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CB2A36828B;
	Mon, 16 Mar 2026 21:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773698069; cv=none; b=WJPv+Mx1IV9mVdq9qUMvXb+Oc/akCM1f1FoSyiXPyRciFRdwSxQBNk+aiacUaViW30PFDEr/yI/OOQELR9pvk8xjaFnx3CCFBE8dbnvqwjnWfRc9qYqNjKwlxVEJ4U60BhqpwjsqvfKZx3XBTxFYjl0BBALsYSOB7bcyGkvJUrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773698069; c=relaxed/simple;
	bh=TMGfrOPqq1QMIR2jmkCprr2khCTXxYuklmyZc5fsbzY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=PyrsT208aJgKfs6iMyS/WLim2+S7gfDJHf7jfOhI/wJcMCT3a6qSwG6z6pHbT6PXF+l1y0ytH0XpDAz1tUpwx0JmDPyjq4lAD1+J4iHAgTcDWNuWM0UfzS4VpqLfBEsv1HxUDcI+m8heuOfiQzGQ9P6kgYyGSdN+NQR9dBeQJe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UG1rg/w6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UG1rg/w6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E334C19421;
	Mon, 16 Mar 2026 21:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773698069;
	bh=TMGfrOPqq1QMIR2jmkCprr2khCTXxYuklmyZc5fsbzY=;
	h=From:Date:Subject:To:Cc:From;
	b=UG1rg/w6PophvgY0jPl/iMm0p1n6G1t5lGM/FGnXbWhvNl3z82NdpIRzM/A/gLS3/
	 kN+UjWYo/kl0bob/MIMsmMXm8wfx6mvLOf5CfBC6biNAPFA01Dmu2GAG0zcQxVjpwd
	 to1dF2Q06P7s0LTzG86pcx0j0AuHWS2VNwLM4cRiTqSTIhgKnJ/UjgBxkVs1h1+4df
	 n8uLFRhVp2lr04mo94A5UmEgoMX6L7umbgIixTiDIrcK1p3RBst7lrauvaYrBJ6xAL
	 o6A+tngEi7dJgnRu5sa/kHdfP+aIzXRIdMlIbOCYY63WfrZZAIGJlBJ5x0nSMushFf
	 X1hztCNQ9UoyQ==
From: Nathan Chancellor <nathan@kernel.org>
Date: Mon, 16 Mar 2026 14:54:22 -0700
Subject: [PATCH] drm/xe: Fix format specifier for printing pointer
 differences
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260316-drm-xe-fix-32-bit-wformat-ptrdiff-v1-1-0108b10b2b6b@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXNywqDMBCF4VeRWXdAEyvSVyldxGRGp+CFSbyA+
 O5N2+UHh/+cEEmFIjyKE5Q2iTJPGdWtAD+4qSeUkA2mNE1pqwaDjngQshxoDXaScOdZR5dwSRq
 EGd2da27r1pK3kDuLUl7/Pp6vv+Pavcmnbxiu6wM+uI0YhQAAAA==
X-Change-ID: 20260316-drm-xe-fix-32-bit-wformat-ptrdiff-a5f4f8483ec3
To: Matthew Brost <matthew.brost@intel.com>, 
 =?utf-8?q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
 Rodrigo Vivi <rodrigo.vivi@intel.com>, 
 Matt Roper <matthew.d.roper@intel.com>, 
 Dnyaneshwar Bhadane <dnyaneshwar.bhadane@intel.com>
Cc: intel-xe@lists.freedesktop.org, dri-devel@lists.freedesktop.org, 
 llvm@lists.linux.dev, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=6882; i=nathan@kernel.org;
 h=from:subject:message-id; bh=TMGfrOPqq1QMIR2jmkCprr2khCTXxYuklmyZc5fsbzY=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDJk7aoQTet+WS1Vufzil+PzhjwxSYounzhNdkP422aS19
 Mz7yJsTO0pZGMS4GGTFFFmqH6seNzScc5bxxqlJMHNYmUCGMHBxCsBEWBYxMmz07I3ZK3f38IsY
 MfMyrm+2ioyzJjluyJJ383AxCAtQ+svwP/9AWW0NW3vmuSeqk9JVy2//Ytv8UWiWcciMoPsHlhw
 r5QEA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

GCC and clang warn (or error with CONFIG_WERROR=y / W=e) several times
when targeting 32-bit platforms along the lines of

  drivers/gpu/drm/xe/xe_lrc.c: In function 'dump_mi_command':
  drivers/gpu/drm/xe/xe_lrc.c:1921:40: error: format '%lx' expects argument of type 'long unsigned int', but argument 3 has type 'int' [-Werror=format=]
   1921 |                 drm_printf(p, "LRC[%#5lx]  =  [%#010x] MI_NOOP (%d dwords)\n",
        |                                    ~~~~^
        |                                        |
        |                                        long unsigned int
        |                                    %#5x
   1922 |                            dw - num_noop - start, inst_header, num_noop);
        |                            ~~~~~~~~~~~~~~~~~~~~~
        |                                          |
        |                                          int

  drivers/gpu/drm/xe/xe_lrc.c:1922:7: error: format specifies type 'unsigned long' but the argument has type '__ptrdiff_t' (aka 'int') [-Werror,-Wformat]
   1921 |                 drm_printf(p, "LRC[%#5lx]  =  [%#010x] MI_NOOP (%d dwords)\n",
        |                                    ~~~~~
        |                                    %#5tx
   1922 |                            dw - num_noop - start, inst_header, num_noop);
        |                            ^~~~~~~~~~~~~~~~~~~~~

Use the '%tx' specifier for printing pointer differences, which clears
up the warnings for 32-bit platforms while introducing no regressions
for 64-bit platforms.

Fixes: 65fcf19cb36b ("drm/xe: Include running dword offset in default_lrc dumps")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/gpu/drm/xe/xe_lrc.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_lrc.c b/drivers/gpu/drm/xe/xe_lrc.c
index 7fb59386d1c5..31d57d8ec051 100644
--- a/drivers/gpu/drm/xe/xe_lrc.c
+++ b/drivers/gpu/drm/xe/xe_lrc.c
@@ -1918,17 +1918,17 @@ static int dump_mi_command(struct drm_printer *p,
 		while (num_noop < remaining_dw &&
 		       (*(++dw) & REG_GENMASK(31, 23)) == MI_NOOP)
 			num_noop++;
-		drm_printf(p, "LRC[%#5lx]  =  [%#010x] MI_NOOP (%d dwords)\n",
+		drm_printf(p, "LRC[%#5tx]  =  [%#010x] MI_NOOP (%d dwords)\n",
 			   dw - num_noop - start, inst_header, num_noop);
 		return num_noop;
 
 	case MI_TOPOLOGY_FILTER:
-		drm_printf(p, "LRC[%#5lx]  =  [%#010x] MI_TOPOLOGY_FILTER\n",
+		drm_printf(p, "LRC[%#5tx]  =  [%#010x] MI_TOPOLOGY_FILTER\n",
 			   dw - start, inst_header);
 		return 1;
 
 	case MI_BATCH_BUFFER_END:
-		drm_printf(p, "LRC[%#5lx]  =  [%#010x] MI_BATCH_BUFFER_END\n",
+		drm_printf(p, "LRC[%#5tx]  =  [%#010x] MI_BATCH_BUFFER_END\n",
 			   dw - start, inst_header);
 		/* Return 'remaining_dw' to consume the rest of the LRC */
 		return remaining_dw;
@@ -1943,35 +1943,35 @@ static int dump_mi_command(struct drm_printer *p,
 
 	switch (inst_header & MI_OPCODE) {
 	case MI_LOAD_REGISTER_IMM:
-		drm_printf(p, "LRC[%#5lx]  =  [%#010x] MI_LOAD_REGISTER_IMM: %d regs\n",
+		drm_printf(p, "LRC[%#5tx]  =  [%#010x] MI_LOAD_REGISTER_IMM: %d regs\n",
 			   dw - start, inst_header, (numdw - 1) / 2);
 		for (int i = 1; i < numdw; i += 2)
-			drm_printf(p, "LRC[%#5lx]  =  - %#6x = %#010x\n",
+			drm_printf(p, "LRC[%#5tx]  =  - %#6x = %#010x\n",
 				   &dw[i] - start, dw[i], dw[i + 1]);
 		return numdw;
 
 	case MI_LOAD_REGISTER_MEM & MI_OPCODE:
-		drm_printf(p, "LRC[%#5lx]  =  [%#010x] MI_LOAD_REGISTER_MEM: %s%s\n",
+		drm_printf(p, "LRC[%#5tx]  =  [%#010x] MI_LOAD_REGISTER_MEM: %s%s\n",
 			   dw - start, inst_header,
 			   dw[0] & MI_LRI_LRM_CS_MMIO ? "CS_MMIO " : "",
 			   dw[0] & MI_LRM_USE_GGTT ? "USE_GGTT " : "");
 		if (numdw == 4)
-			drm_printf(p, "LRC[%#5lx]  =  - %#6x = %#010llx\n",
+			drm_printf(p, "LRC[%#5tx]  =  - %#6x = %#010llx\n",
 				   dw - start,
 				   dw[1], ((u64)(dw[3]) << 32 | (u64)(dw[2])));
 		else
-			drm_printf(p, "LRC[%#5lx]  =  - %*ph (%s)\n",
+			drm_printf(p, "LRC[%#5tx]  =  - %*ph (%s)\n",
 				   dw - start, (int)sizeof(u32) * (numdw - 1),
 				   dw + 1, numdw < 4 ? "truncated" : "malformed");
 		return numdw;
 
 	case MI_FORCE_WAKEUP:
-		drm_printf(p, "LRC[%#5lx]  =  [%#010x] MI_FORCE_WAKEUP\n",
+		drm_printf(p, "LRC[%#5tx]  =  [%#010x] MI_FORCE_WAKEUP\n",
 			   dw - start, inst_header);
 		return numdw;
 
 	default:
-		drm_printf(p, "LRC[%#5lx]  =  [%#010x] unknown MI opcode %#x, likely %d dwords\n",
+		drm_printf(p, "LRC[%#5tx]  =  [%#010x] unknown MI opcode %#x, likely %d dwords\n",
 			   dw - start, inst_header, opcode, numdw);
 		return numdw;
 	}
@@ -1998,12 +1998,12 @@ static int dump_gfxpipe_command(struct drm_printer *p,
 	switch (*dw & GFXPIPE_MATCH_MASK) {
 #define MATCH(cmd) \
 	case cmd: \
-		drm_printf(p, "LRC[%#5lx]  =  [%#010x] " #cmd " (%d dwords)\n", \
+		drm_printf(p, "LRC[%#5tx]  =  [%#010x] " #cmd " (%d dwords)\n", \
 			   dw - start, *dw, numdw); \
 		return numdw
 #define MATCH3D(cmd) \
 	case CMD_##cmd: \
-		drm_printf(p, "LRC[%#5lx]  =  [%#010x] " #cmd " (%d dwords)\n", \
+		drm_printf(p, "LRC[%#5tx]  =  [%#010x] " #cmd " (%d dwords)\n", \
 			   dw - start, *dw, numdw); \
 		return numdw
 
@@ -2136,7 +2136,7 @@ static int dump_gfxpipe_command(struct drm_printer *p,
 	MATCH3D(3DSTATE_SLICE_TABLE_STATE_POINTER_2);
 
 	default:
-		drm_printf(p, "LRC[%#5lx]  =  [%#010x] unknown GFXPIPE command (pipeline=%#x, opcode=%#x, subopcode=%#x), likely %d dwords\n",
+		drm_printf(p, "LRC[%#5tx]  =  [%#010x] unknown GFXPIPE command (pipeline=%#x, opcode=%#x, subopcode=%#x), likely %d dwords\n",
 			   dw - start, *dw, pipeline, opcode, subopcode, numdw);
 		return numdw;
 	}
@@ -2162,7 +2162,7 @@ static int dump_gfx_state_command(struct drm_printer *p,
 	MATCH(STATE_WRITE_INLINE);
 
 	default:
-		drm_printf(p, "LRC[%#5lx]  =  [%#010x] unknown GFX_STATE command (opcode=%#x), likely %d dwords\n",
+		drm_printf(p, "LRC[%#5tx]  =  [%#010x] unknown GFX_STATE command (opcode=%#x), likely %d dwords\n",
 			   dw - start, *dw, opcode, numdw);
 		return numdw;
 	}
@@ -2197,7 +2197,7 @@ void xe_lrc_dump_default(struct drm_printer *p,
 			num_dw = dump_gfx_state_command(p, gt, start, dw, remaining_dw);
 		} else {
 			num_dw = min(instr_dw(*dw), remaining_dw);
-			drm_printf(p, "LRC[%#5lx]  =  [%#10x] Unknown instruction of type %#x, likely %d dwords\n",
+			drm_printf(p, "LRC[%#5tx]  =  [%#10x] Unknown instruction of type %#x, likely %d dwords\n",
 				   dw - start,
 				   *dw, REG_FIELD_GET(XE_INSTR_CMD_TYPE, *dw),
 				   num_dw);

---
base-commit: 1b12096b4bc5177d685ae098fdb90260ffd5db6b
change-id: 20260316-drm-xe-fix-32-bit-wformat-ptrdiff-a5f4f8483ec3

Best regards,
--  
Nathan Chancellor <nathan@kernel.org>

