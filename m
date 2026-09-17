Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABC5C4973B9;
	Thu, 17 Sep 2026 18:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668535; cv=none; b=J5V+wqdaZzYrfwcxZrvMmD5K+rk7uhEC62vTBVTAwTeIDZ0kMxD9GgfHooVpW/AQNd2WEdaJ4o+iD6pO8VBxtz1OMWbepSr1MwncwFoiyEpmVfHgiO2imE7tvFEBAPGk+w2YNiJbLt4jtvHtnjTlg2NuPOZbWqDEce5ZJLdP15w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668535; c=relaxed/simple;
	bh=lLmsziVzEWZJ3KujZc177+n5s4BEe7Y8KWT4KBTh1x8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZWHkR4K5NV6dpfQQdaYdPRUlxmcuya6hP+9hsT4PfhUaI3WBfzcCgLX7+adGyHHMTN3fHIbi5zKuELkOkrNoxFOoBILANJvmEMoMKXQ24b0VzP5NCz27lFqYlckbalhwsRs6iw4PbDgwdGV5CpQI1Xcm0AV5I8b5G780e94uMuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B/xFr/QA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B/xFr/QA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1025D1F00893;
	Thu, 17 Sep 2026 18:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668534;
	bh=9AJtS3Vtq1RT/L4oS5+7jGiBcd5b3cmWM57XtE8KRHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B/xFr/QAysjoXbsQKwrHb5weCCpl7fVbArNz44PTCOIhzLbmkqt84fRe8H7zw9gmz
	 EWoXolXQ7NLEc8Tw8v6tpVcaHTRlKXJNm7hz66ufG1Mn+pHUA4I6Dcv7PDtQYwWNBI
	 QAumNpsrxxUwdDP+CVaHF1gfQIfeRLZc5fd+IoTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Heng <zhangheng@kylinos.cn>,
	CuerdOS Dev Team <cuerdoslinux@proton.me>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0455/1102] ASoC: amd: yc: Add DMI quirk for HP Victus Laptop 16-e1xxx
Date: Thu, 17 Sep 2026 16:06:38 +0100
Message-ID: <20260917151551.110309282@linuxfoundation.org>
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

From: Zhang Heng <zhangheng@kylinos.cn>

[ Upstream commit 38417f5fc8e3323218c19bd7e419eec4fb0697bd ]

Add DMI quirk to enable ACP6x sound card for HP Victus by HP Laptop
16-e1xxx, which fixes microphone not working issue.

Without this quirk, the DMIC on acp6x device is not properly enabled,
causing the microphone to not work.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=218926
Link: https://github.com/CuerdOS/linux-kernel-nhs/commit/b29ba27a0ed672664071b4b345e63b62a419d31d
Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>
Reported-by: CuerdOS Dev Team <cuerdoslinux@proton.me>
Signed-off-by: CuerdOS Dev Team <cuerdoslinux@proton.me>
Link: https://patch.msgid.link/20260730123920.104525-1-zhangheng@kylinos.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 4a7f421b9da29..8ffaceae8fa07 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -668,6 +668,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "8E35"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Victus by HP Laptop 16-e1xxx"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.53.0



