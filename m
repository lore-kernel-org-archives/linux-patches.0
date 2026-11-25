Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620993;
	b=M1oM4D8XN1g0eMq6LNyDcK8zkithu8+VZlD41pjHdr9f12kgpgqhI83M0Oib54xhxEV7
	 0MRnWz1s35dyoCfjy3gWE78NWh8pRTYz1PPyqzuO9kZwU8R2anjGtgQF/WrPLUAkdeElE
	 raEoPcpzvLCtPCy+AgGKlD9DMSPOMb7qTueVBFoWn7G68oWGo2MzV7yseV3o+fgHoOn64
	 9bW1LIF65DdGGUL+4CJNGAPK9u7HT2qx1oS/U2qQYpYBtjDlouxsLp3DjsO1YCAk4zBct
	 911RyVGfh9Zr+rCxCf8KQ+klFTcZ0uuWjbhH1Li7AU9BR1AwwENaiOe1SI+69mYcTtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620993;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YlWJwVTrV9Q/5cOZAFrBlLV+budQhEcOZe0QZ4OttWE=;
	b=dYRGHS3NX1jJB/dXu/l9YBui1Y3NmBHshtCCa+W2JEAg0bRa/mEuaMv7w3udiN06VR1g
	 T6uHLTWcUD/+sy7AyOMNTP/P7PrgBbm1Xw/PMPRu3UtQB+HsuSJxVvNqD61XH2CJgEHWW
	 SWMI2Ik2Ua3B2bl703aVwA7r9ZkYryb0s9ldW5/vZk0IYmUzMdkxwgg/NlrQ6yna28Nsg
	 53MKQ35CbwJDQ6Y5OlnFwgaX9k1Oh34CU3Fu1YPQ1PLqG63e5fn/01G1wr4a51fx5e6OM
	 lkOFyebUTZoIzuimvFPKsS9dYbd2Uf6veiyBzzA/KKK5bBc1/GhDalZ2nX8zg2RAsIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AqTPCBBU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4557C607DE6C;
	Wed, 25 Nov 2026 15:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AqTPCBBU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60B581F00A00;
	Wed, 25 Nov 2026 15:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620992;
	bh=YlWJwVTrV9Q/5cOZAFrBlLV+budQhEcOZe0QZ4OttWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AqTPCBBUvo9PdIpozCXWof/o75MY7XOJ7Xwfgl6Vg6XauK5R3k/nMZKnFIlJMr3ZL
	 /R/5wx408LosOmRIJcHdHRlNUGutal+Ha3fhb+m/m4tzoEL7iZFCnG0K49cP7SmERq
	 3xCMo/N1aSBShCXKYpIa0OjL5u/Idq58VaB3Eu8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	"Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 087/990] bpf: Fix jited line info off by the CFI preamble
Date: Wed, 25 Nov 2026 15:24:14 +0100
Message-ID: <20261125143824.130880276@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Jose Fernandez (Anthropic) <jose.fernandez@linux.dev>

[ Upstream commit 3e4279dc5144a5afcda101df23792b13e94c3859 ]

With CONFIG_CFI=y, every jited line info entry after a function's
first is cfi_get_offset() bytes too high on x86-64, riscv64 and arm64,
so tools that use it show the wrong source line.

The JITs count the insn_to_jit_off[] offsets from the start of the
image. Since the CFI commits below, prog->bpf_func starts
cfi_get_offset() bytes into the image, and bpf_prog_fill_jited_linfo()
adds the offsets to prog->bpf_func. s390 corrects its offsets before
the call, the other three JITs do not.

Subtract cfi_get_offset() once in bpf_prog_fill_jited_linfo() and drop
the s390 correction. jited_linfo[0] stays prog->bpf_func, the
function's ksym address. Without CONFIG_CFI, cfi_get_offset() is 0 and
nothing changes.

Fixes: 4f9087f16651 ("x86/cfi,bpf: Fix BPF JIT call")
Fixes: e63985ecd226 ("bpf, riscv64/cfi: Support kCFI + BPF on riscv64")
Fixes: 710618c760c0 ("arm64/cfi,bpf: Support kCFI + BPF on arm64")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Reported-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Jose Fernandez (Anthropic) <jose.fernandez@linux.dev>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261030-b4-arm64-bpf-linfo-cfi-v2-1-4eac83435d4b@linux.dev
Closes: https://lore.kernel.org/all/20260904014748.C04AA1F000E9@smtp.kernel.org/
Closes: https://lore.kernel.org/all/DLNXZ2WK7TPD.2RZBUNRS4FA4L@gmail.com/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/core.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 346588a32a854..bbd0f1ebd2d3c 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -206,7 +206,9 @@ void bpf_prog_jit_attempt_done(struct bpf_prog *prog)
  * here is relative to the prog itself instead of the main prog.
  * This array has one entry for each xlated bpf insn.
  *
- * jited_off is the byte off to the end of the jited insn.
+ * jited_off is the byte off to the end of the jited insn, counted from
+ * the start of the jited image, which is cfi_get_offset() bytes before
+ * prog->bpf_func.
  *
  * Hence, with
  * insn_start:
@@ -220,7 +222,7 @@ void bpf_prog_jit_attempt_done(struct bpf_prog *prog)
  *
  * For i > linfo_idx,
  *
- * jited_linfo[i] = prog->bpf_func +
+ * jited_linfo[i] = prog->bpf_func - cfi_get_offset() +
  *	insn_to_jit_off[linfo[i].insn_off - insn_start - 1]
  */
 void bpf_prog_fill_jited_linfo(struct bpf_prog *prog,
@@ -248,7 +250,7 @@ void bpf_prog_fill_jited_linfo(struct bpf_prog *prog,
 		/* The verifier ensures that linfo[i].insn_off is
 		 * strictly increasing
 		 */
-		jited_linfo[i] = prog->bpf_func +
+		jited_linfo[i] = prog->bpf_func - cfi_get_offset() +
 			insn_to_jit_off[linfo[i].insn_off - insn_start - 1];
 }
 
-- 
2.53.0



