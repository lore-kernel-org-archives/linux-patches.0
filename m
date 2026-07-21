Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCDAD3B47DF;
	Tue, 21 Jul 2026 20:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666864; cv=none; b=nXxxlY9TOQ07RsBaVVd9j9C2NxclEBfBe1Fj7NqPv4ITw5kZMMngMQDMv6IhX1BBADX8PtB0HVTt+nID+UXpuTftUd1r04hbq3+IYkDwJwuNOaLTdkEsySfRbXwKvGm4JgcDpCgooUs9wbeTRJjFs97ndYSJIlYKeYk3082zXtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666864; c=relaxed/simple;
	bh=VdWbib34uYOGVCL8hMl8NU7gEFFkqSn3l79buxIyFRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E2XtX31vOl0vJrJVil+Wu59o2afolhYnAuqAwjbGHqGspCboB10CVEyKfGOy3Qy5lDEMyCZIlPtvjtluqwJA1+DipB3CkgqdtbF8WO1ehkjlosvVa9A8sw3n5HL1JdC6xnuXSWGzD0Odzs41newEmLfmssmaO5R4aWxy8hAzYq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LNQdjv9/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LNQdjv9/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 307361F000E9;
	Tue, 21 Jul 2026 20:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666863;
	bh=YFzPoEuO/mkjZXbloobWTvpjr0HHyfj+PsX0snIlRE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LNQdjv9/kEopPmSjXBFjBGokQkqMJ588DnSDNgXs7DOzYlC6K66ePtKZWJ2fUbpwO
	 ohkVBLkWBOt7hLfLVv7jBLX7+rgG/tk8iPFON6rOwd86Z9VXlvyq8gz1NqGvZOfTCF
	 SyKKl4F2NvTGM199u4OFPnLQGbwnrb7i7Ayo1Mu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Stitt <justinstitt@google.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>
Subject: [PATCH 6.6 0845/1266] selftests/hid: force using our compiled libbpf headers
Date: Tue, 21 Jul 2026 17:21:22 +0200
Message-ID: <20260721152500.766127792@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Benjamin Tissoires <bentiss@kernel.org>

[ Upstream commit 91939636cac4585e5c99a15c8b9023e0dcabb4e5 ]

Turns out that we were relying on the globally installed headers, not
the ones we freshly compiled.
Add a manual include in CFLAGS to sort this out.

Tested-by: Nick Desaulniers <ndesaulniers@google.com> # Build
Tested-by: Justin Stitt <justinstitt@google.com>
Link: https://lore.kernel.org/r/20230825-wip-selftests-v3-3-639963c54109@kernel.org
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Stable-dep-of: eebbef7c468a ("selftests/hid: Cover hid_bpf_get_data() size overflow")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/hid/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/hid/Makefile b/tools/testing/selftests/hid/Makefile
index dc4f4cc35e5ad5..748e0c79a27dad 100644
--- a/tools/testing/selftests/hid/Makefile
+++ b/tools/testing/selftests/hid/Makefile
@@ -25,6 +25,8 @@ CXX ?= $(CROSS_COMPILE)g++
 HOSTPKG_CONFIG := pkg-config
 
 CFLAGS += -g -O0 -rdynamic -Wall -Werror -I$(OUTPUT)
+CFLAGS += -I$(OUTPUT)/tools/include
+
 LDLIBS += -lelf -lz -lrt -lpthread
 
 # Silence some warnings when compiled with clang
-- 
2.53.0



