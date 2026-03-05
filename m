Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2D193CB2CE;
	Thu,  5 Mar 2026 15:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772725038; cv=none; b=kvUW5lEOCQtBU3hj3qOl1Frbi/hM4tqbgf7L0zdf0Rk5AzDr7ggD6hl8VjeOwYWRlnzEKt77VY3PfwPIEk0P+rEvVLEurzRQkYCRW4SYKYz/HfwqNGGANqIbHjfMe8s9VKKEW8lOehGwmJkyOWJlUtnEGmWcXstuR8mNhPKrmcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772725038; c=relaxed/simple;
	bh=AEpiXHIozBC5iJNZM1xkw2kFkbEtLfq6j5XzwTW9EgI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d0KXG/a8KYSgew24bgZXdsJbR5j4NczS9b27gmA02kcNWoH4EPL1+fGZInbTAorm8pHF++nJUdMqBImous5ez/4djTbE/qpYP+3g0nkv3AmvbuVXrznzhf+Ld5UwXpXEuH6hiOK5rzgHeiZAF8XfigtWqdtUekd2O23LRkx84sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ntxF9A5i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ntxF9A5i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD987C2BC87;
	Thu,  5 Mar 2026 15:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772725038;
	bh=AEpiXHIozBC5iJNZM1xkw2kFkbEtLfq6j5XzwTW9EgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ntxF9A5iCutO+LdGM5yGTZFy9pI/XEEsvLpU3gRYGS9psoC0s25/7fPzaoQPo8Qzv
	 31ArgMdYN49nz6OrHHLBeGG3GkWAHwkxeV3YHr0v2AHyumydbuTmE/eGCKh8vyBQVc
	 RmFe9Bkq5pDfWWW89uiqbeDwVYe4SleyGZClZluWG/7/rOHi7Uu8qyuevbq2TsBRP5
	 TV3JQOFFiBXUZ/NRRO+pH0QhjZZux3PnkJ13lll0LcFeO9FgKUUcliFSzxxf5qcWzU
	 ktXSSmTlZKCXHHcV/BDMb8jiOhUewdCMlMJdihM/0PCK9C6z9x0pZ88btvAe2B43yj
	 GbpFdV6yM5yZQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Piotr Mazek <pmazek@outlook.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	rafael@kernel.org,
	linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.10] ACPI: PM: Save NVS memory on Lenovo G70-35
Date: Thu,  5 Mar 2026 10:36:52 -0500
Message-ID: <20260305153704.106918-9-sashal@kernel.org>
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

From: Piotr Mazek <pmazek@outlook.com>

[ Upstream commit 023cd6d90f8aa2ef7b72d84be84a18e61ecebd64 ]

[821d6f0359b0614792ab8e2fb93b503e25a65079] prevented machines
produced later than 2012 from saving NVS region to accelerate S3.

Despite being made after 2012, Lenovo G70-35 still needs NVS memory
saving during S3. A quirk is introduced for this platform.

Signed-off-by: Piotr Mazek <pmazek@outlook.com>
[ rjw: Subject adjustment ]
Link: https://patch.msgid.link/GV2PPF3CD5B63CC2442EE3F76F8443EAD90D499A@GV2PPF3CD5B63CC.EURP251.PROD.OUTLOOK.COM
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

### Classification

This is a **hardware quirk** — one of the explicitly listed exception
categories that are appropriate for stable backporting. The pattern is
identical to the existing Lenovo G50-45 and G40-45 quirks already in the
table.

### Technical details

- Commit `821d6f0359b0` (2014) made machines with BIOS year >= 2012 skip
  NVS memory saving to speed up S3 suspend.
- Some Lenovo laptops (G50-45, G40-45, and now G70-35) need the NVS save
  despite being post-2012.
- Without this quirk, suspend/resume (S3) is broken on the Lenovo
  G70-35.

### Risk assessment

- **Scope**: Adds exactly 8 lines to a DMI quirk table — the most
  mechanical kind of change possible.
- **Affected systems**: Only the Lenovo G70-35 (DMI match on vendor
  "LENOVO" + product "80Q5"). Zero impact on any other machine.
- **Risk of regression**: Essentially zero. The DMI match is highly
  specific.
- **Benefit**: Fixes S3 suspend/resume on this laptop — a real user-
  facing bug that makes the machine unusable for suspend.

### Stable criteria check

1. **Obviously correct and tested**: Yes — follows exact same pattern as
   existing quirks, and presumably tested by the reporter on the
   hardware.
2. **Fixes a real bug**: Yes — broken S3 suspend/resume on this laptop.
3. **Important issue**: Yes — suspend/resume not working is a
   significant issue for laptop users.
4. **Small and contained**: Yes — 8 lines added to a DMI table, no logic
   changes.
5. **No new features**: Correct — this restores expected behavior on
   specific hardware.
6. **Dependencies**: None — the DMI table and `init_nvs_save_s3`
   callback have existed since 2014. This will apply cleanly to any
   stable tree.

### Verification

- Verified commit `821d6f0359b0` exists and introduced the post-2012 NVS
  nosave optimization (confirmed via `git log` and `git show`).
- Verified the existing quirk table in `drivers/acpi/sleep.c` already
  has identical entries for Lenovo G50-45 ("80E3") and G40-45 ("80E1")
  at lines 373-388.
- Verified `init_nvs_save_s3` callback and `acpi_sleep_dmi_check()`
  (line 412-418) show the 2012 cutoff logic — confirming the quirk
  mechanism.
- Verified the change is purely additive: 8 lines added to the DMI
  table, no existing code modified.
- The `acpisleep_dmi_table` and `init_nvs_save_s3` have been present
  since 2014, so all active stable trees contain the prerequisite code.

This is a textbook hardware quirk addition — small, safe, DMI-matched to
a single platform, fixing a real suspend/resume issue, with zero risk to
other systems.

**YES**

 drivers/acpi/sleep.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
index 66ec81e306d47..132a9df984713 100644
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -386,6 +386,14 @@ static const struct dmi_system_id acpisleep_dmi_table[] __initconst = {
 		DMI_MATCH(DMI_PRODUCT_NAME, "80E1"),
 		},
 	},
+	{
+	.callback = init_nvs_save_s3,
+	.ident = "Lenovo G70-35",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "80Q5"),
+		},
+	},
 	/*
 	 * ThinkPad X1 Tablet(2016) cannot do suspend-to-idle using
 	 * the Low Power S0 Idle firmware interface (see
-- 
2.51.0

