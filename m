Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062817;
	b=CrWc7eQnV3Hg6EN9JRMWVC5gXFapqSOAHWwpnvciioUASLIdeD2fEHONQvW/0sZm7CpX
	 +758vGnwmryd+p6xilBxNkXiU1HaGuWwjfP+YzTflIrxEZkSwiz+zzDd7qhR0sxP9THk2
	 3TNxZvsZjy4Cs89FQ2NGG4PNVGS1A27cc5XBejyk9r9KLv5X5V/yLWxxdtCdgvr37nDS7
	 4UPBmVzg9LQoV9GC1/3Q6qjYWbGztJRNMi9Jk60oUaTYwDNyn3ydQb64X2GiXryqH5Tic
	 pgl4ka7MccAb8j5VoZtg8tpO5+UVkioaA3/KD4gcvNO5zTRi/t/TeVvNWUvjYABrsZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062817;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7LoBpE/tZFaycbgCnb3mEBCuIIpkYHHecZmNX4j0+AQ=;
	b=vhEOVprsfv0WtCNQuRebLvRIAbg8d1qhHFM76YMF39+uYGytCtV4iDE4gGkRPSKIjq8E
	 DgMQiW6LFY+saCxJeuumwcBzf8cyouBFsUhO6XxzoSTFFlRXvRuFoNXMug/OLFQdp6YHp
	 blto75TiSchQSo2ynEQub9RPsycbQjXcsWLX1HEGtgKPeIpI7lNUCyqLkkYueQ4dQBQQW
	 Ea/5ns58PORktZ+boHx3OoHvF5eyIvZoq+d15NLt3bJMNBmowsGJBe8RoDuATFGZgoiBs
	 UdD/ea2rP9MKPtp6HVvQyPdqjjP49Yr8VKlaYnaF86wHdjMFv7rOqrTB7z7VDjDurfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i7Hyxbn2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0E02606D80C;
	Sat,  7 Nov 2026 14:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i7Hyxbn2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FF3F1F0089F;
	Sat,  7 Nov 2026 14:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062817;
	bh=7LoBpE/tZFaycbgCnb3mEBCuIIpkYHHecZmNX4j0+AQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i7Hyxbn2EGdULAC69J1l3F601Xf3sWjgmDq5RhlxE9j7cpOeLqIdQynwouu5nVBO8
	 KP5jTtWh6xFS8PCLrooPf5Rsfyaji/SBUkKMP4WHq5hsmxkF0WxnC9n92HYUxQ3yRI
	 MRXKrtF+xVZ2v4pES5WETO8mX/2oNTMKeVRHktYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin Snyders <robin@snyders.xyz>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 115/869] power: supply: qcom_smbx: fix float voltage selector
Date: Sat,  7 Nov 2026 08:46:37 -0500
Message-ID: <20261107134856.457609602@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Robin Snyders <robin@snyders.xyz>

[ Upstream commit 2a26d260e72a95e9f13b9e475f63aa404600fcb2 ]

FLOAT_VOLTAGE_CFG encodes 3,487,500 uV as selector zero and advances in
7,500 uV steps. The current calculation adds one to that selector, so it
programs the requested float voltage one step too high.

Remove the extra offset and name the hardware encoding constants.

Fixes: 8648aeb5d7b7 ("power: supply: add Qualcomm PMI8998 SMB2 Charger driver")
Cc: stable@vger.kernel.org
Signed-off-by: Robin Snyders <robin@snyders.xyz>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://patch.msgid.link/20260812-qcom-smbx-fixes-v1-3-eb48246be599@snyders.xyz
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/qcom_smbx.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/power/supply/qcom_smbx.c b/drivers/power/supply/qcom_smbx.c
index 6e976342a3fbd..65ee918d1f09b 100644
--- a/drivers/power/supply/qcom_smbx.c
+++ b/drivers/power/supply/qcom_smbx.c
@@ -349,6 +349,8 @@
 
 /* pmi8998 registers represent current in increments of 1/40th of an amp */
 #define CURRENT_SCALE_FACTOR				25000
+#define SMB2_FLOAT_VOLTAGE_MIN_UV			3487500
+#define SMB2_FLOAT_VOLTAGE_STEP_UV			7500
 /* clang-format on */
 
 enum charger_status {
@@ -987,7 +989,8 @@ static int smb_probe(struct platform_device *pdev)
 		return dev_err_probe(chip->dev, rc,
 				     "Failed to init status change work\n");
 
-	rc = (chip->batt_info->voltage_max_design_uv - 3487500) / 7500 + 1;
+	rc = (chip->batt_info->voltage_max_design_uv -
+	      SMB2_FLOAT_VOLTAGE_MIN_UV) / SMB2_FLOAT_VOLTAGE_STEP_UV;
 	rc = regmap_update_bits(chip->regmap, chip->base + FLOAT_VOLTAGE_CFG,
 				FLOAT_VOLTAGE_SETTING_MASK, rc);
 	if (rc < 0)
-- 
2.53.0



