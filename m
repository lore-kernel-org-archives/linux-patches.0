Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC68C198E85;
	Thu,  5 Sep 2024 09:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529990; cv=none; b=L5YwufzphF9u7s23jjJ6tLYAAMQ9dsBEbN2t6fRASfXD+b1Kc4sfMbcPQlOkc14WVCD0PFI4ow3cIrSBnNwkgHsnL3kV76zNqscOc+b1MYstsmL7RLvwzJ+j8mU1Agal6dxX13v0nS6MwMMI6OIobBG3Cq7O5RmixO1+T5wRKZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529990; c=relaxed/simple;
	bh=vMERJuFLquvcN4pjW/Yi8Kf03EW+PCxsmTK57LfYeMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CJDVIFkSM8wF2QuumkClc2r8aw5tipEwssufoIY2DnGT3WKxTguJHSPtPzAPFvlIEEJWv6XVDUmDnqVd5BMRfzZbJJst49EI47JRuUZm+gzS308bjJATkbjoKVSi5XSNbliIANuG8d/x0Cz97p85tU/qJlT1OO51LApL8Xw8ZOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DuCW4k5N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DuCW4k5N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A9EDC4CEC3;
	Thu,  5 Sep 2024 09:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529990;
	bh=vMERJuFLquvcN4pjW/Yi8Kf03EW+PCxsmTK57LfYeMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DuCW4k5NsdBRH0463ibPgTwWqjHaNunBeOEgKIrD2bwprDqFJNwOdTk4c1GeCbYAA
	 ATalAMewkgzA44U2mK/ose8B23bIfD+wjKhdJqnvgYC5FHkCZTovj0x/mdC05YGA6f
	 X/maW4VG0Yg1/rKkykHlOmd7cyPE14QAicNjS0gg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Krzysztof=20St=C4=99pniak?= <kfs.szk@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 020/132] ASoC: amd: yc: Support mic on Lenovo Thinkpad E14 Gen 6
Date: Thu,  5 Sep 2024 11:40:07 +0200
Message-ID: <20240905093723.023239695@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093722.230767298@linuxfoundation.org>
References: <20240905093722.230767298@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



