Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620E617B506;
	Sat, 14 Feb 2026 01:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031058; cv=none; b=EHgJQe6uWvK41TNMjRIeXhx5Oym+4Y8JIWU0d3xYxxm9LevaDRDMtuVofGZ65E87u+oCsSccx0SoOOqa83gwiuJvNTAd9pEMI2GYWQAWqUhVbuDT7qkOfh8mEZVKwOR3Vdhc3Th7CQQY3hYDnWSHkiG7+qCkp9F7bLk528zSVBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031058; c=relaxed/simple;
	bh=8+SbarDVbRZxOg/pWYIHay+wdz+dAk1f4lkH7xgnv24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a4oPFppprb7g8ZytQGpeo8dDcZYmphgDTBpJvVlMLtGS4vlcfJbSXHkeUnbSVbd+taFUozBSOSfwRTsZfZp7nUdrWjbt0bRU07AA6mFytgrrx9PKwOzF1RmPTdhXIFZCNQcFR7e+O9RGrut5oDtYMHWCz4xf6l8nXeH2uEs98As=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LZLRr9vl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LZLRr9vl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31C36C116C6;
	Sat, 14 Feb 2026 01:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771031058;
	bh=8+SbarDVbRZxOg/pWYIHay+wdz+dAk1f4lkH7xgnv24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LZLRr9vlc1AKJJac4JCRDaM7ZWMR9lOYo88KEbfKQ1Da1FjK4VDCJ4GAdm26WN7qe
	 vq0HTUN7owD6k7QxpGK42FTdWTgQd+EXlAjFRSbRlRxnJBPGtKKY2WLgIAJf1jptIz
	 +VYR/z8GTPBR+dUALtDQ78gYMZ9pPsqdWqRvlUF8GVpXx9TrnOxiOG93MpQeO0VeWx
	 APwtihaFaQc4Imd2hLvK2nrNlRhMHkkC9WIEoGw8t/74RW+xcuTWT7P2tBPt8Sgk/U
	 VCqZ3e1vFpFvGQcYDwMZd8H6QrOLMuDwLQNOb4PlsOa3wv65mmhVQ0xtABwrduESPt
	 XsUvI1q4RCAnw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Takashi Iwai <tiwai@suse.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.12] PCI: Add Intel Nova Lake audio Device ID
Date: Fri, 13 Feb 2026 19:58:43 -0500
Message-ID: <20260214010245.3671907-43-sashal@kernel.org>
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

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit b190870e0e0cfb375c0d4da02761c32083f3644d ]

Add Nova Lake (NVL) audio Device ID

The ID will be used by HDA legacy, SOF audio stack and the driver
to determine which audio stack should be used (intel-dsp-config).

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Liam Girdwood <liam.r.girdwood@intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260120193507.14019-2-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis: PCI: Add Intel Nova Lake audio Device ID

### Commit Message Analysis

This commit adds a single PCI Device ID (`0xd328`) for Intel Nova Lake
(NVL) audio hardware to `include/linux/pci_ids.h`. The commit message
clearly states the ID will be used by HDA legacy, SOF audio stack, and
the intel-dsp-config driver to determine which audio stack should be
used.

The commit has strong review coverage:
- Reviewed-by from 3 Intel audio engineers (Kai Vehmanen, Liam Girdwood,
  Ranjani Sridharan)
- Acked-by from the PCI maintainer (Bjorn Helgaas)
- Acked-by from the ALSA maintainer (Takashi Iwai)

### Code Change Analysis

The change is a single line addition in `include/linux/pci_ids.h`:

```c
+#define PCI_DEVICE_ID_INTEL_HDA_NVL    0xd328
```

This is purely a PCI ID definition — a `#define` macro. It adds no
logic, no new functions, no behavioral changes. It simply defines a
constant that other code (HDA driver, SOF driver, intel-dsp-config) can
reference.

### Classification: New Device ID

This falls squarely into the **"New Device IDs"** exception category for
stable backports:
- It's a trivial one-line addition defining a PCI Device ID
- It enables hardware support for Intel Nova Lake audio
- The drivers that consume this ID (HDA, SOF, intel-dsp-config) already
  exist in stable trees

### Important Caveat: Dependency Check

However, there's a critical consideration: **this commit only adds the
PCI ID definition**. By itself, this `#define` does nothing — it's just
a constant. For Nova Lake audio to actually work, the drivers that
reference `PCI_DEVICE_ID_INTEL_HDA_NVL` must also be updated with their
own patches to add this ID to their device tables and configuration
logic.

The commit message says "The ID will be used by HDA legacy, SOF audio
stack and the driver to determine which audio stack should be used
(intel-dsp-config)." The subject line includes "2-" in the Link URL
(`14019-2-peter.ujfalusi@linux.intel.com`), suggesting this is part of a
series.

Without the companion patches that actually use this define in the
driver match tables, this define alone provides no user-visible benefit.
However:

1. The define itself is completely harmless — zero risk of regression
2. It's a prerequisite for the actual driver patches
3. PCI ID defines are commonly backported as part of hardware enablement

### Risk Assessment

- **Risk**: Essentially zero. It's a `#define` in a header file. It
  cannot cause any regression.
- **Benefit**: Enables Intel Nova Lake audio hardware support (when
  companion driver patches are also present)
- **Scope**: Single line, single file

### User Impact

Users with Intel Nova Lake hardware need this ID (and the companion
driver patches) for audio to work. Without it, audio on Nova Lake
platforms would be non-functional.

### Conclusion

This is a textbook example of a new device ID addition — one of the
explicitly allowed exceptions for stable backporting. It's a single-
line, zero-risk change that enables hardware support. The only
consideration is that it needs companion patches in the actual drivers
to be useful, but the define itself is harmless and is a standard
prerequisite.

**YES**

 include/linux/pci_ids.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index a9a089566b7cb..f2849ff1830b1 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -3143,6 +3143,7 @@
 #define PCI_DEVICE_ID_INTEL_HDA_CML_S	0xa3f0
 #define PCI_DEVICE_ID_INTEL_HDA_LNL_P	0xa828
 #define PCI_DEVICE_ID_INTEL_S21152BB	0xb152
+#define PCI_DEVICE_ID_INTEL_HDA_NVL	0xd328
 #define PCI_DEVICE_ID_INTEL_HDA_BMG	0xe2f7
 #define PCI_DEVICE_ID_INTEL_HDA_PTL_H	0xe328
 #define PCI_DEVICE_ID_INTEL_HDA_PTL	0xe428
-- 
2.51.0

