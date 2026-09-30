Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 394E44D9540;
	Wed, 30 Sep 2026 18:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793982; cv=none; b=kv15okAuyu2nfkpG/C20ZtUS48pw9HYls6MzxPyANgL/2UhNpi5iyyw/ebkcHzfUIUUN1NZmuOnDNA7XJEp6zuy61gCz6zT15ufAuQZhVFpFTcO5vas3Yx2MbVU5ebXJuPzLQytKYCLiF1o3dEnhqRVXPTBnhmoXr3lcWAnIgpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793982; c=relaxed/simple;
	bh=G3iLdUJBWVti2ZceXAYzCB20UFduyrMB+W34/G7CiA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rtMrLAjpDKuE9pIE65R/kYXUtsICFLnqVdHJ1F9jXbTu/ULtRwaP6g8EsCg8UUHOcPz7lWq5MVz8paQ3MigsA/11EpDKI3YJIVo8gUWvRVdoyAsgb3K1CHraQ0eONO8TVSyOZMSv4uweEiYlpKcDLGnIQPKeM6E+2CiuTI4JyNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O9LDdh7Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O9LDdh7Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52A5E1F000FF;
	Wed, 30 Sep 2026 18:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793980;
	bh=pFjqdwfPrwMgkdcE7C3h7KUPzUE4kQLZ2feF/lT34Lk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O9LDdh7YDOvWYRrdO0bVPRDoBc8e+NUosn7JfzjXkD+1mfb+Kw6aJvFGZruaeZDgt
	 FKyDaNnN+iBn7JFUGJtwBjqrFXrlRqGlGxcIeGO4L7o/JMr6czh+l7tfMh+lv/P7te
	 uTTOSzEDkfztVDbbbDPjYbeXIUJhH0i9WT0T45PE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Angelo Daros de Luca <luizluca@gmail.com>,
	Mieczyslaw Nalewaj <namiltd@yahoo.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0048/1193] net: dsa: realtek: rtl8365mb: add support for RTL8367SB
Date: Wed, 30 Sep 2026 17:12:12 +0200
Message-ID: <20260930152435.348578351@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Mieczyslaw Nalewaj <namiltd@yahoo.com>

[ Upstream commit 28702a215c96917d85558ad6309a57ab224808c0 ]

Add chip info entry for the Realtek RTL8367SB switch. This device has
chip ID 0x6367 and version 0x0010. It exposes two external interfaces:
port 6 supports MII, TMII, RMII, RGMII, SGMII and HSGMII, while port 7
supports MII, TMII, RMII and RGMII. Use the existing 8365MB-VC jam table
for initialization.

Reviewed-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
Signed-off-by: Mieczyslaw Nalewaj <namiltd@yahoo.com>
Link: https://patch.msgid.link/3c6d822b-0e85-4173-86ba-2badb140bbf1@yahoo.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/realtek/rtl8365mb.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
index 625d1d4d17a20..c7659a1d3be3b 100644
--- a/drivers/net/dsa/realtek/rtl8365mb.c
+++ b/drivers/net/dsa/realtek/rtl8365mb.c
@@ -541,6 +541,20 @@ static const struct rtl8365mb_chip_info rtl8365mb_chip_infos[] = {
 		.jam_table = rtl8365mb_init_jam_8365mb_vc,
 		.jam_size = ARRAY_SIZE(rtl8365mb_init_jam_8365mb_vc),
 	},
+	{
+		.name = "RTL8367SB",
+		.chip_id = 0x6367,
+		.chip_ver = 0x0010,
+		.extints = {
+			{ 6, 1, PHY_INTF(MII) | PHY_INTF(TMII) |
+				PHY_INTF(RMII) | PHY_INTF(RGMII) |
+				PHY_INTF(SGMII) | PHY_INTF(HSGMII) },
+			{ 7, 2, PHY_INTF(MII) | PHY_INTF(TMII) |
+				PHY_INTF(RMII) | PHY_INTF(RGMII) },
+		},
+		.jam_table = rtl8365mb_init_jam_8365mb_vc,
+		.jam_size = ARRAY_SIZE(rtl8365mb_init_jam_8365mb_vc),
+	},
 	{
 		.name = "RTL8367RB-VB",
 		.chip_id = 0x6367,
-- 
2.53.0



