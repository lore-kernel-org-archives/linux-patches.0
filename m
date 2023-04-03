Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB6186FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:27:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61941C433EF;
	Mon,  3 Apr 2023 14:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680532047;
	bh=yp91ujsK4BdIaTx2bsm4I3nm8NlRmWZ6+FhQw/7CL7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dRkin9JKzo2xAMWrTOPrnieJEJeWbJ0kap+b31/Y+xyL65gNf+JF4mhDc5MVVKvvV
	 hYVnQpzC2zZFy4/rPxAFBzVqT/6Zt8vVD0wdp0Ct3qztWxcRxwfWgphGnlGdHMHHO5
	 Vcu2ej+jsqJte6/FIpFTSbvhClLGBN2bwkUKWYf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anders Roxell <anders.roxell@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Marco Elver <elver@google.com>,
	David Gow <davidgow@google.com>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Kees Cook <keescook@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 106/173] kernel: kcsan: kcsan_test: build without structleak plugin
Date: Mon,  3 Apr 2023 16:08:41 +0200
Message-Id: <20230403140417.872610004@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140414.174516815@linuxfoundation.org>
References: <20230403140414.174516815@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Anders Roxell <anders.roxell@linaro.org>

[ Upstream commit 6fcd4267a840d0536b8e5334ad5f31e4105fce85 ]

Building kcsan_test with structleak plugin enabled makes the stack frame
size to grow.

kernel/kcsan/kcsan_test.c:704:1: error: the frame size of 3296 bytes is larger than 2048 bytes [-Werror=frame-larger-than=]

Turn off the structleak plugin checks for kcsan_test.

Link: https://lkml.kernel.org/r/20221128104358.2660634-1-anders.roxell@linaro.org
Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Marco Elver <elver@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: David Gow <davidgow@google.com>
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 5eb39cde1e24 ("kcsan: avoid passing -g for test")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/kcsan/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/kcsan/Makefile b/kernel/kcsan/Makefile
index 65ca5539c470e..c95957741d366 100644
--- a/kernel/kcsan/Makefile
+++ b/kernel/kcsan/Makefile
@@ -14,4 +14,5 @@ obj-y := core.o debugfs.o report.o
 obj-$(CONFIG_KCSAN_SELFTEST) += selftest.o
 
 CFLAGS_kcsan-test.o := $(CFLAGS_KCSAN) -g -fno-omit-frame-pointer
+CFLAGS_kcsan_test.o += $(DISABLE_STRUCTLEAK_PLUGIN)
 obj-$(CONFIG_KCSAN_TEST) += kcsan-test.o
-- 
2.39.2



