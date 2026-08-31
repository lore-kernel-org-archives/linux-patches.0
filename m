Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0974456E05;
	Mon, 31 Aug 2026 13:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183817; cv=none; b=O4afpI1ISyb6K0oLTqgND+CvBuYPYvyYVNeCIgLpe1b9r+RhVeRm6LsQQ1WEXjc8UDI3j4+U6AIBEc5JnvtPujcUWeKEpfBBOtvOjNYOrZWBUgRs6cVbUrsnnHVoYHUDz5OsJbco+wVqIJL1cpCftSZHF44Vl0lsXhcpM27LUeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183817; c=relaxed/simple;
	bh=Ye55eXSohBylkTv5hG5+egzxT/lLc6KCmbI+mjxXNlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JKQupz4JMmcGIcMn8rxnuY4kdJt5klELAqNVe5BRwxhgEGK/BeVXWsnmh0XPc7V21OA2u3rebhpVX6aTxanPuhE+p5NIpg41SmtSuVDZbGG+TLRxHF0Kqgg8Br9IFD0rMbNIcw3ZoLdt/MoyTrWrUCpsTII+wHg7/ABby16xnZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HQkBSo5E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HQkBSo5E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3D9E1F00ADE;
	Mon, 31 Aug 2026 13:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183814;
	bh=ax+2U+d1QBIJ1hGXdZtpy23fVu9P8xhY34mAwN2ZV5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HQkBSo5EB304n2frI3NhfMbBgJbsOnET5C2rp+vFzP2mz7j/B2a9UjZLRKfYn1AFb
	 YVxqMDqTN6DbcQdkHSw4VdIfruGbNj/VDC4gLiHwaUkxi74KhkcZAvB9HfR8EzvBVj
	 fOuFp0T5aor+TBCInJGr98aCUkv2TRGGLq9Vvvrt6Hg+Iz4EcokdyDeqGsM5wq/AV1
	 MjU2eA2sjfImN7Cjdb9kUDD3TqEVlmqaTmnGTxfWBwzsl1mreUi0SgH176UuV/TU8N
	 pfhSLOvUCS982SnvuBWwS4ab/Zu0miGBXE1TpLBvoMMqdZ594b6Ibg3zsDFqLn0Q5K
	 8DlS/zkCsqi7g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Potin Lai <potin.lai.pt@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>,
	linux-hwmon@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] hwmon: (pmbus/lm25066) Fix PMBus coefficients for LM5064/5066/5066i
Date: Mon, 31 Aug 2026 09:25:49 -0400
Message-ID: <20260831133314.4125787-321-sashal@kernel.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Potin Lai <potin.lai.pt@gmail.com>

[ Upstream commit 83dda7ed185501ba1f8165aeca83ff4a8ef7c263 ]

Swap the high setting and low setting coefficients in the lm25066_coeff
table for LM5064, LM5066, and LM5066i. The coefficients were previously
mapped incorrectly, resulting in inverted current and power scaling.

Additionally, dynamically assign the exponent (R) registers inside the
probe's LM25066_DEV_SETUP_CL check. This ensures that the proper
exponent is applied (e.g., for LM25056, high setting power exponent
is -4, but low setting power exponent is -3).

Signed-off-by: Potin Lai <potin.lai.pt@gmail.com>
Link: https://lore.kernel.org/r/20260611-lm25066-driver-fix-v3-1-9d7d4b4e253d@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The background git history search finished successfully. It confirms the
driver has been in-tree since `03e9bd8dbcee6` (2011,
LM25066/LM5064/LM5066) and LM5066i support was added in `5783ec2e5c102`
(2017), with no prior coefficient-fix commits in the history.

That lines up with the earlier analysis: the swapped coefficients date
back to the 2013 refactor, and the verdict for this 6.18.y tree remains
**YES** — a small, maintainer-reviewed fix for wrong current/power
readings on production BMC hardware using these chips.

 drivers/hwmon/pmbus/lm25066.c | 54 ++++++++++++++++++-----------------
 1 file changed, 28 insertions(+), 26 deletions(-)

