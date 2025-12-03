Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3711328634;
	Wed,  3 Dec 2025 15:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777568; cv=none; b=Nu1EaBLyxHhmBcNMnCiRBR9Cr2JbEZGnvgclqG5JU8MQfCabRxbCrdZMeisdksMat8t0SX6XN6J7epQa9Bz+tiVaoE+72Tqm+FdgYJfuDxCUFms07WYfzdjYr7VxPzvE7L9K3KlKJhxPQZ2oRbIazmp3ku4JzvS4LyYmaZuyy0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777568; c=relaxed/simple;
	bh=NaIXOlrbgq8Ensul24gnbCAwEWP7Ergguqm4AO9T2cQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZuwU7GvVxDVyrgiTdDxhT2V6v+86jQJABNCFun6V1DpVzIwciuvu9/bUpDiGXEhVQqxfc04TEA04GfJN7HQZHRKQYlGAY9kpVvTouiOKjVaDgfiqEMBcOStZmdR+JFD3KfMYWOXfxKo4azfhO8aTKkboJdBH0njHTMZbeBhjRx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TCBA01sO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TCBA01sO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1FB5C4CEF5;
	Wed,  3 Dec 2025 15:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777567;
	bh=NaIXOlrbgq8Ensul24gnbCAwEWP7Ergguqm4AO9T2cQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TCBA01sO048I7nDtUfPPtYLRQk49cvTqKj4bGAEg/uNcaS9FjiqdkuLw/sNRWNKNx
	 PoE4yvoHiakS5qQ5trRwt4AYTGpAvV4l8wfar27FG0L9/72YIIWVEZCfmOiSivLWpO
	 DbNmW1XYgN1PM46xr/F2qP62xQjrAmu+ImR5JvHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wilson Alvarez <wilson.e.alvarez@rubonnek.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 061/392] ACPI: video: force native for Lenovo 82K8
Date: Wed,  3 Dec 2025 16:23:31 +0100
Message-ID: <20251203152416.357524007@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 338e1f44906a9..0ecc47e273140 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -635,6 +635,14 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
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



