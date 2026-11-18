Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032449;
	b=VYyNdpOCiPA1edCe5704QZXRhKYxgSacJE/sHwNUd3yMY4s0kywXxqNzXbQ9l4x7pBfJ
	 KEstqNAP1BN7qafzf3wTIANaV9BSlLWFIhyGt00FgogPheqelFZMAJTL2feAtwEIpKekI
	 bW1DMYQYiAbGoBaCIi39JyOz+zED0Tf+BYlJY7oHNo2Sdg2k0g+kvRx9wh3YIXXiMR0/V
	 BH3vgoQ7rEyrEG+jLPfrhqGnzmBrNqnOUqnMc/RiYU1kQc/tjkkYTUYQuy8NUl6kJ1KDq
	 /Xe3pn0UEdT0oSvwr3PCIi66N/cLu1Ex/i6eoi7cSBoy18VQoyU/+4LnSgGHf2J22XA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032449;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WjooN1KVzUs++ksE/qzVI2kXiZPsqC5SfCIpW2o34Xc=;
	b=LHp7mF3y+HGU5k2BzZpGiNbU0YRPHTAF4gu/OBRI3YZMmqkkgVCu4sjqo7T0riOD4hIL
	 n1uSEATEg3qAlCvxVejwYjyC4824/65Fizfg5b0FKgoOd+t5aee/72Wsd9ajc/MSrlFAv
	 6xVTtBzH4XdSJBbOR3ta96lGelTMzSiKWQfi6PvkJS5o5vCQBYQlaRTuoxUxJF8a2lKov
	 a8Bj8HTxziT8kbLKDreRtzLrVejiUoK2VBa27VVwxzH0HEgYeyDMZbuD/IQA60Ya+kWFm
	 cvJ46InmLYmAAtMmMLqtP5COFt7gz6dzqsS+FDh+V7SkeXpsap8DHQypSAE1fifzTrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="J6/YBaPv";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C4FF606A33A;
	Wed, 18 Nov 2026 20:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J6/YBaPv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 582691F000C7;
	Wed, 18 Nov 2026 20:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032449;
	bh=WjooN1KVzUs++ksE/qzVI2kXiZPsqC5SfCIpW2o34Xc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J6/YBaPvs6r4BCrY/u1i6CWQABnZc73h7k7Twx5cWMAHGzd2mb/aU8L/oJtVotpTq
	 akweATkh9dpmy/UWthB35PBWdM/CnxdGOfHkLPNYSw5iih55+5COy+e25ai5JYFd3R
	 P3bTuOHoTm42NJGmhqYeRYY36syfZx5Ox5AhAASQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1374/1756] power: supply: qcom_battmgr: report full batteries
Date: Wed, 18 Nov 2026 15:58:21 +0100
Message-ID: <20261118150103.915601037@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>

[ Upstream commit 6c8098e04ee4d233399e40e7311715844910f8f8 ]

The SC8280XP battery-status response has no explicit full state. When a
battery reaches its full capacity on external power, neither the charging
nor discharging bit is set. The driver consequently reports "Not
charging", which can make userspace show the system as battery powered.

Use the response's power-online bit and the reported capacity to identify
a battery that is full while externally powered. Preserve "Not charging"
for a battery whose charging is inhibited below its full capacity.

Fixes: 29e8142b5623 ("power: supply: Introduce Qualcomm PMIC GLINK power supply")
Assisted-by: LLM
Signed-off-by: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://patch.msgid.link/20261008-battmgr-full-v1-1-4f5485a9c421@oss.qualcomm.com
[put variable definition in Reverse-Christmas-tree order]
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/qcom_battmgr.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/power/supply/qcom_battmgr.c b/drivers/power/supply/qcom_battmgr.c
index 0cb66b131e3f1..81ec6ab7e1ad0 100644
--- a/drivers/power/supply/qcom_battmgr.c
+++ b/drivers/power/supply/qcom_battmgr.c
@@ -1020,6 +1020,7 @@ static void qcom_battmgr_sc8280xp_callback(struct qcom_battmgr *battmgr,
 					   size_t len)
 {
 	unsigned int opcode = le32_to_cpu(resp->hdr.opcode);
+	unsigned int power_state;
 	unsigned int source;
 	unsigned int state;
 	size_t payload_len = len - sizeof(struct pmic_glink_hdr);
@@ -1070,19 +1071,24 @@ static void qcom_battmgr_sc8280xp_callback(struct qcom_battmgr *battmgr,
 			return;
 		}
 
+		battmgr->status.capacity = le32_to_cpu(resp->status.capacity) * 1000;
+		battmgr->status.power_now = le32_to_cpu(resp->status.rate) * 1000;
+		battmgr->status.voltage_now = le32_to_cpu(resp->status.battery_voltage) * 1000;
+		battmgr->status.temperature = qcom_battmgr_sc8280xp_convert_temp(le32_to_cpu(resp->status.temperature));
+
 		state = le32_to_cpu(resp->status.battery_state);
+		power_state = le32_to_cpu(resp->status.power_state);
 		if (state & BIT(0))
 			battmgr->status.status = POWER_SUPPLY_STATUS_DISCHARGING;
 		else if (state & BIT(1))
 			battmgr->status.status = POWER_SUPPLY_STATUS_CHARGING;
+		else if ((power_state & BIT(0)) &&
+			 battmgr->info.last_full_capacity &&
+			 battmgr->status.capacity >= battmgr->info.last_full_capacity)
+			battmgr->status.status = POWER_SUPPLY_STATUS_FULL;
 		else
 			battmgr->status.status = POWER_SUPPLY_STATUS_NOT_CHARGING;
 
-		battmgr->status.capacity = le32_to_cpu(resp->status.capacity) * 1000;
-		battmgr->status.power_now = le32_to_cpu(resp->status.rate) * 1000;
-		battmgr->status.voltage_now = le32_to_cpu(resp->status.battery_voltage) * 1000;
-		battmgr->status.temperature = qcom_battmgr_sc8280xp_convert_temp(le32_to_cpu(resp->status.temperature));
-
 		source = le32_to_cpu(resp->status.charging_source);
 		qcom_battmgr_sc8280xp_set_online(battmgr->ac_psy, &battmgr->ac.online,
 						 source == BATTMGR_CHARGING_SOURCE_AC);
-- 
2.53.0



