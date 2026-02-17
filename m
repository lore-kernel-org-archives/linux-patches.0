Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E3CF374178;
	Tue, 17 Feb 2026 20:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771360787; cv=none; b=Cs1SddsTEypzLyDZIdxBQEblXnrN92Hcql3zZgkO0ahGnW1aVhTdMcGvtqZHHHi/DK0Q2O23EYywLIjy+WPypYMB2sbFRLvGjJPUlLXlk7PFgplO1xxCUaL+Yz/yhfelROfZzIeCkkaVRvJW+//NWfJXD+n5bjvZksN40gbKI40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771360787; c=relaxed/simple;
	bh=q8ieCnN+ddMokkT1dNPjlSl5oenVoKmDsZAjPMc7N/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OKZD/BoWIsH9/ihsYnzxRNy9KiN9Q+VLPGWSM5MroWBUXvPw4kb/Dy5/CZ48ImRts7DQtRUTJVMnxbSwPpLaLzYUaYq/eCNDO4q7XJHbpY9quehk5Hm7Ct2LHC6AO3NjEwNl47it62qgtkRdLUqyEewkBOuRieeYdz3PTImbTVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=swMPzbr+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="swMPzbr+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B718EC4CEF7;
	Tue, 17 Feb 2026 20:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771360787;
	bh=q8ieCnN+ddMokkT1dNPjlSl5oenVoKmDsZAjPMc7N/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=swMPzbr+ma+vSw01TiKnw45kehWbiR30TVMPjV/EC7WV1dA2fbYwVhZ+GVS5KStV2
	 C83wh/VBEkXOOW8gEkjWUl8iYsyXZLr+A5IKEClGokDShKl+8Pm3qzEyUTy6AdDPcm
	 6XLJedNgnSs3S4Nfd3id33YVSs+giRk0FpkxmLv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dirk Su <dirk.su@canonical.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 15/39] ASoC: amd: yc: Add quirk for HP 200 G2a 16
Date: Tue, 17 Feb 2026 21:30:37 +0100
Message-ID: <20260217200004.811909678@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200004.221651386@linuxfoundation.org>
References: <20260217200004.221651386@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dirk Su <dirk.su@canonical.com>

[ Upstream commit 611c7d2262d5645118e0b3a9a88475d35a8366f2 ]

Fix the missing mic on HP 200 G2a 16 by adding quirk with the
board ID 8EE4

Signed-off-by: Dirk Su <dirk.su@canonical.com>
Link: https://patch.msgid.link/20260129065038.39349-1-dirk.su@canonical.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 92d0d39d39d9a..b6068d289f5f9 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -633,6 +633,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "8BD6"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "HP"),
+			DMI_MATCH(DMI_BOARD_NAME, "8EE4"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.51.0



