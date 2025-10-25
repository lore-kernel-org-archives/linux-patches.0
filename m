Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 609662FC893;
	Sat, 25 Oct 2025 16:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408990; cv=none; b=i2Jcwt4gAFUif+6hiujAsTE15Xb+Ate13BHmKcZRqdFdmv4dyQPha1Id28Ynxd4K1gTyY0d7vGxaljDutXyJ/GwbYISHZ6D/w+9yF721djutIMYA+VSI5pALXHzmshgi+5gXKg83zWCSSb5EasZqPunaan05kkwbPTrciZUX0f8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408990; c=relaxed/simple;
	bh=4EA5bMaYbTU6sGOO7qq4zllRTdwBpuv6NlEFMW8tDa4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=suRYRaow0uz7P1CKKPPtIQ9l8/W24KSDwqB9urKTzTyp4MPqVb0i9UvUZQ1kMbc1/feBOgEeZlcVmLcTFiy0bgoBxUI5nzwN3jVum9dCyxER22R1bhRH/cHKldneXi6R44k2L/oQh2dTvemfa5Rm+XJNzsvWEQ1TlkIbqPnqJDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eCoY5LYD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eCoY5LYD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86A90C116B1;
	Sat, 25 Oct 2025 16:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408990;
	bh=4EA5bMaYbTU6sGOO7qq4zllRTdwBpuv6NlEFMW8tDa4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eCoY5LYDMsd6dOelFJl99eKwGf2rfXcaPmywB69ltc7d6KVTK6lWbSZAoKreMpLLE
	 yDfvN5/wPMd+/MThoBxaVCxaAc6+efRn/WY7dVEkuJOOuqXBTyeqML7aBIF+xG6usG
	 YzND/S2VYA5Uyq8LxlE8mv2TrSuU8M/WHStw/a2FvoNvAVktzIqTyo74xkC6C1nwJf
	 QrqmpMIr3nJNrnxgD5rxbzTcX497KtMewBR9HFXah/wsexvBUk96h6MLfyECrPt50W
	 H+0gv0qN3M0MB1pmSOQo7IcWHbMP3GTmK27PlAYiMTYIkSDNJtr8hhvfk37C7kploI
	 SCBOfId+K/eOQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Zijun Hu <zijun.hu@oss.qualcomm.com>,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 6.17-5.4] char: misc: Does not request module for miscdevice with dynamic minor
Date: Sat, 25 Oct 2025 11:56:35 -0400
Message-ID: <20251025160905.3857885-164-sashal@kernel.org>
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

From: Zijun Hu <zijun.hu@oss.qualcomm.com>

[ Upstream commit 1ba0fb42aa6a5f072b1b8c0b0520b32ad4ef4b45 ]

misc_open() may request module for miscdevice with dynamic minor, which
is meaningless since:

- The dynamic minor allocated is unknown in advance without registering
  miscdevice firstly.
- Macro MODULE_ALIAS_MISCDEV() is not applicable for dynamic minor.

Fix by only requesting module for miscdevice with fixed minor.

Acked-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Signed-off-by: Zijun Hu <zijun.hu@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250714-rfc_miscdev-v6-6-2ed949665bde@oss.qualcomm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What it fixes
  - Prevents meaningless module autoload attempts for misc devices with
    dynamically assigned minors. Such modules cannot advertise a stable
    alias, so `request_module("char-major-10-<minor>")` can never match
    them. This avoids pointless usermode helper invocations and
    potential delays or log noise when opening such device nodes.

