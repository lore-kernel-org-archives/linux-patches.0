Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 101E919ABD8;
	Tue, 10 Feb 2026 23:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770766306; cv=none; b=j3+hLj42kX5xyZVUpl0iPfPYPtIid6EdkujANAeeT1GuaJM7tkLPfujF9cdPn/Zxt9pgMkMBN+Cdwa5TblmL9Ki91/OON9yH8tFYeaXZ/6yT/TiX65Dmq6I9yzdgQReHK/ZI6BRHdNskV7rGyEZ+ALljyowleQpI3Dk4iO45dao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770766306; c=relaxed/simple;
	bh=/SRKDlsP60o49QdkRulsXH0sePgm68ETyIi5yUqNtpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XGzYUQSK6mcmhRwc/j3U7vwn2D/J11oHfhjMdDd+d82rbQh1gd+KWMic+uWlrsep0IroSS43LotCiUMEdBKSw5Qe/SyC6WQVjyouHcE1ucXAGg2Fg9+gbNyd2QjBUTnMqxLdmWEDY+Nr+sRM4bvhTiq6xzpnhN28C4gYNbK4MOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YzXfrwZS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YzXfrwZS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DF81C116C6;
	Tue, 10 Feb 2026 23:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770766305;
	bh=/SRKDlsP60o49QdkRulsXH0sePgm68ETyIi5yUqNtpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YzXfrwZSXf4VoAXiTEiNB65WGr3lohLUUui1Ida2b/wtar2IKGl5V9yo0czRY/ZZN
	 r3dYtIrqi/8ITHkZRr7Vb4aJ7UYAycNWXo9aVDTpPx4e1jNm67e0OV8U0V/P0w1SrF
	 S5o3JfF1LU0Aeu3BFep5Ctyz1rwcq32tOzy9gmg1paf4qmq7ebQghnlN/pelOg7VpR
	 bdZhJcH5KDdqyElsEKbIEOlBtNW3R/6mB/mub8wzLb3kugsgfyfRr4F+Tvd2isU5Tn
	 s+1Pj3BgRw7FUBH9j83EanU/3ZTzEbPXCKi4qqccOCiUoQfPHgyc8PyEOPbeCEfA7r
	 MdzZAU6zgNtJA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>,
	jarkko.nikula@linux.intel.com
Subject: [PATCH AUTOSEL 6.19-6.18] i3c: mipi-i3c-hci: Stop reading Extended Capabilities if capability ID is 0
Date: Tue, 10 Feb 2026 18:30:58 -0500
Message-ID: <20260210233123.2905307-13-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260210233123.2905307-1-sashal@kernel.org>
References: <20260210233123.2905307-1-sashal@kernel.org>
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

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 0818e4aa8fdeeed5973e0a8faeddc9da599fc897 ]

Extended Capability ID value 0 is special.  It signifies the end of the
list.  Stop reading Extended Capabilities if capability ID is 0.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260106164416.67074-3-adrian.hunter@intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have a complete picture. Let me summarize the analysis.

---

## Detailed Analysis

### 1. COMMIT MESSAGE ANALYSIS

The subject is: "i3c: mipi-i3c-hci: Stop reading Extended Capabilities
if capability ID is 0"

The message clearly explains: **Extended Capability ID value 0 is
special. It signifies the end of the list.** This is consistent with how
hardware capability lists work in general (PCI uses the same convention,
as confirmed by the PCI extended capability parsing code at
`drivers/pci/pci.h:170` which checks `if (__header == 0) break;`).

The commit is authored by **Adrian Hunter** (Intel), a prolific and
highly respected kernel developer, and was reviewed by **Frank Li**
(NXP), another I3C subsystem contributor. It was accepted by the I3C
subsystem maintainer **Alexandre Belloni**.

### 2. CODE CHANGE ANALYSIS

The change is a single-line modification:

```275:276:drivers/i3c/master/mipi-i3c-hci/ext_caps.c
                if (!cap_length)
                        break;
```

becomes:

```c
                if (!cap_id || !cap_length)
                        break;
```

**What was wrong:** The `i3c_hci_parse_ext_caps()` function walks a
linked list of Extended Capabilities stored in MMIO register space. Per
the MIPI I3C HCI specification, cap_id == 0 is the end-of-list sentinel.
However, the code only checked for `cap_length == 0` to terminate the
walk. If the end-of-list entry has `cap_id == 0` but `cap_length != 0`,
the loop continues reading past the end of the valid capability list.

**What happens without the fix (when cap_id==0, cap_length!=0):**

1. The code does NOT break out of the loop (only `cap_length == 0`
   triggers a break)
