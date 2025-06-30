Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7924224168D;
	Mon, 30 Jun 2025 20:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751317134; cv=none; b=QePE/tq/Jg1TZV4Fn6pfEyVJlDtAlPs8wLB1uQ3aYiWN1Kv/HgFp4gEoyYSDklcu9USKbVMUCx6oqx7medOLzWxztJ1CYCQx7JmZNyPVybTHS/1jT1rjGYHWTCoxZi7G6xz+ZJZ7UV2M3BjlLyOhWUofwAW1XAc7TMRocmGgQtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751317134; c=relaxed/simple;
	bh=WNedFTpYxr+flj+wo5kucjwaGj00QBtIhfPRC4D2XsA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JhdDIWMw7JSpHuE3/tWy2j53KGQlnyYUbUEHG0jWCHARJvtxIx3aurLOEzFAC81/sU7ECma9BdODnRLroqGHFTEZwYqABzCAUvtnEutG5Ev52g53A+UbXpmJuAXuS6qlpHTiXUd8yuxO8FukWAZtquCT2LJ4O8+TXfFgnb6rB9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rLzmfyAQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rLzmfyAQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FC9CC4CEEB;
	Mon, 30 Jun 2025 20:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751317134;
	bh=WNedFTpYxr+flj+wo5kucjwaGj00QBtIhfPRC4D2XsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rLzmfyAQiKQ2CIaLVuIogEMxPsmDslSflnHXyERjHznrZEZZFAnBgj1ajbDOoVba/
	 ery/vMBtTa6T4NLCVLOheFRl+ODhBr0LckP9HZ/fw29gRS8PXP+be+umaji2JiIFgC
	 LBUOSdCHgJ/8gpd7AUr19dQnmS3e4JfqRzj5k3ESEnEa8uE4OuUeiMTNBbFiR6QYUs
	 rDwQWn8c+WLb6FIbpjz5F0H4pmttlL5iLpR3Z27q1vZF1Aii9ubcbPJS1ZB+DAi3+4
	 Iz0o/Vb8MBp5emt17TlwSGtyD4eTfEPpu0elluF5lBY6d0f7V57E1KVwzFJ2eGyleO
	 SoAs7hG5pxsTw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yuzuru10 <yuzuru_10@proton.me>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	mario.limonciello@amd.com,
	venkataprasad.potturu@amd.com,
	tiwai@suse.de,
	talhah.peerbhai@gmail.com
Subject: [PATCH AUTOSEL 6.15 10/23] ASoC: amd: yc: add quirk for Acer Nitro ANV15-41 internal mic
Date: Mon, 30 Jun 2025 16:44:15 -0400
Message-Id: <20250630204429.1357695-10-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250630204429.1357695-1-sashal@kernel.org>
References: <20250630204429.1357695-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15.4
Content-Transfer-Encoding: 8bit

From: Yuzuru10 <yuzuru_10@proton.me>

[ Upstream commit 7186b81807b4a08f8bf834b6bdc72d6ed8ba1587 ]

This patch adds DMI-based quirk for the Acer Nitro ANV15-41,
allowing the internal microphone to be detected correctly on
machines with "RB" as board vendor.

Signed-off-by: Yuzuru <yuzuru_10@proton.me>
Link: https://patch.msgid.link/20250622225754.20856-1-yuzuru_10@proton.me
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES**

This commit should be backported to stable kernel trees. Here's my
extensive analysis:

## Key Points Supporting Backporting:

1. **Device ID Addition**: According to the stable kernel rules in
   Documentation/process/stable-kernel-rules.rst:15, patches that "add a
   device ID" are explicitly acceptable for stable backporting. This
   commit adds a DMI quirk entry which is functionally equivalent to
   adding a device ID.

2. **Hardware Enablement Fix**: The commit fixes a real hardware issue -
   the internal microphone on the Acer Nitro ANV15-41 laptop doesn't
   work without this quirk. This is a concrete bug that affects real
   users.

3. **Minimal and Safe Change**: The patch adds only 7 lines to the
   `yc_acp_quirk_table[]` array:
  ```c
  +       {
  +               .driver_data = &acp6x_card,
  +               .matches = {
  +                       DMI_MATCH(DMI_BOARD_VENDOR, "RB"),
  +                       DMI_MATCH(DMI_PRODUCT_NAME, "Nitro ANV15-41"),
  +               }
  +       },
  ```

4. **Follows Established Pattern**: The change follows the exact same
   pattern as numerous other entries in the DMI quirk table. It's a
   simple addition to an existing table with no algorithmic changes or
   risk of regression.

5. **Precedent from Similar Commits**: Looking at the historical commits
   with similar characteristics:
   - commit 610010737f74 ("ASoC: amd: yc: Add DMI quirk for Lenovo
     Ideapad Pro 5 16ARP8") - Backported with Cc: stable
   - commit c6dce23ec993 ("ASoC: amd: yc: Add DMI quirk for MSI Bravo 15
     C7VF") - Backported with Cc: stable
   - Multiple other similar commits were backported to stable

6. **No Risk of Regression**: The DMI matching is specific to the exact
   board vendor "RB" and product name "Nitro ANV15-41". This cannot
   affect any other hardware models.

## Analysis of the Code:

The change is in `sound/soc/amd/yc/acp6x-mach.c`, which is the machine
driver for AMD Yellow Carp platform using DMIC (Digital Microphone). The
`yc_acp_quirk_table[]` is a DMI (Desktop Management Interface) matching
table that identifies specific laptop models that need special handling
to enable their internal microphones.

Without this quirk, the AMD audio driver doesn't properly detect or
initialize the internal microphone on the affected laptop model, leaving
users without functioning audio input.

## Conclusion:

This is a textbook example of a commit suitable for stable backporting -
it's a hardware enablement fix that adds a device-specific quirk with
zero risk to other systems. The absence of an explicit "Cc:
stable@vger.kernel.org" tag in the commit message doesn't disqualify it
from backporting; it simply means the author didn't explicitly request
it at submission time.

 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 3d9da93d22ee8..88f1d72f95b2b 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -346,6 +346,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "83Q3"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "RB"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Nitro ANV15-41"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.39.5

