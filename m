Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3150D1F12F8;
	Sat, 25 Oct 2025 16:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408937; cv=none; b=ZByokkoIT/6xGfOZc6IpIkGdUrYaYxSyLpTDyr90Sjg+SCfITtBfBZuZwM3W00OHGA8UyCAymPDg+bEgJZN8reuAfaBU5JkkL6sY7IGNKNhdREzWkxN4iPl4mkkoJknmfVVvz6Ft+da38bpYuar6rmGSeVd6YjXG/vwW8KKIOTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408937; c=relaxed/simple;
	bh=4FdEqkgIw2ja8qYOelOp6m1us7ZJTTKkOMzOaCdIfQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SHC7UI7KPnKdR7awWObCJY1Req0NZxIh3c7/ylgZilBhDuWYVqrks6gWKb+r2UdsQ6vxAW+KgcjnPI8aIOIcI5fdrCiO4JRAAT2VdU9gnaVoS3K9s9sP+jzJegnSCbhBahqR7kbwd9HutTsjuZMFaS8F33ylDnHDfb0zUwm8Ui8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SsE8yVaw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SsE8yVaw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FDA7C4CEFB;
	Sat, 25 Oct 2025 16:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408937;
	bh=4FdEqkgIw2ja8qYOelOp6m1us7ZJTTKkOMzOaCdIfQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SsE8yVawlaJtqeZIT1QlplLZ4272B6PCP5v0cEs/p96tuQjdogpuZ9uunLMvUpm4M
	 Wh6/+6RGRaVxGrmAa9VdlUzjhc8AJ0+ffwenSUNCxjaCfIjQGWlozPQrTG1fDscVRT
	 +lQK2i/hO4kKBgzwSh5SBYQaLFgmbs3ULx+9U2qGM05egZWQwe6/Oo1PbPdE5yvda6
	 Ue/CWbzei/W9wvbvQCJFD1VZ5kGmyDdUepAhIHZF61Yv5wLn2ciAnjqLyPPjF8YLkE
	 /zNcCDWY6SzXYSP0Ep6RxbjmkX0psnD6k69zXnyeobvGdKanOuXhsaOJGD7iLehN9p
	 /Mw+Ug39UaXlQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: chenmiao <chenmiao.ku@gmail.com>,
	Stafford Horne <shorne@gmail.com>,
	Sasha Levin <sashal@kernel.org>,
	alexander.deucher@amd.com,
	alexandre.f.demers@gmail.com
Subject: [PATCH AUTOSEL 6.17-6.12] openrisc: Add R_OR1K_32_PCREL relocation type module support
Date: Sat, 25 Oct 2025 11:56:11 -0400
Message-ID: <20251025160905.3857885-140-sashal@kernel.org>
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

From: chenmiao <chenmiao.ku@gmail.com>

[ Upstream commit 9d0cb6d00be891586261a35da7f8c3c956825c39 ]

To ensure the proper functioning of the jump_label test module, this patch
adds support for the R_OR1K_32_PCREL relocation type for any modules. The
implementation calculates the PC-relative offset by subtracting the
instruction location from the target value and stores the result at the
specified location.

Signed-off-by: chenmiao <chenmiao.ku@gmail.com>
Signed-off-by: Stafford Horne <shorne@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What it fixes
  - Adds missing relocation handling for OpenRISC modules:
    `R_OR1K_32_PCREL` now computes a proper PC-relative value, enabling
    modules that use this relocation (e.g., the jump_label test module)
    to load and run correctly.
  - Before this change, such relocations fell into the default case and
    were left un-applied while only logging an error, which risks
    loading a broken module without failing the load explicitly (see
    `arch/openrisc/kernel/module.c:72` and the unconditional `return 0`
    at `arch/openrisc/kernel/module.c:79`).

- Change details
  - New case computes S + A − P for 32-bit PC-relative relocations and
    writes the result directly:
    - `arch/openrisc/kernel/module.c:58`: `case R_OR1K_32_PCREL:`
    - `arch/openrisc/kernel/module.c:59`: `value -= (uint32_t)location;`
    - `arch/openrisc/kernel/module.c:60`: `*location = value;`
  - This mirrors established semantics for 32-bit PC-relative
    relocations, consistent with other architectures’ module loaders
    (e.g., `arch/hexagon/kernel/module.c:132` uses `*location = value -
    (uint32_t)location;`).
  - It fits alongside existing relocation handling already present for
    OpenRISC:
    - Absolute 32-bit relocations written directly
      (`arch/openrisc/kernel/module.c:42`).
    - Branch-style PC-relative relocations (`R_OR1K_INSN_REL_26`) that
      subtract P, then encode into a 26-bit field
      (`arch/openrisc/kernel/module.c:51`–`56`).
    - Other recently added relocations such as `R_OR1K_AHI16` and
      `R_OR1K_SLO16` (`arch/openrisc/kernel/module.c:62`–`71`).

- Impact and scope
  - The change is small and contained to a single switch case in the
    OpenRISC module loader (`arch/openrisc/kernel/module.c`).
  - It only affects module relocation handling, which is invoked during
    module loading via the generic path in `kernel/module/main.c:1617`
    (SHT_RELA → `apply_relocate_add`).
  - No API or architectural changes; no effect on other subsystems or
    architectures.

- Risk assessment
  - Very low risk:
    - The operation is a straightforward, canonical PC-relative
      computation (S + A − P).
    - It aligns with existing patterns for other architectures and with
      OpenRISC’s own existing PC-relative branch relocation handling.
  - High user value for OpenRISC users:
    - Fixes module load-time correctness for modules emitting
      `R_OR1K_32_PCREL`, including the jump_label test module.

- Backport considerations
  - Suitable for stable: it’s a clear bug fix, minimal, and
    architecture-local.
  - If older stable trees predate `R_OR1K_*` relocation renaming, the
    backport may need to map to the legacy names; otherwise the change
    is mechanically the addition of this single case.

Conclusion: This is a small, targeted, correctness fix to the OpenRISC
module loader that prevents silently broken module loads and aligns with
standard relocation semantics. It should be backported.

 arch/openrisc/kernel/module.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/openrisc/kernel/module.c b/arch/openrisc/kernel/module.c
index c9ff4c4a0b29b..4ac4fbaa827c1 100644
--- a/arch/openrisc/kernel/module.c
+++ b/arch/openrisc/kernel/module.c
@@ -55,6 +55,10 @@ int apply_relocate_add(Elf32_Shdr *sechdrs,
 			value |= *location & 0xfc000000;
 			*location = value;
 			break;
+		case R_OR1K_32_PCREL:
+			value -= (uint32_t)location;
+			*location = value;
+			break;
 		case R_OR1K_AHI16:
 			/* Adjust the operand to match with a signed LO16.  */
 			value += 0x8000;
-- 
2.51.0

