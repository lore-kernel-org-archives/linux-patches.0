Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0208A29A2;
	Mon,  4 Aug 2025 00:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754267660; cv=none; b=lmOPqKZRFqY0t398DqTNCGpJlHCSt8XOr5WomU9pUpsa1FZHd3WhS71KKbtTAgTfV5zpAf0nky26rLbQOxHncqSvZES3kYpfMypnCweExQEZAIHdkGoubZD/pe09INYYMMETC8I2WTRREGou/2zNJu2iaA5TuDZ0qQyJiKhg864=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754267660; c=relaxed/simple;
	bh=MVYERXRYEmAzADDBO7PTJjCByP1qg4y7LfqCnncXkG0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Df94L8uK7Hj9yrVgI6MmhwGjLt48Axa11WT5701nbmV1SNsf4SB0whMoPcjJhBU2rFd9YViIzqQ11FDn03LrXg68snTQu3nOOoS97U4xNwk8apazfCsIobBCQUAnfxYVgOunTyk1b+bnKwoJ+hOUwSSpr2DSM59BPCzIdoqAoUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wk085tWo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wk085tWo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F23F1C4CEEB;
	Mon,  4 Aug 2025 00:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754267658;
	bh=MVYERXRYEmAzADDBO7PTJjCByP1qg4y7LfqCnncXkG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wk085tWoIoq71p4VTgUkPlDBmPzMhTrrGpMF/Kt/UvKTVZnUmEFz4yGNezKoYWRKN
	 1QZqmSP9S+svar9RvZB865sF0t/RJnhAjs/HKtAl2XkCsjJbkpYfeZQ3mQtilen3h/
	 FGzE2KZtL4M3FwcpoGn7MHqfSPAGtZuYCAwHgL5rCZhKLHlO4488eLw3WrmHG2LLk6
	 5gb5B1SxJxtfMKp5MZQfUuzKonF7Mkzkb93PTkfmTgSOWZr2iT6KEa/eHxBFo4ujPA
	 6SfethINoYimQ4SblnNZBWF6AEbjWUtZDRuorMS6jVyrCRlAqZlNRDfRsyTNQGw2ct
	 jgRwD/GD+CDtw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mario Limonciello <mario.limonciello@amd.com>,
	Adam Berglund <adam.f.berglund@hotmail.com>,
	Hans de Goede <hansg@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Shyam-sundar.S-k@amd.com,
	platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 6.6 02/59] platform/x86/amd: pmc: Add Lenovo Yoga 6 13ALC6 to pmc quirk list
Date: Sun,  3 Aug 2025 20:33:16 -0400
Message-Id: <20250804003413.3622950-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250804003413.3622950-1-sashal@kernel.org>
References: <20250804003413.3622950-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.101
Content-Transfer-Encoding: 8bit

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 4ff3aeb664f7dfe824ba91ffb0b203397a8d431e ]

The Lenovo Yoga 6 13ACL6 82ND has a similar BIOS problem as other Lenovo
laptops from that vintage that causes a rather long resume from suspend.

Add it to the quirk list that manipulates the scratch register to avoid
the issue.

Reported-by: Adam Berglund <adam.f.berglund@hotmail.com>
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4434
Tested-by: Adam Berglund <adam.f.berglund@hotmail.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Hans de Goede <hansg@kernel.org>
Link: https://lore.kernel.org/r/20250718172307.1928744-1-superm1@kernel.org
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**YES**

This commit should be backported to stable kernel trees. Here's my
extensive analysis:

## Backport Justification

1. **Fixes a real user-impacting bug**: The commit addresses a BIOS
   firmware bug that causes "rather long resume from suspend" on the
   Lenovo Yoga 6 13ALC6 laptop. This is a significant usability issue
   that affects users of this specific hardware model during
   suspend/resume operations.

2. **Minimal and contained change**: The patch simply adds 8 lines to an
   existing DMI quirk table (lines 193-201 in the diff). It adds one new
   entry:
  ```c
  {
  .ident = "Lenovo Yoga 6 13ALC6",
  .driver_data = &quirk_s2idle_bug,
  .matches = {
  DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
  DMI_MATCH(DMI_PRODUCT_NAME, "82ND"),
  }
  },
  ```

3. **Follows established pattern**: The fix uses the exact same
   mechanism (`quirk_s2idle_bug`) that's already applied to 20+ other
   Lenovo laptops in the same file. The workaround manipulates a scratch
   register (FCH_PM_SCRATCH) to skip a problematic SMI handler during
   suspend-to-idle resume, as documented in the comment at lines
   241-248.

4. **No architectural changes**: This is purely a device-specific quirk
   addition to an existing quirk framework. No new functionality is
   introduced, no APIs are changed, and no kernel subsystem architecture
   is modified.

5. **Low regression risk**: The change only affects systems that match
   the specific DMI strings (LENOVO board vendor + 82ND product name).
   It cannot affect any other hardware.

6. **Tested by reporter**: The commit message indicates "Tested-by: Adam
   Berglund" who was also the reporter of the issue, confirming the fix
   works on the affected hardware.

7. **Follows stable tree rules**: This is exactly the type of commit
   that stable trees want:
   - Fixes a real bug (long resume times)
   - Minimal change (8 lines)
   - Hardware-specific fix with no broader impact
   - Already tested on affected hardware

The issue being fixed is documented at
https://gitlab.freedesktop.org/drm/amd/-/issues/4434, and the workaround
applies the same proven fix that's been working for numerous other
Lenovo models with similar BIOS issues related to suspend-to-idle resume
performance when IOMMU is enabled for NVMe devices.

 drivers/platform/x86/amd/pmc/pmc-quirks.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/platform/x86/amd/pmc/pmc-quirks.c b/drivers/platform/x86/amd/pmc/pmc-quirks.c
index 7ed12c1d3b34..04686ae1e976 100644
--- a/drivers/platform/x86/amd/pmc/pmc-quirks.c
+++ b/drivers/platform/x86/amd/pmc/pmc-quirks.c
@@ -189,6 +189,15 @@ static const struct dmi_system_id fwbug_list[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "82XQ"),
 		}
 	},
+	/* https://gitlab.freedesktop.org/drm/amd/-/issues/4434 */
+	{
+		.ident = "Lenovo Yoga 6 13ALC6",
+		.driver_data = &quirk_s2idle_bug,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "82ND"),
+		}
+	},
 	/* https://gitlab.freedesktop.org/drm/amd/-/issues/2684 */
 	{
 		.ident = "HP Laptop 15s-eq2xxx",
-- 
2.39.5

