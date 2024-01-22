Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A03F4133435;
	Tue, 23 Jan 2024 01:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971912; cv=none; b=XFUAj1OltU5TEd1xo4UvE0y5DID4/x5xrO9RdB0AiBL+Aprn3viE0HvsS2Bl46cSnpsHUTpIZgxp0PhDWIV9KxunldKtauMvK5ONRfaqV/0QSXVUd5Qm9kdjrKaOtj9FGPrE5ek/2wGpfyUmYMuwuEO2e+HjZWO5x4269zWWsJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971912; c=relaxed/simple;
	bh=hq+um1bShNeq/CAos+r8p4bAdROYd5fczq7BdPSsQ8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nJP1cCouPPeMeMkc89cPp7jogNQaKzEuxGaM/252r+uaHDEvR5GRbbAIE3MEmav7bj+iaqSo5Eudzpx7DrgP07YZ3UgOyCru7oyhPbJeKELq9Y9+QBvRBniF1+ZBZm6RlEoAn0f1lMZwCvtbXkv3F1pGUG900+xvgYkrF/RpRWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EZKFboyb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EZKFboyb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07ED1C433C7;
	Tue, 23 Jan 2024 01:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971912;
	bh=hq+um1bShNeq/CAos+r8p4bAdROYd5fczq7BdPSsQ8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EZKFboyb+BwxB5vOwZNUENSGpIVVWCx9X1ClODZR2UECcAEezhR/RrQ1L57qAYrCG
	 0gQhUw9hh+3/AAliaNNA5tRI9tU+fYa+0ReFeYVFZJ06OjRxFzPls+ycO0CvMSusmQ
	 GKP5XrsNp5GMR8zP650fLVbzrdRmiVx2XWtWLZvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Mengmeng <zhaomengmeng@kylinos.cn>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 349/417] selftests/sgx: Skip non X86_64 platform
Date: Mon, 22 Jan 2024 15:58:37 -0800
Message-ID: <20240122235803.879859062@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 75af864e07b6..04ee17d3d394 100644
--- a/tools/testing/selftests/sgx/Makefile
+++ b/tools/testing/selftests/sgx/Makefile
@@ -16,9 +16,9 @@ HOST_CFLAGS := -Wall -Werror -g $(INCLUDES) -fPIC -z noexecstack
 ENCL_CFLAGS := -Wall -Werror -static -nostdlib -nostartfiles -fPIC \
 	       -fno-stack-protector -mrdrnd $(INCLUDES)
 
+ifeq ($(CAN_BUILD_X86_64), 1)
 TEST_CUSTOM_PROGS := $(OUTPUT)/test_sgx
 
-ifeq ($(CAN_BUILD_X86_64), 1)
 all: $(TEST_CUSTOM_PROGS) $(OUTPUT)/test_encl.elf
 endif
 
-- 
2.43.0



