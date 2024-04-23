Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B5591482F6;
	Tue, 23 Apr 2024 21:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908616; cv=none; b=pvQ2CJZEoE4JzqRbMt5fnJSFDHz5GaeOSdmtS5SjhAkVu6tqJdCTLx6eFLs9Lup0CQuhP+6kDhErvuH0VKAVEZvu16bfdMhjREfz0yjq2xyu4TmihFORmhJEi41UaraPuBpJWMh7HIlbRqtq7BsrQpaKBGAv/rXXG6WR4S3oDQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908616; c=relaxed/simple;
	bh=s6dkfHRbfr9B7XT3lX7yyACEVQxiZjuH0Z5jDp3Ymm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MFP3zU7djyoAE6zQtbwpaM/rXzXnpN3RsPsxhsdfIcrU65x+GysqxqU+hzFXXK9nMvQiUGwTMXj68jrUofQGtoHxMvFseyYmLNySYyQvB/o9Uve6uHwrFBhqI2XNehvSA2tzmWLwg7tIVofIKaX6JCDpB3uadD4rQsi39Ccs6o0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XaEhQU/i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XaEhQU/i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E305C3277B;
	Tue, 23 Apr 2024 21:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908616;
	bh=s6dkfHRbfr9B7XT3lX7yyACEVQxiZjuH0Z5jDp3Ymm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XaEhQU/iM/0K1ZsIPdS+idg8OGTQaLaGzL+uGSzWMTCJ/VwOycjLpgjXl8H9QM6y+
	 nfgkPu0wR8avsQbq+9W8Xd4SCriaPJaYR5Lc+fYIL6CDMkJYg414gXkffQo9NlVluH
	 wXoVIOQPZr+Z5Pnc4Pfp8ribv2JLQ2jLfQ13rhTw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Hans de Goede <hdegoede@redhat.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 089/158] platform/x86/amd/pmc: Extend Framework 13 quirk to more BIOSes
Date: Tue, 23 Apr 2024 14:38:46 -0700
Message-ID: <20240423213858.644454412@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



