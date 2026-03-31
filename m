Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B0BC413225;
	Tue, 31 Mar 2026 16:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976280; cv=none; b=l42fTymG/phU7SWtKMJZgRPRSEXliJ+FzWXdCBnGwNP4ZJj4jhHU8yMKQt7D6O58skIv3qygBGtZ1Nu08su/IUDmAL9Cc0LT/oXTXTkm48y85q7MLv5y52XJH7g0gD1VESPZCKjxhc3DkJ55PYVeDst+UNCuGg/bC5CM4GVJ8yY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976280; c=relaxed/simple;
	bh=uMT6AlfBWmZDkJySJC33Mdc2sZmmD/a/VHKwijdapsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qdFIqm6LlT80erOTxh2HnOkJg2bcusp0HB4kjwkjedlCeWWfPD/fkU2RMy2DgBc2fCHZucO91aZ3tsmnQwSLA2Kz4TwlmgZe36wYxrPMJ6FuiYPFdxEp6rrr8Xws1zgelVLY3l9LtaVBKX93e/T9W8jhrTG97UgCjB5o1/LGhss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lFQXsg3y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lFQXsg3y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C6F9C19424;
	Tue, 31 Mar 2026 16:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976279;
	bh=uMT6AlfBWmZDkJySJC33Mdc2sZmmD/a/VHKwijdapsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lFQXsg3yI2JIQrCQo1V76bSUlN2oPL7Ts8idTnnJxQ87rvp87sc0BLu6RiH066Ep2
	 +Kul93QQXLaqwc1DOn5Eaww9wh+8PsaDiOwI0y2tcOnXmciNxvfZ/+lXJYKhGMPefn
	 SsDMxWHB8nvviP6jU3NEJSrJ9zcuxTnQQb/PUbEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antheas Kapenekakis <lkml@antheas.dev>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 032/309] platform/x86: oxpec: Add support for OneXPlayer X1z
Date: Tue, 31 Mar 2026 18:18:55 +0200
Message-ID: <20260331161754.664209242@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antheas Kapenekakis <lkml@antheas.dev>

[ Upstream commit 4049c46edb5d44c0de045f6f504371705dd603dd ]

X1z is a variant of OneXPlayer X1 A with 8840U. It seems that only one
user has this one. Add a quirk for it to the oxpec driver.

Signed-off-by: Antheas Kapenekakis <lkml@antheas.dev>
Link: https://patch.msgid.link/20260223183004.2696892-3-lkml@antheas.dev
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/oxpec.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/platform/x86/oxpec.c b/drivers/platform/x86/oxpec.c
index 9511791f04d9a..bf07732776ca9 100644
--- a/drivers/platform/x86/oxpec.c
+++ b/drivers/platform/x86/oxpec.c
@@ -285,6 +285,13 @@ static const struct dmi_system_id dmi_table[] = {
 		},
 		.driver_data = (void *)oxp_mini_amd_pro,
 	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "ONE-NETBOOK"),
+			DMI_EXACT_MATCH(DMI_BOARD_NAME, "ONEXPLAYER X1z"),
+		},
+		.driver_data = (void *)oxp_x1,
+	},
 	{
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "ONE-NETBOOK"),
-- 
2.51.0



