Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AB9213B78A;
	Tue, 27 Feb 2024 13:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040553; cv=none; b=TKIMliTLDGLfZAKLmGbxluY5iTIPzEsK53duQG6FZIUf8QONxofW727G6FAn+zWmFMivl9Lb2lcG+aNQnYB52sy/Xah0oQrNCerxAgOLTJQmXDhZIxJUohZeX6oP86wZPP2ciya21Be5QZiTil4C33YVHDAmzYHMBGcNkOHhasU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040553; c=relaxed/simple;
	bh=QcUsJ7N1Ua0figC0lWXUNYPUzO9KPatVkjQvr17mzXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uvr+RCz2uzP5e/DRW4DRueZiZ7PWjtBZ7KPjMsFwOn+G+iJ2qoGM/+nnd1fVrt6QrEOHIvBy2bkHd8F7A5EyV96UFIsm1sfqvpDpAHYIm98C9PXkcbKW5LlmcByWCxecpOscKAPjo4iJv34CZiutZGmir6XHwbFdVKj58ih5IZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2iC4nOcf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2iC4nOcf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3794C43390;
	Tue, 27 Feb 2024 13:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040553;
	bh=QcUsJ7N1Ua0figC0lWXUNYPUzO9KPatVkjQvr17mzXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2iC4nOcfcVNiiFTJ68MCe1Dn96bNselgYhSbxxFdH7RnhRFirNIr4zfxkfQ5jDR58
	 9ymxsFmbgQiM/7f5GH96ybOW74aHYd0BUd5Yw/7nwPTdAQCW9pWz5G+lZOl0P0b11k
	 1crN/57jtixmu9zwbVVfoo3l7Kx6ZNY/5qdMh//c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christoph=20M=C3=BCllner?= <christoph.muellner@vrull.eu>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 006/334] tools: selftests: riscv: Fix compile warnings in cbo
Date: Tue, 27 Feb 2024 14:17:44 +0100
Message-ID: <20240227131630.841863226@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Müllner <christoph.muellner@vrull.eu>

[ Upstream commit ac7b2a02d62faff8c6d45bacb5cb9ea565b47776 ]

GCC prints a couple of format string warnings when compiling
the cbo test. Let's follow the recommendation in
Documentation/printk-formats.txt to fix these warnings.

Signed-off-by: Christoph Müllner <christoph.muellner@vrull.eu>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Link: https://lore.kernel.org/r/20231123185821.2272504-3-christoph.muellner@vrull.eu
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/riscv/hwprobe/cbo.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/riscv/hwprobe/cbo.c b/tools/testing/selftests/riscv/hwprobe/cbo.c
index c000942c80483..c537d52fafc58 100644
--- a/tools/testing/selftests/riscv/hwprobe/cbo.c
+++ b/tools/testing/selftests/riscv/hwprobe/cbo.c
@@ -95,7 +95,7 @@ static void test_zicboz(void *arg)
 	block_size = pair.value;
 	ksft_test_result(rc == 0 && pair.key == RISCV_HWPROBE_KEY_ZICBOZ_BLOCK_SIZE &&
 			 is_power_of_2(block_size), "Zicboz block size\n");
-	ksft_print_msg("Zicboz block size: %ld\n", block_size);
+	ksft_print_msg("Zicboz block size: %llu\n", block_size);
 
 	illegal_insn = false;
 	cbo_zero(&mem[block_size]);
@@ -119,7 +119,7 @@ static void test_zicboz(void *arg)
 		for (j = 0; j < block_size; ++j) {
 			if (mem[i * block_size + j] != expected) {
 				ksft_test_result_fail("cbo.zero check\n");
-				ksft_print_msg("cbo.zero check: mem[%d] != 0x%x\n",
+				ksft_print_msg("cbo.zero check: mem[%llu] != 0x%x\n",
 					       i * block_size + j, expected);
 				return;
 			}
@@ -199,7 +199,7 @@ int main(int argc, char **argv)
 	pair.key = RISCV_HWPROBE_KEY_IMA_EXT_0;
 	rc = riscv_hwprobe(&pair, 1, sizeof(cpu_set_t), (unsigned long *)&cpus, 0);
 	if (rc < 0)
-		ksft_exit_fail_msg("hwprobe() failed with %d\n", rc);
+		ksft_exit_fail_msg("hwprobe() failed with %ld\n", rc);
 	assert(rc == 0 && pair.key == RISCV_HWPROBE_KEY_IMA_EXT_0);
 
 	if (pair.value & RISCV_HWPROBE_EXT_ZICBOZ) {
-- 
2.43.0



