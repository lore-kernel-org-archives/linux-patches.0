Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9E83356757;
	Thu, 17 Sep 2026 18:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668548; cv=none; b=dlQfbMMrYvjrvw7I5qy2wugQgFrkIwbz8Bc677F/RcUY8HD0D+27C+L9ied6d+Z77SkfVvFloXDfFR7e6tEBcXuvP/fRV4lJdEHfhWLjxWxLV7R8P8IYFnlbkEUgoWMc4FNu3mNManh9S89Xx5K2Vmmbjh+KEy+14TmYHaVHrGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668548; c=relaxed/simple;
	bh=rZLtGSxTzVVqBCUeUyNFY/0hv0WgQcJm95x8vwdo1mE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jO1NkQedgNPY4QG8HH7yvS1Sobi8upB46ouh97aRYcXwG/YGzqtPcvpKifANp6oS12HUn65ogkNXlJYgcHpzCyxjD1Z4LzCueuJhcDQwpmS9ftDsdrdn/eUx2xdx82E95XszkoCLl7si5cTbDECIP4C5/n37tYsFpv43Ve4p4DQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HrP+cGPc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HrP+cGPc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DFDC1F000FF;
	Thu, 17 Sep 2026 18:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668546;
	bh=+P/Q8+USsGK0cgI7TSytWu2ecfm5HEQg/e04mKfqG38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HrP+cGPcIXMZMguQwdFAzlBwokomsIO86Ey2XbCLHGizSnxH5F9Q3L7vBHZkdfcWh
	 VNJutUBcwgBrvh6XeWJQPaz3Xy5xE1vdjrHsnN8xDxtRByUypGGDwZBsezOYg0oEbQ
	 Z1hJ39lqFcnOXDyUYRGAUPq2k3PKtKzAVgSeLnQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0458/1102] ata: libata-core: Disable LPM on WDC WD141KFGX-68FH9N0
Date: Thu, 17 Sep 2026 16:06:41 +0100
Message-ID: <20260917151551.185115235@linuxfoundation.org>
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
index dc3e7d8eae161..caf77faf7a33f 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4324,6 +4324,7 @@ static const struct ata_dev_quirks_entry __ata_dev_quirks[] = {
 	 */
 	{ "WDC WD100EFGX-68CPLN0",	NULL,	ATA_QUIRK_NOLPM },
 	{ "WDC WD102KFBX-68M95N0",	NULL,	ATA_QUIRK_NOLPM },
+	{ "WDC WD141KFGX-68FH9N0",	NULL,	ATA_QUIRK_NOLPM },
 	{ "WD Green 2.5 480GB",		NULL,	ATA_QUIRK_NOLPM },
 
 	/*
-- 
2.53.0