diff --git a/drivers/hwmon/pmbus/lm25066.c b/drivers/hwmon/pmbus/lm25066.c
index dd7275a67a0ab..6e23ada64e2ff 100644
--- a/drivers/hwmon/pmbus/lm25066.c
+++ b/drivers/hwmon/pmbus/lm25066.c
@@ -132,23 +132,23 @@ static const struct __coeff lm25066_coeff[][PSC_NUM_CLASSES + 2] = {
 			.R = -2,
 		},
 		[PSC_CURRENT_IN] = {
-			.m = 10742,
-			.b = 1552,
+			.m = 5456,
+			.b = 2118,
 			.R = -2,
 		},
 		[PSC_CURRENT_IN_L] = {
-			.m = 5456,
-			.b = 2118,
+			.m = 10742,
+			.b = 1552,
 			.R = -2,
 		},
 		[PSC_POWER] = {
-			.m = 1204,
-			.b = 8524,
+			.m = 612,
+			.b = 11202,
 			.R = -3,
 		},
 		[PSC_POWER_L] = {
-			.m = 612,
-			.b = 11202,
+			.m = 1204,
+			.b = 8524,
 			.R = -3,
 		},
 		[PSC_TEMPERATURE] = {
@@ -167,23 +167,23 @@ static const struct __coeff lm25066_coeff[][PSC_NUM_CLASSES + 2] = {
 			.R = -2,
 		},
 		[PSC_CURRENT_IN] = {
-			.m = 10753,
-			.b = -1200,
+			.m = 5405,
+			.b = -600,
 			.R = -2,
 		},
 		[PSC_CURRENT_IN_L] = {
-			.m = 5405,
-			.b = -600,
+			.m = 10753,
+			.b = -1200,
 			.R = -2,
 		},
 		[PSC_POWER] = {
-			.m = 1204,
-			.b = -6000,
+			.m = 605,
+			.b = -8000,
 			.R = -3,
 		},
 		[PSC_POWER_L] = {
-			.m = 605,
-			.b = -8000,
+			.m = 1204,
+			.b = -6000,
 			.R = -3,
 		},
 		[PSC_TEMPERATURE] = {
@@ -202,23 +202,23 @@ static const struct __coeff lm25066_coeff[][PSC_NUM_CLASSES + 2] = {
 			.R = -2,
 		},
 		[PSC_CURRENT_IN] = {
-			.m = 15076,
-			.b = -504,
+			.m = 7645,
+			.b = 100,
 			.R = -2,
 		},
 		[PSC_CURRENT_IN_L] = {
-			.m = 7645,
-			.b = 100,
+			.m = 15076,
+			.b = -504,
 			.R = -2,
 		},
 		[PSC_POWER] = {
-			.m = 1701,
-			.b = -4000,
+			.m = 861,
+			.b = -965,
 			.R = -3,
 		},
 		[PSC_POWER_L] = {
-			.m = 861,
-			.b = -965,
+			.m = 1701,
+			.b = -4000,
 			.R = -3,
 		},
 		[PSC_TEMPERATURE] = {
@@ -519,18 +519,20 @@ static int lm25066_probe(struct i2c_client *client)
 	info->m[PSC_VOLTAGE_OUT] = coeff[PSC_VOLTAGE_OUT].m;
 	info->b[PSC_VOLTAGE_OUT] = coeff[PSC_VOLTAGE_OUT].b;
 	info->R[PSC_VOLTAGE_OUT] = coeff[PSC_VOLTAGE_OUT].R;
-	info->R[PSC_CURRENT_IN] = coeff[PSC_CURRENT_IN].R;
-	info->R[PSC_POWER] = coeff[PSC_POWER].R;
 	if (config & LM25066_DEV_SETUP_CL) {
 		info->m[PSC_CURRENT_IN] = coeff[PSC_CURRENT_IN_L].m;
 		info->b[PSC_CURRENT_IN] = coeff[PSC_CURRENT_IN_L].b;
+		info->R[PSC_CURRENT_IN] = coeff[PSC_CURRENT_IN_L].R;
 		info->m[PSC_POWER] = coeff[PSC_POWER_L].m;
 		info->b[PSC_POWER] = coeff[PSC_POWER_L].b;
+		info->R[PSC_POWER] = coeff[PSC_POWER_L].R;
 	} else {
 		info->m[PSC_CURRENT_IN] = coeff[PSC_CURRENT_IN].m;
 		info->b[PSC_CURRENT_IN] = coeff[PSC_CURRENT_IN].b;
+		info->R[PSC_CURRENT_IN] = coeff[PSC_CURRENT_IN].R;
 		info->m[PSC_POWER] = coeff[PSC_POWER].m;
 		info->b[PSC_POWER] = coeff[PSC_POWER].b;
+		info->R[PSC_POWER] = coeff[PSC_POWER].R;
 	}
 
 	/*
-- 
2.53.0

