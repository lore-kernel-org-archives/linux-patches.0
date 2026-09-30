Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F7972222D0;
	Wed, 30 Sep 2026 18:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794490; cv=none; b=VoO2fkY6t0yB4T8DpNwaUaZ+kFo3zAhhKlvfF2m5JRcV4dGTARXG/BLr1sqYYe9npNmZRtu4cU+sU0Y5/gdk5cJBm9xgGSbBK+6dKinsSiQfsstkOS2RnKh5SIv2Q0yU+/IoTcCnRV36dTXNFurNxxAJLp3CBiVM8w7YrNxJL1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794490; c=relaxed/simple;
	bh=vSfJe4wPlQGM7d0ZGBtYwPGyegln8jQE8cG4jzatoyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N+teKZ6ljpLjQsJATsOJ0UjyB4ds/tc9HB6OUH2LwQJuHT4/x4H8CfrWFU4Xoktsn8roFEnrGd0+f5kAXi8c167hkBakBvV1oFau6OTryjsuOatG+S5nJ61RMEBPcR+GHt7wi5u4dkEbUxNb4jJXVCQedPsEgngASlNGxXfgmLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MThg5sXq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MThg5sXq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0730D1F000FF;
	Wed, 30 Sep 2026 18:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794489;
	bh=AHfxSQdd7FK06quP3DS5nFkTaWckjZEpkAJSBOYJrfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MThg5sXqvxK81Liu6xU/WreipdYxJHhxPT78C4NmZmU7tSpOyA8Rz0wh0KTx9CEjz
	 FiQM0oNDch8pohEBYbLR5uxLu1qQQD7VJo6zsBOaeAHmQYChkXYQiVtg0Jb2GgXEsX
	 QvjdxchuJdnOnNSscah0Z560gOryISFEEv/ca0XQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gleb Sonichev <sonichev555@gmail.com>,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0195/1193] platform/x86: dell-laptop: add Inspiron N5110 to touchpad LED quirk table
Date: Wed, 30 Sep 2026 17:14:39 +0200
Message-ID: <20260930152438.534972279@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Gleb Sonichev <sonichev555@gmail.com>

[ Upstream commit bfe91a80b13f8068f6fa07aa8c468d284150d4ad ]

The Inspiron N5110 needs the touchpad LED quirk (Vostro V130 quirk)
to properly control the touchpad LED. Add its DMI identifier
to the existing quirk table, next to the similar Inspiron M5110 entry.

Tested on Dell Inspiron N5110.
The touchpad LED works correctly with this quirk enabled.

Signed-off-by: Gleb Sonichev <sonichev555@gmail.com>
Acked-by: Pali Rohár <pali@kernel.org>
Link: https://patch.msgid.link/20260525100047.20046-1-sonichev555@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/dell/dell-laptop.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/platform/x86/dell/dell-laptop.c b/drivers/platform/x86/dell/dell-laptop.c
index d151202bc9949..0ea4c2168fb45 100644
--- a/drivers/platform/x86/dell/dell-laptop.c
+++ b/drivers/platform/x86/dell/dell-laptop.c
@@ -206,6 +206,15 @@ static const struct dmi_system_id dell_quirks[] __initconst = {
 		},
 		.driver_data = &quirk_dell_vostro_v130,
 	},
+	{
+		.callback = dmi_matched,
+		.ident = "Dell Inspiron N5110",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Inspiron N5110"),
+		},
+		.driver_data = &quirk_dell_vostro_v130,
+	},
 	{
 		.callback = dmi_matched,
 		.ident = "Dell Vostro 3360",
-- 
2.53.0



