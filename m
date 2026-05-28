Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E195E2D9787;
	Thu, 28 May 2026 20:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999745; cv=none; b=CkQYmgtdER9auvMdgZgMza6V1mA+SLyZS4AZatzS8nDF7zdhUq4/pC9o9mY8EZ2XyJ8Hr6OtilEDi0KeP9g5fER5u8hgFUGR3ri2TdRZoxiJTo0b+kZp0KEgEhek3vrnoblc0eoZzXtT4eGQ/bKylxLVsPoFeWuvf+6vKkGyH3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999745; c=relaxed/simple;
	bh=n4dGNjWV5uBWb8xggwXTJFRK0YKzWJbLjKwOJ5l/yk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qXPNW+rfEURSuE6+N36Mf89NxxfdqYbT3/PmwiDVFpOCMS6C7uvJXQWOrbWlsZmoGI0MSpV1tzkNln9xBLzkz1dr9w1A3YplcdbByWDnucZmc7HTrnM/bGp5BV5cMWKudu/fBGSnbMT0VtBO5xoyBDIp3TzLENHSdGTuGjdVw+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eL2reOeB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eL2reOeB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C0FD1F000E9;
	Thu, 28 May 2026 20:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999744;
	bh=xGF8KR5G49FxeIglurCYnuG0zCosEeJQNRNMrscCggQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eL2reOeBg5mD8yERDPuG5eXpLaZTjVOC62AUzFs2VpoBIYH0Tb76xiAXrY8Fc/xGs
	 1CZ8JS2ia+a6z0f5Ie65PcBGSZCbxTyMp8ZyF2wYr0f8vcYQm1IR/+nT6TSDXyHFby
	 TJB3IL0ZfWrsFNaLWIqoKnv/7fw6vedVdyHxPlCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maulik Shah <maulik.shah@oss.qualcomm.com>,
	Navya Malempati <navya.malempati@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 176/377] pinctrl: qcom: Fix GPIO to PDC wake irq map for qcs615
Date: Thu, 28 May 2026 21:46:54 +0200
Message-ID: <20260528194643.518744967@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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



