Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 402994120B;
	Mon,  2 Jun 2025 15:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877589; cv=none; b=S3KpAVgj4ArUHYXRM27IO2rmVx+DBXL3aHMhlPwwJtAMu1KxJwcuy/2wBOpEL9tNcqSbUBXpc1nATuiEycZb9cuSeiE+s7xDnMSTdNNIgK69lfB5LL4n+l3IFPpkbpkux6HUAqZVkR9t6nKstvDBzc2023u1hRUM1c75nDJQMIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877589; c=relaxed/simple;
	bh=OwBGBKndrkY4UOMpeQ/YjtGK2kT4XIl1Vu+XG/0bao0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fUP5u5dktDk3P70xtyR6RnZjwCVZMG4okUrtMJek7ptarQuirjsoak5xYh9ShTINaMMRzEA2bdtQMrg6soED55gqon7q8Lj1fxXWsj+/0UyXCQW1F1z/CRkcRb3LVpP4c5YUhYPl+fllDa2EcvCHi3gQFjbli2lENNRziHQfBc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OdB8McD0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OdB8McD0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E65FC4CEF0;
	Mon,  2 Jun 2025 15:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877588;
	bh=OwBGBKndrkY4UOMpeQ/YjtGK2kT4XIl1Vu+XG/0bao0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OdB8McD0QGqhjmWpJGcc53ioivXxX+QTux+iL0hu/FjzQOIJ0AVsFmdv/CBVuuyN6
	 d04ccBkIa9Yy1yA6WSjBsXVMmQihRaRJFoxdj3OhwTbWZo1tEL+enhU9kLrAJJTfqq
	 dcN3ZOTRBvUXkSkNYwHOeuzsut7XdFdxY1/0IWGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Derek Barbosa <debarbos@redhat.com>,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	Hans de Goede <hdegoede@redhat.com>,
	Armin Wolf <W_Armin@gmx.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 324/325] platform/x86: thinkpad_acpi: Ignore battery threshold change event notification
Date: Mon,  2 Jun 2025 15:50:00 +0200
Message-ID: <20250602134333.105880616@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 295939e9ac69d..17d74434e6046 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -211,6 +211,7 @@ enum tpacpi_hkey_event_t {
 	/* Thermal events */
 	TP_HKEY_EV_ALARM_BAT_HOT	= 0x6011, /* battery too hot */
 	TP_HKEY_EV_ALARM_BAT_XHOT	= 0x6012, /* battery critically hot */
+	TP_HKEY_EV_ALARM_BAT_LIM_CHANGE	= 0x6013, /* battery charge limit changed*/
 	TP_HKEY_EV_ALARM_SENSOR_HOT	= 0x6021, /* sensor too hot */
 	TP_HKEY_EV_ALARM_SENSOR_XHOT	= 0x6022, /* sensor critically hot */
 	TP_HKEY_EV_THM_TABLE_CHANGED	= 0x6030, /* windows; thermal table changed */
@@ -3948,6 +3949,10 @@ static bool hotkey_notify_6xxx(const u32 hkey,
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



