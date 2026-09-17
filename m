Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E36C94E3769;
	Thu, 17 Sep 2026 18:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668530; cv=none; b=EvJsye7P/UURuWXwKUlYc0u1E6FasHSX2Q//cz4l/h8XT+ZPDLQnK59fSAQajJtfxoLhW0ZyxI3YPApBPVNFwewD/TLyMQl6Ct/PJgYSMGwyoS2yxB2sZg5pqnCLq+G5OXn4J/swlO1jqnrs16jrro62/ARefhhbljpU/EOsFzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668530; c=relaxed/simple;
	bh=JhR8XpJZNVKXjdajAHEEdtcZiDVxWSAnCgUgxm1hLR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nQgimJ9Ya5iWK9e9/bJbWn74d1mke4zLmajVwzVuMm51dumxYTEVdg1RmA+TiPVqrAYy2A3o9PGmH/yWPvSjDuBrNlKVBSBDavWemDutVbP4YYttz3pGsYWDZSgYuoOzBIZyqSIrHmV0KA1p6sf3uVzgJEhO5PGE/qYz2hsgJe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x37CZ1ba; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x37CZ1ba"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 131181F000FF;
	Thu, 17 Sep 2026 18:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668528;
	bh=F6UZ0ksxpmBkdgoTpk0AEpjKm7XmLNNtI2qFGzdr+uk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x37CZ1bacQMinqHfnpy81+P0F6e8zXJhME2uPFvpFAboI3F7cNZCkEgeoQEbA1CXJ
	 30My78O3bEqaq4rWI6BwX68Frq8nQK9EuHxodFN7lRlzgqDbX9NtLSneHZ523Hptkw
	 rJ2cgdP3ADUd7UiaKmJVNqz6Z4D6Vr/eUgJMuNGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0453/1102] ata: libata-core: Disable LPM on WD Green 2.5 480GB
Date: Thu, 17 Sep 2026 16:06:36 +0100
Message-ID: <20260917151551.059208997@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit d549df8a0ace611bff0a336a907f93420648b462 ]

According to a user report, the WD Green 2.5 480GB has problems with LPM.

Link: https://lore.kernel.org/linux-ide/CAGiKK17Fg4SgS+y0GzD3new44QzD_yPZU5V3ZeHdUr9mFnfn1Q@mail.gmail.com/
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 816f756c5b094..dc3e7d8eae161 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4324,6 +4324,7 @@ static const struct ata_dev_quirks_entry __ata_dev_quirks[] = {
 	 */
 	{ "WDC WD100EFGX-68CPLN0",	NULL,	ATA_QUIRK_NOLPM },
 	{ "WDC WD102KFBX-68M95N0",	NULL,	ATA_QUIRK_NOLPM },
+	{ "WD Green 2.5 480GB",		NULL,	ATA_QUIRK_NOLPM },
 
 	/*
 	 * This sata dom device goes on a walkabout when the ATA_LOG_DIRECTORY
-- 
2.53.0



