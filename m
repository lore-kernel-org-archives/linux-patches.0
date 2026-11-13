Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585624;
	b=Eet4F4RMHKTba7mLt3pDjBh3c1AMHiY2+NRphwjJGDZWnFYYTPD+LZfj7G4iXP/qTi+P
	 hVuPgjQRoBjfKWk/qMMXlG6CvX7LFZmU4Vsqy8kKYbfsSK6qUrRIXjD1bpitPcQk8G0Ui
	 kFQs2BzoviZMTJiHX15u999c/EDMCHRdAtCt26TFLn1NzfFV4lORJODG0s8T7yNm5pl6D
	 yUSvneJivS1NuTYEEYSNX3EeNDQ8L4XcaUrUvB7qXi+LEnLXQA2PdyD/C0KsuKLPzHKTS
	 RSZdYuqKIQmaZpmMk2s3K40FuZm7INj8LUiDjUy3bGiOReJ4EjoBNeX1iITcs6dgIew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585624;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zCEXrmTH1TtYArcN+jIcaYtpUVRU7K+V4AxLl9h5Qro=;
	b=MsUywsmzOtpyRmlquSue28NspV9h1EbLfNxPZnOLeA3x/6EqIbY19u+OzUJT1MJ27w5O
	 7TtjZ5LmQczFuC4SeTJ+LogdUlikHu4y0cKz+V1gE/srCDzFy30MCs4iLl8IxADxKmZx7
	 Q080Gxdkwu90QNI+BkSlWB5/s0tNm0tB6B/2yZ/5Kc2BOUQDqum/5fwq+AwTNwY/weHSD
	 QmaKcpjq+Sjxg6Layfs1Lu4qA5Ps1JDnYpvb6c92P8yza9XLmKF84VNjE6BatpSTp6zZ7
	 MJNc80YaZIZ/xHQtqQXo0QnTKM2CPms3a4jhY9fZZIzNjC6MfF3dnGfLSdwNfo1lfmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nV4dAS9v;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E63BD6070FC1;
	Fri, 13 Nov 2026 16:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nV4dAS9v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96C0A1F000C5;
	Fri, 13 Nov 2026 16:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585623;
	bh=zCEXrmTH1TtYArcN+jIcaYtpUVRU7K+V4AxLl9h5Qro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nV4dAS9vHxigFzxrgJDStSMUsDK4UNqOGy6Ug+wsDU+yKb1R5KusqL3CqmxLb/D0Q
	 WvShPFxfEpGREySqzVOz02mN37X+BtoYw5mnBrDb5aUeR3CqPM1iuVvYOHT/0d/kvI
	 n7BsLBhHYQ8ZDFIUa2rcMSYltfSxONVgYW65aS/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Guan-Chun Wu <409411716@gms.tku.edu.tw>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 246/507] lib/base64: silence clang-24 -Wconstant-conversion with diag pragmas
Date: Fri, 13 Nov 2026 10:49:10 -0500
Message-ID: <20261113153802.914775190@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit 3af83c11cf5990fda0bfe3959aa6391ff903ffdd ]

After a recent change in clang to warn on signed char conversions within
array initializers [1], there are several instances of this warning from
base64_rev_maps in lib/base64.c, which can break the build with W=e or
CONFIG_WERROR=y:

  lib/base64.c:58:18: error: implicit conversion from 'int' to 's8' (aka 'signed char') changes value from 131 to -125 [-Werror,-Wconstant-conversion]
     58 |         [BASE64_IMAP] = BASE64_REV_INIT('+', ',')
        |                         ^~~~~~~~~~~~~~~~~~~~~~~~~
  lib/base64.c:52:2: note: expanded from macro 'BASE64_REV_INIT'
     48 | #define BASE64_REV_INIT(ch_62, ch_63) { \
        |                                       ~
     49 |         [0 ... 0x1f] = -1, \
     50 |         INIT_32(0x20, ch_62, ch_63), \
     51 |         INIT_32(0x40, ch_62, ch_63), \
     52 |         INIT_32(0x60, ch_62, ch_63), \
        |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~
  ...
  lib/base64.c:34:42: note: expanded from macro 'INIT_1'
     34 |                 : (v) >= '0' && (v) <= '9' ? (v) - '0' + 52 \
        |                                              ~~~~~~~~~~^~~~
  lib/base64.c:58:18: error: implicit conversion from 'int' to 's8' (aka 'signed char') changes value from 130 to -126 [-Werror,-Wconstant-conversion]
     58 |         [BASE64_IMAP] = BASE64_REV_INIT('+', ',')
        |                         ^~~~~~~~~~~~~~~~~~~~~~~~~
  lib/base64.c:52:2: note: expanded from macro 'BASE64_REV_INIT'
     48 | #define BASE64_REV_INIT(ch_62, ch_63) { \
        |                                       ~
     49 |         [0 ... 0x1f] = -1, \
     50 |         INIT_32(0x20, ch_62, ch_63), \
     51 |         INIT_32(0x40, ch_62, ch_63), \
     52 |         INIT_32(0x60, ch_62, ch_63), \
        |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~
  ...
  lib/base64.c:34:42: note: expanded from macro 'INIT_1'
     34 |                 : (v) >= '0' && (v) <= '9' ? (v) - '0' + 52 \
        |                                              ~~~~~~~~~~^~~~
  ...

These are false positives, as the branch where the wraparound could happen
is unreachable with the values that clang reports.  This is not considered
a bug by some clang folks [2][3], so silence the warnings using the __diag
macros the kernel has to workaround compiler warnings when necessary.

Link: https://lore.kernel.org/20261008-base64-silence-clang-24-constant-conversion-v1-1-0858b60b23c8@kernel.org
Link: https://github.com/llvm/llvm-project/commit/a5ef934a8d295dc03be3960f2b3744ec2e53238e [1]
Link: https://github.com/llvm/llvm-project/issues/223923#issuecomment-6056856245 [2]
Link: https://github.com/llvm/llvm-project/pull/226775#pullrequestreview-5454407389 [3]
Fixes: c4eb7ad32eab ("lib/base64: optimize base64_decode() with reverse lookup tables")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Closes: https://github.com/ClangBuiltLinux/linux/issues/2181
Acked-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Bill Wendling <morbo@google.com>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Guan-Chun Wu <409411716@gms.tku.edu.tw>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/base64.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/lib/base64.c b/lib/base64.c
index 325c7332b0492..e46be3a55585c 100644
--- a/lib/base64.c
+++ b/lib/base64.c
@@ -52,11 +52,14 @@ static const char base64_tables[][65] = {
 	INIT_32(0x60, ch_62, ch_63), \
 	[0x80 ... 0xff] = -1 }
 
+__diag_push();
+__diag_ignore(clang, all, "-Wconstant-conversion", "https://github.com/llvm/llvm-project/issues/223923");
 static const s8 base64_rev_maps[][256] = {
 	[BASE64_STD] = BASE64_REV_INIT('+', '/'),
 	[BASE64_URLSAFE] = BASE64_REV_INIT('-', '_'),
 	[BASE64_IMAP] = BASE64_REV_INIT('+', ',')
 };
+__diag_pop();
 
 #undef BASE64_REV_INIT
 #undef INIT_32
-- 
2.53.0



