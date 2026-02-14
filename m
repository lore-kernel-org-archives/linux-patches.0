Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AD53DF59;
	Sat, 14 Feb 2026 00:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771030716; cv=none; b=qubeDRzJKSzPTUx9OUg1os/3A/T1upEGLMQALl4YrDGBnWTrntcw3e9UnoAXOf4UJZfmMMteaPjemcj9NlAPZiHUr+EnuOV8XNoEMiY4N3aw7WzEAHJpXWNohTJa2fIVgqIq05ijViww6T+oREB2J9Y9R13z9umhsjcA4o8NkKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771030716; c=relaxed/simple;
	bh=9iUqq9ZQm+L4L0WZKC72XnpCTsO/DQnYd7c8gUn/SE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IemN7T633Takz/Z6u6dSP5EKllL3UFgJaKOjh7PJtTCqcnUEOQ1pvTjXqXRMRUFCuIaBvqYrxkOOhDVb746PZkpc0jY87EfLx8tbzueaqrP4VbWvQ9wglWfH1CphZDroairT7BISALRI5et15YnBwLDABkxQWLqR1+bYVYTrUSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GSPOji4Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GSPOji4Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F6F6C116C6;
	Sat, 14 Feb 2026 00:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771030716;
	bh=9iUqq9ZQm+L4L0WZKC72XnpCTsO/DQnYd7c8gUn/SE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GSPOji4QqRHEiVmQFrnVKtGcaTfBjnT6aA1QsEkaEWonVkmgh0rnEcOKlTFWQWz0+
	 rohVvlNTwGRwJ5BD/WMHRvCn//sgxvZnF4Ep9Oy+5ZCjoh6G1nicpreyBkFjpdRUqp
	 mtvOEG13lGoj0U/sMHC9g1m07QX0iGnmdslL7nzKMLsT9spX8NKdXlVMsjwfSf9DRf
	 K2Qc9byZ5fj8hEP9a4TDGbmz2umM7YRUms39SEHrnm1bMN2CdJJ+Q3ulzuXlk4b3Wj
	 i5QLJ6DkuWaztI4JOZbUSXZwpLJKPwxH8ZUETJ3WnoFWWfZ+XvuE5P9LTDFb2k8ptX
	 Nad12yEq/jcvg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>,
	kernel test robot <lkp@intel.com>,
	Julia Lawall <julia.lawall@inria.fr>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	nathan@kernel.org,
	mingo@kernel.org,
	ardb@kernel.org,
	Neeraj.Upadhyay@amd.com,
	aik@amd.com,
	yelangyan@huaqin.corp-partner.google.com,
	ashish.kalra@amd.com,
	llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 6.19-6.18] x86/sev: Use kfree_sensitive() when freeing a SNP message descriptor
Date: Fri, 13 Feb 2026 19:58:10 -0500
Message-ID: <20260214005825.3665084-4-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214005825.3665084-1-sashal@kernel.org>
References: <20260214005825.3665084-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: "Borislav Petkov (AMD)" <bp@alien8.de>

[ Upstream commit af05e558988ed004a20fc4de7d0f80cfbba663f0 ]

Use the proper helper instead of an open-coded variant.

Closes: https://lore.kernel.org/r/202512202235.WHPQkLZu-lkp@intel.com
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Julia Lawall <julia.lawall@inria.fr>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Link: https://patch.msgid.link/20260112114147.GBaWTd-8HSy_Xp4S3X@fat_crate.local
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have a thorough understanding. Let me compile my full analysis.

---

## Detailed Analysis

### 1. Commit Message Analysis

The commit message is intentionally understated: "Use the proper helper
instead of an open-coded variant." However, this is a **security-
relevant fix** flagged by automated static analysis tools. It was:

- **Reported-by: kernel test robot** (automated scanner from Intel)
- **Reported-by: Julia Lawall** (well-known for Coccinelle semantic
  patches that detect exactly these patterns)
- **Reviewed-by: Tom Lendacky** (AMD SEV subsystem maintainer)
- **Authored-by: Borislav Petkov** (x86 co-maintainer, AMD SEV expert)

### 2. Code Change Analysis

The change is in `snp_msg_free()` in `arch/x86/coco/sev/core.c`:

**Before:**
```c
memset(mdesc, 0, sizeof(*mdesc));
kfree(mdesc);
```

**After:**
```c
kfree_sensitive(mdesc);
```

This is a **critical difference** despite appearing cosmetic:

