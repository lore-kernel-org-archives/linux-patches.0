Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025309;
	b=wjp7mVJEsMdWoq1HJjxh1vct7Oi/Mc5yytiQCOvWZQhFMSoU36tghkolPYzalX0DEfA6
	 Tg1CQiquYmxCFMZjsa+3dXbi+ZXKO2Xr3zyViiCOqQhjLzHm3e58kKnHmkraZgFEZ6tVz
	 SbhcAHf+qxQVMCi+w0RYiq0sMQ/Q5QZRs6dFfTHJde5OQEdmawnSpMJMMgkyHUnR76VD7
	 0H8YLOpcKNoqKBW2NY+qtUGxyYrHeA+9XMtEEGw04QP21fVR/2hyfz6s2cV3oV5f0dCVu
	 99xOmaQ7kvVhllmtDhMD+uBvQQHccajvK+/Pdsd4u8NN/kCcZE6JMBM9YIqLtDNn+/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025309;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=byMi3NwZ87IfCcU3SvKvX5v5+ZqQF0LJY08zjxbwOVk=;
	b=cM34x0kBSakCvD7u+zkI0m82csNrQLrj7jleAR5p9YUDd8d6Qqk0y71uPua206LX+/y4
	 G3pLx2/UW+td1Pc+74OugBMxTTy7FSpQ24i6PceAbETqb2iCiaGcF1oK5TLged7pDF5/u
	 5uMjsiXvmdEi/OjEaafdCYcPXYG1m+U068D2a3vgp6g8rdoBfFdoanJrAOb6KjVtyra1u
	 fP/QmhaHJuUJpNMZXsDMUCPgMuyhY+5CELtcpkjUoXCynRmtGrjF41CRWQ/+ul60wdZxO
	 ocO/kPEexx+glxQ6KjHBVFopxcl1ozcTlw9NO0Hrpv75MX5krtdfEwBtn4WCF7K5bKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qNtDR3ct;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF543606A31C;
	Wed, 18 Nov 2026 18:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qNtDR3ct
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D68D1F000C5;
	Wed, 18 Nov 2026 18:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025309;
	bh=byMi3NwZ87IfCcU3SvKvX5v5+ZqQF0LJY08zjxbwOVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qNtDR3ctAonj0jeEFR+k14Cw0tqBvus5wvCufs2ZAhXMRK9xksINn4NNuCFLzbGZD
	 mOBZOnLTinOlQqlomEIihD68gBBXmEqhfnrVd6CJFWyCf3AzDW0TZlEeUgv5nZQKZa
	 apag/D7op+tWZHO6desc6HfVGBOY06wZQKGQVvXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liviu Nicoara <lnicoara@thinkoid.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1035/2151] power: supply: qcom_battmgr: Report capacity on X1E80100
Date: Wed, 18 Nov 2026 15:46:10 +0100
Message-ID: <20261118150200.063139936@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liviu Nicoara <lnicoara@thinkoid.org>

[ Upstream commit f7c62ebfd9127b12a1e39f1cc7f3131cb3065886 ]

Commit 3f87baacea4d ("power: supply: qcom_battmgr: Report battery
capacity") added POWER_SUPPLY_PROP_CAPACITY to the SC8280XP battery
properties, computed from the firmware's charge and last-full values.
When commit cc3e883a0625 ("power: supply: qcom_battmgr: Add charge
control support") later gave X1E80100 a property table of its own, the
table was copied without the capacity property, so X1E80100 machines
expose energy_now and energy_full but no capacity.

The percentage is already computed for this variant in the shared
SC8280XP callback; only the property list is missing it. Add it, in the
same place it sits in the SC8280XP table.

Tested on a Dell XPS 13 9345: capacity reads 94 with energy_now
52640000 and energy_full 55540000.

Fixes: cc3e883a0625 ("power: supply: qcom_battmgr: Add charge control support")
Signed-off-by: Liviu Nicoara <lnicoara@thinkoid.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://patch.msgid.link/20260920193402.2402-1-lnicoara@thinkoid.org
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/qcom_battmgr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/power/supply/qcom_battmgr.c b/drivers/power/supply/qcom_battmgr.c
index 03ffaad3b53df..d171ce7ff124f 100644
--- a/drivers/power/supply/qcom_battmgr.c
+++ b/drivers/power/supply/qcom_battmgr.c
@@ -834,6 +834,7 @@ static const enum power_supply_property x1e80100_bat_props[] = {
 	POWER_SUPPLY_PROP_STATUS,
 	POWER_SUPPLY_PROP_PRESENT,
 	POWER_SUPPLY_PROP_TECHNOLOGY,
+	POWER_SUPPLY_PROP_CAPACITY,
 	POWER_SUPPLY_PROP_CYCLE_COUNT,
 	POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN,
 	POWER_SUPPLY_PROP_VOLTAGE_NOW,
-- 
2.53.0



