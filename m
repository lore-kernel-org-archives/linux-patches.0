Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9208B1F30AD;
	Tue, 27 May 2025 02:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748313472; cv=none; b=CwA71z5f7CgImThmaDxx3ZPOichrKraFZlF8p5Y8YiU8+R9J1UTtrG1fwDWfB9tcEZzp12oGDjA38wrO6I6DWf1ZZ7miaEoWcq7LIAFpd+ZmkvPrOSckw6T0tIpl2ALwuYf2ZyN6H3nERB+S2ZkV3AsQQHo+EVe4aJz1l15D6Us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748313472; c=relaxed/simple;
	bh=UIkIdWu5BZZYO3DwL/7oUkvx4wilRA1O+jr4hhW4VzU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hKezSldJJedf5uOf9y8CPUlDdTtDBEWOjPKo1dSZBkKqWRUUw/uLQM/RvVy1nnozYPCkOcbeZDxrpXsTe4t9NdzsGMJZq4gxySvPzPYoIT7At+ZClnJtTqmdv8GHSzIxxud8PPfEeL4ajy+VVofNfW3Lk6u0iSSKTpS1J6Gl69Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qEqKuqLO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qEqKuqLO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1FF5C4AF09;
	Tue, 27 May 2025 02:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748313472;
	bh=UIkIdWu5BZZYO3DwL/7oUkvx4wilRA1O+jr4hhW4VzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qEqKuqLOuxZeecWTDOOQn7h4MrL2f9TzL9PyjyQcTeWrDsP2BGnFnsIhD2eLUiVjf
	 xVwTfhspvaiQdMLDrtWGzFqRwYqp+nKTehM3RpLvpZj8xngLSqRXCO1poIb+IZiQvg
	 3aiCsbb+B4VMNHCVCoCPZeQUqytMPyqi7scHk/VLEGDDhyIkynWct8L1Qoh/EC4tWX
	 VkkP+eHUIaraA+/WZsL981heOU/PmyJL/NlgO6BSxEoEQhcZfiAm+/jyaQ0Q9kpUzD
	 gRiUE7NCDqzVnIWUbFEYCXJJbxQCsfD8XA41UC96S0kKz8vtz7o6euUz2rVD9eWlLh
	 e8f4tb8z27WlQ==
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
Subject: [PATCH AUTOSEL 6.12 3/5] platform/x86: thinkpad_acpi: Ignore battery threshold change event notification
Date: Mon, 26 May 2025 22:37:43 -0400
Message-Id: <20250527023745.1017153-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250527023745.1017153-1-sashal@kernel.org>
References: <20250527023745.1017153-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.30
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
index dea40da867552..99d6c72892f7c 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -232,6 +232,7 @@ enum tpacpi_hkey_event_t {
 	/* Thermal events */
 	TP_HKEY_EV_ALARM_BAT_HOT	= 0x6011, /* battery too hot */
 	TP_HKEY_EV_ALARM_BAT_XHOT	= 0x6012, /* battery critically hot */
+	TP_HKEY_EV_ALARM_BAT_LIM_CHANGE	= 0x6013, /* battery charge limit changed*/
 	TP_HKEY_EV_ALARM_SENSOR_HOT	= 0x6021, /* sensor too hot */
 	TP_HKEY_EV_ALARM_SENSOR_XHOT	= 0x6022, /* sensor critically hot */
 	TP_HKEY_EV_THM_TABLE_CHANGED	= 0x6030, /* windows; thermal table changed */
@@ -3778,6 +3779,10 @@ static bool hotkey_notify_6xxx(const u32 hkey, bool *send_acpi_ev)
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

