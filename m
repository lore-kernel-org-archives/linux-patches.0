Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F883423A70;
	Tue, 31 Mar 2026 16:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974781; cv=none; b=TayZ4NV1dABr8ITxInGV0tt8Ih5Kp26zUSegvD+Zi6F3o8BlwoOj1HhhhpBZPgCNCtP0QUO8pVoK0+c139OnKWHSP3g2y/942s0it7bTpP7Mgfx5dJ8CPa6lyjvnq7+zQbX44YDrTJS6HAY3mP9Wej8S59Sfs5V8jnoishP4GKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974781; c=relaxed/simple;
	bh=QWStvSvssEq4gXdYyWCFDHC6FrRjRvdczL+WTxtB28s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MUCkOy5BMdgGDJVChA5mYSvQQwSVzy4cahCS9joBpwtIz07JeDAj9rOq6Z245p17XakpOLFPKGycsOER4wE5lf2jWedqtdLmFrHaxEEWtj+3WlOL2GUu/f2dfVjbJFBkp4nq2QJqIU8T3ZL0XsfUXiRsvWlD2hXPBPQVcmetXFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QkSuUboO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QkSuUboO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9D3CC19423;
	Tue, 31 Mar 2026 16:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974781;
	bh=QWStvSvssEq4gXdYyWCFDHC6FrRjRvdczL+WTxtB28s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QkSuUboOqPBR7v81lS+s1oLreDoxLh0YLps3K4bWLgw3SW2knQgH9zGU6S6tsEbof
	 QOiY6S6Tvij4fihzXHPN1knEdsreTlGAIrNJUGExBd8ZoX4weX7peiUXe/Qd0MGtVc
	 dENSDV5LJua65dyQ6BYr2h+OPC1v//01QF6GHGEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antheas Kapenekakis <lkml@antheas.dev>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 041/342] platform/x86: oxpec: Add support for Aokzoe A2 Pro
Date: Tue, 31 Mar 2026 18:17:54 +0200
Message-ID: <20260331161800.414430104@linuxfoundation.org>
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

[ Upstream commit cd0883055b04586770dab43c64159348bf480a3e ]

Aokzoe A2 Pro is an older device that the oxpec driver is missing the
quirk for. It has the same behavior as the AOKZOE A1 devices. Add a
quirk for it to the oxpec driver.

Signed-off-by: Antheas Kapenekakis <lkml@antheas.dev>
Link: https://patch.msgid.link/20260223183004.2696892-5-lkml@antheas.dev
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/oxpec.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/platform/x86/oxpec.c b/drivers/platform/x86/oxpec.c
index 623d9a452c469..158c545d4efbb 100644
--- a/drivers/platform/x86/oxpec.c
+++ b/drivers/platform/x86/oxpec.c
@@ -114,6 +114,13 @@ static const struct dmi_system_id dmi_table[] = {
 		},
 		.driver_data = (void *)aok_zoe_a1,
 	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "AOKZOE"),
+			DMI_EXACT_MATCH(DMI_BOARD_NAME, "AOKZOE A2 Pro"),
+		},
+		.driver_data = (void *)aok_zoe_a1,
+	},
 	{
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "AOKZOE"),
-- 
2.51.0



