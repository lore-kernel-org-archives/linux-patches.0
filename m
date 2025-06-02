Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6884F22A814;
	Mon,  2 Jun 2025 14:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875864; cv=none; b=KuQGhIUVnERDK/R5ji8cBa6BMiQ2qrUrfi8jizzdoMSCMFC8CPlvELu3JQY4CnVegU1raKS4hAdCwtvqvBsRZSbJ1c6PPbeW4Nj9W3FUf0/0LtRvcvujLZ+rml0tzuWvBsEzC6K1cwhW/IL2q1k16l2pVkh77Wxaown1Azcw+Ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875864; c=relaxed/simple;
	bh=noIJ5uW3aL5siMsgwUZSFkb+qp18jc3hUcsbDTbNOsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OUBKK2tBTRPUD329cP9U6bslUIFdMkPgX5hE0KirOHBznjbQtiI5bSsRZFs5n9qC9qmNE10LH3QabN9mg0zrtzBMxSpprnDXEzuX4bID5wjOPR1dit+kdrE3iBxK+1OUtXFf2k9Zjo0fMNSTXNTXA5AtzDGA6Q2SWLyPvlDCcr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BPNJd/jT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BPNJd/jT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92EC2C4CEEE;
	Mon,  2 Jun 2025 14:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875863;
	bh=noIJ5uW3aL5siMsgwUZSFkb+qp18jc3hUcsbDTbNOsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BPNJd/jTszfQXRs3E3RUOFvUEbKCzG2rUUIadi4fNgG0qFBMmwj8y0X9OLTbHd9zi
	 KU7Ou+GweJuaGPYIGyxgsEL9Cds1k83/gXi2r51j/zMpYuqmNAhFtuIoxZgtaoUa86
	 QLbJLMuPfFDttu92mJlwVe5JfwQC1A8WM5+aUP/Q=
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
Subject: [PATCH 5.10 268/270] platform/x86: thinkpad_acpi: Ignore battery threshold change event notification
Date: Mon,  2 Jun 2025 15:49:13 +0200
Message-ID: <20250602134318.292242844@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index e9e63d8cbfbfd..5a8434da60e78 100644
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



