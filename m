Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC1951946C8;
	Fri,  9 Jan 2026 12:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960354; cv=none; b=Iw5YC2dcUbSJR91e+Rg0dAbGOUW0IdVjEobKGXcoR9eUbzJvYL72NsHg93R3sDJJNwlt4OJf2J098vAD71MKXOPn62K5uDFcqYQz101qfsdrisZRJlqXNXcduZTUIrY4Xl6szMqyW0upK5FjXo6h3azJKDDR9NBZj+CkPZcMmwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960354; c=relaxed/simple;
	bh=sPIAFPmaYwhtQcsA2MvFKsD3+PDI5kkllsMCPig/Pa8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AQuopj6HGAdGvq5fqefYTi1oMlIDLgVhkaFBMpsT4qzSMnDzux079V71aOYD/8DYN37z/bk0KvS6vgwV5THcN/YSngca6cZIK4OWDmGr2+imAizVx7ngWFe3e9IIV/XJk5neDb/i79/qqQmzl14jtFpWT+RudCUQuVGPftPfnxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jz7+jQe2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jz7+jQe2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 316A7C16AAE;
	Fri,  9 Jan 2026 12:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960354;
	bh=sPIAFPmaYwhtQcsA2MvFKsD3+PDI5kkllsMCPig/Pa8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jz7+jQe2UD5/JkCq12yToYwoqq+TdijB60204Fin81MsZwL/DzwrxG+APX+c/hmpI
	 z+8ms+uFNE0XhxMFZsqMAz2Uxhj5/JTVhojJU7TPA+ysT/MyMSQsF5nAV8Xu5uwVKm
	 DrZrj6OvrU7qDhDSizSX7BZHdQbvoQ//fUXybFik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoffer Sandberg <cs@tuxedo.de>,
	Werner Sembach <wse@tuxedocomputers.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 374/737] Input: i8042 - add TUXEDO InfinityBook Max Gen10 AMD to i8042 quirk table
Date: Fri,  9 Jan 2026 12:38:33 +0100
Message-ID: <20260109112148.063888971@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoffer Sandberg <cs@tuxedo.de>

commit aed3716db7fff74919cc5775ca3a80c8bb246489 upstream.

The device occasionally wakes up from suspend with missing input on the
internal keyboard and the following suspend attempt results in an instant
wake-up. The quirks fix both issues for this device.

Signed-off-by: Christoffer Sandberg <cs@tuxedo.de>
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20251124203336.64072-1-wse@tuxedocomputers.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/serio/i8042-acpipnpio.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/input/serio/i8042-acpipnpio.h
+++ b/drivers/input/serio/i8042-acpipnpio.h
@@ -1169,6 +1169,13 @@ static const struct dmi_system_id i8042_
 		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
 					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
 	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "X5KK45xS_X5SP45xS"),
+		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
+					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
+	},
 	/*
 	 * A lot of modern Clevo barebones have touchpad and/or keyboard issues
 	 * after suspend fixable with the forcenorestore quirk.


