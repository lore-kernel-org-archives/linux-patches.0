Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB4732741DA;
	Sat, 25 Oct 2025 16:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408918; cv=none; b=mz9XtXYdM3HlWUDclkxCsiK3J91ELw0l98zP7Z4XYdt2B5luU7nlQqP3NbJ4C2K67mxXK2TLWjT19x5t9fPYm2iamHKCfsZilL7DY/8mcBMGqKuo6bfHQj6teRLa9wbsiOmVzKxN0JoIZ0LxMiDVS+4zJRfEXgaVhJimnpKi14c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408918; c=relaxed/simple;
	bh=7LlleGvQTKPFRUPTQ4TnmBZHLhxAptbV69fH3thPF8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MMhv5W14BX9pvoMZvQjdOppsgDCVDWQhH0IJcCJIYfnaPsXrosdRErKLDexEjFSjzgHhXXWwywzxFIamgDNdLqrSskBZ4tmtkfC76mgmgY61DylFgeMy7Gsdtr9dgigbdglOSZyPp1nmXLpY+9GPsENGF21Juof9h0iQP25Kbgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gq6oZuQb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gq6oZuQb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD16BC4CEFB;
	Sat, 25 Oct 2025 16:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408918;
	bh=7LlleGvQTKPFRUPTQ4TnmBZHLhxAptbV69fH3thPF8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gq6oZuQbf4i3rLcXJdwu9YpqvITnKP6eV8pDf45bzAS8eFpFOIs36xKq91LhrOnGp
	 swFs2q48Efspilihq70k5N0SJUxg/PQ3U/gCQbOCrGbVhU47DYtuZlcsuy+Fox0/CI
	 1NOk/pnBs8hGyHgMy/kyD3UOoasbAm715NJHGg8Fbp7YG8BL6lPN28XyYL/BVGtUEi
	 ggM57AVwwx4fIR2L9lZDNtKGHoc/Gzgqbv7Q3BQI+N0BkJccJYf+ge2tzn1bePbtTK
	 +q6Q4PH/N9FNOp6Dq4eQL5z2x3jCc4qGYZdcKt5kkUvZDKZsPR+mlMV5CWM9WDH5A2
	 lB3fTQSLyM4TQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mark Pearson <mpearson-lenovo@squebb.ca>,
	Kean Ren <kean0048@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	derekjohn.clark@gmail.com,
	platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17] platform/x86: think-lmi: Add extra TC BIOS error messages
Date: Sat, 25 Oct 2025 11:56:02 -0400
Message-ID: <20251025160905.3857885-131-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Transfer-Encoding: 8bit

From: Mark Pearson <mpearson-lenovo@squebb.ca>

[ Upstream commit a0d6959c345d89d811288a718e3f6b145dcadc8c ]

Add extra error messages that are used by ThinkCenter platforms.

Signed-off-by: Kean Ren <kean0048@gmail.com>
Signed-off-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Link: https://lore.kernel.org/r/20250903173824.1472244-4-mpearson-lenovo@squebb.ca
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What it fixes
  - On ThinkCentre systems, BIOS WMI calls for certificate operations
    can return TC‑specific strings that this driver did not recognize.
    Unknown strings fall back to -EPERM, so a successful operation could
    be reported as failure, and real failures would be collapsed into a
    generic error. This creates real user-facing breakage for sysfs
    writes that manage BIOS certificates.

- Where the bug is
  - Error mapping logic: `tlmi_errstr_to_err()` maps BIOS strings to
    errno by scanning `tlmi_errs[]`, and returns -EPERM on no match:
    drivers/platform/x86/lenovo/think-lmi.c:247–257.
  - All BIOS WMI method wrappers use this path via `tlmi_simple_call()`:
    drivers/platform/x86/lenovo/think-lmi.c:273–300. Any non-zero
    mapping is propagated as the sysfs write result.

- What changed
  - Added ThinkCentre-specific strings to the mapping table
    `tlmi_errs[]`:
    - Success string: `"Set Certificate operation was successful."` →
      `0`
    - Specific failure strings: invalid parameter/type/password, retry
      exceeded, password invalid, operation aborted, no free slots,
      certificate not found, internal error, certificate too large →
      appropriate `-EINVAL`, `-EACCES`, `-EBUSY`, `-ENOSPC`, `-EEXIST`,
      `-EFAULT`, `-EFBIG`
    - Location: drivers/platform/x86/lenovo/think-lmi.c:207–224
  - This ensures ThinkCentre BIOS responses are properly interpreted
    instead of defaulting to -EPERM.

- Why it matters in practice
  - Certificate operations in this driver (e.g., install/update/clear
    certificate, cert→password) call `tlmi_simple_call()` with
    ThinkCentre certificate GUIDs (see call sites in
    `certificate_store()` and `cert_to_password_store()`):
    drivers/platform/x86/lenovo/think-lmi.c:841, 895–906, 795. With the
    old table, a genuine success response like `"Set Certificate
    operation was successful."` would be treated as an error (-EPERM),
    causing sysfs writes such as `.../authentication/*/certificate` to
    fail even though the BIOS accepted the operation.
  - The new entries also surface more precise errno for failures,
    improving diagnostics for userspace tools and admins.

- Risk and scope
  - Minimal: a localized addition to a string→errno table; no control
    flow or architectural changes.
  - Affects only Lenovo think-lmi driver behavior on ThinkCentre
    platforms when handling certificate-related WMI responses.
  - No user-visible API changes beyond correcting erroneous return
    codes; improves correctness and debuggability.

- Stable backport fit
  - Fixes a real user-impacting bug (false -EPERM on success, ambiguous
    errors).
  - Small, self-contained, and low-risk.
  - Confined to platform/x86/lenovo/think-lmi.

Given the above, this is a good candidate for stable backporting.

 drivers/platform/x86/lenovo/think-lmi.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/platform/x86/lenovo/think-lmi.c b/drivers/platform/x86/lenovo/think-lmi.c
index 0992b41b6221d..e6a2c8e94cfdc 100644
--- a/drivers/platform/x86/lenovo/think-lmi.c
+++ b/drivers/platform/x86/lenovo/think-lmi.c
@@ -179,10 +179,21 @@ MODULE_PARM_DESC(debug_support, "Enable debug command support");
 
 static const struct tlmi_err_codes tlmi_errs[] = {
 	{"Success", 0},
+	{"Set Certificate operation was successful.", 0},
 	{"Not Supported", -EOPNOTSUPP},
 	{"Invalid Parameter", -EINVAL},
 	{"Access Denied", -EACCES},
 	{"System Busy", -EBUSY},
+	{"Set Certificate operation failed with status:Invalid Parameter.", -EINVAL},
+	{"Set Certificate operation failed with status:Invalid certificate type.", -EINVAL},
+	{"Set Certificate operation failed with status:Invalid password format.", -EINVAL},
+	{"Set Certificate operation failed with status:Password retry count exceeded.", -EACCES},
+	{"Set Certificate operation failed with status:Password Invalid.", -EACCES},
+	{"Set Certificate operation failed with status:Operation aborted.", -EBUSY},
+	{"Set Certificate operation failed with status:No free slots to write.", -ENOSPC},
+	{"Set Certificate operation failed with status:Certificate not found.", -EEXIST},
+	{"Set Certificate operation failed with status:Internal error.", -EFAULT},
+	{"Set Certificate operation failed with status:Certificate too large.", -EFBIG},
 };
 
 static const char * const encoding_options[] = {
-- 
2.51.0

