Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018466;
	b=mGTErZxsO05b9JdcMwJ68EfJkVJpAFwB57GxSrdFWt7sTa5OIOBEchqW+P4enPxSphAv
	 2uYzZnZV5mvDLXf8870yIZrPTaxmcfcs688AZ5GDuGfRnKeqw3/2uwhGOgUQzGmqQVAwe
	 UWIITIjHyseEedyP//Wr7+1JqXG12FuDSZ1ANdSyc2/UQ8MqqoL2emwozv6HuB6x0yfe8
	 JTQ8jQwE79duecOFtgb7INx6pzkm7VVY4G4qgdaYlwRjOlWO123GvmaHl1i3QKHBP1uIv
	 oUqrg2hwTE+lLvIo1FTWA1CWvv+xv+WfD8aQHDWlkaJes4eMdQWam119m0W8Vm3D2mg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018466;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IPTFQybBvqt8Rchwm8+JymaBG0WpODNLSG4OhA7+2cQ=;
	b=NL0wNJ8heWRxtS1OMYi79GC9vs5NnvSHZvZFpPsObtVn3j2mkyxsPyDPmLKOpQVbiiKs
	 EU0ZSnagLe5dBo8LA5zm7RcGWCPhXfDXLRxheOkzOrphESqCKzhSOD9HW3+Frxuqq6qo5
	 +Uujk4BbDoCjjevYUFpXuRv7Hk8XAISO/mJBlbqeXKayPUmEkn0mCX6imw2nBkCmvDsIY
	 SaQOFhI3oJaVhMeYxW0QodcfAHEbpy/M4k2e8p/RYJ7DwfHFB/MSaBMdEWyuIDdSMzBDy
	 P/CFkRmX+AmYQO85KR8iKEfJivf7tb4EKb8XGTqtOWpnVKUaRKiPoelitsjNWq4fTNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OVKyrIA1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E840D606A32C;
	Wed, 18 Nov 2026 16:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OVKyrIA1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E4E71F000C4;
	Wed, 18 Nov 2026 16:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018465;
	bh=IPTFQybBvqt8Rchwm8+JymaBG0WpODNLSG4OhA7+2cQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OVKyrIA1WMPrkAIR6yp15LsjFrSzILpnUrwKycd44PGGHhshS0dtOF74TlmQmK0Qm
	 AjDU41XLqAy8v/64qtjr//9opsH+OGUZ1DfAuYG1i0q7g0MHsKIkfo65v1tHQ01Mvo
	 fvXN4BAjCOqlFP1AZgq9GK6UzZ/DJtihU8Q7dKm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liviu Nicoara <lnicoara@thinkoid.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1249/2651] power: supply: qcom_battmgr: Report capacity on X1E80100
Date: Wed, 18 Nov 2026 15:41:29 +0100
Message-ID: <20261118150332.948618007@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 97c8501c29961..4ca3409819229 100644
--- a/drivers/power/supply/qcom_battmgr.c
+++ b/drivers/power/supply/qcom_battmgr.c
@@ -830,6 +830,7 @@ static const enum power_supply_property x1e80100_bat_props[] = {
 	POWER_SUPPLY_PROP_STATUS,
 	POWER_SUPPLY_PROP_PRESENT,
 	POWER_SUPPLY_PROP_TECHNOLOGY,
+	POWER_SUPPLY_PROP_CAPACITY,
 	POWER_SUPPLY_PROP_CYCLE_COUNT,
 	POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN,
 	POWER_SUPPLY_PROP_VOLTAGE_NOW,
-- 
2.53.0



