Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041980;
	b=K7ocJTnekQXyqjCtW7PWqfmmvOBp1J0oAwvphIpv1ohgaWkGhawhINPnDkNMLlpbYDs7
	 LCuhYpDsxXEeVh4bLlAbd6PYoX1IB0uOzno8LQoAgNLndIcEYIqKwWU8OC8wBFyaaCuLY
	 8tWSahYMbokxbhkXfXUql150vLE/ORaYpwrZMh6G/ufhpFP+un+ahDRzZDVhjllblUg7e
	 1MqlptMKUr4v0VRYT4+ezFFnSVvmh1TN0KH4U5wRIdQEr5lVAtyROlXgTy9E5oVROcAzH
	 VF4wqs9J35+/ZHnjcKzRu9BeD6nD2xkinrWuilR7om6HIWJuTda3ryxm8IUQ+BEAf2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041980;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jTAj62CKiJ74Embno0sJGub7TCgG8UJk8Py+06iwAX0=;
	b=qzYpGYd4H9ffAPGl4InitspEvMA/BAc3OeLzmQGOte42EVWeUU4cJYCNntF4ev+Th2zE
	 WBSOeQ9hMWzAXVbAXmYf7ISgC5eyUqU9QLcnf9vn4TYIpE8ZqM86jc1eDfF65uB0BRJQl
	 kFfdATNGrvtAeTCcnS39Vj2Tlxi0jPQcacbhUnpOWwpVLjkjbY4eWXDHKaXNG4GYaYclE
	 eOPDrc32e1HcEIc71Jb8ZBfqMVhdxUlAlOzTejoPBCKwlpHnWJcYeI5+UUKwKx+gPwHUb
	 5zsi5Zj8QT6ATAY9PEfM+s2WpXWVc6PIM+s8rqlGXGO2H3FI53sY5xxEjaai8WLlGQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kjJQroLK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B0D1606A32C;
	Wed, 18 Nov 2026 22:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kjJQroLK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAF431F000C4;
	Wed, 18 Nov 2026 22:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041980;
	bh=jTAj62CKiJ74Embno0sJGub7TCgG8UJk8Py+06iwAX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kjJQroLKtJcSt1BCrfB9Cob9QKVamDgEdWaI6J9Plxvqg+PPRbYK3YHV9We6rMKpw
	 oxRpkuVkkN6Ov+t5xcnSlCI1tkVYY9GT+2RqCF8OZMrVNO9Mlijjul/eVLl7uCQxEO
	 wXhutHIw30CP6jiXivX5nFPtG3/hjDnOzbX5zsis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3007/3318] power: supply: qcom_battmgr: report full batteries
Date: Wed, 18 Nov 2026 16:00:29 +0100
Message-ID: <20261118150450.454491160@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 63799fd24e837..bfff97756e7d5 100644
--- a/drivers/power/supply/qcom_battmgr.c
+++ b/drivers/power/supply/qcom_battmgr.c
@@ -1017,6 +1017,7 @@ static void qcom_battmgr_sc8280xp_callback(struct qcom_battmgr *battmgr,
 					   size_t len)
 {
 	unsigned int opcode = le32_to_cpu(resp->hdr.opcode);
+	unsigned int power_state;
 	unsigned int source;
 	unsigned int state;
 	size_t payload_len = len - sizeof(struct pmic_glink_hdr);
@@ -1065,19 +1066,24 @@ static void qcom_battmgr_sc8280xp_callback(struct qcom_battmgr *battmgr,
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



