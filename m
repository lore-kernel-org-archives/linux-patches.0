Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0920E4156F0;
	Fri,  4 Sep 2026 05:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499852; cv=none; b=kpdrNw8oWmsHbmNEpC+lfjlbAWFQdo3Sntg0rrABfzG1KrVY/HKA4ZfnBY3bmvWOKQpw9YeQGHeB2HNbX94i3BJrjg7y4xCnMlxySSdTRWmEbvmwu1Se9dynq7fSGcz+1C+Sdk/lAHtFrCFC8M19hiQlhKeUie9azndEBArH3Sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499852; c=relaxed/simple;
	bh=+n6V/4o4rT599/10VUGtiRHKNgumsKaPG5Qv/2QW2Ks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ifn6IOZKc3NwlaFNXYdUWk1HgEkdbRKrPhgUPmSY34SU2gMJFYSUS1YPHpu1G0ffrLzRwPdPH32k0Hb6jxLAuZhYdi+Pf5HrgHohDUtvlCS1Figwvc2ymsMSgzZpD7KZvVfbJYsMvsltFpki+l4qKgOnNxeZZLyVKsirYTmNeO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0jxlD2Xz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0jxlD2Xz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 188061F00A3D;
	Fri,  4 Sep 2026 05:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499850;
	bh=RCUNtF57TbU3T8ez8IYVnKHHhXfvydH85u43VgbzqLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0jxlD2Xzuf9886p8TYw8hKWGyrCkNrsBkUVkmf81SLBIQVPUG48EmvF9/ftljFOHU
	 S2rGFWEjduEO+tH6od+S1YRxda6QBeOxlP0V5WEx08G0uLyFpxPa+D4sjs7Zk3bCsE
	 Fg6OWlRy+bDmsteu155AyTGqXMV+5OL9f47WgPak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yahia Ahmed <yahmedd043@gmail.com>,
	Krishna Chomal <krishna.chomal108@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 7.2 563/713] platform/x86: hp-wmi: Add support for OMEN MAX 16-ak0xxx (8DD6)
Date: Fri,  4 Sep 2026 06:58:51 +0200
Message-ID: <20260904045816.438557296@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krishna Chomal <krishna.chomal108@gmail.com>

commit a7320d6eb9c4240c948cd9c64582b3bd04cbaf4b upstream.

The HP OMEN MAX 16-ak0xxx (board ID: 8DD6) has the same WMI interface
as other Victus S boards, but requires quirks for correctly switching
thermal profile.

After testing we know that (similar to another HP Omen Max 16 device,
board ID 8D87), the embedded controller on this board does not expose
thermal profile which means we have to intentionally disable EC readback.

Add the DMI board name to victus_s_thermal_profile_boards[] table and
map it to omen_v1_no_ec_thermal_params.

Testing on board 8DD6 confirmed that platform profile is registered
successfully and fan RPMs are readable and controllable.

Tested-by: Yahia Ahmed <yahmedd043@gmail.com>
Cc: stable@vger.kernel.org # v6.18+
Signed-off-by: Krishna Chomal <krishna.chomal108@gmail.com>
Link: https://patch.msgid.link/20260623141314.33947-1-krishna.chomal108@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/hp/hp-wmi.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/platform/x86/hp/hp-wmi.c
+++ b/drivers/platform/x86/hp/hp-wmi.c
@@ -266,6 +266,10 @@ static const struct dmi_system_id victus
 		.driver_data = (void *)&omen_v1_no_ec_thermal_params,
 	},
 	{
+		.matches = { DMI_MATCH(DMI_BOARD_NAME, "8DD6") },
+		.driver_data = (void *)&omen_v1_no_ec_thermal_params,
+	},
+	{
 		.matches = { DMI_MATCH(DMI_BOARD_NAME, "8E35") },
 		.driver_data = (void *)&omen_v1_legacy_thermal_params,
 	},


