Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029858;
	b=pNPYCkaR+tIT/2hC1vu0H/PdypqZ/KlEXZ+zQxfXKlm5qx58UmQqqbPRICkuFhzqvjta
	 ohhnAe2V/omL3JgpntKJ0J6JoJSk/4hGjn3woFSJpN0SPkyzo53w6q8xE1sOy6GSPRKF9
	 8FhtheFYuPcbQO4HPUCYHzTVuBcg8UvDf6PRmJNGq4WDoGz2AGKP3s8RPFXyomSSPxJKl
	 TOrlkLFeOfxsR45dQ6An1ISyJ7pEX2N7t+n1LceP8bhM341EGcwVKhGM2/NhNGRdf11C4
	 bpRiA/iSUUUxn+n2xF3nSYigxuSf3onyLvpZM5JAq/k80yG+JZmiqf4ZmgWzWwIZI1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029858;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XoLBCiuFiavFIIId77ZMMiocnvvQ16gX5JsoA1GBkK4=;
	b=e5M2ECNOyI+fMRcSkq2CYmnJqXlxMpZkclWm+7xgiqBWITwJ93mWGb4dViePN54QCzAT
	 QG++uc9uqB+8k2wyFKM49TgmCvyV1Tq8AHrWM1A/U3c0CG+1nHej7rMJNRGnf4+RrHKTs
	 kByuEelJLzKDAfekJZR6W2UCix8kHl4651aKI0zFVPa9dV5FgW9K31aUUsqAEDE7SlRZ4
	 0iglW3POUoLL+bsdeRHFLIqa1dc9ee4br7Xrb3ybodKCpLu/iF7hZKXzBRfgkqqHeDi1a
	 uj/c8ZYwhsEw4dORDj5JyIzEBpDp3qZWDd8+FIAFvLdryTpCPdF7o+ovaE6h7hk11cg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pNez3mZ1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64104606A320;
	Wed, 18 Nov 2026 19:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pNez3mZ1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B47851F000C4;
	Wed, 18 Nov 2026 19:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029858;
	bh=XoLBCiuFiavFIIId77ZMMiocnvvQ16gX5JsoA1GBkK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pNez3mZ1JogPEoY3u/ebVtj0ZpZLf5t5c8RWwIDHs6ZfB9sq7UIdxnqjzqFX/SXJa
	 Oy+TRx8MxtaJYzKEReasplnB11jdp1M1AeTt6mxpuufv2Jk8RsvfHuy6gaMBJN/Yx1
	 VTcwH0tt6g27cI5Jz5/JLdiRdmUpD2rGI7qKvgb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0498/1756] regulator: mp886x: check get_voltage_sel() return value
Date: Wed, 18 Nov 2026 15:43:45 +0100
Message-ID: <20261118150028.910033236@linuxfoundation.org>
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

From: Jisheng Zhang <jszhang@kernel.org>

[ Upstream commit 87121c42fadc7683469aee96ad833bc560197a55 ]

The get_voltage_sel() can fail, resulting in negative error codes
stored in unsigned integers and corrupted state logic.

Fixes: 97be82880b61 ("regulator: add support for MP8869 regulator")
Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260901043123.5401-1-jszhang@kernel.org?part=1
Link: https://patch.msgid.link/20260909143957.9284-2-jszhang@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/mp886x.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/mp886x.c b/drivers/regulator/mp886x.c
index 451bd7c0abe24..75c6d9e5d550a 100644
--- a/drivers/regulator/mp886x.c
+++ b/drivers/regulator/mp886x.c
@@ -256,6 +256,7 @@ static int mp886x_regulator_register(struct mp886x_device_info *di,
 {
 	struct regulator_desc *rdesc = &di->desc;
 	struct regulator_dev *rdev;
+	int sel;
 
 	rdesc->name = "mp886x-reg";
 	rdesc->supply_name = "vin";
@@ -277,7 +278,12 @@ static int mp886x_regulator_register(struct mp886x_device_info *di,
 	rdev = devm_regulator_register(di->dev, &di->desc, config);
 	if (IS_ERR(rdev))
 		return PTR_ERR(rdev);
-	di->sel = rdesc->ops->get_voltage_sel(rdev);
+
+	sel = rdesc->ops->get_voltage_sel(rdev);
+	if (sel < 0)
+		return sel;
+	di->sel = sel;
+
 	return 0;
 }
 
-- 
2.53.0



