Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A86143C76;
	Thu, 11 Apr 2024 10:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831357; cv=none; b=JvoUsF2MsgZKURJdebw66VHZwx3deNA3RXse8mN2KdY42ontTXVylfUrxf+M2VQ0Vcpt/CC9i97FqVY81VxavFsl6CBYPah28i9P4HkOsUrpU1YuBZ4Bk10pzKthfu6tvgT1lSlpkjd0XgYmjDlnyCx3CTW1JLCwiCsxgQ3Nd5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831357; c=relaxed/simple;
	bh=9k7rM3AsNn1p2FU6Fdx8cP8a9+FJG0romYQ8Pu8C8tc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YIS1CfPbO6ycXVXiDcbmkBRyenybC9fjT4PuCH5p58W8UDnuahTtRCWIIe2b2TwsjHq3i1nhKT9mn4R80SObDjLoK0IzAMK1H+HfRogIRGIt/9ZR5WvUSvoCRw/8CCrIH7or53okWLS79i8wJU2I5v5aKFlravIOQxdeqYkbMtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2JD/8+mk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2JD/8+mk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11F25C433C7;
	Thu, 11 Apr 2024 10:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831357;
	bh=9k7rM3AsNn1p2FU6Fdx8cP8a9+FJG0romYQ8Pu8C8tc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2JD/8+mkqz3MpKlGs5Rbep+JG7PbWuLbp7By55xw6QFkVBtCJ1mlWR4qq0Cl8E7+5
	 9OvchsAvVSG4tga1iwhhV77N2AmZoDd7kdCQN5a+2Dwg0IwtgfULYVnvEbvv4iuVit
	 FtAcnjotf4taey0NKV0swlNGcIiB58qXqgAXZ8PI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mitch Cooley <m.cooley.198@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 094/114] ASoC: amd: yc: Fix non-functional mic on ASUS M7600RE
Date: Thu, 11 Apr 2024 11:57:01 +0200
Message-ID: <20240411095419.728830732@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095416.853744210@linuxfoundation.org>
References: <20240411095416.853744210@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: M Cooley <m.cooley.198@gmail.com>

[ Upstream commit db185362fca554b201e2c62beb15a02bb39a064b ]

The ASUS M7600RE (Vivobook Pro 16X OLED) needs a quirks-table entry for the
internal microphone to function properly.

Signed-off-by: Mitch Cooley <m.cooley.198@gmail.com>

Link: https://msgid.link/r/CALijGznExWW4fujNWwMzmn_K=wo96sGzV_2VkT7NjvEUdkg7Gw@mail.gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 1d1452c29ed02..69c68d8e7a6b5 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -311,6 +311,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "E1504FA"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "M7600RE"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.43.0



