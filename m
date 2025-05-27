Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BF4D2153D2;
	Tue, 27 May 2025 02:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748313499; cv=none; b=JOBoCdWgURdNtKVsvRM+9IAELY7tjw063xSGScaekW+QbZ31XIdpXGwiequow+kWLa8Vf2IrMKXQl+Cq9oHcaSYqvEpD+aVllYxEcCHmDhgkzgJC+5/JO/rOEiMfQ17fUipgzZIDKMMwXODwCg38TpcZjCioKu51v1ElL82hub0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748313499; c=relaxed/simple;
	bh=tQRelC5kw0w0hRH7BufIp9wBWcvLvRolAcIqDcVvd0U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fWui+sbMjPC7bNANmAppt4bO6ZLHVsR5LgFwQloEYB6b0WPOvLLU8SAKsDmcYOxkJaFjC5nxgQHmC0FRJ7VPuHhjfh4NNjFF8SDDms6G42JRi0OyLKDWlyPcbOf3gg42fd24Aops10f0kpJ1OS7UHT3QMUpvkjjJZ0niidS4pJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jKvbnXKQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jKvbnXKQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA052C4CEED;
	Tue, 27 May 2025 02:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748313499;
	bh=tQRelC5kw0w0hRH7BufIp9wBWcvLvRolAcIqDcVvd0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jKvbnXKQH0vJOyIWETcQV0pvNFnCZGMXzUQ5hb214ljENq9kcFxOw0fw8GoxD1EeV
	 964wgiFOD8mBlEH6wH73YPvcUOaCeaHsu0MjhO5HU1You/yPmUXsLQRu8IqtCTD7Hr
	 5I6vX51oiAiiQOoQqlOMOukRF1shu683jV0hOvZ0NxNZJMTqBi6TRPJaJq54kum80h
	 AMmpvaLbv4fm3ASRO3NqaM6d0b3g+fCKJ465hhrrUxpSD3CCDHL97j/uYZINIlJtHj
	 pTIhtQ8koVua2S/Orrd2daBLYCvfUxa9jvg1CYpEIqYdcU7Zs3oduGcy46+L5NNKyt
	 Qyo10WF5ge3/Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mark Pearson <mpearson-lenovo@squebb.ca>,
	Derek Barbosa <debarbos@redhat.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Armin Wolf <W_Armin@gmx.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	hmh@hmh.eng.br,
	ibm-acpi-devel@lists.sourceforge.net,
	platform-driver-x86@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 2/2] platform/x86: thinkpad_acpi: Ignore battery threshold change event notification
Date: Mon, 26 May 2025 22:38:15 -0400
Message-Id: <20250527023815.1017408-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250527023815.1017408-1-sashal@kernel.org>
References: <20250527023815.1017408-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.10.237
Content-Transfer-Encoding: 8bit

From: Mark Pearson <mpearson-lenovo@squebb.ca>

[ Upstream commit 29e4e6b4235fefa5930affb531fe449cac330a72 ]

If user modifies the battery charge threshold an ACPI event is generated.
Confirmed with Lenovo FW team this is only generated on user event. As no
action is needed, ignore the event and prevent spurious kernel logs.

Reported-by: Derek Barbosa <debarbos@redhat.com>
Closes: https://lore.kernel.org/platform-driver-x86/7e9a1c47-5d9c-4978-af20-3949d53fb5dc@app.fastmail.com/T/#m5f5b9ae31d3fbf30d7d9a9d76c15fb3502dfd903
Signed-off-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Armin Wolf <W_Armin@gmx.de>
Link: https://lore.kernel.org/r/20250517023348.2962591-1-mpearson-lenovo@squebb.ca
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/thinkpad_acpi.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index c07b3bcbf795d..fc4322abf4c6a 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -195,6 +195,7 @@ enum tpacpi_hkey_event_t {
 	/* Thermal events */
 	TP_HKEY_EV_ALARM_BAT_HOT	= 0x6011, /* battery too hot */
 	TP_HKEY_EV_ALARM_BAT_XHOT	= 0x6012, /* battery critically hot */
+	TP_HKEY_EV_ALARM_BAT_LIM_CHANGE	= 0x6013, /* battery charge limit changed*/
 	TP_HKEY_EV_ALARM_SENSOR_HOT	= 0x6021, /* sensor too hot */
 	TP_HKEY_EV_ALARM_SENSOR_XHOT	= 0x6022, /* sensor critically hot */
 	TP_HKEY_EV_THM_TABLE_CHANGED	= 0x6030, /* windows; thermal table changed */
@@ -4049,6 +4050,10 @@ static bool hotkey_notify_6xxx(const u32 hkey,
 		pr_alert("THERMAL EMERGENCY: battery is extremely hot!\n");
 		/* recommended action: immediate sleep/hibernate */
 		break;
+	case TP_HKEY_EV_ALARM_BAT_LIM_CHANGE:
+		pr_debug("Battery Info: battery charge threshold changed\n");
+		/* User changed charging threshold. No action needed */
+		return true;
 	case TP_HKEY_EV_ALARM_SENSOR_HOT:
 		pr_crit("THERMAL ALARM: a sensor reports something is too hot!\n");
 		/* recommended action: warn user through gui, that */
-- 
2.39.5

