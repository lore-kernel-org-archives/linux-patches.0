Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB0511FC7FB;
	Fri,  5 Dec 2025 04:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764909256; cv=none; b=OKls/tnxcHrtjLmv/QOM+WtwjzH2Ny8hBTrsSGBJFXfPE+9QH81zd3DM1hn/Z/wJJOMw4uRdPtuC0XPErUrNi/VZxfScIQKsjgGHdtabTOTnrbcuKtukZ7GwQJSXRZbTXy7fT863ErGEqS1883gmUTHz6gAdWg43oJ7Yka+/7FA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764909256; c=relaxed/simple;
	bh=Xs/I7HqLKfC5G8zYrX9cZYJlBM7YKSjh1XunHYin8+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dWHF+42qPampa77are7EHlUYKLtkgxNmorhZ5XK6+9LDJDz5ItIe+CF/FTjYZ1x3ERHiyKoCvQZO1NQp879thBTaWsVYip7/bahtOD40jqwwU4aksnpIJOCjdudQwJEmW0vBYSYouOQdO0VVuoioytIQnC0OYFMz29s/k3M3SpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iaelsAcS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iaelsAcS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBB83C4CEF1;
	Fri,  5 Dec 2025 04:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764909255;
	bh=Xs/I7HqLKfC5G8zYrX9cZYJlBM7YKSjh1XunHYin8+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iaelsAcSpD2/8eqJBX6ow/zoAPA2VI8Twu3cD+DjLIRbb9/sRrvuMN1sYrQYRiZ2C
	 aG1SzuFuGCgKO97lunmezB+/JAtg7cNStv/bOfZT5ulj2UaVdJS57crcLf0OxbVTAV
	 HPzf+phNs7D2C2Pwbdpqml4Z97FVtMKt33fKRNcu2CzywjZYXQ6t+CUqZa6fdQ9eIT
	 A8zz1+CEAiXdWcFx0dX3o0sWpUiR0o9WQOLcFRjlHdh5Htq2+f8jqjZlSAEKrRewAu
	 uxPV85ZLST4zH/ArOTtR37aaCaYdv0aJDxOj6W0A8KTAAo5fOYmctidh9cQwRrZfb/
	 uS13AiqDs9Zpg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 6.18-6.17] scripts: kdoc_parser.py: warn about Python version only once
Date: Thu,  4 Dec 2025 23:33:43 -0500
Message-ID: <20251205043401.528993-2-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251205043401.528993-1-sashal@kernel.org>
References: <20251205043401.528993-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

[ Upstream commit ade9b9576e2f000fb2ef0ac3bcd26e1167fd813b ]

When running kernel-doc over multiple documents, it emits
one error message per file with is not what we want:

	$ python3.6 scripts/kernel-doc.py . --none
	...
	Warning: ./include/trace/events/swiotlb.h:0 Python 3.7 or later is required for correct results
	Warning: ./include/trace/events/iommu.h:0 Python 3.7 or later is required for correct results
	Warning: ./include/trace/events/sock.h:0 Python 3.7 or later is required for correct results
	...

Change the logic to warn it only once at the library:

	$ python3.6 scripts/kernel-doc.py . --none
	Warning: Python 3.7 or later is required for correct results
	Warning: ./include/cxl/features.h:0 Python 3.7 or later is required for correct results

When running from command line, it warns twice, but that sounds
ok.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Message-ID: <68e54cf8b1201d1f683aad9bc710a99421910356.1758196090.git.mchehab+huawei@kernel.org>
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis

### 1. COMMIT MESSAGE ANALYSIS

**Subject**: `scripts: kdoc_parser.py: warn about Python version only
once`

**Problem**: When `kernel-doc` processes multiple files with Python <
3.7, it emits one warning per file, creating noise:
```
Warning: ./include/trace/events/swiotlb.h:0 Python 3.7 or later is
required for correct results
Warning: ./include/trace/events/iommu.h:0 Python 3.7 or later is
required for correct results
Warning: ./include/trace/events/sock.h:0 Python 3.7 or later is required
for correct results
...
```

**Solution**: Add a module-level flag (`python_warning`) so the warning
is emitted once per process run.

**Tags**: No "Cc: stable@vger.kernel.org" or "Fixes:" tag.

**Author**: Mauro Carvalho Chehab (kernel-doc maintainer)
**Date**: September 18, 2025

---

### 2. CODE CHANGE ANALYSIS

**Files changed**: 1 file (`scripts/lib/kdoc/kdoc_parser.py`)
**Lines changed**: +6, -1 (net +5)

**Diff**:
```python
+python_warning = False  # Module-level global flag

class KernelDoc:
    def __init__(self, config, fname):
        ...
- if sys.version_info.major == 3 and sys.version_info.minor < 7:
+        global python_warning
+        if (not python_warning and
+            sys.version_info.major == 3 and sys.version_info.minor <
7):
             self.emit_msg(0,
                           'Python 3.7 or later is required for correct
results')
+            python_warning = True
```

