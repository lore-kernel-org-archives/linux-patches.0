Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B6513207;
	Wed, 11 Feb 2026 12:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770813093; cv=none; b=RE6wzicE4UH4pvVK/siQL+XFq0kVrXDzx2kVoiiiMbcE+nBrNzn4h8M+gLLAkcQ0jDpoy9u/fZqtbbq7jKombuPci6rZAyoLiIFJqq/x6ciMskEcy6m64SnTaOb5cFezh2KASQzdRj6OwAwnFZImu+Wjg7MWeS4yAgr/bOORwE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770813093; c=relaxed/simple;
	bh=4cYzhg36eRCdHeDXkrqTRinwTV6Hk6R7oxtOoKAW+GA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lf5i+RfGQzcbX1SpnAzulhRla9pkBsoTd1pKoR0M7DZanNkadBnERrcb+IBkpSdqs9ijBW6oohfTDck+qbKDukn/Xd5jE8G/eRC3t+AeJswKpxXO5eMqv95LldrKtSnDf3Ym0Nqe7+IBAiPsJ+s0MNek+lxGw+1otqo6FJ0Hl7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=THcv2Vow; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="THcv2Vow"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47339C19424;
	Wed, 11 Feb 2026 12:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770813092;
	bh=4cYzhg36eRCdHeDXkrqTRinwTV6Hk6R7oxtOoKAW+GA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=THcv2Vowh6I4geU/w5bLT+157SiEeO3lOnWTxOrDiWJpQEA/bxd5YNwQ1fYd7kVq3
	 fzUP/2pK/hSbrSL57lPfMcLlybm1VdYTJhnjfSOqCOBIHMwLHngdfFo2MNiD80BcUr
	 ksbIhEDfgf7MRN3t3HZ2TnItWnUK62HgGdkFxTc3mvVfDjvYsv2uFgDeNAiHOBCE73
	 sPR/MaRdz5qfNGTfq1TUp9SOAWvGAb+6r9XIJvop1l75ddfuTZ/PZCStzXBuNIbWkz
	 DUh9xu+7GjHy+Ifodh4k3P7aPAl5wSCDmvQL9muUrNQR7rJboQ744dEptPAuGieBZy
	 AhCFUqy8lJdFw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Sam James <sam@gentoo.org>,
	Andreas Larsson <andreas@gaisler.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 6.19-5.10] sparc: don't reference obsolete termio struct for TC* constants
Date: Wed, 11 Feb 2026 07:30:20 -0500
Message-ID: <20260211123112.1330287-10-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260211123112.1330287-1-sashal@kernel.org>
References: <20260211123112.1330287-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Transfer-Encoding: 8bit

From: Sam James <sam@gentoo.org>

[ Upstream commit be0bccffcde3308150d2a90e55fc10e249098909 ]

Similar in nature to commit ab107276607a ("powerpc: Fix struct termio related ioctl macros").

glibc-2.42 drops the legacy termio struct, but the ioctls.h header still
defines some TC* constants in terms of termio (via sizeof). Hardcode the
values instead.

This fixes building Python for example, which falls over like:
  ./Modules/termios.c:1119:16: error: invalid application of 'sizeof' to incomplete type 'struct termio'

Link: https://bugs.gentoo.org/961769
Link: https://bugs.gentoo.org/962600
Signed-off-by: Sam James <sam@gentoo.org>
Reviewed-by: Andreas Larsson <andreas@gaisler.com>
Signed-off-by: Andreas Larsson <andreas@gaisler.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The file is identical across all stable kernel versions. Now I have a
complete picture. Here is my detailed analysis:

---

## Comprehensive Analysis

### 1. COMMIT MESSAGE ANALYSIS

**Subject**: "sparc: don't reference obsolete termio struct for TC*
constants"

The commit explicitly states it fixes a **build failure** in userspace
software. It references:
- A prior identical fix for powerpc (`ab107276607a`)
- The root cause: glibc 2.42 drops the legacy `struct termio` definition
- A concrete symptom: Python fails to build with `sizeof` applied to
  incomplete type
