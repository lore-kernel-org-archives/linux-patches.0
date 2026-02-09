Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E089D285060;
	Mon,  9 Feb 2026 14:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647528; cv=none; b=ZzrlUFByMp2vprGqU+3ItFcrEbmt0NSrNjBb4bNllRg7jDXqTZ1nFKLDn54QcBsOMVfUPakvwnLUTNAqZ62X6UmW7ALSufn4hhkaIaSEi/4t0Px0gcxKjDYO4Ru3+I9DpcFSGbFiGEjdxYYbkhQw3rnF2I4VLyRWn/HRupW14Qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647528; c=relaxed/simple;
	bh=07mAElcJ9tyawnf/mkYp+AaPpYvofoidVPv3T5RDf7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=inz64DVlCnkG6F6TEjk7fybUo85BEBIk3A6nnSU/DXnKioCFLNoLdFjl+GWkqjpi6tjG104juMyX33dATQp8ghQ0SFVbEwnje28k8mucNnZIlbRMU7FM/lFCsvFqfZf9yjwbRjVOoPALHtf7KkfK5OlBbAZP0sb3HEnFbV3lP/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EBJd9iH5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EBJd9iH5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54213C16AAE;
	Mon,  9 Feb 2026 14:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647527;
	bh=07mAElcJ9tyawnf/mkYp+AaPpYvofoidVPv3T5RDf7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EBJd9iH5kamYrTyWihmg2sgT74Amdgi0yDnBzPS67NEJtD3BnK1LuH6x+58AZLIh+
	 HtRIypc3OYS44tlx9viE0slU+ACqLTv5yZq05DqqX7Vb5zHXzagPfSg2uUgPwVYezk
	 AuiACbDw8ad6eH94RYJNi3mruk487iVJFx1A/5hw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radhi Bajahaw <bajahawradhi@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 092/175] ASoC: amd: yc: Fix microphone on ASUS M6500RE
Date: Mon,  9 Feb 2026 15:22:45 +0100
Message-ID: <20260209142323.739678849@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
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

From: Radhi Bajahaw <bajahawradhi@gmail.com>

[ Upstream commit 8e29db1b08808f709231e6fd4c79dcdee5b17a17 ]

Add DMI match for ASUSTeK COMPUTER INC. M6500RE to enable the
internal microphone.

Signed-off-by: Radhi Bajahaw <bajahawradhi@gmail.com>
Link: https://patch.msgid.link/20260112203814.155-1-bajahawradhi@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index c0a8afb42e165..c4a4a06528b45 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -416,6 +416,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "M6500RC"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "M6500RE"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.51.0



