Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83CEB307ADA;
	Sat, 25 Oct 2025 16:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409490; cv=none; b=XWXjW9sjR4h+t6a/f4WS+GYtym7xFXjaZrBf4dyr0DCtBDJjQdiZDGlZmCsAoaNtjtdQBp5wz4fqfMJXh/49vPac79Pud0K/oQLLMeIrbYz4astR1F1vCrbdAXUgj25x1bB/ke4EwpO22u93o3L2fEy4Mc5DeiqZICbR0hrHVEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409490; c=relaxed/simple;
	bh=nTpHRM+FCEoJ12pwLkMF4yFwFZpMpZd1oLTK9U32Gi8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PTKfPLmNAgIgQABAAu6XVVDq4wUtvmPWXYsUgt48lKOWSRNu+iCiQ7t8uu4eCs0uXLojZuMdraYkhqaCIPZiiYwnlHEeaSRV7Ds7Tf/oZ2dtsTEOw0g2dF5GZJ6+bLIJ2nbtnYeSm+8gLpTCnOh6Cbbuiqq/0AkgRy5X5Rglj8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g/tj2YQG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g/tj2YQG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C644C4CEFB;
	Sat, 25 Oct 2025 16:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409490;
	bh=nTpHRM+FCEoJ12pwLkMF4yFwFZpMpZd1oLTK9U32Gi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g/tj2YQGkcx6RKqIQxvFKhDssTFtDi1f+8U8z4Hwwah8k8pdUP+cYPIifdQvrB22h
	 SgSt9GCUleM7GGToSB9Ov6Hwm/KEPhckGwdmuLMQMbFh3gEq2DYAKJy0PIBAdxfImZ
	 jXoK+BeYlcYZqX5go2bifnZq09NlIvQH3zAtGUV0VJXnq1xKkrKz7tKlnC3gghNpAn
	 eA2DbkPqyDdBA2H0XkyUx3zsMOQUAeKp+MMUlJNnyXigvjFRXMzAcK/6G8yeKDC90m
	 XkT83UNgVI9psZg+MKD/eHnNj5l20SbfwlpTTnXggJ8pi4S5ELdK+CvGLo8yo3Faxz
	 2PrSFiFnlOdxg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Qianfeng Rong <rongqianfeng@vivo.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>,
	jack.xu@intel.com,
	suman.kumar.chakraborty@intel.com,
	alexandre.f.demers@gmail.com
Subject: [PATCH AUTOSEL 6.17-6.6] crypto: qat - use kcalloc() in qat_uclo_map_objs_from_mof()
Date: Sat, 25 Oct 2025 11:59:39 -0400
Message-ID: <20251025160905.3857885-348-sashal@kernel.org>
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

From: Qianfeng Rong <rongqianfeng@vivo.com>

[ Upstream commit 4c634b6b3c77bba237ee64bca172e73f9cee0cb2 ]

As noted in the kernel documentation [1], open-coded multiplication in
allocator arguments is discouraged because it can lead to integer overflow.

Use kcalloc() to gain built-in overflow protection, making memory
allocation safer when calculating allocation size compared to explicit
multiplication.  Similarly, use size_add() instead of explicit addition
for 'uobj_chunk_num + sobj_chunk_num'.

Link: https://www.kernel.org/doc/html/next/process/deprecated.html#open-coded-arithmetic-in-allocator-arguments #1
Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What changed: The allocation in
  drivers/crypto/intel/qat/qat_common/qat_uclo.c:1903 switched from
  open-coded arithmetic to overflow-aware helpers:
  - New: kcalloc(size_add(uobj_chunk_num, sobj_chunk_num),
    sizeof(*mobj_hdr), GFP_KERNEL) at
    drivers/crypto/intel/qat/qat_common/qat_uclo.c:1903.
  - This replaces a prior kzalloc((uobj_chunk_num + sobj_chunk_num) *
    sizeof(*mobj_hdr), GFP_KERNEL) (per diff), eliminating unchecked
    addition and multiplication in the allocator arguments.

- Why it matters: The element count comes directly from MOF-parsed
  headers:
  - Counts are read from the object headers at
    drivers/crypto/intel/qat/qat_common/qat_uclo.c:1896–1901
    (uobj_hdr->num_chunks, sobj_hdr->num_chunks; defined as unsigned
    short in drivers/crypto/intel/qat/qat_common/icp_qat_uclo.h:562).
  - The allocated array is then indexed for each chunk in two loops at
    drivers/crypto/intel/qat/qat_common/qat_uclo.c:1916–1923 and
    1926–1933. If the allocation were undersized due to integer overflow
    in the size calculation, these loops could write past the end of the
    buffer.
  - The MOF data ultimately originates from firmware loaded via
    request_firmware() and passed to qat_uclo_map_obj()
    (drivers/crypto/intel/qat/qat_common/adf_accel_engine.c:67–85,
    93–101), so a malformed or corrupted file can drive these values.
    This makes integer-overflow hardening here security-relevant.

- Why it’s a good stable backport:
  - Bug fix: Prevents potential integer overflow (both addition and
    multiplication) when computing an allocation size from externally
    supplied data. kcalloc() provides built-in multiply overflow
    checking; size_add() prevents addition overflow before the multiply.
  - Minimal and contained: One-line behavioral change in a single
    helper, no API/ABI or architectural changes, same zero-
    initialization semantics as kzalloc.
  - Low regression risk: On valid inputs behavior is unchanged; on
    overflow it now fails cleanly with -ENOMEM at
    drivers/crypto/intel/qat/qat_common/qat_uclo.c:1905, which
    propagates to the existing error paths and cleanup.
  - Subsystem impact: Localized to the Intel QAT firmware loading path;
    does not affect core crypto or memory management.

- Notes for backporting:
  - If a target stable series lacks size_add(), the same safety intent
    can be preserved by using kcalloc(uobj_chunk_num + sobj_chunk_num,
    sizeof(*mobj_hdr), GFP_KERNEL) where the kcalloc() multiply overflow
    check still blocks the dangerous case. Using size_add() is preferred
    when available.

Given the clear safety improvement, tiny scope, and near-zero regression
risk, this is an appropriate candidate for stable backporting.

 drivers/crypto/intel/qat/qat_common/qat_uclo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/qat/qat_common/qat_uclo.c b/drivers/crypto/intel/qat/qat_common/qat_uclo.c
index 21d652a1c8ef3..18c3e4416dc51 100644
--- a/drivers/crypto/intel/qat/qat_common/qat_uclo.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_uclo.c
@@ -1900,7 +1900,7 @@ static int qat_uclo_map_objs_from_mof(struct icp_qat_mof_handle *mobj_handle)
 	if (sobj_hdr)
 		sobj_chunk_num = sobj_hdr->num_chunks;
 
-	mobj_hdr = kzalloc((uobj_chunk_num + sobj_chunk_num) *
+	mobj_hdr = kcalloc(size_add(uobj_chunk_num, sobj_chunk_num),
 			   sizeof(*mobj_hdr), GFP_KERNEL);
 	if (!mobj_hdr)
 		return -ENOMEM;
-- 
2.51.0

