Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 228FB47F781;
	Mon, 31 Aug 2026 13:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183464; cv=none; b=CK6IWkxsiSBnKhBCVaHfpKm+roN3SVTfRuI6TfG7gNTDUIeHbPUrGZzKIwlvzvO8k/0i0h9kUpQBE1AT4/XW8lQK58Lnc5W/Sz6G4obw0cvwFXYTZ1vGn3j3zsZCJLSJznSK/G3Sx/qK0SgPlzogOis9l+mn5kmf3hrjvZdHi3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183464; c=relaxed/simple;
	bh=LG1lnK+eu905RJMV0XpQ2MVQAss3rIzZtqTejqF+EOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KyR1s/c9IftvPAyxGDB4EXp3rFx/Mcc+FUkvB0J9QNYM54X3pubK8dpf2XikQ8NTJm7tIJUwEhmp7n+8HZuAKX3O124dg1LCbAiK3NLYBHaLD+jezfvmVUBcQ1vPFKf+SHHN2g61r2C7jNkEdqC1GBDRbgEF7/WSY2P7LnAOuPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Mx8cC2rC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mx8cC2rC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C9B71F00A3F;
	Mon, 31 Aug 2026 13:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183463;
	bh=+cT9VZJ4nI0oegICZvjfshAj04GCGW/ExACGxHSW/HM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mx8cC2rCTfhRPCIe/cLvBx2V4Mn35YwS+x8EYmfrnFAUD+5tSq3gNE+GEaXZAnLb5
	 9jxyo2Yp3TH6EXsa06Y4sxZFOaym6rBrIkKN+NqT9due/Ws9BKtpwSv43H0k1Fk4GZ
	 LVS+5HHPVnlqhIQG3k0wE0y7wNTWr2K0l7Sr0GuDLtdOXwezet99YwRAlXixefU0ai
	 2dNaAFWXCFLLWg5Vu94UnySiYwI9Eh9YGCop5mKVzwEb328R95OEzLUplcT1LvUSYc
	 LNnY363fJOiPqmXs5NLX4SOCWUx3xxPIxmoIH7eIhDkC6ij3Ze3aXM2Z3gK6BKCrph
	 yL1c90+Jm8hRg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Charles Keepax <ckeepax@opensource.cirrus.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	yung-chuan.liao@linux.intel.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] soundwire: intel_auxdevice: Add cs42l43b to wake_capable_list
Date: Mon, 31 Aug 2026 09:22:19 -0400
Message-ID: <20260831133314.4125787-111-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Transfer-Encoding: 8bit

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit be6d8daaab654e9b0a8508757534d556d399d0cd ]

Add cs42l43b (both packaging options) to the wake_capable_list
because it can generate jack events whilst the bus is stopped.

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>
Link: https://patch.msgid.link/20260429153614.741899-1-ckeepax@opensource.cirrus.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The background history checks finished successfully and match the
earlier analysis:

- `wake_capable_list` has been in this tree since Linux 6.18-rc7
  (`ac3fd01e4c1ef`).
- The only later change to it here is the cs42l45 entry
  (`487e455643c04`), which `b4 dig` links to the Cirrus lore thread from
  December 2025.

That supports treating the cs42l43b addition the same way: a small
hardware quirk for an existing Intel SoundWire wake table. The backport
recommendation remains **YES** for 6.18.43.

 drivers/soundwire/intel_auxdevice.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/soundwire/intel_auxdevice.c b/drivers/soundwire/intel_auxdevice.c
index 8752b0e3ce74c..c0c8ffcecc6bf 100644
--- a/drivers/soundwire/intel_auxdevice.c
+++ b/drivers/soundwire/intel_auxdevice.c
@@ -51,6 +51,8 @@ struct wake_capable_part {
 };
 
 static struct wake_capable_part wake_capable_list[] = {
+	{0x01fa, 0x2A30},
+	{0x01fa, 0x2A3B},
 	{0x01fa, 0x4243},
 	{0x01fa, 0x4245},
 	{0x025d, 0x5682},
-- 
2.53.0

