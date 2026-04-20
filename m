Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 739D8329C6D;
	Mon, 20 Apr 2026 16:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701212; cv=none; b=Kyf1nv0jTvHKcO5okpGhfUq0X6d1UiUuSy/yoH+9cTy5T0ApdDvolj9zvy/GVYSSkp0D/9MktaMwvC9ExaMkyFYyvXcoImFa1LTzvTSxSZbHnb1AvXjMzRF9gQ+xRYRpeupQKoWbNAZ7BRm5tyOUQLDuI/V9Cx/9ricvqiiCFpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701212; c=relaxed/simple;
	bh=dagpbsKuI7l4aZLIf7CYnLk80KMqd0l6D/iS9WkqE0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s0wZ/5QnjQbeMHhsGpChlZCb7n+7k+EFgKljvPmIkwzPWvfnGHn9KkCyN9NCbhtJCTbEJi7LBouhcTRp1O5ppXNHoolSURcwgg9PuGvWmffTOrfza9h74BgH/cCz5hZvvAGpWbwxMB2B5lAChXF9g4ya/MadJEwXurIdB2Q457U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YCUvYFWD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YCUvYFWD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A2E4C19425;
	Mon, 20 Apr 2026 16:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776701212;
	bh=dagpbsKuI7l4aZLIf7CYnLk80KMqd0l6D/iS9WkqE0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YCUvYFWDmDuAQakIrXB9G8BaeFc3/x00B9SGijuGp5M30sXZ3g2NMFn79L/Ofa8y8
	 ZIu6W7jMyCg5cE2nXaI1Dzshw66ehORWqQkmZpqJp2wdKJnVC1EghthOynU7gVVS/W
	 zx1PEZnr+tEzzUr1mwE3q/kGhXHOz11pxwJadCKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imrane <ihalim.me@gmail.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 026/162] platform/x86/amd: pmc: Add Thinkpad L14 Gen3 to quirk_s2idle_bug
Date: Mon, 20 Apr 2026 17:40:58 +0200
Message-ID: <20260420153927.968592612@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153927.006696811@linuxfoundation.org>
References: <20260420153927.006696811@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

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
 drivers/platform/x86/amd/pmc/pmc-quirks.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/platform/x86/amd/pmc/pmc-quirks.c b/drivers/platform/x86/amd/pmc/pmc-quirks.c
index a6006b4ec2cc0..a3921f8106c12 100644
--- a/drivers/platform/x86/amd/pmc/pmc-quirks.c
+++ b/drivers/platform/x86/amd/pmc/pmc-quirks.c
@@ -197,6 +197,15 @@ static const struct dmi_system_id fwbug_list[] = {
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



