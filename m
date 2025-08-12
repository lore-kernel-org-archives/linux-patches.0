Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF1422C15B5;
	Tue, 12 Aug 2025 17:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020732; cv=none; b=RB8o043UDZYmVUDgMsmpQmbZs61vrtJ0HgQVzxffk19tn7xegshQ98BrA68T6ZjCQF9f2c/ggDzBAznn8+JfSxkuR0lc41U9cRRkYZL9guDF7DMPHlGtsq54u3abzEopRnu1iJWSBEgqt7aLCCT+j6P2dMp87G/7bkmYS7/e9v4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020732; c=relaxed/simple;
	bh=u+dOoLaEiQnPyUPqqj1xNpOfVnfsdQy2EMxdNLXxkAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GtpQER0R0PyRTOApvqUdiNMwtQs2khPcIyYu2GTndDPmG2rnNz5tXL1COkgF6BWdASzwIdGYoYMoI3gqc/1bkvtYlnIn+Rp2ygRwXuHHv5oDvc8n5OQlkhwBwEqm1EVVCrJuBspM2G3UIOykCVNJ5IPi4RMAMyaCvYNgWF4Hi3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BLriT1Sr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BLriT1Sr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E053C4CEF0;
	Tue, 12 Aug 2025 17:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020732;
	bh=u+dOoLaEiQnPyUPqqj1xNpOfVnfsdQy2EMxdNLXxkAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BLriT1SrBY9cMFGT9k8NPHOGCJnXgQ2arz/eko1i336A/OIw/83mNlVXSUFG3PDhN
	 rKpu2bz/feiwDSwPKwzPNgZojw6hQwMw15BN6sqRj/EOQfSt5DLLoGEdU44miSmI7N
	 etcqQB6bxwkfkBT6jNp1BlUqG/u2g8yTuyvcz3jE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandru Andries <alex.andries.aa@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 005/262] ASoC: amd: yc: add DMI quirk for ASUS M6501RM
Date: Tue, 12 Aug 2025 19:26:33 +0200
Message-ID: <20250812172953.196198560@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandru Andries <alex.andries.aa@gmail.com>

[ Upstream commit 6f80be548588429100eb1f5e25dc2a714d583ffe ]

add DMI entry for ASUS Vivobook PRO 15X (M6501RM)
to make the internal microphone function

Signed-off-by: Alexandru Andries <alex.andries.aa@gmail.com>
Link: https://patch.msgid.link/20250707220730.361290-1-alex.andries.aa@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 1063a19b39aa..24919e68b346 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -409,6 +409,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "M6500RC"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "M6501RM"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.39.5



