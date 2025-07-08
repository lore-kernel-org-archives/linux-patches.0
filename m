Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0182014A60D;
	Tue,  8 Jul 2025 16:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993596; cv=none; b=lqzbPNfmvtBk1G806cB90T0MxvScOVLVOu59POWhr+cdB8nwfXEmvUQrWHWdRJmfnlVVCAf30dX4bTx0sIYMTYHbcqmxnS6nfgA96kIfRJk2/oSuri56BDLgrvS66fagiiHnOK+BapGi+xBAbtxJf9SuVZw8FI5Ah4ALf03s11E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993596; c=relaxed/simple;
	bh=eyCjJzxMJjDSidxbFtJiIYt3K5bnPo81/6rGrm4Jm1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dTUe0nmlEDZY0VuGkvqI6mBPwIfA2T6qbsjIW4FenCUK8bLBMWsBbyewQb81LtOoqY3GEI5UMEnOINdx3ZnlzdePrkH21WcTdYSsUUqeLUlpbF6YMH9ItEymZZkR60nfwuMbhbbFYrQD7za4E4DTzdJjEiO9en/4uVNBJL3he+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GlVA7UB3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GlVA7UB3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2374EC4CEED;
	Tue,  8 Jul 2025 16:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993595;
	bh=eyCjJzxMJjDSidxbFtJiIYt3K5bnPo81/6rGrm4Jm1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GlVA7UB315iNjbf+hOW/Kb6F4rvwYc8i6E1/08By3mXjEJdJx+NrX75MmtpHMcECH
	 7Dhu6Y/PpQVU/SCYmenK/J568JjvkxVsEEsobrGVWFV2H7imqzixklwq8eCUbl0xDl
	 RRAAXAHA7Z5dwfjX5A7aMwLoikI641HwjF+oEZvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Santese <santesegabriel@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 128/178] ASoC: amd: yc: Add quirk for MSI Bravo 17 D7VF internal mic
Date: Tue,  8 Jul 2025 18:22:45 +0200
Message-ID: <20250708162239.920606706@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabriel Santese <santesegabriel@gmail.com>

[ Upstream commit ba06528ad5a31923efc24324706116ccd17e12d8 ]

MSI Bravo 17 (D7VF), like other laptops from the family,
has broken ACPI tables and needs a quirk for internal mic
to work properly.

Signed-off-by: Gabriel Santese <santesegabriel@gmail.com>
Link: https://patch.msgid.link/20250530005444.23398-1-santesegabriel@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index b27966f82c8b6..4f8481c6802b1 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -451,6 +451,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Bravo 17 D7VEK"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Micro-Star International Co., Ltd."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Bravo 17 D7VF"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.39.5