**Mechanism**:
- `KernelDoc.__init__()` runs once per file.
- The check was unconditional, causing repeated warnings.
- The fix adds a module-level flag set after the first warning to
  suppress subsequent ones.

**Correctness**: Correct. The flag is checked and set atomically within
the same conditional, preventing races.

---

### 3. CLASSIFICATION

**Type**: Bug fix (UX)

**Category**: Build/documentation tool fix
- Not kernel runtime code
- Affects `kernel-doc` output
- Improves developer experience

**Exception categories**: None (not device IDs, quirks, DT updates, or
build fixes)

**Security**: No security impact

---

### 4. SCOPE AND RISK ASSESSMENT

**Complexity**: Low
- Simple flag check
- No logic changes
- Minimal code

**Risk**: Very low
- Only changes warning output
- No functional changes
- No new code paths
- No dependencies on other changes

**Subsystem**: Documentation build tools (`scripts/lib/kdoc/`)
- Less critical than kernel runtime code
- Still affects developers building docs

**Files touched**: 1 file, 7 lines changed

---

### 5. USER IMPACT

**Who is affected**:
- Developers building kernel documentation
- CI/CD systems running `kernel-doc`
- Anyone using Python < 3.7 with `kernel-doc` on multiple files

**Severity**: Low–moderate
- Not a crash or data corruption
- User-visible annoyance (warning spam)
- Can obscure other warnings

**Real-world impact**: Yes
- Occurs when processing multiple files (common)
- Example: `python3.6 scripts/kernel-doc.py . --none` on a directory

**Note**: Python 3.9+ is the kernel minimum, but some systems may still
use older versions.

---

### 6. STABILITY INDICATORS

**Tested-by**: Not mentioned
**Reviewed-by**: Jonathan Corbet (kernel-doc maintainer)
**Age**: Commit from September 2025 (recent)

**Maintainer approval**: Signed-off by Jonathan Corbet (maintainer)

---

### 7. DEPENDENCY CHECK

**Prerequisite**: Requires commit `40020fe8e3a40` ("docs: kdoc: emit a
warning for ancient versions of Python") from July 2025.

**Backport implications**:
- If the prerequisite exists in a stable tree, this applies cleanly.
- If not, both commits would need to be backported together.
- The prerequisite is also a small, low-risk change.

**Code existence**: The `KernelDoc` class and the warning check exist in
current stable trees (the warning was added in 2025).

---

### 8. STABLE KERNEL RULES EVALUATION

**1. Obviously correct and tested**: Yes — simple flag check, reviewed
by maintainer
**2. Fixes a real bug**: Yes — excessive warning spam
**3. Important issue**: Moderate — UX improvement, not critical
**4. Small and contained**: Yes — 7 lines, single file
**5. No new features**: Correct — only changes warning behavior
**6. Applies cleanly**: Yes — if prerequisite exists

**Concerns**:
- Documentation tool fix (less critical than kernel code)
- Requires prerequisite commit
- UX improvement, not a critical bug

**Benefits**:
- Fixes a real user-visible issue
- Very low risk
- Small and simple
- Improves developer experience

---

### 9. FINAL ASSESSMENT

**Verdict**: YES, with conditions

**Reasoning**:
1. Fixes a real user-visible bug (excessive warnings)
2. Very low risk (warning output only)
3. Small, simple change
4. Reviewed by maintainer
5. Improves developer experience

**Conditions**:
- The prerequisite commit (`40020fe8e3a40`) must exist in the target
  stable tree, or both commits should be backported together.
- This is a UX improvement, not critical, but it addresses a real
  annoyance.

**Recommendation**: Backport to stable trees that have the prerequisite
warning commit, or backport both commits together. The low risk and
clear benefit justify inclusion.

**YES**

 scripts/lib/kdoc/kdoc_parser.py | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/scripts/lib/kdoc/kdoc_parser.py b/scripts/lib/kdoc/kdoc_parser.py
index 2376f180b1fa9..89d920e0b65ca 100644
--- a/scripts/lib/kdoc/kdoc_parser.py
+++ b/scripts/lib/kdoc/kdoc_parser.py
@@ -350,6 +350,7 @@ class KernelEntry:
             self.section = SECTION_DEFAULT
             self._contents = []
 
+python_warning = False
 
 class KernelDoc:
     """
@@ -383,9 +384,13 @@ class KernelDoc:
         # We need Python 3.7 for its "dicts remember the insertion
         # order" guarantee
         #
-        if sys.version_info.major == 3 and sys.version_info.minor < 7:
+        global python_warning
+        if (not python_warning and
+            sys.version_info.major == 3 and sys.version_info.minor < 7):
+
             self.emit_msg(0,
                           'Python 3.7 or later is required for correct results')
+            python_warning = True
 
     def emit_msg(self, ln, msg, warning=True):
         """Emit a message"""
-- 
2.51.0