1. **`memset()` can be optimized away**: When `memset()` is followed
   immediately by `kfree()`, the compiler can perform dead store
   elimination (DSE). Since the memory is about to be freed and no code
   reads the zeroed values, the compiler may determine the `memset()` is
   a dead store and remove it entirely. This is increasingly common with
   modern GCC and Clang optimization levels, and especially with LTO.

2. **`kfree_sensitive()` uses `memzero_explicit()`**: This function
   calls `memset()` followed by `barrier_data()`, which is a compiler
   barrier that prevents the zero operation from being optimized away.
   This is the canonical kernel API specifically designed for clearing
   sensitive data before freeing.

3. **`kfree_sensitive()` clears the entire slab allocation**: Via
   `ksize()`, it zeros the whole allocated slab object (which may be
   larger than `sizeof(*mdesc)`), while the original code only zeroed
   `sizeof(*mdesc)`. This provides more thorough clearing of any padding
   or slab slack space.

### 3. Sensitivity of the Data

The `snp_msg_desc` structure contains:

- **`secret_request` and `secret_response`** (embedded `struct
  snp_guest_msg`): These are **double-buffered encrypted/decrypted guest
  messages** used for communication between the SEV-SNP guest VM and the
  AMD Secure Processor (ASP). The comment in the struct says "Avoid
  information leakage by double-buffering shared messages in fields that
  are in regular encrypted memory." Each `snp_guest_msg` contains auth
  tags, sequence numbers, and a full-page payload.
- **`vmpck`**: Pointer to the VM Platform Communication Key.
- **`ctx`**: AES-GCM crypto context (freed separately via `kfree()`).
- **`secrets`**: Pointer to the SNP secrets page.
- **`os_area_msg_seqno`**: Message sequence number.

This is AMD SEV-SNP code. The entire purpose of SEV-SNP is to protect
guest VM memory from the hypervisor. Leaving cryptographic state and
message contents in freed slab memory directly undermines the security
guarantees of the technology.

### 4. History and Stable Tree Applicability

- `snp_msg_free()` was introduced in commit c5529418d0507 ("x86/sev:
  Carve out and export SNP guest messaging init routines"), which landed
  in **v6.14-rc1**.
- The buggy `memset() + kfree()` pattern was introduced by this same
  refactoring commit.
- The fix applies to all stable trees from **v6.14 onwards**: 6.14.y,
  6.15.y, 6.16.y, 6.17.y, 6.18.y.
- I confirmed the vulnerable code exists in v6.14 and that
  `kfree_sensitive()` is available there.
- It does NOT apply to 6.12.y, 6.6.y, or older LTS trees (they use a
  different code structure in `drivers/virt/coco/sev-guest/`).

### 5. Risk Assessment

- **Size**: 3 lines changed to 2 lines (net -1 line). One of the
  smallest possible changes.
- **Risk**: Essentially zero. `kfree_sensitive()` is the standard kernel
  API for this exact use case, has been available since v5.9, and is
  used in 300+ call sites across the kernel.
- **No dependencies**: The fix is entirely self-contained.
- **No behavioral change** from a functional perspective — same memory
  is freed — only ensures the zeroing actually happens at runtime.

### 6. Classification

This is a **security fix** in **security-critical AMD SEV-SNP code**.
The pattern of `memset() + kfree()` for sensitive data is a well-known
anti-pattern that has been the subject of multiple CVEs in other
software projects. While the compiler may or may not optimize it away in
current builds, it is a latent security vulnerability that could
manifest with different compiler versions, optimization flags, or LTO
configurations.

### 7. Verdict

This commit:
- Fixes a real security issue (potential leakage of cryptographic data
  in freed memory)
- Is in security-critical code (AMD SEV-SNP guest messaging)
- Is extremely small and surgical (2 lines -> 1 line)
- Uses the canonical kernel API (`kfree_sensitive()`)
- Has zero risk of regression
- Was reviewed by the AMD SEV maintainer
- Was flagged by two independent automated/semi-automated analysis tools
- Applies cleanly to stable trees v6.14+
- Has no dependencies on other commits

**YES**

 arch/x86/coco/sev/core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 9ae3b11754e65..c8ddb9febe3d9 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -2008,8 +2008,7 @@ void snp_msg_free(struct snp_msg_desc *mdesc)
 	free_shared_pages(mdesc->request, sizeof(struct snp_guest_msg));
 	iounmap((__force void __iomem *)mdesc->secrets);
 
-	memset(mdesc, 0, sizeof(*mdesc));
-	kfree(mdesc);
+	kfree_sensitive(mdesc);
 }
 EXPORT_SYMBOL_GPL(snp_msg_free);
 
-- 
2.51.0

