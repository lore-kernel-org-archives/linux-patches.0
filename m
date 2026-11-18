Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055229;
	b=YaxM+ZBhTU1IVd2ClxsmzKUV5Z7EF+/CZbS4HXXgT05BZYfB4z7dXeU0cX/uc9Cd1v/B
	 CJN76IGGnDKf6EIE/kbIwjaTckQosn76WgC80G3FqhpoTPcDKytJH6VHUe2W/eDb4/PWi
	 4BpK1CJ63PIkA84Py1Jcy8C5CY+FlHFvDAMdc7odLJiVlRqZEuEDB6ZYyJpyhNS4xiMAU
	 e697jHcrpOj60LvWWRd2bEvVzU1F16BGFWopQF8paVC6CgHzHZtpZevcKTxe/3CvCLpRq
	 gGE+J/fmO3iUxhJjeMFHGA9wYaEpkoHwJ7h4+k8/liFT6j4DkVP86Xsrx1bw9+3bG6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055229;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BbNExSb9/cOYEnOfamh/xi2mWnsOpwpTjCYlkeBsBtM=;
	b=mIz3Tv/FRmjdNX4hpYq/32xcaq1BDP2+8Vh90/5hTslAOzdlB665AsQ7qhVUjTQORgxM
	 1VrkbsID+FASdslCFdIKTcirnpUpiheSAUR/AavoVx/OOdxn8shk40OYl2hRZCYX/GP++
	 ZH330+4hpELkJLC36Py5evCcnkK4DEjS/HEYNkHszvXu8IwFmkUdVZu9wz2YxEZL7AfK6
	 d3M5/sTG+cZYBn1fP1xvAH5/J//p9QW2pFqInCjRUbZgR/VybZXW4scfAEJ/+Ii16QtR8
	 9p0dqj6oaUiFc/8MBFsQI0gQuZpzXeqSxYaEYPgBKo4EO7mYbkQmu7vSh9hyUIKp+1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eA+bLKmQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3B40606A320;
	Thu, 19 Nov 2026 02:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eA+bLKmQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25A641F000C4;
	Thu, 19 Nov 2026 02:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055229;
	bh=BbNExSb9/cOYEnOfamh/xi2mWnsOpwpTjCYlkeBsBtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eA+bLKmQ+YBRfuhl2bBEEm+eDHCzzGmQb92nzmrjsJt9rhKy8sJt07YeftC3XUOhr
	 LRXnwNKu48bXAIQ2z7DwolJCUq7I4PUwZsIVnf9qHUKa7/QZrK8i7BD20G2tZw8ot9
	 WTaS2m9HkcjNtEHn7jMIWdBxMcWOy8b4FiFpu9QY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1550/2214] regulator: mp886x: check get_voltage_sel() return value
Date: Wed, 18 Nov 2026 15:53:46 +0100
Message-ID: <20261118150114.123365965@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



