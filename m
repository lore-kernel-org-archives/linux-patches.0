Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC511F6696;
	Tue,  3 Dec 2024 15:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238102; cv=none; b=Z3euAiU2sqGanAZtc3uEXgoNPiweEduNJ0kgp5zgroypCP3kn3ZkO8d3ohg2+Iq+4fbAb6aRSsYgiYRxLrh00Dc6fjnhhDxLhJjqwLqNOTXq5nMkowFbEAcI1LN8v4ESq/M/aEbg7hHi6K18eC4uo9xNe+KewahnRTgBkVHD7Bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238102; c=relaxed/simple;
	bh=FsxTOLEvPA2P9EHudlFITy2NzAgdQXVCKWT7bRZeJ68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bA4Ch/FpzhEwANk5yCD+S4p7Fggsf9pALcuNB8v951QJup7PnbrDzK5OJSAQT1K3ROfOCEjHAf+MlUna4Ad0sOjjPFZSB99dubG+TR2pyBDAEtnOx+MXkkGx20Az2GhMItmkYOzZOtRtbcgSJ9x7SBR24ZRYtPs3tNNvHpkhqLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q38W1crb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q38W1crb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65640C4CECF;
	Tue,  3 Dec 2024 15:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238102;
	bh=FsxTOLEvPA2P9EHudlFITy2NzAgdQXVCKWT7bRZeJ68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q38W1crbx/Xr+c2qY9UscoICwiaZQp2W2sgLETETaiQZDaRGRD3wmc8WpHh4UO+54
	 a3TfD5NiWwUsXlqziXVq3aNwCpwKbMyK40CiNi/NWKIcL5BlA+AFIt27eqDlcSjTAU
	 1C0e8kDhrmHTMDXPI36VjIpc0UQPB0NT4VVUHah0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Benjamin Mugnier <benjamin.mugnier@foss.st.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 162/817] media: i2c: vgxy61: Fix an error handling path in vgxy61_detect()
Date: Tue,  3 Dec 2024 15:35:34 +0100
Message-ID: <20241203144002.051300129@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 0d5c92cde4d38825eeadf5b4e1534350f80a9924 ]

If cci_read() fails, 'st' is set to 0 in cci_read(), so we return success,
instead of the expected error code.

Fix it and return the expected error.

Fixes: 9a6d7f2ba2b9 ("media: i2c: st-vgxy61: Convert to CCI register access helpers")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Benjamin Mugnier <benjamin.mugnier@foss.st.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/vgxy61.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/vgxy61.c b/drivers/media/i2c/vgxy61.c
index 30378e9620166..8034e21051bec 100644
--- a/drivers/media/i2c/vgxy61.c
+++ b/drivers/media/i2c/vgxy61.c
@@ -1617,7 +1617,7 @@ static int vgxy61_detect(struct vgxy61_dev *sensor)
 
 	ret = cci_read(sensor->regmap, VGXY61_REG_NVM, &st, NULL);
 	if (ret < 0)
-		return st;
+		return ret;
 	if (st != VGXY61_NVM_OK)
 		dev_warn(&client->dev, "Bad nvm state got %u\n", (u8)st);
 
-- 
2.43.0



