Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB5DB409630;
	Thu, 28 May 2026 20:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998463; cv=none; b=kaMyjoOc0hiKPySd7TWVEYxOsFaHewyD57BUqcYWqFZraFieLHpgCnnrZ1u2ibSk/BNGtq86NTLvEe+CX2PTpJu7onibPh2Vf6avYRDMsGr92q2Pq8obdoWcBu1+gBCN8TmzyxX9jSTiBiW9PqFij8LmsLNkdQPK8LtOAHQcyiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998463; c=relaxed/simple;
	bh=nMPCXQ7jYo2tBMDaG2atSQHTbROK9hfgR4BF4lwZ+OY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kq8nye31Gh4idOSU4Dqk/epN5zr2GKVqaAaxMdGgQlkHRoEXrzaWZomoHKrFmFiAvB3ZXTFs5rM+7DwYPq3jtVOWwZ9lh1VLUtOCIhjUvIyxj/y47dMouWarM7gmJGsAJ1RZ5qrDSSXMIvOI9J0rlIbTNcYAL1bKSom7Q1MaD64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bYsNjqvl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bYsNjqvl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3ECB1F000E9;
	Thu, 28 May 2026 20:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998462;
	bh=PNZuiKbxQ9rPb/+c2sn8kuZifNeBq/daoeWfJ+lLFXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bYsNjqvlR4goTLheKr6Zpaoa6i6zufBMXRRGeAJPtl6TWN95g7VznGWvpfdibOk4P
	 5b6yIE/la+s052zeWtxHCFJpT8co76VTvNVtuv9yB3J8LpR5S/bJUvWtm3iIBSggKZ
	 aucj13qqHbiqEG6iJDEnwkQUZxaYPMI6em1aXr5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maulik Shah <maulik.shah@oss.qualcomm.com>,
	Navya Malempati <navya.malempati@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 182/461] pinctrl: qcom: Fix GPIO to PDC wake irq map for qcs615
Date: Thu, 28 May 2026 21:45:11 +0200
Message-ID: <20260528194652.343886055@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maulik Shah <maulik.shah@oss.qualcomm.com>

[ Upstream commit 9d69033ad967b6e09b1e5b30d1a32c6c4876465d ]

PDC interrupts 122-125 were meant for ibi_i3c wakeup but qcs615 do not
support i3c. GPIOs 39,51,88 and 89 are also connected to different PDC
pin to support non-ibi wakeup. Update the wakeirq map to reflect same.

Fixes: b698f36a9d40 ("pinctrl: qcom: add the tlmm driver for QCS615 platform")
Signed-off-by: Maulik Shah <maulik.shah@oss.qualcomm.com>
Signed-off-by: Navya Malempati <navya.malempati@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/qcom/pinctrl-qcs615.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/qcom/pinctrl-qcs615.c b/drivers/pinctrl/qcom/pinctrl-qcs615.c
index f1c827ddbfbfa..4d474c312c10b 100644
--- a/drivers/pinctrl/qcom/pinctrl-qcs615.c
+++ b/drivers/pinctrl/qcom/pinctrl-qcs615.c
@@ -1043,11 +1043,11 @@ static const struct msm_pingroup qcs615_groups[] = {
 static const struct msm_gpio_wakeirq_map qcs615_pdc_map[] = {
 	{ 1, 45 },    { 3, 31 },    { 7, 55 },    { 9, 110 },   { 11, 34 },
 	{ 13, 33 },   { 14, 35 },   { 17, 46 },   { 19, 48 },   { 21, 83 },
-	{ 22, 36 },   { 26, 38 },   { 35, 37 },   { 39, 125 },  { 41, 47 },
-	{ 47, 49 },   { 48, 51 },   { 50, 52 },   { 51, 123 },  { 55, 56 },
+	{ 22, 36 },   { 26, 38 },   { 35, 37 },   { 39, 118 },  { 41, 47 },
+	{ 47, 49 },   { 48, 51 },   { 50, 52 },   { 51, 116 },  { 55, 56 },
 	{ 56, 57 },   { 57, 58 },   { 60, 60 },   { 71, 54 },   { 80, 73 },
 	{ 81, 64 },   { 82, 50 },   { 83, 65 },   { 84, 92 },   { 85, 99 },
-	{ 86, 67 },   { 87, 84 },   { 88, 124 },  { 89, 122 },  { 90, 69 },
+	{ 86, 67 },   { 87, 84 },   { 88, 117 },  { 89, 115 },  { 90, 69 },
 	{ 92, 88 },   { 93, 75 },   { 94, 91 },   { 95, 72 },   { 96, 82 },
 	{ 97, 74 },   { 98, 95 },   { 99, 94 },   { 100, 100 }, { 101, 40 },
 	{ 102, 93 },  { 103, 77 },  { 104, 78 },  { 105, 96 },  { 107, 97 },
-- 
2.53.0



