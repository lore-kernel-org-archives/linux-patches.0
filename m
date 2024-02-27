Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 277C613B2BA;
	Tue, 27 Feb 2024 13:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040556; cv=none; b=Ar3Rgc8R5O953zEEoMXUVqwkHWVE4WVDR6VJr5zWZJkQIoAkXCG/IKTfvc76IV3I3JnhWYTgxXpJKVh6e0zHF7tow5AAR3OWWM+nGYeqjlhb3wZs2iNUeSUoT1UTUitfykCB+P0FnkWvfYZwLPXyyzWngffgxsXrKG0cMOhU16I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040556; c=relaxed/simple;
	bh=tq/DN3BaShDobhpFDqetOVXp2j7iZBYowLKSgVY8WQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b/YaFaiDJH/0MgFogVTDM331rjXuU/JavrlULGImu83BdMO674qZUzHIIf5UkN0YDYu/7JJy6b4/om21khJZQTyfwI+UNB8V0stCwWQIvM2P9wHqD6gT+aOGDQT/UGBM/V6myh5XwvL218Z8Hpvv/Ey1rm5qelecgs+VdlZgXUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1U59/gyY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1U59/gyY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA28CC43390;
	Tue, 27 Feb 2024 13:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040556;
	bh=tq/DN3BaShDobhpFDqetOVXp2j7iZBYowLKSgVY8WQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1U59/gyYsGHySVPzqo+Liy3mYrlHuEzNwuvM/rVrDEB+dD7C5yXj8TdR4ci/tH5s4
	 1iTNFzkx/yYingIoy+/Lj4IhLl57+VIdXNasQZKIsJHPgk0DfLHTGYRfK3xfC3v0eR
	 K95gxQ/mHJnKFUkwv4ldJCkuCiTheL9I9Niod3Q0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christoph=20M=C3=BCllner?= <christoph.muellner@vrull.eu>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 007/334] tools: selftests: riscv: Fix compile warnings in vector tests
Date: Tue, 27 Feb 2024 14:17:45 +0100
Message-ID: <20240227131630.871898496@linuxfoundation.org>
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



