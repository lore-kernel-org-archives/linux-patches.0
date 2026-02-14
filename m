Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 116F517B506;
	Sat, 14 Feb 2026 01:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031018; cv=none; b=CMaqmtliubugWRW4tOzg6o8vXTFGqRQmnJzDM0xmwUXfMXRFvfWPJKIuBhq5TAtGKXGA384npT/bPdK49B1zSsdnWHm57+Ucg1R6KhKgbi8hopsdUVpYSXwNzfD6mpvTxkgXyxrl1NqIwkP9KlbPcGAXHCsn6cVBc2o39mgDCls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031018; c=relaxed/simple;
	bh=hr6ZlRyO3yRbLRvj6Vembu5LFGUc/HNiBv7978rmiTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CjtahshaI8a+Yz1CqXwlof2+DxrOQGTRyFoZdFtxW2mtW4fzLBePlPQqCo0pkmynrBB3dR6os01TqqoIdQgPGagX8dffzb+3k8PHn1RLzq6j/1Pv71r2vsmnnJcKqLzTPeZDqjFei/QgTJWEuXx6YND00XzW101H9TMgGr54FdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I1YUL+Lu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I1YUL+Lu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC40AC116C6;
	Sat, 14 Feb 2026 01:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771031017;
	bh=hr6ZlRyO3yRbLRvj6Vembu5LFGUc/HNiBv7978rmiTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I1YUL+LuWzU6FZyQMpkYoqOaP/3s4R9g1I5P6OVy0qGeOETF1BHBrv4DEIolpKwsV
	 fHO6czASskLNE1MD+j2zLNrmraFqEgoyeKXAqlBWT+/nkMF/6xRWtBVEhE4giCq1Vr
	 REszDjuznxayvoBXbxAiHCLN9+rIAt4OvydOoY9TzwlounTU5gmMt50qfizpgLc9W+
	 3ScFy6ABzfvNkQJOzMFLAElOYWKHGPTco4hkQIU9joIcvtL3LltJyqtws2BCGK2G+c
	 fJdhe/B0riQPm8DZjtiAY4UzyqIMtQLYRPno0RZooWkiIHF/oBJTXak5IFpKfxHLMX
	 nb9oCLFt2+Fiw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	tglx@kernel.org,
	wangruikang@iscas.ac.cn,
	yelangyan@huaqin.corp-partner.google.com,
	Vijendar.Mukunda@amd.com
Subject: [PATCH AUTOSEL 6.19] ALSA: hda: controllers: intel: add support for Nova Lake
Date: Fri, 13 Feb 2026 19:58:24 -0500
Message-ID: <20260214010245.3671907-24-sashal@kernel.org>
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

[ Upstream commit 7f428282fde34f06f3ab898b8a9081bf93a41f22 ]

Add NVL to the PCI-ID list.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Liam Girdwood <liam.r.girdwood@intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Acked-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260120193507.14019-5-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis

### Commit Message Analysis

The commit subject and body are straightforward: "add support for Nova
Lake" by adding a PCI device ID (`HDA_NVL`) to the existing HDA (High
Definition Audio) controller driver's PCI ID table.

### Code Change Analysis

The diff shows a single line addition:
```c
{ PCI_DEVICE_DATA(INTEL, HDA_NVL, AZX_DRIVER_SKL | AZX_DCAPS_INTEL_LNL)
},
```

This adds the Nova Lake (NVL) PCI device ID to the `azx_ids[]` table in
`sound/hda/controllers/intel.c`. The entry uses the same driver type
(`AZX_DRIVER_SKL`) and capabilities (`AZX_DCAPS_INTEL_LNL`) as other
recent Intel platforms like Panther Lake, Wildcat Lake, and the already-
present `HDA_NVL_S` (Nova Lake-S variant).

### Classification

This is a **new device ID addition** to an existing, well-established
driver. This falls squarely into the "NEW DEVICE IDs" exception category
that is explicitly allowed and encouraged for stable backports.

Key characteristics:
- **One-line change**: Minimal risk
- **Pattern-matching existing entries**: Uses the same driver/caps as
  NVL_S which is already present
- **No new code paths**: The driver infrastructure already handles this;
  only the PCI ID binding is added
- **No new features or APIs**: Just enables an existing driver to bind
  to new hardware

### Risk Assessment

- **Risk**: Essentially zero. Adding a PCI ID to a table cannot break
  existing functionality. The new entry only activates when the specific
  Nova Lake hardware is present.
- **Scope**: Single line in a single file
- **Dependencies**: The `HDA_NVL` PCI ID macro must be defined in the
  PCI ID header. Since `HDA_NVL_S` already exists and this commit was
  accepted upstream, the corresponding ID definition is present.

### User Impact

Without this PCI ID entry, users with Nova Lake hardware will have no
HDA audio support. This is a direct hardware enablement fix — audio
simply won't work on these systems without it.

### Stability Indicators

- **Reviewed-by**: Three reviewers (Kai Vehmanen, Liam Girdwood, Ranjani
  Sridharan — all Intel audio engineers)
- **Acked-by**: Takashi Iwai (HDA subsystem maintainer)
- **Pattern**: Identical to dozens of previous Intel HDA PCI ID
  additions that routinely go to stable

### Dependency Check

The only dependency is the PCI ID definition macro (`INTEL_HDA_NVL` or
similar) in the PCI ID headers. This would need to be present in the
stable tree. Given that `HDA_NVL_S` is already in the table, the
corresponding header changes for the NVL family may already be partially
present, though the specific `HDA_NVL` ID definition would need to be
verified or backported alongside this.

### Conclusion

This is a textbook stable backport candidate: a single-line PCI device
ID addition to an existing, mature driver (Intel HDA), enabling audio on
new hardware. It has zero risk of regression, multiple expert reviews,
and direct user impact. The only consideration is ensuring the PCI ID
macro definition is also backported.

**YES**

 sound/hda/controllers/intel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/controllers/intel.c b/sound/hda/controllers/intel.c
index 1e8e3d61291a1..1b365e0772970 100644
--- a/sound/hda/controllers/intel.c
+++ b/sound/hda/controllers/intel.c
@@ -2551,6 +2551,7 @@ static const struct pci_device_id azx_ids[] = {
 	/* Wildcat Lake */
 	{ PCI_DEVICE_DATA(INTEL, HDA_WCL, AZX_DRIVER_SKL | AZX_DCAPS_INTEL_LNL) },
 	/* Nova Lake */
+	{ PCI_DEVICE_DATA(INTEL, HDA_NVL, AZX_DRIVER_SKL | AZX_DCAPS_INTEL_LNL) },
 	{ PCI_DEVICE_DATA(INTEL, HDA_NVL_S, AZX_DRIVER_SKL | AZX_DCAPS_INTEL_LNL) },
 	/* Apollolake (Broxton-P) */
 	{ PCI_DEVICE_DATA(INTEL, HDA_APL, AZX_DRIVER_SKL | AZX_DCAPS_INTEL_BROXTON) },
-- 
2.51.0

