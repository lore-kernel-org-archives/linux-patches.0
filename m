Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC71B481DD;
	Mon,  4 Aug 2025 00:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754267032; cv=none; b=W8WdEN28BngQcAMHsBlO31KfCW3X5it3xn/XZh5AotJm7uC2nxfxAuHi2lk5pwjDK0oU4dt/wUDACvvUC0Lit/rsXqz0xSmzHelSHfCv4+ooFjDOxfnWxupT+U5CXwUMfNdd1dFpxC0cYVleAePzM8IyBWIc4GQoccJ09TvGeBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754267032; c=relaxed/simple;
	bh=k3GEGDOOa0AgPbMBKM3Bez/wll+kW5k1UWqNHwMV5WM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=i8062OsSGpaGXirD9ZFmag+XRw9qCGFYRLsXDSfXbSDJe20ljoidpYx85DeGnFh1FBozyOZ2kmo0zugciSxsBlkhA++ZYXulYRYh44KBJ6onSSBiGlND3C4CgDh7WeR9peAur4zkxBl7div6jpLhlk7GSGL84JJZCiQbmNFj3xI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iNjYUYSB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iNjYUYSB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08AD6C4CEEB;
	Mon,  4 Aug 2025 00:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754267032;
	bh=k3GEGDOOa0AgPbMBKM3Bez/wll+kW5k1UWqNHwMV5WM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iNjYUYSB0AMXl9Eaj6XYLzdbcqo0AXWgORZ1/stnyPI6/cvOgNPAnYwp9clpd9ord
	 7JJ/HEV48AiR4Txfs65ik0dZkioGnCCFI9LvuNJlIxJgLXe3h6GN1cq4KzMR/tJFPt
	 6C4VCMcoXiXrLon+R12PTBs5oq91eq81OUhkQ82SK8jZKWvkUJSE36FE2OB94Hovpk
	 mmnO93BobRfl4WYlr2JnDIMTouxu/saTN7aAqoxVHURA/xSfYSkR5nKowYDAs+7x4q
	 vwQvWG1X7nlvXaVj/7y9pmO1rLmwjeMjm5vRtZDV5kc63b3ProwOKkQHjgrmqbKrG9
	 za82kOaI0492g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Moon Hee Lee <moonhee.lee.ca@gmail.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Baoquan He <bhe@redhat.com>,
	David Woodhouse <dwmw@amazon.co.uk>,
	Sasha Levin <sashal@kernel.org>,
	mingo@kernel.org
Subject: [PATCH AUTOSEL 6.16 03/85] selftests/kexec: fix test_kexec_jump build
Date: Sun,  3 Aug 2025 20:22:12 -0400
Message-Id: <20250804002335.3613254-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250804002335.3613254-1-sashal@kernel.org>
References: <20250804002335.3613254-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
Content-Transfer-Encoding: 8bit

From: Moon Hee Lee <moonhee.lee.ca@gmail.com>

[ Upstream commit 661e9cd196598c7d2502260ebbe60970546cca35 ]

The test_kexec_jump program builds correctly when invoked from the top-level
selftests/Makefile, which explicitly sets the OUTPUT variable. However,
building directly in tools/testing/selftests/kexec fails with:

  make: *** No rule to make target '/test_kexec_jump', needed by 'test_kexec_jump.sh'.  Stop.

This failure occurs because the Makefile rule relies on $(OUTPUT), which is
undefined in direct builds.

Fix this by listing test_kexec_jump in TEST_GEN_PROGS, the standard way to
declare generated test binaries in the kselftest framework. This ensures the
binary is built regardless of invocation context and properly removed by
make clean.

Link: https://lore.kernel.org/r/20250702171704.22559-2-moonhee.lee.ca@gmail.com
Acked-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Moon Hee Lee <moonhee.lee.ca@gmail.com>
Acked-by: Baoquan He <bhe@redhat.com>
Acked-by: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Perfect! This confirms the exact build issue described in the commit
message. The problem is that `$(OUTPUT)` is undefined when building
directly in the kexec directory.

**Backport Status: YES**

This commit should be backported to stable kernel trees for the
following reasons:

1. **Fixes a real bug**: The commit fixes a build failure that prevents
   the kexec selftests from building when invoked directly from
   `tools/testing/selftests/kexec/`. The error message confirms this:
   `make: *** No rule to make target '/test_kexec_jump', needed by
   'test_kexec_jump.sh'. Stop.`

2. **Small and contained fix**: The change is minimal - it simply
   replaces the custom Makefile rule:
  ```makefile
  test_kexec_jump.sh: $(OUTPUT)/test_kexec_jump
  ```
  with the standard kselftest framework approach:
  ```makefile
  TEST_GEN_PROGS := test_kexec_jump
  ```

3. **No architectural changes**: This is purely a build system fix that
   doesn't change any kernel functionality or introduce new features. It
   just fixes the Makefile to use the standard kselftest variables.

4. **Minimal risk**: The change uses the established kselftest framework
   pattern (`TEST_GEN_PROGS`) which is well-tested and widely used
   throughout the kernel selftests. From examining `lib.mk`, we can see
   that `TEST_GEN_PROGS` automatically handles the `$(OUTPUT)` prefix
   and proper clean targets.

5. **Fixes testing infrastructure**: Having working selftests is
   important for kernel stability testing. This fix ensures that the
   kexec jump functionality can be properly tested in stable kernels,
   which is particularly important given that kexec is a critical
   feature for system reliability.

6. **Clear regression**: The bug prevents a previously working test from
   building in certain scenarios. While the test builds correctly when
   invoked from the top-level selftests Makefile (which sets OUTPUT),
   direct builds fail. This is a regression in usability that affects
   developers and CI systems.

The fix follows the documented pattern for kselftest Makefiles and will
ensure consistent behavior regardless of how the tests are invoked. This
is exactly the type of targeted bug fix that belongs in stable kernels -
it fixes a specific issue without introducing new functionality or risk.

 tools/testing/selftests/kexec/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kexec/Makefile b/tools/testing/selftests/kexec/Makefile
index e3000ccb9a5d..874cfdd3b75b 100644
--- a/tools/testing/selftests/kexec/Makefile
+++ b/tools/testing/selftests/kexec/Makefile
@@ -12,7 +12,7 @@ include ../../../scripts/Makefile.arch
 
 ifeq ($(IS_64_BIT)$(ARCH_PROCESSED),1x86)
 TEST_PROGS += test_kexec_jump.sh
-test_kexec_jump.sh: $(OUTPUT)/test_kexec_jump
+TEST_GEN_PROGS := test_kexec_jump
 endif
 
 include ../lib.mk
-- 
2.39.5

