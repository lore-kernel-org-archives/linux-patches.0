Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBDB32036FE;
	Thu, 13 Feb 2025 14:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458250; cv=none; b=Kd7bogJRG/7HVe91B/+1tAaPFzUj2mtbWkIRX960bYTTotc16At3fqN8CDXT7YzxsyVCa/cjdurTNesGpSfJpd++oMWDecJGsZG8agTgi2JccrKDs2rOyaj+5HJpNLW5dmOSJPiOmWfLY1I3hpycCqQbUFR2LhklmTN2acYYlJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458250; c=relaxed/simple;
	bh=BfBKFjKW7uiZGtDqZvB46FhCtfAkDfNEdp5VjWAkY6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q1XCQFlzWaDzZIysOlEZ93Id7UMwPMv8KUvBCizacX1iSJBHf9JMkkIa9YW0vCMX17OUqn/jwxIKsfXk7W+mLnW+lRQVSm3WqrdBoX8PEa3T0eKLPX0NmbmYBh3oIILVdWmbFDCxLH+EBvNO480obzCcHdg5et/RlIuAzjNrzjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P9npgwA9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P9npgwA9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32263C4CED1;
	Thu, 13 Feb 2025 14:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458250;
	bh=BfBKFjKW7uiZGtDqZvB46FhCtfAkDfNEdp5VjWAkY6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P9npgwA939vIeH7rwUngJZo/AoT9QhShsNL0XwNTCE8rbIptsf/y0OvSf94VHGoC+
	 hsx306ELJLwM1+U1puMcUciUjbGDZJT3aWzr/Poge60eWOMMdk4bjvq9I1y6K5iCe0
	 Hp4SvzxhhspXUWPgMzkoCE7t8L/wJh171oaLAZdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Baumann <daniel@debian.org>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 6.12 345/422] ata: libata-core: Add ATA_QUIRK_NOLPM for Samsung SSD 870 QVO drives
Date: Thu, 13 Feb 2025 15:28:14 +0100
Message-ID: <20250213142449.867734843@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Daniel Baumann <daniel@debian.org>

commit cc77e2ce187d26cc66af3577bf896d7410eb25ab upstream.

Disabling link power management on Samsung SSD 870 QVO drives
to make them work again after the switch of the default LPM
policy to low.

Testing so far has shown that regular Samsung SSD 870
(the non QVO variants) do not need it and work fine with
the default LPM policy.

Cc: stable@vger.kernel.org
Fixes: 7627a0edef54 ("ata: ahci: Drop low power policy board type")
Signed-off-by: Daniel Baumann <daniel@debian.org>
Link: https://lore.kernel.org/linux-ide/ac64a484-022c-42a0-95bc-1520333b1536@debian.org/
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-core.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4143,6 +4143,10 @@ static const struct ata_dev_quirks_entry
 	{ "Samsung SSD 860*",		NULL,	ATA_QUIRK_NO_NCQ_TRIM |
 						ATA_QUIRK_ZERO_AFTER_TRIM |
 						ATA_QUIRK_NO_NCQ_ON_ATI },
+	{ "Samsung SSD 870 QVO*",	NULL,	ATA_QUIRK_NO_NCQ_TRIM |
+						ATA_QUIRK_ZERO_AFTER_TRIM |
+						ATA_QUIRK_NO_NCQ_ON_ATI |
+						ATA_QUIRK_NOLPM },
 	{ "Samsung SSD 870*",		NULL,	ATA_QUIRK_NO_NCQ_TRIM |
 						ATA_QUIRK_ZERO_AFTER_TRIM |
 						ATA_QUIRK_NO_NCQ_ON_ATI },


