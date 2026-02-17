Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4705129A1;
	Tue, 17 Feb 2026 20:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361429; cv=none; b=jgAnxYYFoiK/Atmh9a+zIfkErWYsUlcovvR6ERKYxl1oDUhAelBktmXC8WJThX8rodNiAF8d+vJo9W46JMpoGl96UJxH6jYzPAQlLPlK2O3Av2s1OD/onUKU3ep1jnbckOVSq08vdsxjJKVb1ck2W/AbPJiM7Ov8KZz9JaAUebk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361429; c=relaxed/simple;
	bh=2qCBx8DU0+VDj4NtBkNSwRT6SVZRKZvUqdmC09elhnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HIZiWbXMLuB1Lxa+yCSciHqkUCbVB0mDBxU2pvzYYNitoP9HeT7c6frZjo5imofHkVFiZuuYl+w4lCKvX4SqPCoMAvwpABem145MgFBPm8zG705PLT37dT1Acoj6vClgfTMuNxDsJWV2v2v2nkNWO5xcm/rXXf40Zg8RAsncFJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Js6xWpvC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Js6xWpvC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABD08C4CEF7;
	Tue, 17 Feb 2026 20:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361429;
	bh=2qCBx8DU0+VDj4NtBkNSwRT6SVZRKZvUqdmC09elhnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Js6xWpvCMTDMUyD/cLvwcITfJKq9pZ4m4MQZbq/U1rgXoZFgDiqnv7wMwIaKKX/UA
	 kuFLIpbYn7RpDs1OeHMkvNEQ2SA6E3VH0Ls5BQRhtVsEN8mzVkGuOXKBdG8aB/qwp3
	 iFZ4IlipH+AtdntKhsJ9PcQSEVehro2wlFXubkMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dirk Su <dirk.su@canonical.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 14/43] ASoC: amd: yc: Add quirk for HP 200 G2a 16
Date: Tue, 17 Feb 2026 21:31:54 +0100
Message-ID: <20260217200007.016341384@linuxfoundation.org>
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
index c18da0915baad..67f2fee193980 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -640,6 +640,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
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



