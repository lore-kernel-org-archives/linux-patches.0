Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062815;
	b=nEUFhKYTLbCzxjAjdpjRaf+M/ksVYEC6aiAFr9vjbLZLc3R+78elnL5H5oKcppbV3Q12
	 NmMNRwjKXugUuVugFgk8Xe8YVZVSvVUM/QzcJbpHxliNWCWXApfooK6EKETyJ4Y7gvcmR
	 bW5abqz4bkI5Rs5PctQT0nJYCanMhjNvdGvxE68caPBmZUMAF3yJ/RMtV8GZ4mu+IcpuT
	 O3HIT7uN28ZvpzCBXo+Qo4xzVBW7w1M7ZMmY73KlWVHF+eI0aJf566k5rdbZNapRYkR/Z
	 vO9t8YD4PUJSPl6rb+jxkQs8p9RGvLjj3TW8AC43zE+R72e8CgQ6gLS/baxtHlNmR+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062815;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Nt0uLIz1GAUVEvxgYluel3UTZ4NJgYyPG2NyuIvUhjs=;
	b=i2Hh6WO6hLDXqI2oubo79kPY77hubQw4P+95QwT8Bv2pUh5MdikVcq5Md7fizkcLionB
	 rsefv/oGFznIwejSoYvW9ddHPMe1H3D3pCILtJHI+UWHq3W2ajckQsUOnTeejlk7234sc
	 GAQgqpzsL67ycIrG3np+6kjJPGXYUsWh4NKGSG/xcoDuErEWo/33jtyaROVt2FdzkYF0N
	 EN70lBUzopfgJtKJZZ4rsbpLL/B0Y/KUqdMls3ryOselHLbWsS+zS3g+OuRyyf4ZmeRLd
	 MHjdmPnAUZyNJKdIZv5q2bqO0YbenKkm8IAs4VlEnP+pZOhsWYQ+fSGGJbSlzYDXCPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lJt3FnLh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B140606A333;
	Sat,  7 Nov 2026 14:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lJt3FnLh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC13E1F008A2;
	Sat,  7 Nov 2026 14:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062815;
	bh=Nt0uLIz1GAUVEvxgYluel3UTZ4NJgYyPG2NyuIvUhjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lJt3FnLhoTJl9mQot7cr7rozU4IptosWEu1NdgSg1JQ51wffoszb3BBnLO7QEyQW8
	 wLT5cmCbXGK47UOujN7B0/xPLIaRMR7YrrmBALyghMojNRNVRXNRmhsegPFGBAdDS4
	 Kz6HaDKSlErm9R7tftm1znnGqE5hCmLczQr47DUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin Snyders <robin@snyders.xyz>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 113/869] power: supply: qcom_smbx: include base when petting watchdog
Date: Sat,  7 Nov 2026 08:46:35 -0500
Message-ID: <20261107134856.403067727@linuxfoundation.org>
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

[ Upstream commit 2f0dec12007891398e6e3041aca0b8656918973d ]

BARK_BITE_WDOG_PET is an offset from the charger peripheral base, but
the watchdog bark handler writes it as an absolute SPMI address. This can
write another PMIC peripheral and leave the charger watchdog unserviced.

Add the charger base, as all other qcom_smbx register accesses do.

Fixes: 8648aeb5d7b7 ("power: supply: add Qualcomm PMI8998 SMB2 Charger driver")
Cc: stable@vger.kernel.org
Signed-off-by: Robin Snyders <robin@snyders.xyz>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://patch.msgid.link/20260812-qcom-smbx-fixes-v1-1-eb48246be599@snyders.xyz
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/qcom_smbx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/supply/qcom_smbx.c b/drivers/power/supply/qcom_smbx.c
index b1cb925581ec6..11aab7e635592 100644
--- a/drivers/power/supply/qcom_smbx.c
+++ b/drivers/power/supply/qcom_smbx.c
@@ -757,7 +757,7 @@ static irqreturn_t smb_handle_wdog_bark(int irq, void *data)
 
 	power_supply_changed(chip->chg_psy);
 
-	rc = regmap_write(chip->regmap, BARK_BITE_WDOG_PET,
+	rc = regmap_write(chip->regmap, chip->base + BARK_BITE_WDOG_PET,
 			  BARK_BITE_WDOG_PET_BIT);
 	if (rc < 0)
 		dev_err(chip->dev, "Couldn't pet the dog rc=%d\n", rc);
-- 
2.53.0



