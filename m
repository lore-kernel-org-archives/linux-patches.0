Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74DF03054E8;
	Sat, 25 Oct 2025 16:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409388; cv=none; b=BtlCI/LtFjqvQVQ9HoPH6RjNAnjg+HJeSv58tPpNmGaLA179f44eK3u6eQcdvC3mqM7ozLMf367P/pEmJ8EslrQ0Agoalx4W74sUiWfKFhjgBW2dtk4z8roGik4xI8puMbnLiAV+U2SGs9eSe7COIIeiPjbnBPIug5I3jXfQeNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409388; c=relaxed/simple;
	bh=yeTLH9FKHFlRz+2nh/sQscPakwnjGVZRsx1ude9S/Uc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H3ThKXcraCtwOd1wTzEW7/YaAKXXjUrAqwQUk/SnHJ5O8/or2gpUglLQDtd+QeLxHfmH9c8WeuJexABPiV2lb9E3Ow46HuT2i8rw4EUPQycVX6O7EP8hWo9l0UMwOygHhKOBp10AOCY4NFc7raFKxRJVP1LRKCK4iHhquTFNHmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xk5OFrG6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xk5OFrG6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23722C4CEF5;
	Sat, 25 Oct 2025 16:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409386;
	bh=yeTLH9FKHFlRz+2nh/sQscPakwnjGVZRsx1ude9S/Uc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xk5OFrG6EGGMpwq3PUViIeeuTZjZSW+60GjWRG/UIm+AwSrXGL52FXxbQydrdimEX
	 a9mcrRsY4Aa6Iag5lL0PhlFaw5DdSuV4tf26xWFTHCAIo+pZRjIz0OXmBGVwMf9FCB
	 evJEh9FQUtbaam3U2pXbbz9mcgGVfsecsy1GpZOOa0AHk/C7Cl7ZDP4iqLAHKQFu3l
	 +DD06Yexo1+KKEFVu51E5tAMXJ+/YnibYoFQLsuNWhSDUXw7LPG/b5gdbmnbL9DE4U
	 cIClYsR83LIKnFUnU8Nxk2y7rz8Q+FDTNkccrSeDUSaKlS1KCJm4AT6VMwjcwTNgla
	 osJwNT7LAnC4Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>,
	Andreas Larsson <andreas@gaisler.com>,
	Sasha Levin <sashal@kernel.org>,
	alexandre.f.demers@gmail.com,
	alexander.deucher@amd.com
Subject: [PATCH AUTOSEL 6.17-6.1] sparc64: fix prototypes of reads[bwl]()
Date: Sat, 25 Oct 2025 11:58:51 -0400
Message-ID: <20251025160905.3857885-300-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 7205ef77dfe167df1b83aea28cf00fc02d662990 ]

Conventions for readsl() are the same as for readl() - any __iomem
pointer is acceptable, both const and volatile ones being OK.  Same
for readsb() and readsw().

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Reviewed-by: Andreas Larsson <andreas@gaisler.com>
Signed-off-by: Andreas Larsson <andreas@gaisler.com> # Making sparc64 subject prefix
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES
- `arch/sparc/include/asm/io_64.h:253`, `:259`, `:265` now declare
  `readsb/readsw/readsl` with `const volatile void __iomem *` so callers
  keep their `const`/`volatile` qualifiers. Without this, every sparc
  build that uses the standard helpers via `ioread{8,16,32}_rep()` (see
  `arch/sparc/include/asm/io_64.h:289-291`) forces a qualifier drop,
  which becomes a hard build failure whenever `CONFIG_WERROR` or `make
  W=1` is enabled.
- The rest of the kernel already advertises these helpers as taking
  const-qualified pointers (for example `lib/iomap.c:360-372` and the
  asm-generic helpers), so sparc was the outlier. Aligning the
  prototypes removes that API mismatch and stops downstream drivers from
  needing casts/workarounds when built for sparc64.
- Risk is negligible: the bodies still just hand the pointer to
  `ins[blw]()` after an `unsigned long __force` cast, so runtime
  behavior is unchanged while the compiler interface is fixed.
Given it repairs a real build breakage for standard warning-as-error
configurations with effectively zero regression surface, it’s a good
stable backport candidate.

 arch/sparc/include/asm/io_64.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/sparc/include/asm/io_64.h b/arch/sparc/include/asm/io_64.h
index c9528e4719cd2..d8ed296624afd 100644
--- a/arch/sparc/include/asm/io_64.h
+++ b/arch/sparc/include/asm/io_64.h
@@ -250,19 +250,19 @@ void insl(unsigned long, void *, unsigned long);
 #define insw insw
 #define insl insl
 
-static inline void readsb(void __iomem *port, void *buf, unsigned long count)
+static inline void readsb(const volatile void __iomem *port, void *buf, unsigned long count)
 {
 	insb((unsigned long __force)port, buf, count);
 }
 #define readsb readsb
 
-static inline void readsw(void __iomem *port, void *buf, unsigned long count)
+static inline void readsw(const volatile void __iomem *port, void *buf, unsigned long count)
 {
 	insw((unsigned long __force)port, buf, count);
 }
 #define readsw readsw
 
-static inline void readsl(void __iomem *port, void *buf, unsigned long count)
+static inline void readsl(const volatile void __iomem *port, void *buf, unsigned long count)
 {
 	insl((unsigned long __force)port, buf, count);
 }
-- 
2.51.0

