Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8F2D421EF4;
	Tue, 31 Mar 2026 16:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974783; cv=none; b=cnzMe7Ey6NyE4+OL3Jf91Q9Bx5GIP0Ow5kNo/+tiDtvwwkR4VLZEmoOcejiPA3nsqVjYNw7rWvNlU3Mh537kqMlUPWhdEUeIuIbNfwi7XUy0rDyyGe3TlJ3aBS9zUJYFaTzfu1fMWB5Se7YvRFxS3BCRB+EYYYYLCvSL1g2s3iU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974783; c=relaxed/simple;
	bh=rl+NCeE3MZ3YImvgTbfK4NmC6ZnNvXxCNUlCs3/H8CE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Dp5wNQm5ManH/1GRo/TNFmwODHOyC8r0haUbouDIGKf5k4JQElbUBSzmFIDAsmORHyANLOaDDPNCkx65BHSJsLSnEaNKlL6RZWsJC7xbGvic0XdVPUILRc6ygfyhM6VISCfkDWU7iqoTzKWX8PP9AIzTxWBa+jDy0sJy1IIB/yI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=noI3OnA6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="noI3OnA6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50108C19423;
	Tue, 31 Mar 2026 16:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974783;
	bh=rl+NCeE3MZ3YImvgTbfK4NmC6ZnNvXxCNUlCs3/H8CE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=noI3OnA6R/oN1wxqRLRC1HJg0GbE6xr7W5IUHIfXw7fuzS7wYVjHzPJH2C7w2I8im
	 YbzAT1qHD8+z9zG4sdF6e8Ck2yBcN059r6utlBwLsUuhCuaC9Etygi4vYOL/Qlikn8
	 lU/tVOWL1tJ/mIkw7WJDbcA9ydSS5T9YhyvQmurs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antheas Kapenekakis <lkml@antheas.dev>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 042/342] platform/x86: oxpec: Add support for OneXPlayer X1 Air
Date: Tue, 31 Mar 2026 18:17:55 +0200
Message-ID: <20260331161800.450728939@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antheas Kapenekakis <lkml@antheas.dev>

[ Upstream commit 2a3b4a8c10a64a62c4243007139d253dc1324dfd ]

X1 Air is an X1 variant with a newer Intel chipset. It uses the same
registers as the X1. Add a quirk for it to the oxpec driver.

Signed-off-by: Antheas Kapenekakis <lkml@antheas.dev>
Link: https://patch.msgid.link/20260223183004.2696892-4-lkml@antheas.dev
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/oxpec.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/platform/x86/oxpec.c b/drivers/platform/x86/oxpec.c
index 158c545d4efbb..6d4a53a2ed603 100644
--- a/drivers/platform/x86/oxpec.c
+++ b/drivers/platform/x86/oxpec.c
@@ -247,6 +247,13 @@ static const struct dmi_system_id dmi_table[] = {
 		},
 		.driver_data = (void *)oxp_x1,
 	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "ONE-NETBOOK"),
+			DMI_EXACT_MATCH(DMI_BOARD_NAME, "ONEXPLAYER X1Air"),
+		},
+		.driver_data = (void *)oxp_x1,
+	},
 	{
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "ONE-NETBOOK"),
-- 
2.51.0



