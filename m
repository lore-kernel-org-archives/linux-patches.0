Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D2073BF30A;
	Thu, 15 Jan 2026 17:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496754; cv=none; b=JFHTZVJrluvkhK0yvMMMHRArRFe9H461FpGUl6L+xfJbFU7bn7phE61ELUZ+SUwTNzcJZA+N2nDMSTAYFk86Z8Vq7EBEUs8K3+LirQB2rtWMjyqhQNs6Fh6yKHhpiD1jA8jbnz/V6CAY9ls8/rObE45t5YpeLqev1wZh/Iexj8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496754; c=relaxed/simple;
	bh=zll4jvel5PKNAMJUvOf+3etQmqmHYCW4S++MBucOTpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YlpvBV4Cx31SGwmlTaTu/gVD9k1PQYRi6nTRfeLXdRd/DdYVrALmAWRJW3Q6Uw98S9z6SPZvvKOUAoAhyNzmWcH6notOFmMdWbTA6TzPnjFoRZrs5qYVkDw0pKwzpbuqY0ZdnQ7SmI5S5h95mTgGrOn+CDBPeX2tMqai3uTQJYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OfkgODP8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OfkgODP8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC3E6C116D0;
	Thu, 15 Jan 2026 17:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496754;
	bh=zll4jvel5PKNAMJUvOf+3etQmqmHYCW4S++MBucOTpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OfkgODP8qhjt203a4kqfOoCvLEWmC/3pA9gZXnV8nUWrbL4SFg1YJy3dJWuRoUcQk
	 lMINdEVfq6uENuULIYCiWN2UQVW1ndMCBVnF5MmDHOFZE/fJG+PNHc3hmzMLxKO9q2
	 ugRku2phf7YS21wxQrV1py3qXApwXvrG0WE1sZp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emerson Pinter <e@pinter.dev>,
	Niklas Cassel <cassel@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 106/119] ata: libata-core: Disable LPM on ST2000DM008-2FR102
Date: Thu, 15 Jan 2026 17:48:41 +0100
Message-ID: <20260115164155.777881584@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
References: <20260115164151.948839306@linuxfoundation.org>
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

[ Upstream commit ba624ba88d9f5c3e2ace9bb6697dbeb05b2dbc44 ]

According to a user report, the ST2000DM008-2FR102 has problems with LPM.

Reported-by: Emerson Pinter <e@pinter.dev>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220693
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 0cb97181d10a9..802967eabc344 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4064,6 +4064,9 @@ static const struct ata_dev_quirks_entry __ata_dev_quirks[] = {
 	{ "ST3320[68]13AS",	"SD1[5-9]",	ATA_QUIRK_NONCQ |
 						ATA_QUIRK_FIRMWARE_WARN },
 
+	/* Seagate disks with LPM issues */
+	{ "ST2000DM008-2FR102",	NULL,		ATA_QUIRK_NOLPM },
+
 	/* drives which fail FPDMA_AA activation (some may freeze afterwards)
 	   the ST disks also have LPM issues */
 	{ "ST1000LM024 HN-M101MBB", NULL,	ATA_QUIRK_BROKEN_FPDMA_AA |
-- 
2.51.0



