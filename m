Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F8DB29A1;
	Tue, 17 Feb 2026 20:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361497; cv=none; b=j/+A63IzCJGNGkWrellN3zkiJxBYGJYgq3PqdyyudJ1byBZi/5WUd1EKjFLCo4kHKjgeq5QzN90Bcw2hRP4IsGTBo2NsJHf/HA3sGv7R4ZE9DPPkdEsBMiEOv2M4R+tfpmKLaUDi4lBG6GfvBcnnzrGxJ94F+/bHWp+Bb173SD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361497; c=relaxed/simple;
	bh=B3kx5P2O0y5rg9s+bpDic/tuo3ARgk7U2TTI3WLCMAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fv0HCTaJ4Ku3UbIVQjmJ4woxfV14B9/PPK3ktgFhCfiIMEwhWWaxqztlt1vGByyYriJ8ARD+DVYRkksFuHx0LhBwLBR+QzghjWJUO085ofqi9hvHTGpCfdfXA7vIFJ2BdJsyjh2mszJGZ265XvKkp5QILB2BQM9dQCVhYU5ycSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SxgIZWFe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SxgIZWFe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78B41C4CEF7;
	Tue, 17 Feb 2026 20:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361496;
	bh=B3kx5P2O0y5rg9s+bpDic/tuo3ARgk7U2TTI3WLCMAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SxgIZWFeTWzZNhwRuOML8L+0fYEcBigtR6y1qIDkTiMpq/G142ec4aziSniKE44GU
	 2pTWaVmaFaWsNU3MeoqsUForPnspJqlbbwo1JEE7qblUjR+jc6hQYJyptJKtZyEgbi
	 DqlZJ3SM92ulzsGFMoQSCT1D1HzpnnZKdUm1LlRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anatolii Shirykalov <pipocavsobake@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 05/43] ASoC: amd: yc: Add ASUS ExpertBook PM1503CDA to quirks list
Date: Tue, 17 Feb 2026 21:31:45 +0100
Message-ID: <20260217200006.676679908@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200006.470920131@linuxfoundation.org>
References: <20260217200006.470920131@linuxfoundation.org>
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

From: Anatolii Shirykalov <pipocavsobake@gmail.com>

[ Upstream commit 018b211b1d321a52ed8d8de74ce83ce52a2e1224 ]

Add ASUS ExpertBook PM1503CDA to the DMI quirks table to enable
internal DMIC support via the ACP6x machine driver.

Signed-off-by: Anatolii Shirykalov <pipocavsobake@gmail.com>
Link: https://patch.msgid.link/20260119145618.3171435-1-pipocavsobake@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index c4a4a06528b45..c18da0915baad 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -542,6 +542,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "15NBC1011"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ASUS EXPERTBOOK PM1503CDA"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.51.0



