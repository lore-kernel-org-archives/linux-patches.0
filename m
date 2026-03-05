Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59B943CA49B;
	Thu,  5 Mar 2026 15:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772725042; cv=none; b=EJ5F5kkZcqOFyz+lsDDOL0kY3jQc38ADJcxk44j/HrsV9VMzT6OxW9ndKBZfoV6C8d7MK1IHbc911NPpnvqpKJz3u+j+hVNrL477HT3OAp2fZnRjznQW4TvKtRQBSoWRFleWg/PVr9j5iYXCgnhKC8yFm2woSP7xc3QoP2iBBnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772725042; c=relaxed/simple;
	bh=o9uqiIEj6QMRQg/6N+H8jSXsxYL6TKchhBOcANcRrJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=shBXhwxyFXZ9T3aaRbnjduGNYXH+1CRU7Ht3j7XZGiorbS96mHAIwgAioqOfsXBiR2ogqGfGVAXhVwMOs9aM477Jso0cpnkDeZ8aBr4xpeRXOWqVd9NOm4w5DE1R4upu+c8c4O7RlWAIoyQ4VxWPTiDLNYx1kfDn3DXM5ymj6A4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iPcBRxhg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iPcBRxhg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA344C2BC87;
	Thu,  5 Mar 2026 15:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772725042;
	bh=o9uqiIEj6QMRQg/6N+H8jSXsxYL6TKchhBOcANcRrJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iPcBRxhgXO/p07PmcHK/TxUFVEMdm3kC5qLTXMJSaATIHpD0by4K4UqSPgo0qKkQq
	 i7WYZTansFzc/jXO3GO4rtENrWRBxfPNqCyH+XmY3nVTjCzvt/eiZ+Ly55ZVbU6zET
	 IF1pbgfBI1BnQHfM8jbH+tgw1dC8mu9/rwn7wtOCHRcAj2wQJVe8SGqYCd/yNKDZWL
	 rs90nKshz9IYEbxe4+HSdcGSnndP9x/6E1LWQ2hWh6LMKq/Fl9PXZXEame6EeO13d4
	 TypmIMowDShYKoHr91CKZSHEB2Hx4MJ5j4mun+R4JNf4s0oOCFLnZbdYJki6pCXo/M
	 l9hoPy3GtUv3A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Azamat Almazbek uulu <almazbek1608@gmail.com>,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	lgirdwood@gmail.com,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.1] ASoC: amd: yc: Add ASUS EXPERTBOOK BM1503CDA to quirk table
Date: Thu,  5 Mar 2026 10:36:54 -0500
Message-ID: <20260305153704.106918-11-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260305153704.106918-1-sashal@kernel.org>
References: <20260305153704.106918-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Azamat Almazbek uulu <almazbek1608@gmail.com>

[ Upstream commit 32fc4168fa56f6301d858c778a3d712774e9657e ]

The ASUS ExpertBook BM1503CDA (Ryzen 5 7535U, Barcelo-R) has an
internal DMIC connected through the AMD ACP (Audio CoProcessor)
but is missing from the DMI quirk table, so the acp6x machine
driver probe returns -ENODEV and no DMIC capture device is created.

Add the DMI entry so the internal microphone works out of the box.

Signed-off-by: Azamat Almazbek uulu <almazbek1608@gmail.com>
Reviewed-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Link: https://patch.msgid.link/20260221114813.5610-1-almazbek1608@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis: ASoC: amd: yc: Add ASUS EXPERTBOOK BM1503CDA to quirk table

### What the commit does

This is a simple DMI quirk table addition — a 7-line entry adding the
ASUS EXPERTBOOK BM1503CDA to the `yc_acp_quirk_table[]` in
`sound/soc/amd/yc/acp6x-mach.c`. Without this entry, the internal DMIC
(digital microphone) on this laptop is not detected, and the driver
probe returns `-ENODEV`, meaning **no microphone capture device is
created** — the internal mic simply doesn't work.

### Stable kernel criteria assessment

1. **Fixes a real bug**: Yes — the internal microphone doesn't work on
   this specific laptop model without the quirk entry.
2. **Obviously correct and tested**: Yes — it's a trivial DMI match
   entry following the exact same pattern as dozens of other entries in
   the same table. Reviewed by the AMD audio maintainer (Vijendar
   Mukunda).
3. **Small and contained**: Yes — 7 lines added to a single file, no
   logic changes whatsoever.
4. **No new features**: Correct — this enables existing hardware support
   on a specific device, not a new feature.
5. **Exception category**: This falls squarely under **hardware
   quirks/workarounds** — one of the explicitly allowed categories for
   stable backports.

### Risk assessment

- **Risk**: Essentially zero. The DMI match is specific to one laptop
  model (`ASUS EXPERTBOOK BM1503CDA` from `ASUSTeK COMPUTER INC.`). It
  cannot affect any other hardware.
- **Benefit**: Internal microphone works on this laptop model.
- **Dependencies**: None — the driver and quirk table infrastructure
  already exist in stable trees.

### Verification

- Verified the diff is a pure DMI table entry addition (7 lines) with no
  logic changes.
- Verified the entry follows the identical pattern of all other entries
  in the table (DMI_MATCH on BOARD_VENDOR + PRODUCT_NAME, driver_data =
  &acp6x_card).
- Verified the commit has `Reviewed-by: Vijendar Mukunda
  <Vijendar.Mukunda@amd.com>` (AMD audio subsystem reviewer).
- The file `sound/soc/amd/yc/acp6x-mach.c` and the `yc_acp_quirk_table`
  have existed in stable trees — this is a mature driver with many
  similar quirk entries.

### Conclusion

This is a textbook stable backport candidate: a hardware quirk addition
that enables an internal microphone on a specific laptop. Zero risk,
clear user benefit, trivially correct.

**YES**

 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index f1a63475100d1..7af4daeb4c6ff 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -703,6 +703,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 				DMI_MATCH(DMI_PRODUCT_NAME, "Vivobook_ASUSLaptop M6501RR_M6501RR"),
 			}
 		},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ASUS EXPERTBOOK BM1503CDA"),
+		}
+	},
 	{}
 };
 
-- 
2.51.0

