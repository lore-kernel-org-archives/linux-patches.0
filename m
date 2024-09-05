Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F1C6199229;
	Thu,  5 Sep 2024 09:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529517; cv=none; b=Kba4ziUhOTNJsHmHxPHNYwU2B31QzO6ERXvXu9iM/XcWr+/5ElWXQ/z5geBHeujUw/B6LmbMlxA9fUUClWyxYdYIcNnCDddorsmxvwWrNOTABFp4hu5rYhPLReoDThaMZtA2n464mqgIb7xvmfmGTRZnRLdKd8Wq6KrAipGN6Q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529517; c=relaxed/simple;
	bh=8iv0FEGEX5gbGmXSULPt7/2vCLajrwdr9BSHXi/WJTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p4xeLMFDL2hUtLi344Wx/JxebHd7Pd8wCreu+FHmiFKw+SFM1z0Q5ApuMOrZM1/46HeSlh1nch9On7CxjtQiPsVNhidVMsGXJ01F4P8LOh0EyyTSnKF8rNi2AWokU3zeBEJgDsZUDYuaHBvzbetJ2zAnpDhx36MEksbzicG7eOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tlDH1AXc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tlDH1AXc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9A1AC4CEC7;
	Thu,  5 Sep 2024 09:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529517;
	bh=8iv0FEGEX5gbGmXSULPt7/2vCLajrwdr9BSHXi/WJTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tlDH1AXcdZJpxK9PwzAz9y4g/UNJ20gAZNMSksvUrAH8EGl9gIGrYmLUZfOnFMI4F
	 NP59s3rbzFqLmRFSyJ+c3CfsgGGP/pNWWZeSGlJyhtqPWFoERjtEbYSVe/veC29fY7
	 OqQihmeMu3UP297J9+50A8ETxtk+6mobj8Ar4Yj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Krzysztof=20St=C4=99pniak?= <kfs.szk@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 027/184] ASoC: amd: yc: Support mic on Lenovo Thinkpad E14 Gen 6
Date: Thu,  5 Sep 2024 11:39:00 +0200
Message-ID: <20240905093733.307418862@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Stępniak <kfs.szk@gmail.com>

[ Upstream commit 23a58b782f864951485d7a0018549729e007cb43 ]

Lenovo Thinkpad E14 Gen 6 (model type 21M3)
needs a quirk entry for internal mic to work.

Signed-off-by: Krzysztof Stępniak <kfs.szk@gmail.com>
Link: https://patch.msgid.link/20240807001219.1147-1-kfs.szk@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index e933d07614527..f6c1dbd0ebcf5 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -220,6 +220,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "21J6"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "21M3"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.43.0



