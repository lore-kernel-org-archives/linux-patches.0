Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 186F94C97;
	Tue, 11 Nov 2025 00:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822560; cv=none; b=HAvD16LY4enfFvB9odsf4Qo7tRkKfloPVStsSdZXT/VhT7Yr8UVo13XnBaYVMET9Gf3RnAWI/FgBlfHZKQGa8iztUA1SUWLv/aaXdrb9H7Vz4PlExi8R9zJNvM0Uu5swfSG2pa1jUqFuF71uMgDwBzTXuvanY4cJWpL/BXhHaK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822560; c=relaxed/simple;
	bh=ylx8/Ws9g1wga5zniE6QvPxKBEnLSr17vqK2Nc1ueAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=agFSsvTKc/jsl9Lp4J7D07GKyxtqI+g6RdmPQmVHXNjRhNBp/U/yh2TpHPzGt3lKjbFAJ5NDWTJc7mvCEiQymL0qMpvu1Shom2MUVLa+AoDi4L6K1xaugWBCouKMm9KbTnWXlsfrNaQvL0h40bR7NBk8us2T3Cy5twnpsQlk164=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JUlNWtVR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JUlNWtVR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8E69C4CEFB;
	Tue, 11 Nov 2025 00:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822560;
	bh=ylx8/Ws9g1wga5zniE6QvPxKBEnLSr17vqK2Nc1ueAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JUlNWtVRPHyiBoQtFHrkz0UW/HmTaDRInqe8StmrzWVfDuYDdO7lPH8Dkw4OLI2pE
	 FAQDMRf16zrreIKSckSSSY0D5nEiUwaLFJfZc3Y1/dX168rT8fJZtg+QTvV8F00sCd
	 1meRTUjnq5YJ9OvUQoEo1jB/YDL6F3N4FM8nFDHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wilson Alvarez <wilson.e.alvarez@rubonnek.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 137/849] ACPI: video: force native for Lenovo 82K8
Date: Tue, 11 Nov 2025 09:35:07 +0900
Message-ID: <20251111004539.709231553@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index d507d5e084354..4cf74f173c785 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -948,6 +948,14 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
 		DMI_MATCH(DMI_PRODUCT_NAME, "Mipad2"),
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



