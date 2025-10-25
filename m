Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1553C302756;
	Sat, 25 Oct 2025 16:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408601; cv=none; b=IeZGKuQTYEtnZKMYommK7OXxi7IAtziRkaNcRprZ0sP0LFJ9QyyXuJJTTr/PSmtvOHp0HzJ5Yyjlrj7rn2jmHxIrBj3bN6uQ7zawAlN+a7AHP/kDBQBwq2c9qoC2OZTB/X4DoyZQPx8hoo2jKGc/PWy80NwN4S8pMD6DkFhP730=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408601; c=relaxed/simple;
	bh=tr6NjjIal2jilq05rVtA3iF3OIIGZzWQ0daOnxfd4G0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VHusQ+Rwe42o0tcWkKLsgnPNSFyVgV32dstH/X1MJiVEzqdJpcUyCiuo1akM3k4EqyHzJJ7QGjI+TZGLXxAMTkc3MUtW5YJmYJGYNP5IUZVrEf/PySIswwKOiojRCT3c+g+At82+SWIBjXScWLXqyDbrS/J5bmjEOg27hWOLz68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dVhaIAbL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dVhaIAbL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4E0BC4CEF5;
	Sat, 25 Oct 2025 16:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408600;
	bh=tr6NjjIal2jilq05rVtA3iF3OIIGZzWQ0daOnxfd4G0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dVhaIAbL2XkwvtEHX3S8ZqNnvM1g9MZTgFtW456ZJR/GcKIKkRZ2NzfiglzvBfxGw
	 XNx8NlkVZCi1U421yR1lnSu1hoVLTzVgyMOuSoWLHrVQR0a1KVq0PWTMdYqrXAj1N9
	 B8LaqBQvoEqsEaMCN7YuyR17mG6QvG1TnmSCPhqBzFqucNgJnLlr15Z+WgIcoFehUM
	 OcV2rWEuZASdEEDMzocrZLaE3KbkIRMPtdmzuP7BBxhZo1uUl/VX0g2/n00OQVZZC5
	 hPJReX0VI4HxfK7ywzzMOXOvIWfxqfXHT4m2xCqigKmIpBCRL8b3Tb87wERnvz++S9
	 lLOE4yANIgTZg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Rob Clark <robin.clark@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>,
	alexander.deucher@amd.com,
	viswanath.kraleti@oss.qualcomm.com,
	bruce.ashfield@gmail.com,
	alexandre.f.demers@gmail.com,
	reatmon@ti.com
Subject: [PATCH AUTOSEL 6.17-6.12] drm/msm/registers: Generate _HI/LO builders for reg64
Date: Sat, 25 Oct 2025 11:54:09 -0400
Message-ID: <20251025160905.3857885-18-sashal@kernel.org>
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

From: Rob Clark <robin.clark@oss.qualcomm.com>

[ Upstream commit 60e9f776b7932d67c88e8475df7830cb9cdf3154 ]

The upstream mesa copy of the GPU regs has shifted more things to reg64
instead of seperate 32b HI/LO reg32's.  This works better with the "new-
style" c++ builders that mesa has been migrating to for a6xx+ (to better
handle register shuffling between gens), but it leaves the C builders
with missing _HI/LO builders.

So handle the special case of reg64, automatically generating the
missing _HI/LO builders.

Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/673559/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What it fixes: The msm register header generator didn’t emit C
  “builder” helpers with _LO/_HI suffixes for 64-bit registers defined
  via <reg64>. The driver code relies on those helpers when writing the
  lower/upper 32-bit halves separately. For example, the a6xx ring
  programming uses CP_WAIT_REG_MEM_POLL_ADDR_LO/HI in
  drivers/gpu/drm/msm/adreno/a6xx_gpu.c:296–301 and
  CP_SMMU_TABLE_UPDATE_0_TTBR0_LO / CP_SMMU_TABLE_UPDATE_1_TTBR0_HI in
  drivers/gpu/drm/msm/adreno/a6xx_gpu.c:254–258. When the XML defines
  these as <reg64>, the generator previously did not create matching
  _LO/_HI helpers, which leads to missing symbols at build time.