- Code-level analysis
  - Current behavior: In `misc_open()` the code unconditionally requests
    a module if no matching `miscdevice` is found on first lookup, then
    retries the lookup (drivers/char/misc.c:118,
    drivers/char/misc.c:135–149).
  - Change: Only request a module when the minor is a fixed, known
    value; i.e., add a guard `minor < MISC_DYNAMIC_MINOR` around the
    autoload attempt, and move the final “not found” check outside the
    block so logic remains identical otherwise. The semantic change is
    that no autoload is attempted for dynamic minors.
  - Rationale supported by headers:
    - `MISC_DYNAMIC_MINOR` is a sentinel 255
      (include/linux/miscdevice.h:74). Dynamic minors are allocated from
      `MISC_DYNAMIC_MINOR + 1` upward (drivers/char/misc.c:65–76), so
      they are unknown until registration and cannot be known in advance
      of module load.
    - `MODULE_ALIAS_MISCDEV(minor)` expands to a fixed `char-
      major-10-<minor>` alias (include/linux/miscdevice.h:105–107). It
      cannot be used for dynamically assigned minors (which aren’t
      constant at build time). Thus, `request_module("char-major-%d-%d",
      MISC_MAJOR, minor)` (drivers/char/misc.c:137) can never succeed
      for dynamic minors.
  - Correctness of control flow:
    - After patch, if `new_fops` is still NULL, the function immediately
      fails with `-ENODEV`, just as it did before when autoload didn’t
      resolve the device. Moving the `if (!new_fops) goto fail;` outside
      the conditional preserves behavior for fixed-minor flows and
      removes only the futile autoload for dynamic minors.

- User impact
  - Eliminates unnecessary invocations of modprobe/kmod when opening
    stale or handcrafted device nodes with dynamic minors. This reduces
    latency and log spam without changing any successful open path for
    valid misc devices.

- Security considerations
  - Reduces the surface for unintended autoloading by user-triggered
    opens of arbitrary `char-major-10-<large minor>` device nodes where
    no legitimate alias can exist. While not a direct vulnerability fix,
    it narrows pointless autoloading opportunities.

- Scope and risk
  - Small, localized change in `drivers/char/misc.c::misc_open()`
    (drivers/char/misc.c:118). No ABI/API changes. No architectural
    changes.
  - Only affects the autoload attempt for “not found” cases; normal open
    paths (where the `miscdevice` is registered) are unchanged.
  - Fixed-minor devices keep working as before because the autoload
    remains in place for minors `< MISC_DYNAMIC_MINOR`.

- Stable backport criteria
  - Fixes a real, user-visible misbehavior (unnecessary autoload
    attempts) with potential performance/log impact.
  - Minimal, well-scoped change to a mature code path.
  - No new features; purely a behavioral correction for an edge case.
  - Acknowledged and merged by subsystem maintainer; Signed-off-by Greg
    Kroah-Hartman indicates upstream acceptance.
  - Applies cleanly across stable series; `misc_open()` and the related
    defines/macros are long-stable and consistent.

- Conclusion
  - Recommended for backport: it’s a safe, contained fix that prevents
    futile module requests for dynamic minors and aligns behavior with
    the documented aliasing mechanism for misc devices.

 drivers/char/misc.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/char/misc.c b/drivers/char/misc.c
index 255a164eec86d..4c276b8066ff8 100644
--- a/drivers/char/misc.c
+++ b/drivers/char/misc.c
@@ -132,7 +132,8 @@ static int misc_open(struct inode *inode, struct file *file)
 		break;
 	}
 
-	if (!new_fops) {
+	/* Only request module for fixed minor code */
+	if (!new_fops && minor < MISC_DYNAMIC_MINOR) {
 		mutex_unlock(&misc_mtx);
 		request_module("char-major-%d-%d", MISC_MAJOR, minor);
 		mutex_lock(&misc_mtx);
@@ -144,10 +145,11 @@ static int misc_open(struct inode *inode, struct file *file)
 			new_fops = fops_get(iter->fops);
 			break;
 		}
-		if (!new_fops)
-			goto fail;
 	}
 
+	if (!new_fops)
+		goto fail;
+
 	/*
 	 * Place the miscdevice in the file's
 	 * private_data so it can be used by the
-- 
2.51.0

