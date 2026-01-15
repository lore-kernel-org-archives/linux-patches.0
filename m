Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAE4D3BB9F3;
	Thu, 15 Jan 2026 16:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496364; cv=none; b=LSOvaYFxNOfiy0Z2tu1S7UosvWiy7iMZXW7ySqAZY77voy6QkiuCPQhw91upKeylzqFkqHcEKRRRHa7iWteDzvTE9n+nBIfw4W/bycoSh8u3gEEmN/AuJHXM+jNiJJdWnub5U9supTj7Xq6F+NOFPtWsHgyTXb/jzs0eNTfH60M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496364; c=relaxed/simple;
	bh=PypxCJlYWZnZOei2r3u2u3TgeLauKPSJJptlFipvNe8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PSWLVJAtjPWxwK2BDaqhErO1U7vODg1udrfPYLudt4dCC5LNJQVOcj0x3WnVR7e7yrtgJKb/+Q1oS3Horqc0iGZ6JpqlGFyZuYUtlDP+9U4MSH9ETZ+3va6PpAaS7haOaBGS6lXqu5KeB3xqTPv1xv7++orYbj6w3FAOS9FbaJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UURz/EMW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UURz/EMW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 594A5C16AAE;
	Thu, 15 Jan 2026 16:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496363;
	bh=PypxCJlYWZnZOei2r3u2u3TgeLauKPSJJptlFipvNe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UURz/EMWax5PKE3soy9PgJF5tV9Unx+vZAlAWY22RgM7HPZ4JSLRRbcDJDt8+GQBU
	 nlIz2lQAdquP8ofUFOuhCvSoi1ww2zB3EfnALe1fSUmSFLqDvoO4150QqZgNfYHRtC
	 ijPJhRLUFPF97r5T0kNWKl+8vuRYJVF8y2fgXkDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emerson Pinter <e@pinter.dev>,
	Niklas Cassel <cassel@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 169/181] ata: libata-core: Disable LPM on ST2000DM008-2FR102
Date: Thu, 15 Jan 2026 17:48:26 +0100
Message-ID: <20260115164208.414847068@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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
index f48fb63d7e854..1216b4f2eb904 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4132,6 +4132,9 @@ static const struct ata_dev_quirks_entry __ata_dev_quirks[] = {
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