- Change scope and mechanism:
  - Tracks the register bit width in the bitset object by wiring the
    current reg into the bitset:
    - Add `self.reg = None` to Bitset
      (drivers/gpu/drm/msm/registers/gen_header.py:164).
    - Assign it in the parser when constructing a register/bitset pair
      so the bitset knows its register size
      (drivers/gpu/drm/msm/registers/gen_header.py:652–655).
  - Emits pass-through _LO/_HI builders for 64-bit registers:
    - In Bitset.dump(), if the associated register is 64-bit, generate:
      - `static inline uint32_t <prefix>_LO(uint32_t val) { return val;
        }`
      - `static inline uint32_t <prefix>_HI(uint32_t val) { return val;
        }`
      - See drivers/gpu/drm/msm/registers/gen_header.py:270–274.
  - These identity builders match how call sites are used: callers pass
    `lower_32_bits(...)` or `upper_32_bits(...)`, or a literal low/high
    value, and the builder for each 32-bit half should be a no-op
    bitpack.

- Why it’s suitable for stable:
  - Small and contained: One file change (the code generator) with a
    simple conditional emission of two inline helpers per 64-bit reg.
  - Risk is minimal: It does not alter runtime code paths; it only
    changes the generated headers to add missing helpers. Existing non-
    reg64 code paths are untouched.
  - Fixes a concrete build/use issue: Current XMLs in the msm tree
    define several registers as <reg64> (e.g., CP_WAIT_REG_MEM has a
    reg64 POLL_ADDR in
    drivers/gpu/drm/msm/registers/adreno/adreno_pm4.xml:1515), and
    driver code uses the _LO/_HI builders in functions like
    a6xx_gpu_init() paths
    (drivers/gpu/drm/msm/adreno/a6xx_gpu.c:296–301). Without these
    helpers, builds break or require code churn to avoid the builders.
  - No architectural changes or feature add: It’s purely a
    compatibility/interop fix between the XML register descriptions and
    the C builder users, aligning the C generator with the already-
    supported C++ builders.

- Notes on side effects:
  - The new helpers are only emitted for 64-bit registers, so they don’t
    collide with existing field-level macros for reg32.
  - The helpers are identity functions by design, which is correct for
    writing the discrete 32-bit halves of a 64-bit register pair (call
    sites already pass the lower/upper 32-bit values).
  - If the affected XMLs are not present in a given stable branch, this
    change remains harmless and inert.

Given the above, this is a low-risk, build-enabling fix that aligns the
generator with the register XMLs and the msm driver’s C callers.
Backporting is appropriate.

 drivers/gpu/drm/msm/registers/gen_header.py | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/msm/registers/gen_header.py b/drivers/gpu/drm/msm/registers/gen_header.py
index a409404627c71..6a6f9e52b11f7 100644
--- a/drivers/gpu/drm/msm/registers/gen_header.py
+++ b/drivers/gpu/drm/msm/registers/gen_header.py
@@ -150,6 +150,7 @@ class Bitset(object):
 	def __init__(self, name, template):
 		self.name = name
 		self.inline = False
+		self.reg = None
 		if template:
 			self.fields = template.fields[:]
 		else:
@@ -256,6 +257,11 @@ class Bitset(object):
 	def dump(self, prefix=None):
 		if prefix == None:
 			prefix = self.name
+		if self.reg and self.reg.bit_size == 64:
+			print("static inline uint32_t %s_LO(uint32_t val)\n{" % prefix)
+			print("\treturn val;\n}")
+			print("static inline uint32_t %s_HI(uint32_t val)\n{" % prefix)
+			print("\treturn val;\n}")
 		for f in self.fields:
 			if f.name:
 				name = prefix + "_" + f.name
@@ -620,6 +626,7 @@ class Parser(object):
 
 		self.current_reg = Reg(attrs, self.prefix(variant), self.current_array, bit_size)
 		self.current_reg.bitset = self.current_bitset
+		self.current_bitset.reg = self.current_reg
 
 		if len(self.stack) == 1:
 			self.file.append(self.current_reg)
-- 
2.51.0

