Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63C2D7BB1F;
	Wed, 21 Feb 2024 13:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523997; cv=none; b=hVt+1fzgfC/tGY/bRTH/D04J7WHNYKWg41r8tD4wbzc/utQgUUQAXMGsEtDdltkC7fCyQAf0GHkohHTVYzjGXPSUO1zeVi3vV4otpg5nlhuEdh/TMWqxJGAyIgWKvEWWIQ36UqA5BcFRKxrhLSToucQLmnQrOfDDXKyaCc/FZoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523997; c=relaxed/simple;
	bh=5dFjmQUe6dpkUZL+eg850sc35yEujgMeP72J5XCsHtY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LhTq+XqgjPHPSTE+8QBLYj7oXqPb/NWEdRJVF0k+trFmPhJo/dI5Y8L74MZazXlL/CLI77YOXCnQsuTZM8V02LZeTIvaRNPmtZo9JhnszthVqyjKN9XGWG0kzZjzhV6xwwDKqHdfPQtCxacVplBaFzfVd5cb3fOmO7paifC4OqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cbMOT9fg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cbMOT9fg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7910C43390;
	Wed, 21 Feb 2024 13:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523997;
	bh=5dFjmQUe6dpkUZL+eg850sc35yEujgMeP72J5XCsHtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cbMOT9fgBPi/zD3JN+OFQidxUqRPSZHn75oTC6iJ/CKFH61Ngpr4pXforFO7HAxZj
	 z//oE1Sf1VAWoCF5XDXf1aIDHZkOxpe6X86lINztZ4Nsw6pGWTb03ogBNOqW5Rdi84
	 X2gOJh7LDNGLDl4rmqD+BPrixveJlDzuASkh/bPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuluo Qiu <qyl27@outlook.com>,
	Celeste Liu <CoelacanthusHex@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 113/379] ACPI: video: Add quirk for the Colorful X15 AT 23 Laptop
Date: Wed, 21 Feb 2024 14:04:52 +0100
Message-ID: <20240221125958.271670639@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuluo Qiu <qyl27@outlook.com>

[ Upstream commit 143176a46bdd3bfbe9ba2462bf94458e80d65ebf ]

The Colorful X15 AT 23 ACPI video-bus device report spurious
ACPI_VIDEO_NOTIFY_CYCLE events resulting in spurious KEY_SWITCHVIDEOMODE
events being reported to userspace (and causing trouble there) when
an external screen plugged in.

Add a quirk setting the report_key_events mask to
REPORT_BRIGHTNESS_KEY_EVENTS so that the ACPI_VIDEO_NOTIFY_CYCLE
events will be ignored, while still reporting brightness up/down
hotkey-presses to userspace normally.

Signed-off-by: Yuluo Qiu <qyl27@outlook.com>
Co-developed-by: Celeste Liu <CoelacanthusHex@gmail.com>
Signed-off-by: Celeste Liu <CoelacanthusHex@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpi_video.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/acpi/acpi_video.c b/drivers/acpi/acpi_video.c
index 9d384656323a..b2364ac455f3 100644
--- a/drivers/acpi/acpi_video.c
+++ b/drivers/acpi/acpi_video.c
@@ -568,6 +568,15 @@ static const struct dmi_system_id video_dmi_table[] = {
 		DMI_MATCH(DMI_PRODUCT_NAME, "Vostro 3350"),
 		},
 	},
+	{
+	 .callback = video_set_report_key_events,
+	 .driver_data = (void *)((uintptr_t)REPORT_BRIGHTNESS_KEY_EVENTS),
+	 .ident = "COLORFUL X15 AT 23",
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "COLORFUL"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "X15 AT 23"),
+		},
+	},
 	/*
 	 * Some machines change the brightness themselves when a brightness
 	 * hotkey gets pressed, despite us telling them not to. In this case
-- 
2.43.0



