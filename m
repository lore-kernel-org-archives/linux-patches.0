Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A56EB44D022;
	Tue, 10 Mar 2026 09:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773133336; cv=none; b=TKyewU0lQyiDIsSlmYZh586VifQTwQ/ZENAv+5qDXtABKMcFD6eKdu0YNCrB/AymiHF/u1D7K6GtEFIyzHWyHw4fAlqtHT2fUuJyMfg5BgxenPCbhUSbf1GUZ76byyxw4vomFKReIcVK/O661cRVtFFw+mzaUjvRVc/lpnqrLfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773133336; c=relaxed/simple;
	bh=36e06rCIrcn030aSNsQ3eHJsRqmBD5AITtUSy6cDlDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N19G9hexAeyUWeQQjXYeP9KnlYzR32tMc/WB/YZtU6begcEt8i5pa5/hEIjZ8gTcBWfBN/Sp41YJxc6dxjU5uz/DmjrWTpClOtxAdih1zwUQMAGrmX9FEs8GrGw/40zUbrPAuDPNPpha4hnwWvD5rCZ7wnvzu3ITDdOnOlkjosc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rns6tPuD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rns6tPuD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F627C2BC86;
	Tue, 10 Mar 2026 09:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773133336;
	bh=36e06rCIrcn030aSNsQ3eHJsRqmBD5AITtUSy6cDlDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rns6tPuDsf9CmChl8YyJwFHNjzGeZVTorayTPX75224vDJJ44+xQkP43cABVjHOw2
	 tjoFql1wVpUbN1+OgtlJNRIjY4aei7ewyeESJaAOy0vmfHOeqCp/UnfWm+XKsBQjNj
	 1NYNIsUwAj5zQKHz1f3xv1nHwYlFY95ixs74dDToPAu3habkS8aqW/YyFH+fvevgrU
	 hRvLud0KvPT1po4B+lNx5YQsb+Xn/swHeqpicwAlo42we1r8Yq64KCmZFM2uNPJXzn
	 eNpqNUviclShYlJI2v1l2XxsyXpPnI6OfytFcslHc2zL5q6iJrqgKZ2MCaeH8EG9VX
	 Lrxzm8QBjQvLA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Antheas Kapenekakis <lkml@antheas.dev>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	derekjohn.clark@gmail.com,
	samsagax@gmail.com,
	hansg@kernel.org,
	platform-driver-x86@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.18] platform/x86: oxpec: Add support for Aokzoe A2 Pro
Date: Tue, 10 Mar 2026 05:01:20 -0400
Message-ID: <20260310090145.2709021-20-sashal@kernel.org>
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

From: Antheas Kapenekakis <lkml@antheas.dev>

[ Upstream commit cd0883055b04586770dab43c64159348bf480a3e ]

Aokzoe A2 Pro is an older device that the oxpec driver is missing the
quirk for. It has the same behavior as the AOKZOE A1 devices. Add a
quirk for it to the oxpec driver.

Signed-off-by: Antheas Kapenekakis <lkml@antheas.dev>
Link: https://patch.msgid.link/20260223183004.2696892-5-lkml@antheas.dev
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is important context. The driver was originally `drivers/hwmon/oxp-
sensors.c` (added in late 2022, so present in 6.1+ stable trees) and was
moved/renamed to `drivers/platform/x86/oxpec.c` in April 2025. This
means:

- **For stable trees based on kernels before the move (6.1.y, 6.6.y,
  6.12.y likely)**: The file is at `drivers/hwmon/oxp-sensors.c`, and
  this patch won't apply cleanly. A backport would need to target the
  old location.
- **For newer stable trees (6.15.y+)**: The patch would apply cleanly.

The driver rename is a significant obstacle for backporting to older
stable trees, though the fix itself is trivial.

### Verification:
- Confirmed the driver was originally `drivers/hwmon/oxp-sensors.c`
  (added Nov 2022, present since ~v6.2)
- Confirmed it was moved to `drivers/platform/x86/oxpec.c` in commit
  `3012bb39001c` (April 2025)
- Confirmed the change is a pure DMI table entry addition using existing
  `aok_zoe_a1` enum value
- Confirmed `aok_zoe_a1` is already used by two other AOKZOE entries (A1
  AR07, A1 Pro)
- Confirmed the patch was reviewed by Ilpo Järvinen (platform/x86
  maintainer)
- The driver's presence in older stable trees is under a different
  filename, meaning this patch would need adjustment for backporting to
  older stable branches

### Summary

This is a textbook hardware quirk addition — a trivial DMI table entry
that enables an existing driver to support a specific device (Aokzoe A2
Pro). It has zero risk of regression, fixes a real hardware support gap
for actual users, and is reviewed by the subsystem maintainer. The only
caveat is that it would need path adjustment for older stable trees
where the driver is still at `drivers/hwmon/oxp-sensors.c`, but that's a
mechanical change. This meets all stable kernel criteria.

**YES**

 drivers/platform/x86/oxpec.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/platform/x86/oxpec.c b/drivers/platform/x86/oxpec.c
index 623d9a452c469..158c545d4efbb 100644
--- a/drivers/platform/x86/oxpec.c
+++ b/drivers/platform/x86/oxpec.c
@@ -114,6 +114,13 @@ static const struct dmi_system_id dmi_table[] = {
 		},
 		.driver_data = (void *)aok_zoe_a1,
 	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "AOKZOE"),
+			DMI_EXACT_MATCH(DMI_BOARD_NAME, "AOKZOE A2 Pro"),
+		},
+		.driver_data = (void *)aok_zoe_a1,
+	},
 	{
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "AOKZOE"),
-- 
2.51.0

