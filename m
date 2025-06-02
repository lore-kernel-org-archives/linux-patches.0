Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 044EB2C327E;
	Mon,  2 Jun 2025 14:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875035; cv=none; b=G9hbH4OTY6apzkaZV6MPkHyRxtpF3+tDToVAyKFSf4EcKhUTyjemtRGe0Jf2MaTWtCXBFlcKYYo++XRYdF+5BO09cAL17sXj0+pBwj6hSAFsxKYxJA9opUvtMueRq1NoLoYUG70xHQIm9YvYLZllTMA436F6pXCWZRNNrgaLr6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875035; c=relaxed/simple;
	bh=HegTlO36RaKslskhO6uVBGA0cuAN54bvk59PsOE7+SQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tYghGYFvV/YU2+r52zuWX6rl3WUPYuemY2JHGJ025EYsvsWAs43RlGeGxPPpZVseK3tlMNQxNXC7p/0QudW73qocV1MfNjP2BY8JDl7Otcvu3MAgR8JCvoT65+xNdQlcotg9RAyNByal0EO7i2nyDVn5Hgo/X3HBCe/cSORgnhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=htcRmf01; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="htcRmf01"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 695CAC4CEEB;
	Mon,  2 Jun 2025 14:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875034;
	bh=HegTlO36RaKslskhO6uVBGA0cuAN54bvk59PsOE7+SQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=htcRmf0123rs43Xf/m3wuFV4zZi/PKBCMrsJcIBDTSEokRk0FHWzGU+1fHYPhINxM
	 8E69YeEj/unsouR73ZLfrbq9uko1VE31+h9aG6eQTvDax4sqxW/RVlbISpImloh4Ly
	 inifv7pOuPk6sI9ksoG/M6r9CLhn5lVM3dn/GpCc=
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
Subject: [PATCH 5.4 203/204] platform/x86: thinkpad_acpi: Ignore battery threshold change event notification
Date: Mon,  2 Jun 2025 15:48:56 +0200
Message-ID: <20250602134303.648394259@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 441b7fb6b37af..9eb74d9e1519c 100644
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
@@ -4059,6 +4060,10 @@ static bool hotkey_notify_6xxx(const u32 hkey,
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



