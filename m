Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75E9F1420DE;
	Tue, 27 Feb 2024 13:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041687; cv=none; b=HJsELgFN7UnyDmm8q4b2v8V21o/cky4rHXdYO5pMO+ODcc/6TYY/AwE2dmbI2uOggYa5xtdZWCwIvaUG/sJQhOvZ6g9O10PTjKu8jxomFG42nMN4Kaa1BNhWB6kk2y30mVmM+UgHFrlXXhSgDLbn9kEcCXMM/RrA0p6FUM+YhJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041687; c=relaxed/simple;
	bh=wvAaclIUPMbZdkw+FdEQ/DbxI61Jd4z2gCJV3qI6sqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VzYtupPFdEDztY6HAtwrrd1nOZ+9c8r5sT+jY09ZOpZMsRl3eZ55/WOlplBvHJ/gg7v1jGSmPMeaU7/gEMQk1h33D3bDVMjN7fFvLN8iPfaXt/nUdDCX4cRww/4rPEQiKCo/GIyVJ7TIiULiNjgYW+Uku8diABxVtAphUoU8Ijo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GCFRp2CQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GCFRp2CQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0121DC433C7;
	Tue, 27 Feb 2024 13:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041687;
	bh=wvAaclIUPMbZdkw+FdEQ/DbxI61Jd4z2gCJV3qI6sqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GCFRp2CQkAqr0clAq2QrQrPdd5qhP6aMr+t4e72wlpryDaMhY4C2En2onam+ZHuFp
	 TQ48ogcZaYM0zxQhtNaGkI3398Gut4bpADYiW9Ufs2euQ9z7neHoTkxoPksexIvymE
	 Q1WCOChaKc7m/WnKJAkqTU6Jb5JNPeftuA/QxV0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christoph=20M=C3=BCllner?= <christoph.muellner@vrull.eu>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 007/299] tools: selftests: riscv: Fix compile warnings in vector tests
Date: Tue, 27 Feb 2024 14:21:58 +0100
Message-ID: <20240227131626.080301657@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Müllner <christoph.muellner@vrull.eu>

[ Upstream commit e1baf5e68ed128c1e22ba43e5190526d85de323c ]

GCC prints a couple of format string warnings when compiling
the vector tests. Let's follow the recommendation in
Documentation/printk-formats.txt to fix these warnings.

Signed-off-by: Christoph Müllner <christoph.muellner@vrull.eu>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Link: https://lore.kernel.org/r/20231123185821.2272504-5-christoph.muellner@vrull.eu
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/riscv/vector/v_initval_nolibc.c | 2 +-
 tools/testing/selftests/riscv/vector/vstate_prctl.c     | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/riscv/vector/v_initval_nolibc.c b/tools/testing/selftests/riscv/vector/v_initval_nolibc.c
index 66764edb0d526..1dd94197da30c 100644
--- a/tools/testing/selftests/riscv/vector/v_initval_nolibc.c
+++ b/tools/testing/selftests/riscv/vector/v_initval_nolibc.c
@@ -27,7 +27,7 @@ int main(void)
 
 	datap = malloc(MAX_VSIZE);
 	if (!datap) {
-		ksft_test_result_fail("fail to allocate memory for size = %lu\n", MAX_VSIZE);
+		ksft_test_result_fail("fail to allocate memory for size = %d\n", MAX_VSIZE);
 		exit(-1);
 	}
 
diff --git a/tools/testing/selftests/riscv/vector/vstate_prctl.c b/tools/testing/selftests/riscv/vector/vstate_prctl.c
index b348b475be570..8ad94e08ff4d0 100644
--- a/tools/testing/selftests/riscv/vector/vstate_prctl.c
+++ b/tools/testing/selftests/riscv/vector/vstate_prctl.c
@@ -68,7 +68,7 @@ int test_and_compare_child(long provided, long expected, int inherit)
 	}
 	rc = launch_test(inherit);
 	if (rc != expected) {
-		ksft_test_result_fail("Test failed, check %d != %d\n", rc,
+		ksft_test_result_fail("Test failed, check %d != %ld\n", rc,
 				      expected);
 		return -2;
 	}
@@ -87,7 +87,7 @@ int main(void)
 	pair.key = RISCV_HWPROBE_KEY_IMA_EXT_0;
 	rc = riscv_hwprobe(&pair, 1, 0, NULL, 0);
 	if (rc < 0) {
-		ksft_test_result_fail("hwprobe() failed with %d\n", rc);
+		ksft_test_result_fail("hwprobe() failed with %ld\n", rc);
 		return -1;
 	}
 
-- 
2.43.0



