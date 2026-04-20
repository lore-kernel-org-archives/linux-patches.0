Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 440BD3FAE0C;
	Mon, 20 Apr 2026 13:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691576; cv=none; b=JKsGhBICEbo8cT1RUYIJ+QPT2Xa194p2zL6ihPK+L4ZvqUXdNbwwXQ/dXYAahoE4988XCE4+hBCk/aTJ6ely6jniDVaV5xdbpaVQmn4IiYqDxofybgqQghPkmSm2p4fJVAFYrxIHZdk0LCW1RvPia8c4wbcqMsN5OeGI7IiF2Dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691576; c=relaxed/simple;
	bh=CMSXB+94jX6MNjXe4NPuWU1GoG5gqxP3gsk+uMDmSIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u/Lq+povV2qw3UuTYe69yxvOj3c9vE0TYU2m21s96DrLtR4jjKsUmtwX7Owclef8zlorHnZt3wpeGOHjwTCx7Zx46j83ggkHCFdElmGsFMCzgN5wHBnaefzRDrcbJ561CDEed4qLbRUByP8t/1L6085rjXQsc8cZl5qIeKHxOlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oqheJ0YQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oqheJ0YQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 293D2C2BCB6;
	Mon, 20 Apr 2026 13:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691576;
	bh=CMSXB+94jX6MNjXe4NPuWU1GoG5gqxP3gsk+uMDmSIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oqheJ0YQdWZuH/dFa3DoqbWRKpKNv1V0ARSpunN8w2BS1J8UyQ/UHHbMyDFWpeIKq
	 HA52UzsOKUQeCfmAm7VtQb5LP3LuVwllJlUzZKjWX6V+4CWqdcJy4/zOkf37p6IX4k
	 9PaksJz56b3Axb6xpjoWn/vXT2HHb8aUtmkbqTaBg7OOo/W+kC1lcuoFwv43y4+fDw
	 vGOtQNAiSQu0TY7pcj7rZJtEzSVASVRr1bPC6/emDEs10B/Mv2lSZVv1AXVr/bGvsP
	 6W7fwA8j1AgS/i9XRHyYf9VN927I/5Psfp9J4MJ2fV7UN5w/YDDqNbky2B1GiE1rCN
	 hEa4VQRolLs0w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mario Limonciello <mario.limonciello@amd.com>,
	Imrane <ihalim.me@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Shyam-sundar.S-k@amd.com,
	hansg@kernel.org,
	platform-driver-x86@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] platform/x86/amd: pmc: Add Thinkpad L14 Gen3 to quirk_s2idle_bug
Date: Mon, 20 Apr 2026 09:18:24 -0400
Message-ID: <20260420132314.1023554-110-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 1a9452c428a6b76f0b797bae21daa454fccef1a2 ]

This platform is a similar vintage of platforms that had a BIOS bug
leading to a 10s delay at resume from s0i3.

Add a quirk for it.

Reported-by: Imrane <ihalim.me@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221273
Tested-by: Imrane <ihalim.me@gmail.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://patch.msgid.link/20260324211647.357924-1-mario.limonciello@amd.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

 drivers/platform/x86/amd/pmc/pmc-quirks.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/platform/x86/amd/pmc/pmc-quirks.c b/drivers/platform/x86/amd/pmc/pmc-quirks.c
index ed285afaf9b0d..24506e3429430 100644
--- a/drivers/platform/x86/amd/pmc/pmc-quirks.c
+++ b/drivers/platform/x86/amd/pmc/pmc-quirks.c
@@ -203,6 +203,15 @@ static const struct dmi_system_id fwbug_list[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "82XQ"),
 		}
 	},
+	/* https://bugzilla.kernel.org/show_bug.cgi?id=221273 */
+	{
+		.ident = "Thinkpad L14 Gen3",
+		.driver_data = &quirk_s2idle_bug,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "21C6"),
+		}
+	},
 	/* https://gitlab.freedesktop.org/drm/amd/-/issues/4434 */
 	{
 		.ident = "Lenovo Yoga 6 13ALC6",
-- 
2.53.0

