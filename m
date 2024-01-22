Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB027768F6;
	Tue, 23 Jan 2024 02:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975525; cv=none; b=Ajphi1Oww5xN0JHfc9K0QVRNcn6Z2duFaq4LSsglfIVg+Ix5zEaO4v7znJ7LBuXjtAQh8raXD2cKGcJb50XhvN1foErhqVSxCEwdKVop2K6yyKU8As0m67EUXetKty4pFFbTCz2zjVYwkfSXFTPaaEXRnW24tXpjs1N2+MP4gqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975525; c=relaxed/simple;
	bh=fo2vU9AhyqXp96PfCJpVb1SchcBHK7sEgiUpbmhb5kw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P2FwVVSMbISrbmAa/u0SBu0tHaqV1Aofc9pobqwipVAWrNSZc73hsAk618X/wYlB0EIiWGnHWLT0UQZl3baQHOt+y9yCDu1uBsawWCl5Bv7fGoxQ8WDT0z70HX+NbaVv0LNLmDtBzH1iv1op3WR5QgZ1NXY3UKBvkId/vGzk8ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uKfJ9uNU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uKfJ9uNU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8126FC43390;
	Tue, 23 Jan 2024 02:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975525;
	bh=fo2vU9AhyqXp96PfCJpVb1SchcBHK7sEgiUpbmhb5kw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uKfJ9uNUD2vHOzJDkUSDc36M3WZByTqHKhgHaqGeENdC4xJMqVgfgUWbekrq6DSbh
	 b6DHoAfuZjU5R5EoNUAaPC5rHaLYeYz3xeIr3vDyDjgcQWtC1fWIZNo67yq1rVgxUN
	 8M8vUvbR1RxEdWuEw7h2QeF0+NCvJOdxH9Jyh5zw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Mengmeng <zhaomengmeng@kylinos.cn>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 478/583] selftests/sgx: Skip non X86_64 platform
Date: Mon, 22 Jan 2024 15:58:49 -0800
Message-ID: <20240122235826.613178835@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

From: Zhao Mengmeng <zhaomengmeng@kylinos.cn>

[ Upstream commit 981cf568a8644161c2f15c02278ebc2834b51ba6 ]

When building whole selftests on arm64, rsync gives an erorr about sgx:

rsync: [sender] link_stat "/root/linux-next/tools/testing/selftests/sgx/test_encl.elf" failed: No such file or directory (2)
rsync error: some files/attrs were not transferred (see previous errors) (code 23) at main.c(1327) [sender=3.2.5]

The root casue is sgx only used on X86_64, and shall be skipped on other
platforms.

Fix this by moving TEST_CUSTOM_PROGS and TEST_FILES inside the if check,
then the build result will be "Skipping non-existent dir: sgx".

Fixes: 2adcba79e69d ("selftests/x86: Add a selftest for SGX")
Signed-off-by: Zhao Mengmeng <zhaomengmeng@kylinos.cn>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Link: https://lore.kernel.org/all/20231206025605.3965302-1-zhaomzhao%40126.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/sgx/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/sgx/Makefile b/tools/testing/selftests/sgx/Makefile
index 50aab6b57da3..01abe4969b0f 100644
--- a/tools/testing/selftests/sgx/Makefile
+++ b/tools/testing/selftests/sgx/Makefile
@@ -16,10 +16,10 @@ HOST_CFLAGS := -Wall -Werror -g $(INCLUDES) -fPIC -z noexecstack
 ENCL_CFLAGS := -Wall -Werror -static -nostdlib -nostartfiles -fPIC \
 	       -fno-stack-protector -mrdrnd $(INCLUDES)
 
+ifeq ($(CAN_BUILD_X86_64), 1)
 TEST_CUSTOM_PROGS := $(OUTPUT)/test_sgx
 TEST_FILES := $(OUTPUT)/test_encl.elf
 
-ifeq ($(CAN_BUILD_X86_64), 1)
 all: $(TEST_CUSTOM_PROGS) $(OUTPUT)/test_encl.elf
 endif
 
-- 
2.43.0



