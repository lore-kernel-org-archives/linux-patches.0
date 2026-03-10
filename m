Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA43346AEFA;
	Tue, 10 Mar 2026 09:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773133352; cv=none; b=H+FpX+Nc066q27V2jiWRZ6xkiFWI3Dxv7DQz0H7J1m1569nr4tYgih+juNtiwUy7SRQfcV37kmkgoFAF4tSBBhbLDxC/tn9wc37y97n7IkEWZbs1VgFodwjx+NgVTIQBgXIV/wgAihCnBji/bJlTAoav7O6WCy8ipgUC2hRKr8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773133352; c=relaxed/simple;
	bh=TgJ28ZB9y41IT6jdJ16OAYYVcd9wSY24fXvEnxIyItE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A8LphLgbMMFt5wMw9yEfd5i79fzRIzUQbOVemCcS7ecG6lWqz+oyfZZT1ScBET7WrlabXguVptxFGy8L1awiQ71td6DYsPX3ZwEa1eHvAHSaaSFnV91TQddeUgVDrn/Y5Zypot7RaJ115iSwILLDor6xJtlAcYb8xLhxV1c4rJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RVTdaBgQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RVTdaBgQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D55AEC19423;
	Tue, 10 Mar 2026 09:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773133352;
	bh=TgJ28ZB9y41IT6jdJ16OAYYVcd9wSY24fXvEnxIyItE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RVTdaBgQc/r39czwNxV94gwflU8T7MyKY7ymiGa/VlZV+WlzipzzUI5TgtmHV4bqi
	 rXd0YemtQZbUfcO4PyXlnHRMvnf15xsPNX5rl9AnbcC/ni/Go0PgNvjPP8dYp9R/b9
	 2+SGwy0eYFJqUUelKLjyL7hhJsAuOSb5MikMniTmFEMEwLz2TUqCsVVIrHsp9kF9xs
	 RTxXajHoznyNfb3cyAxdYvhMiBX535K4pBR4dYPbXUA1okzNREckCtUTDQHkF60B5X
	 uStuPHbr/+UPQP86dZ+C1aFxt4adqB4VJWbPySGU9HGxagFHZcTnwTwI/uPIvjCAoD
	 3VaDFgXUkmglQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Anton Plotnikov <plotnikovanton@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	hansg@kernel.org,
	platform-driver-x86@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19] platform/x86: hp-wmi: add Omen 14-fb1xxx (board 8E41) support
Date: Tue, 10 Mar 2026 05:01:32 -0400
Message-ID: <20260310090145.2709021-32-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260310090145.2709021-1-sashal@kernel.org>
References: <20260310090145.2709021-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.6
Content-Transfer-Encoding: 8bit

From: Anton Plotnikov <plotnikovanton@gmail.com>

[ Upstream commit 729ffcffa73069cb066fd54a2bc7b09e5f782d48 ]

Reverse engineering of the HP Omen Windows utility shows that for performance
mode it uses the same codes listed in hp_thermal_profile_omen_v1. Therefore it
seems sufficient to add the board model name to omen_thermal_profile_boards.

Tested on Omen 14-fb1xxx: CPU power in performance profile reaches the Windows
limit (65W), instead of 45W in automatic BIOS mode. Max fan speed was reached
as well.

Link: https://patch.msgid.link/20260203164832.40514-1-plotnikovanton@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis

### What the commit does
This is a one-line addition of a board ID string `"8E41"` to the
`omen_thermal_profile_boards[]` array in the HP WMI driver. This enables
thermal profile support (performance mode, fan control) for the HP Omen
14-fb1xxx laptop using existing v1 thermal profile code paths.

### Classification: Device ID Addition
This falls squarely into the **"NEW DEVICE IDs"** exception category for
stable backports. The driver and all thermal profile infrastructure
already exist — this simply adds a board identifier so the existing code
recognizes this specific hardware model.

### Risk Assessment
- **Scope**: Single string added to a `const char *` array — cannot get
  simpler
- **Blast radius**: Only affects systems with DMI board name "8E41" (HP
  Omen 14-fb1xxx)
- **Regression potential**: Essentially zero — if the board ID doesn't
  match, nothing changes for any other system
- **Testing**: Explicitly tested by the author on the target hardware,
  confirmed working (65W CPU power, max fan speed)

### User Impact
Without this entry, HP Omen 14-fb1xxx users get stuck at 45W CPU power
in automatic BIOS mode instead of the full 65W performance profile. This
means the hardware doesn't function at its intended capability under
Linux.

### Review Status
- Reviewed-by and signed-off by Ilpo Järvinen (Intel), who is the
  platform/x86 maintainer
- The approach was validated through reverse engineering the Windows
  Omen Command Center utility

### Stable Criteria Check
- **Obviously correct**: Yes — adding a string to an existing board list
- **Fixes a real issue**: Yes — enables hardware to function properly
- **Small and contained**: Yes — one line, one file
- **No new features**: Correct — uses existing thermal profile v1
  infrastructure
- **No new APIs**: Correct

### Verification
- Read the diff directly: confirmed it's a single string `"8E41"` added
  to the `omen_thermal_profile_boards` array at line 149 of
  `drivers/platform/x86/hp/hp-wmi.c`
- The commit message explicitly states testing results on the target
  hardware
- The array is used to match DMI board names to enable existing omen
  thermal profile code paths — no new code paths are introduced
- Reviewed-by tag from subsystem maintainer Ilpo Järvinen confirms
  correctness

### Conclusion
This is a textbook device ID addition — the simplest and lowest-risk
category of stable backport. It enables proper hardware functionality
for a specific laptop model using entirely existing driver
infrastructure. The risk is negligible, the benefit is real for affected
users, and it has maintainer review.

**YES**

 drivers/platform/x86/hp/hp-wmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/hp/hp-wmi.c b/drivers/platform/x86/hp/hp-wmi.c
index bc550da031fa1..ec87fd96686cf 100644
--- a/drivers/platform/x86/hp/hp-wmi.c
+++ b/drivers/platform/x86/hp/hp-wmi.c
@@ -133,6 +133,7 @@ static const char * const omen_thermal_profile_boards[] = {
 	"8900", "8901", "8902", "8912", "8917", "8918", "8949", "894A", "89EB",
 	"8A15", "8A42",
 	"8BAD",
+	"8E41",
 };
 
 /* DMI Board names of Omen laptops that are specifically set to be thermal
-- 
2.51.0

