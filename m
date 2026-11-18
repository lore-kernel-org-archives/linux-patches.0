Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060813;
	b=kiO/MZsbPbBzBYoYkq2RE0KOpaROIwtcclF8QqsvPHu2KXj/C7jPnuMUJPCHs5vtiInG
	 OPQFdwbKIs6aQwaaZT8IZjtvISUrWNWo0Fl8ZqLClBlgHggNtczNWRRIrAx7CdMar4/LS
	 ngEjWLZm4CAOGWoSON3Rx4O4CqoDcmpw7nnFNG5bd7yp9kW8fbLnf6XZfYfRHuXGOwIGR
	 aCmGA2wNYgXAtt28HRqwuFIdmEKEoglNcTRIsnwWb86pQli8gkWDODc5OtZ3S7jR5IxBZ
	 03nAR4mER0tK6SlaQtgVy9c91VBSZUrBstSTaIpP1haQml72d3fwH7d4fuvNVClEfUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060813;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tDeL/yKq19uwJG3iOKCfTxDObgowaIv25S/rvj2r86Q=;
	b=cA9gC1d7H0H+fAOMpu3oiYlcHAOVzoXY0c2V0JR/T8iZq5nnYbFt+3oFoMaWJgrgQBQg
	 fFlKj/pzAW29TjBZj9R2fbIE1Ofm4be8E/1D0fd0o8f9vlFRd6Atxxl2LRxOoQ3lZez8b
	 K5PkmTOrqruBNE5SJ5w5vdan+vyzeoh5jzDGmOEEICxMQzVeKY6s8nXuLqRtMnp269Rbx
	 lv/Q+aF43qnsyBhcQD26LZ4Y3qPkQc4R5jilwC/7k/1shrZXlRAziGKLQoiltyCIsEszV
	 laaR4PXUqxb3G5MQD3wiEoBm7onxJqNZPO8qz7+pxsH974ep4XYjTKw93aBzX9mAs0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jGX+5r2Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57214606A330;
	Thu, 19 Nov 2026 04:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jGX+5r2Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A84061F000C5;
	Thu, 19 Nov 2026 04:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060813;
	bh=tDeL/yKq19uwJG3iOKCfTxDObgowaIv25S/rvj2r86Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jGX+5r2ZA4Vl2EIfr4YjwP4fWCVHCXTeYf4cE20SufuT/9Aq1SSg6SqP/4p5Ankk0
	 qFkLu5q+k7PSB2/5QzORkd8J4j5jXF/eR0pNI8IxC/JbdqgS6/VpVv7g7thikmhJpn
	 zuK1ynYJelJyevIgaec2b9zFKLERvGFOLpAiXgTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1293/1848] regulator: mp886x: check get_voltage_sel() return value
Date: Wed, 18 Nov 2026 15:55:31 +0100
Message-ID: <20261118150013.674225120@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 7910896df51a5..f42572d0f94e5 100644
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



