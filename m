Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42ACE21CFEF;
	Sat, 14 Feb 2026 01:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031194; cv=none; b=I08YOTEoc+GP0UkcZLPplxx22aSaC4MvKrzXJk4+8HeuuASXz9lcq2zdSE6LZMgq9rDm1VdcSfD0Xt5duoYoG6QZmoZF8k3ceFiKJJK6x34oPYIT2hazTsylH8y3TFoPAWV2ht3rMOznZYtac6kH+Xj4VQKj3GCLO348jhYAs5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031194; c=relaxed/simple;
	bh=7hMeVkvsA0gGwoVYMGwgHvrV7O2gLPrQILkoi1Ws+eo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gHYdGqWH4OVqfpVz4CP8tq+0aOYZTkLBjYYRkJbLcyEOjNDYBWzb7cvq9vIj52e/e67rfDu+ZeU+9xXHDFmyxeO4r8p78zIYFp+CpAGSy7h7EOMt22btpzrEnp2KusBpb5Akq11ayaQZ2h2LVIJ2JPTxVfK3fFvCxN0YGHCrFw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MKccyw60; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MKccyw60"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EC5FC116C6;
	Sat, 14 Feb 2026 01:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771031194;
	bh=7hMeVkvsA0gGwoVYMGwgHvrV7O2gLPrQILkoi1Ws+eo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MKccyw607povjPZOjDggncofGiSD5iUBUaVys13+FtOFBP5Lmc5vBf87IpxqHun/f
	 B2d0kEU00phF/5eJXqAquhWBI/TdU0PfS3qsIVA3otxpaeE58mNYPmFdWJsOQQW3+e
	 sW+8h6Ap+ewxnu26WrTfqpkIbyCM2F/0q0JsYjqb85ueY+PF86sZkfIfPwUsiVHSz8
	 iBzZ/S2zqYh3A+PZskelHx7xJ7t5q1by9EJS7X0lLmFbaJgdDXYAKonX7+2x+MAbqu
	 qnZLlcT7O/eMYjCnznWQvovK0pni50dgu4ZZKzSv3ojhQ+146lElw/ZwGz6wKmNiOt
	 RBiBK57Sc8aag==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Denis Pauk <pauk.denis@gmail.com>,
	Marcus <shoes2ga@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>,
	linux-hwmon@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.6] hwmon: (nct6775) Add ASUS Pro WS WRX90E-SAGE SE
Date: Fri, 13 Feb 2026 19:59:36 -0500
Message-ID: <20260214010245.3671907-96-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214010245.3671907-1-sashal@kernel.org>
References: <20260214010245.3671907-1-sashal@kernel.org>
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

From: Denis Pauk <pauk.denis@gmail.com>

[ Upstream commit 246167b17c14e8a5142368ac6457e81622055e0a ]

Boards Pro WS WRX90E-SAGE SE has got a nct6775 chip, but by default there's
no use of it because of resource conflict with WMI method.

Add the board to the WMI monitoring list.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=204807
Signed-off-by: Denis Pauk <pauk.denis@gmail.com>
Tested-by: Marcus <shoes2ga@gmail.com>
Link: https://lore.kernel.org/r/20251231155316.2048-1-pauk.denis@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis

### Commit Message Analysis
This commit adds a board identifier string ("Pro WS WRX90E-SAGE SE") to
the `asus_msi_boards[]` list in the nct6775 hwmon driver. The commit
message explains that this ASUS motherboard has an nct6775 hardware
monitoring chip, but it cannot be used by default due to a resource
conflict with WMI methods. Adding the board to the WMI monitoring list
resolves this conflict and enables hardware monitoring.

### Code Change Analysis
The change is a **single line addition** — inserting one string into an
alphabetically sorted list of board names:

```c
"Pro WS WRX90E-SAGE SE",
```

This is inserted between "Pro WS W790E-SAGE SE" and "ProArt
B650-CREATOR", maintaining alphabetical order. No logic changes, no new
functions, no structural modifications.

### Classification: Hardware Quirk / Device ID Addition
This falls squarely into the **"hardware quirks/workarounds"** exception
category for stable backports. The `asus_msi_boards[]` list is
effectively a board-level quirk table that tells the driver to use WMI-
based monitoring instead of direct I/O, resolving the resource conflict.
Without this entry, users of this specific motherboard cannot use
hardware monitoring at all.

### Stability Indicators
- **Tested-by:** Marcus confirmed the fix works on the actual hardware
- **Bug report link:**
  https://bugzilla.kernel.org/show_bug.cgi?id=204807 — this is a
  documented real-world issue
- **Reviewed and merged by:** Guenter Roeck, the hwmon subsystem
  maintainer
- **Pattern:** Identical to dozens of other board additions in this same
  file that have been backported to stable

### Risk Assessment
- **Risk: Extremely low.** Adding a string to a board match list cannot
  affect any other board or any other code path. The match is exact —
  only the "Pro WS WRX90E-SAGE SE" board is affected.
- **Scope:** Single line in a single file
- **Dependencies:** None — the WMI monitoring infrastructure already
  exists in stable trees
- **Regression potential:** Essentially zero

### User Impact
Without this fix, users of the ASUS Pro WS WRX90E-SAGE SE motherboard (a
workstation-class board) have no hardware monitoring capability. This is
a real user-reported bug (kernel bugzilla #204807) with a tested fix.

### Stable Criteria Check
1. **Obviously correct and tested:** Yes — single string addition,
   tested by user
2. **Fixes a real bug:** Yes — hardware monitoring doesn't work without
   it
3. **Important issue:** Yes — complete loss of hwmon functionality for
   this board
4. **Small and contained:** Yes — one line
5. **No new features:** Correct — enables existing functionality on
   specific hardware
6. **Applies cleanly:** Very likely — it's a simple list insertion

**YES**

 drivers/hwmon/nct6775-platform.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hwmon/nct6775-platform.c b/drivers/hwmon/nct6775-platform.c
index c3a719aef1ace..555029dfe713f 100644
--- a/drivers/hwmon/nct6775-platform.c
+++ b/drivers/hwmon/nct6775-platform.c
@@ -1357,6 +1357,7 @@ static const char * const asus_msi_boards[] = {
 	"Pro WS W680-ACE IPMI",
 	"Pro WS W790-ACE",
 	"Pro WS W790E-SAGE SE",
+	"Pro WS WRX90E-SAGE SE",
 	"ProArt B650-CREATOR",
 	"ProArt B660-CREATOR D4",
 	"ProArt B760-CREATOR D4",
-- 
2.51.0

