Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D839414388D;
	Tue, 23 Apr 2024 21:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908497; cv=none; b=a7Ae++VCw9pBib0hqSDjduLW8BY3W8gZAAZUN7HPToFsyfkRBLDEAj04ORhdV+XyRPSAEF4v2wnj6mfqNJ+X1L4y6Yjh4lEPazpoRDx+I7dSmpwSJ9oMza/eA24RM0aMBXDHAKFRu3Y03+NzZYBlbS2GbGm1RhDmEZh8dYw3pk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908497; c=relaxed/simple;
	bh=zgbrH9Yo/IgRaUCcyqlOAOlQ+TMCACupaOb6ApxkDQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q+2Rsh9sMp4UtKoeaVDvwRc+z0WQl+WviL+dFnkmvZP8VAarlGD52Ua6ZbR8EtqpJpfrDuoXeX7lcBPRzmLBFnJ4SIw5VifaZTtpT09BriN6bQ3TDjsunqXIsm/f4r8yNFRHmJN3JKIZTRUGVZk6yfiMKNF7ur4BGRcbeXiEzK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jWXNVZaA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jWXNVZaA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A96C7C32783;
	Tue, 23 Apr 2024 21:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908497;
	bh=zgbrH9Yo/IgRaUCcyqlOAOlQ+TMCACupaOb6ApxkDQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jWXNVZaANBTQx+1UqrYF4IXmmjWvg/k4SWgCcdNiY0z6HtTHJs14SjgAGt0qxtKXG
	 u/ut7Z6VBnQsRQWZvQDMdQoHAiG+7zdFy3OatVZ8EXIK8yuZzM+fMB421fB5NbFhIe
	 NJT3tg5owzOSBssMCub9PT+RpTjwshTwaJvLf5Tc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Hans de Goede <hdegoede@redhat.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 075/158] platform/x86/amd/pmc: Extend Framework 13 quirk to more BIOSes
Date: Tue, 23 Apr 2024 14:38:17 -0700
Message-ID: <20240423213858.392416386@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit f609e7b1b49e4d15cf107d2069673ee63860c398 ]

BIOS 03.05 still hasn't fixed the spurious IRQ1 issue.  As it's still
being worked on there is still a possibility that it won't need to
apply to future BIOS releases.

Add a quirk for BIOS 03.05 as well.

Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20240410141046.433-1-mario.limonciello@amd.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/pmc/pmc-quirks.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/platform/x86/amd/pmc/pmc-quirks.c b/drivers/platform/x86/amd/pmc/pmc-quirks.c
index b456370166b6b..b4f49720c87f6 100644
--- a/drivers/platform/x86/amd/pmc/pmc-quirks.c
+++ b/drivers/platform/x86/amd/pmc/pmc-quirks.c
@@ -208,6 +208,15 @@ static const struct dmi_system_id fwbug_list[] = {
 			DMI_MATCH(DMI_BIOS_VERSION, "03.03"),
 		}
 	},
+	{
+		.ident = "Framework Laptop 13 (Phoenix)",
+		.driver_data = &quirk_spurious_8042,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Framework"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Laptop 13 (AMD Ryzen 7040Series)"),
+			DMI_MATCH(DMI_BIOS_VERSION, "03.05"),
+		}
+	},
 	{}
 };
 
-- 
2.43.0



