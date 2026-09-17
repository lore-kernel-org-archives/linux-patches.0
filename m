Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B09DF3C9892;
	Thu, 17 Sep 2026 17:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665136; cv=none; b=GHMmeMvjIjUR1VRQ2RBPsOleP3qi+SozYDNBo/pgskGmXuq1lWm4DLxGuIB2DjwL7OyV8SPkVQO9t11Ah76nOiNnYSH4uxfBg9RDGng90nZ464yndJzFz8F7KQHhdSlMaxkuiK2iYD9moF24eCI9xCXLk3rcbQzNMKFNkP/hn5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665136; c=relaxed/simple;
	bh=WpfT2q/HnGj5DMNd314FZGsvgeTKcUJllc0grMZTcIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q5e14ocC2c8TB3qXiX7PDNBZg62AdIoWlH/8PktnQ7rwFoA9tywX86xloXR8AX21/0s4IBgPi8v9hwYqmAbgmPrgVrnGnbYCjSW95WqhmH0yBkzSktHl9WXbrhB/61b6ZDNRVef1Fg+hrU3/SI+l79cEvLfXcHRekqdGZ6FM6HM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lniDNDlj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lniDNDlj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF5A71F0089A;
	Thu, 17 Sep 2026 17:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665135;
	bh=jVOSI5UUKqnSJ/ENU3ZfDHUj+REL/F3AIT1jWSjf7oY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lniDNDljPB6UoQCn7DQmbiKLqcJHqni9GJve/Z9eg8Tf0+TSK2R+Wrp8Cg1Cm5StS
	 ePIUEfS26E/arGo8Rl9tllBsmmfqjtrSbCwy18tLRnU6O8mKcBsHgPpD1Ccas3fi+c
	 YEkKzH7whZsdwFSFDC+7UWiTd8+IV5CWExhARbDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0561/1250] ata: libata-core: Disable LPM on WDC WD141KFGX-68FH9N0
Date: Thu, 17 Sep 2026 16:05:56 +0100
Message-ID: <20260917151607.133515368@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit 3971921a055330669b281962ff723d1abb76a58c ]

According to a user report, WDC WD141KFGX-68FH9N0 has problems with LPM.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=220693
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index a7a89b675a912..ef7f93aca36d1 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4379,6 +4379,7 @@ static const struct ata_dev_quirks_entry __ata_dev_quirks[] = {
 	 */
 	{ "WDC WD100EFGX-68CPLN0",	NULL,	ATA_QUIRK_NOLPM },
 	{ "WDC WD102KFBX-68M95N0",	NULL,	ATA_QUIRK_NOLPM },
+	{ "WDC WD141KFGX-68FH9N0",	NULL,	ATA_QUIRK_NOLPM },
 	{ "WD Green 2.5 480GB",		NULL,	ATA_QUIRK_NOLPM },
 
 	/*
-- 
2.53.0



