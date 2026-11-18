Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020903;
	b=Pr1ll0QiYj71HwlHL1j/0sidp+3kfztKuOnHQwfiKKFnxIlTTmIRyia6z63on0WDUeI2
	 91XNr9cvHtdxqasSImqVQ7N9JFMJAFQJ0dvcAg4OPwDP24jQijIeB6cg96l7MPwWkLpSV
	 tMgJqEzGVYeg17S9bWLA8l/pMmojwjsuWQfno8QCBP6MTlOVH9rTc7WjM/+Vjz7llZ+Cz
	 YCMCUs1ORWamYo6zEA417v+dhejxO9yVK+hT2DmzmuKlnltdq0xaQXtb+InBL4jVP6YsB
	 VFo7hzdzw7c5YC/PsulnwZJ4Btg5wpxkxuRokkM7qZCCo1NPd/lgloOtM8fUKjbBg8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020903;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Pk23Mr9xz+P/BOCS07sVBl6RhsZpNGhGtmTJD9Q0I/Q=;
	b=ArJcd975C955yhuxlQdMiv5VsNwC33dKEj3Y08FBNIXe22tQNoeE04RZpK32Fr3znOoJ
	 5L1UA2ez3wlI+yeyWy+HWoplOTp3dN+zUTqsB0ncPY2iZKjz86x5UHhgy21br5u8oEMzJ
	 qpeAKGTNzlOwc2nHCXGf+Uyf5Laj9UxKfHEe/34t9gkAIjJxnZbxrq4627dNyeW+7azUg
	 Ip2kY3xz2VUfJpLj8kwZvrTiNtnPLRFeZ4p2bpNQlbgFKhh8qjQviEQerSKCyEgX9X/qJ
	 /DZVeCpVOdHUfxleKL1EujrwsfVe7HX9TlPjXzjNYCMwxLW/CkrpH2pGqY2dhYmcFZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DU7tvfiy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35CE860A2605;
	Wed, 18 Nov 2026 16:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DU7tvfiy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 855E71F000C4;
	Wed, 18 Nov 2026 16:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020903;
	bh=Pk23Mr9xz+P/BOCS07sVBl6RhsZpNGhGtmTJD9Q0I/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DU7tvfiyBPGHuAeUk53+m1bx+R7AcFRg3DUH5Tg0XsGoBeGg3ObYZZxSe5bar+/Ux
	 NAABsK5o/QvSuc55YOs5N5QrW1ZBemcpN7nOO60Ds37e3dLgrNh+fr208v2DnthCda
	 Lod7g8xN+IozVc8iA9g/wAEfii5/90EPf0gIiCVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2117/2651] power: supply: qcom_battmgr: report full batteries
Date: Wed, 18 Nov 2026 15:55:57 +0100
Message-ID: <20261118150402.148608270@linuxfoundation.org>
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
index 99ae0920f7264..636d6f6acecc5 100644
--- a/drivers/power/supply/qcom_battmgr.c
+++ b/drivers/power/supply/qcom_battmgr.c
@@ -1277,6 +1277,7 @@ static void qcom_battmgr_sc8280xp_callback(struct qcom_battmgr *battmgr,
 					   size_t len)
 {
 	unsigned int opcode = le32_to_cpu(resp->hdr.opcode);
+	unsigned int power_state;
 	unsigned int source;
 	unsigned int state;
 	size_t payload_len = len - sizeof(struct pmic_glink_hdr);
@@ -1327,19 +1328,24 @@ static void qcom_battmgr_sc8280xp_callback(struct qcom_battmgr *battmgr,
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