- Two Gentoo bug tracker links
  ([#961769](https://bugs.gentoo.org/961769),
  [#962600](https://bugs.gentoo.org/962600)) with real user reports
- Reviewed-by from the sparc subsystem maintainer (Andreas Larsson)

### 2. CODE CHANGE ANALYSIS

The change is minimal - 4 lines in a single UAPI header file
`arch/sparc/include/uapi/asm/ioctls.h`:

```8:11:arch/sparc/include/uapi/asm/ioctls.h
#define TCGETA          _IOR('T', 1, struct termio)
#define TCSETA          _IOW('T', 2, struct termio)
#define TCSETAW         _IOW('T', 3, struct termio)
#define TCSETAF         _IOW('T', 4, struct termio)
```

These are replaced with hardcoded hex values:
- `TCGETA` = `0x40125401` (was `_IOR('T', 1, struct termio)`)
- `TCSETA` = `0x80125402` (was `_IOW('T', 2, struct termio)`)
- `TCSETAW` = `0x80125403` (was `_IOW('T', 3, struct termio)`)
- `TCSETAF` = `0x80125404` (was `_IOW('T', 4, struct termio)`)

**Value verification**: I manually computed these using sparc's
`asm/ioctl.h` (which has `_IOC_READ=2`, `_IOC_WRITE=4`, shifts at
29/16/8/0). With `sizeof(struct termio) = 18` (0x12), all four values
are mathematically correct. The parisc fix uses identical values
(0x40125401, 0x80125402, 0x80125403, 0x80125404), which is expected
since sparc and parisc share the same ioctl encoding scheme.

**Bug mechanism**: The `_IOR` and `_IOW` macros expand to use
`sizeof(struct termio)`. When userspace code includes `<asm/ioctls.h>`
transitively (through `<sys/ioctl.h>` -> `<bits/ioctls.h>` ->
`<asm/ioctls.h>`), and glibc 2.42+ is installed (which dropped the
`struct termio` definition), the compiler encounters `sizeof` on an
incomplete/undefined type, causing a hard build error.

### 3. PRECEDENT - IDENTICAL FIXES ACROSS ARCHITECTURES

This is the **fourth** architecture getting this exact same fix:

| Architecture | Commit | Merged in | Cc: stable? |
|---|---|---|---|
| xtensa | `f61bf8e7d19e0` | v3.17 (2014!) | N/A |
| powerpc | `ab107276607a` | v6.16 | No |
| parisc | `8ec5a066f88f8` | v6.18 | **Yes** |
| alpha | `9aeed90419298` | v6.19 | No |
| **sparc** | *(this commit)* | pending | No |
| SH | already hardcoded | N/A | N/A |

The parisc version has explicit `Cc: stable@vger.kernel.org`, confirming
the stable maintainers consider this type of fix stable-appropriate. The
sparc version simply lacks the tag - likely an oversight by the
submitter.

### 4. REAL-WORLD IMPACT

- **Multiple bug reports**: Gentoo bugs #961769 and #962600 document the
  issue with real users affected on both hppa and sparc
- **Critical software broken**: Python (CPython) cannot be built on
  sparc with glibc 2.42+, a fundamental system component
- **Gentoo already carries this patch**: Gentoo has backported this fix
  to their linux-headers packages for kernel versions 6.16 and 6.17,
  demonstrating real demand
- **Affects ALL userspace programs** that reference
  TCGETA/TCSETA/TCSETAW/TCSETAF through the standard header chain
- **Multiple users confirmed**: Dennis Clarke confirmed the issue on
  sparc64 (Sun Netra X1), Stian Halseth reported it for sparc, matoro
  reported it for hppa

### 5. CLASSIFICATION

This is a **build fix for UAPI headers** - one of the explicitly allowed
exception categories for stable. It:
- Fixes a real build failure (not theoretical)
- Does NOT change any kernel behavior
- Does NOT change any ioctl numbers (values are identical)
- Does NOT add new features or APIs
- Is a UAPI header issue (kernel-userspace interface)

### 6. SCOPE AND RISK ASSESSMENT

- **Lines changed**: 4 lines in 1 file
- **Subsystem**: sparc architecture UAPI headers
- **Risk**: Essentially **zero**. The hardcoded values are
  mathematically identical to what the macros produce. This is a pure
  constant-expression replacement. The kernel itself never evaluates
  these macros (it uses the ioctl numbers directly) - they only matter
  for userspace header consumption.
- **Regression potential**: None. The ioctl numbers are ABI-stable and
  have been the same since sparc Linux support was added.

### 7. DEPENDENCY CHECK

This patch has **no dependencies**. The file
`arch/sparc/include/uapi/asm/ioctls.h` is identical in v5.15, v6.1,
v6.6, and v6.19 with respect to the changed lines. The patch applies
cleanly to **all** active stable kernel trees.

### 8. STABILITY INDICATORS

- **Reviewed-by**: Andreas Larsson (sparc subsystem maintainer)
- **Author**: Sam James (Gentoo developer, same author as the parisc and
  alpha versions)
- **Pattern established**: Same fix already applied and tested on 4+
  other architectures over 10+ years
- **Values verified**: Identical to parisc which shares the same ioctl
  encoding

### Summary

This is a textbook stable backport candidate. It's a tiny, zero-risk
build fix for a UAPI header that prevents userspace software (including
Python) from compiling on sparc with modern glibc. The identical fix has
been applied across multiple architectures, the parisc version was
explicitly tagged `Cc: stable@vger.kernel.org`, Gentoo is already
carrying it as a patch for older kernel versions, and the change has
been reviewed by the sparc maintainer. The hardcoded values are
mathematically provably correct, and the patch applies cleanly to all
stable trees.

**YES**

 arch/sparc/include/uapi/asm/ioctls.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/sparc/include/uapi/asm/ioctls.h b/arch/sparc/include/uapi/asm/ioctls.h
index 7fd2f5873c9e7..a8bbdf9877a41 100644
--- a/arch/sparc/include/uapi/asm/ioctls.h
+++ b/arch/sparc/include/uapi/asm/ioctls.h
@@ -5,10 +5,10 @@
 #include <asm/ioctl.h>
 
 /* Big T */
-#define TCGETA		_IOR('T', 1, struct termio)
-#define TCSETA		_IOW('T', 2, struct termio)
-#define TCSETAW		_IOW('T', 3, struct termio)
-#define TCSETAF		_IOW('T', 4, struct termio)
+#define TCGETA          0x40125401 /* _IOR('T', 1, struct termio) */
+#define TCSETA          0x80125402 /* _IOW('T', 2, struct termio) */
+#define TCSETAW         0x80125403 /* _IOW('T', 3, struct termio) */
+#define TCSETAF         0x80125404 /* _IOW('T', 4, struct termio) */
 #define TCSBRK		_IO('T', 5)
 #define TCXONC		_IO('T', 6)
 #define TCFLSH		_IO('T', 7)
-- 
2.51.0

