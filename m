Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA77624DFF9;
	Mon,  1 Dec 2025 11:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588386; cv=none; b=I7F8iYJUUIVRAyHbot4CYr2AKjCj/WbbxbLpqmmeVpn1exi/6BCrrQ8k/kRqkGSmIRj2hrO9Tr5yE3/S0gJ/VFidBP8lvUTfSH6BrGZB3XoJvxgOm5zCoCjqlYQFQMbNoU+zCjVkX/23qqBG2SuEos3l0QEDVxT82FhM5txbSB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588386; c=relaxed/simple;
	bh=dfo7TqnEQaeSkThn6uo2xIknzVWMqAWk6MsRzQoVbyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q66LTdcbss8GGh46DT5WPm2mn6p2wnUZx5yr7FvGks3FSHcJi125D1dckgML8gecgr+yyndwq24Llya5G/635qQahNg7GeftE9wiivGOWVFCVSweDGqNHYdNbt4gSh9AB0jakgVnDbu8J5CXUu0uG7Ivi0qGY91nshgENlhrRC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dnkf3YoD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dnkf3YoD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6547EC113D0;
	Mon,  1 Dec 2025 11:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588386;
	bh=dfo7TqnEQaeSkThn6uo2xIknzVWMqAWk6MsRzQoVbyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dnkf3YoDPSy90FVE7JCMvR/jEbJ7Oc5HzwPdKJevpdsszUYhqTWWGjVFPpzv9KA89
	 MpW6rVLlr/biQ9Qn1AKtboB61ynQPdwKFD+CNGwZSGvoUVO1wGcUF3LqAl5YaQqA67
	 hPXSbjv58xPNcgB+wB5hCJ7wQ0732aNcU6syO4DM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wilson Alvarez <wilson.e.alvarez@rubonnek.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 030/187] ACPI: video: force native for Lenovo 82K8
Date: Mon,  1 Dec 2025 12:22:18 +0100
Message-ID: <20251201112242.342206397@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello (AMD) <superm1@kernel.org>

[ Upstream commit f144bc21befdcf8e54d2f19b23b4e84f13be01f9 ]

Lenovo 82K8 has a broken brightness control provided by nvidia_wmi_ec.
Add a quirk to prevent using it.

Reported-by: Wilson Alvarez <wilson.e.alvarez@rubonnek.com>
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4512
Tested-by: Wilson Alvarez <wilson.e.alvarez@rubonnek.com>
Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
Link: https://patch.msgid.link/20250820170927.895573-1-superm1@kernel.org
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/video_detect.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index be9c70806b620..640e3fecd62d0 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -556,6 +556,14 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
 		DMI_MATCH(DMI_PRODUCT_NAME, "MS-7721"),
 		},
 	},
+	/* https://gitlab.freedesktop.org/drm/amd/-/issues/4512 */
+	{
+	 .callback = video_detect_force_native,
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "82K8"),
+		},
+	},
 	{ },
 };
 
-- 
2.51.0



