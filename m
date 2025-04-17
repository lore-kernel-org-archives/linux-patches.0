Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26B3C254AF5;
	Thu, 17 Apr 2025 17:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912693; cv=none; b=o/ptCnWIm18Bm4lAem6k248Gf3Rs5k/K6SUnqKWXGvpj0LJLp1GtUnJntZjqmBPRdr+odBMXofg45mbMIYdVqVqVJ+y7S3iOaGhBI3KtYPBualKK9AxkZerCRQr3OAQEpCWHUiZG6XqXGLcXf/MKu8FMgG7luM6c/bWnFupzPCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912693; c=relaxed/simple;
	bh=nYL3iHDub8eLUik04iqhoKAV8idg3oCe0QDuLSwNNkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H7biMCRoHANvuCXUks9B/sqyj0G6C6+B2d9LAuX2MfrS/j4RioTQB6yACXVvGEY+BBQCkWo0yA4z8Wsk/Abxc2oI13H5fXBrEuGErx6FxZtwDbX1sqLNW5rKbOqZ70XlVbwtFhu6rOjAqvSao1IWMuMW+kv4vHAxfMSlUP47WoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O6wGTwOA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O6wGTwOA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92A58C4CEE4;
	Thu, 17 Apr 2025 17:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912693;
	bh=nYL3iHDub8eLUik04iqhoKAV8idg3oCe0QDuLSwNNkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O6wGTwOA2oinwvgiIgK1JKpA/hpmc04XjGtUs9Vqkc8zMttovb9TGqqiCNUiPXJd4
	 EhjoZCUYZZAO2HW+ctcWtmZfr/S1um2yWr1tvkd8K13lD2y83JsKUsh+0tnGNbVZxm
	 buXUMaqIGy+/UOSS41n0vs+rkTTQE02doTUxStvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Syed Saba kareem <syed.sabakareem@amd.com>,
	Reiner <Reiner.Proels@gmail.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 093/449] ASoC: amd: yc: update quirk data for new Lenovo model
Date: Thu, 17 Apr 2025 19:46:21 +0200
Message-ID: <20250417175121.710020743@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Syed Saba kareem <syed.sabakareem@amd.com>

[ Upstream commit 5a4dd520ef8a94ecf81ac77b90d6a03e91c100a9 ]

Update Quirk data for new Lenovo model 83J2 for YC platform.

Signed-off-by: Syed Saba kareem <syed.sabakareem@amd.com>
Link: https://patch.msgid.link/20250321122507.190193-1-syed.sabakareem@amd.com
Reported-by: Reiner <Reiner.Proels@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219887
Tested-by: Reiner <Reiner.Proels@gmail.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index bd3808f98ec9e..e632f16c91025 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -339,6 +339,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "83Q3"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "83J2"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.39.5