2. The `cap_id == 0` won't match any vendor-specific range (0xc0-0xcf)
3. The `cap_id == 0` won't match any entry in the `ext_capabilities[]`
   table (lowest valid ID is 0x01)
4. The code prints `dev_notice("unknown ext_cap 0x00\n")` and continues
5. It advances `curr_cap` by `cap_length * 4` bytes, now pointing into
   undefined MMIO space
6. Subsequent `readl()` calls read garbage data from MMIO registers past
   the capability list
7. If garbage data happens to match a valid capability ID (like
   0x01-0x10, 0x9d-0x9e), the corresponding **parser function will be
   called with a bogus MMIO base address**, reading/writing the wrong
   hardware registers
8. If garbage data produces a `cap_length` that fails the size check,
   `i3c_hci_parse_ext_caps()` returns `-EINVAL`, causing
   `i3c_hci_init()` to fail entirely and the **I3C controller to not
   initialize at all**

### 3. CLASSIFICATION

This is a **real bug fix**. The bug is:
- **Spec violation**: cap_id==0 is end-of-list per the MIPI I3C HCI
  specification
- **Potential driver initialization failure**: Garbage data past the
  list can cause `-EINVAL` return, preventing the I3C controller from
  working
- **Potential incorrect hardware register access**: If garbage data
  matches a valid capability ID, parser functions will `readl()` and
  potentially `writel()` at wrong MMIO offsets, which could cause
  **hardware misbehavior or corruption**

### 4. SCOPE AND RISK ASSESSMENT

- **Lines changed:** 1 (adding `!cap_id ||` to an existing condition)
- **Files touched:** 1 (`ext_caps.c`)
- **Complexity:** Trivial - simply adds a termination check for a known
  end-of-list sentinel
- **Risk of regression:** Essentially zero. If `cap_id == 0`, the spec
  says it's end-of-list, so stopping is always the correct behavior. No
  valid capability has ID 0.

### 5. USER IMPACT

The MIPI I3C HCI driver is used on real hardware - primarily Intel
platforms (as evidenced by Adrian Hunter's active Intel-specific I3C HCI
PCI patches, including adding support for Intel Nova Lake-S). Users with
I3C controllers that use capability ID 0 as the end-of-list marker (as
the spec prescribes) would hit this bug. The consequence ranges from
spurious log messages to complete failure of the I3C controller
initialization.

### 6. STABILITY & BACKPORT ASSESSMENT

- **Applies cleanly:** The vulnerable code is identical in all stable
  trees (5.15, 6.1, 6.6, 6.12). The only change since introduction was a
  `DBG()` to `dev_dbg()` conversion, which doesn't affect the
  surrounding context enough to prevent clean application.
- **Obviously correct:** Adding `!cap_id` as a termination condition is
  obviously correct per spec.
- **Self-contained:** No dependencies on other commits. The patch
  message ID (`67074-3`) indicates it was patch 3 in a series, but the
  fix is completely standalone.
- **Small and surgical:** One condition added to one line.
- **Tested:** Already reviewed, accepted, and merged into mainline.

### 7. COMPARISON WITH PCI

The PCI extended capability parser uses the exact same pattern: `if
(__header == 0) break;` (in `PCI_FIND_NEXT_EXT_CAP` macro at
`drivers/pci/pci.h:170`). The I3C HCI code was simply missing this
standard end-of-list check.

### Conclusion

This is a minimal, obviously correct, zero-risk fix for a real hardware-
facing bug that has existed since the driver was introduced in v5.11.
Without it, the I3C HCI driver may fail to initialize or access
incorrect hardware registers when walking past the end of the Extended
Capability list. The fix adds a single condition check (`!cap_id`) that
aligns with the MIPI I3C HCI specification and follows the same pattern
used by PCI capability parsing. It applies cleanly to all stable trees.

**YES**

 drivers/i3c/master/mipi-i3c-hci/ext_caps.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i3c/master/mipi-i3c-hci/ext_caps.c b/drivers/i3c/master/mipi-i3c-hci/ext_caps.c
index 7714f00ea9cc0..533a495e14c86 100644
--- a/drivers/i3c/master/mipi-i3c-hci/ext_caps.c
+++ b/drivers/i3c/master/mipi-i3c-hci/ext_caps.c
@@ -272,7 +272,7 @@ int i3c_hci_parse_ext_caps(struct i3c_hci *hci)
 		cap_length = FIELD_GET(CAP_HEADER_LENGTH, cap_header);
 		dev_dbg(&hci->master.dev, "id=0x%02x length=%d",
 			cap_id, cap_length);
-		if (!cap_length)
+		if (!cap_id || !cap_length)
 			break;
 		if (curr_cap + cap_length * 4 >= end) {
 			dev_err(&hci->master.dev,
-- 
2.51.0

