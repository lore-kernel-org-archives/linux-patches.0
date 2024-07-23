Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA4891586CB;
	Tue, 23 Jul 2024 18:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759318; cv=none; b=WxY9XqTNHlfbAeVG1uZx/wIs415tnIWebXXWf4Sdy+RBk+sv3rdxBGoMJN+p9/A6bmg6EfrDkUxxZTkFIU1wLjPEAWqOCOAjU9oBTYwc2kgw9wGe6115Bmm5giB0H0ez+oK0kHZeMQ+monNHsaU+xjSrl9zk6VAwIec8xKFFfQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759318; c=relaxed/simple;
	bh=Kx2ZCEBzJfn1LA1fiR3gTZysNr+0HuI8dOIEH9G3f70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ABO4OGytlgE+VOMNOKk2gtTPnRUsZvh6GEQtr2MBTLuuQXCit0a/zs2yWHzRdbD6p3VUerw0ZfDU+pjj7z0EvDHq+l3zKo0EJljt46JcpgIU2MkUATNvmvTG9E8CNCJfBgqeThlvj3871RctN4M7O/+3QYBbfh8tlltDIO0Vpko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eZtDq9IX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eZtDq9IX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7008BC4AF0A;
	Tue, 23 Jul 2024 18:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759317;
	bh=Kx2ZCEBzJfn1LA1fiR3gTZysNr+0HuI8dOIEH9G3f70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eZtDq9IXEmZCURALdF7YYM/8N5ECTlkr8E5lb6h49y5D4YLC2MhazPpYxbaRj0G7i
	 1kN5HDfFNyJ86VYabUPBC9eGUYuX3cWOa+ecek6S5laGqixFIojNZ98bWze1r81KNO
	 Dd09R4p6SI9E+t7tXKgSV6g7ZTyEyMuFkZBcIiho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vyacheslav Frantsishko <itmymaill@gmail.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 076/105] ASoC: amd: yc: Fix non-functional mic on ASUS M5602RA
Date: Tue, 23 Jul 2024 20:23:53 +0200
Message-ID: <20240723180406.174514282@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180402.490567226@linuxfoundation.org>
References: <20240723180402.490567226@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vyacheslav Frantsishko <itmymaill@gmail.com>

[ Upstream commit 63b47f026cc841bd3d3438dd6fccbc394dfead87 ]

The Vivobook S 16X IPS needs a quirks-table entry for the internal microphone to function properly.

Signed-off-by: Vyacheslav Frantsishko <itmymaill@gmail.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://patch.msgid.link/20240626070334.45633-1-itmymaill@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 0568e64d10150..8e3eccb4faa72 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -283,6 +283,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "M5402RA"),
 		}
 	},
+        {
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "M5602RA"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.43.0



