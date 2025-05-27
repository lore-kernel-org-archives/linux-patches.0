Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBA951CAA7B;
	Tue, 27 May 2025 17:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367610; cv=none; b=nB1iZEK170prchZS2nqfdUQN8Rxn3lPCIX6CzDfXhqA2zisitMuzAnCyQzKILZdY8X5j1LMza8wu4SCZ1FW+Ow7mwdrz5hpGOy6zee0dohuncDsjCuAUotqM0myBtRvuXXoEu6C3H/0TVvtKHrjCAh5UbPveb9k5JAh7wi4/3+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367610; c=relaxed/simple;
	bh=tD8MEq5uj93rUtq6usOpj3On/8dVzYbbC1asamPrBmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M9kjcfzyuXL8wxsugpNcf89ppRQjA1InijF08heflUEv0imiXYf3q74PWIx3qbCs9NCgPjiJdQ7+Ebf/Mc3klQn/EYDYfOn/8NRYXIZyf5pEDgVjDlwEniVJzKCQasAlW6jUjkdZ2uAXa11G5WQn/8OhUjmkdHP/sbqTMqE1b+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fEClanPU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fEClanPU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AE2EC4CEE9;
	Tue, 27 May 2025 17:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367610;
	bh=tD8MEq5uj93rUtq6usOpj3On/8dVzYbbC1asamPrBmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fEClanPUdsDqcc74vUbU3vy62xIrMOqxZTf/4R9X8nFDCf/3aaGVFWox/D8N7IWyx
	 0GqrvuV0NXJm7qn9ObD7e4+VPpNlompoidX8r+EAQ9kkjPz4OwPKdiui8auFDd3hw9
	 f45wjxvyAItUt93yTnSkLXTDnyWq9I+KKmmcPuVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hector Martin <marcan@marcan.st>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 441/783] ASoC: tas2764: Mark SW_RESET as volatile
Date: Tue, 27 May 2025 18:23:58 +0200
Message-ID: <20250527162531.096501388@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

From: Hector Martin <marcan@marcan.st>

[ Upstream commit f37f1748564ac51d32f7588bd7bfc99913ccab8e ]

Since the bit is self-clearing.

Signed-off-by: Hector Martin <marcan@marcan.st>
Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://patch.msgid.link/20250208-asoc-tas2764-v1-3-dbab892a69b5@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tas2764.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/tas2764.c b/sound/soc/codecs/tas2764.c
index bc0a73fc7ab41..31f94c8cf2844 100644
--- a/sound/soc/codecs/tas2764.c
+++ b/sound/soc/codecs/tas2764.c
@@ -652,6 +652,7 @@ static const struct regmap_range_cfg tas2764_regmap_ranges[] = {
 static bool tas2764_volatile_register(struct device *dev, unsigned int reg)
 {
 	switch (reg) {
+	case TAS2764_SW_RST:
 	case TAS2764_INT_LTCH0 ... TAS2764_INT_LTCH4:
 	case TAS2764_INT_CLK_CFG:
 		return true;
-- 
2.39.5



