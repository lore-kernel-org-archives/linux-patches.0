Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B5348615A;
	Tue, 17 Dec 2024 17:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456259; cv=none; b=g8BbkzfUsnaKUeGvC9jsfcybNs9DRSvKH7mJtu6FiDdvfZzlZWdoqdIBRzKFN0w2cNHJ1hIFHoeT4zBCJR5Jx1+EDpZQGTo+40es2zaOyi2g1TjHA7qu6N3N/GlSLERSXKlnuqySdLUWqcSRFCmHaqP8U/tAsqBeWoXoz72Ll1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456259; c=relaxed/simple;
	bh=X6WMRdyizDCDzs/xFtI0hHucoTuCVA2dNQP2DC+vzuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YTP+/ygRACMtmRv9NJd7fu3ANcdnxOTq4Yuvxs1UXas2QW5HQHWbqWLfNrDrJwV1ztPDzGLwPC17AiwPQyYISkwT47so9zKtstshz5T28oUr1moMFFnlSCNwzIfLvHlQjgEoU1GUEZcwccoaqDStjzE6Qcl0qoiB/j1I5FnvQnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Lk1d50S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Lk1d50S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 855A2C4CEDD;
	Tue, 17 Dec 2024 17:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456258;
	bh=X6WMRdyizDCDzs/xFtI0hHucoTuCVA2dNQP2DC+vzuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1Lk1d50SbsVc2BW8IOqdNwJxs5B2WAPFIiXF7Z5b+lus9y76N3tr/H0HHnrEBn13/
	 Xt7Ah2wrBBR8Na9F64svLQrAxX4dMnrlNl+eyj+ri1DihcWpAAniFDvuCGiml1OnYu
	 3xB3ev/bFPaRVwYtemocnNw/D0taLXoNYqBodFZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	"stable@vger.kernel.org, Sasha Levin" <sashal@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eduard Zingerman <eddyz87@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>
Subject: [PATCH 6.6 099/109] selftests/bpf: remove use of __xlated()
Date: Tue, 17 Dec 2024 18:08:23 +0100
Message-ID: <20241217170537.522869858@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170533.329523616@linuxfoundation.org>
References: <20241217170533.329523616@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Shung-Hsi Yu <shung-hsi.yu@suse.com>

Commit 68ec5395bc24, backport of mainline commit a41b3828ec05 ("selftests/bpf:
Verify that sync_linked_regs preserves subreg_def") uses the __xlated() that
wasn't in the v6.6 code-base, and causes BPF selftests to fail compilation.

Remove the use of the __xlated() macro in
tools/testing/selftests/bpf/progs/verifier_scalar_ids.c to fix compilation
failure. Without the __xlated() checks the coverage is reduced, however the
test case still functions just fine.

Fixes: 68ec5395bc24 ("selftests/bpf: Verify that sync_linked_regs preserves subreg_def")
Cc: Eduard Zingerman <eddyz87@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/progs/verifier_scalar_ids.c |   16 ----------------
 1 file changed, 16 deletions(-)

--- a/tools/testing/selftests/bpf/progs/verifier_scalar_ids.c
+++ b/tools/testing/selftests/bpf/progs/verifier_scalar_ids.c
@@ -682,22 +682,6 @@ __msg("from 3 to 4")
 __msg("4: (77) r1 >>= 32                     ; R1_w=0")
 __msg("5: (bf) r0 = r1                       ; R0_w=0 R1_w=0")
 __msg("6: (95) exit")
-/* Verify that statements to randomize upper half of r1 had not been
- * generated.
- */
-__xlated("call unknown")
-__xlated("r0 &= 2147483647")
-__xlated("w1 = w0")
-/* This is how disasm.c prints BPF_ZEXT_REG at the moment, x86 and arm
- * are the only CI archs that do not need zero extension for subregs.
- */
-#if !defined(__TARGET_ARCH_x86) && !defined(__TARGET_ARCH_arm64)
-__xlated("w1 = w1")
-#endif
-__xlated("if w0 < 0xa goto pc+0")
-__xlated("r1 >>= 32")
-__xlated("r0 = r1")
-__xlated("exit")
 __naked void linked_regs_and_subreg_def(void)
 {
 	asm volatile (


