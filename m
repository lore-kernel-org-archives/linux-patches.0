Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D93861C68F
	for <patches@lists.linux.dev>; Thu,  5 Mar 2026 18:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772737182; cv=none; b=hH/DR1UvAmd9Kp5vo4Cd69tDL8xjvaLnWlxKBzzaevtwTaIeBCECghXaNX9XVAX4/KmtVfy3F7BAJ4j2y9WXViZzltPI/nT6FEqBm5fhHAMpR5EAeiNpLsua4YjLIBqFNrQPgcj2MpnSSlVdH/imrCVmn6XoxXOEJtN99kRnfKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772737182; c=relaxed/simple;
	bh=BvAolbTAOeeCHBi8DJFVw81rI59azfr8TqaBD2qV4vQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=b9F4SEiQnEct30fMQo27pPIGsJi4tm5H7J+s8dWEPbfaKjTn7CM4pmQjWmp0lLvEl94+CLOgD1bGWzmzDo7bQb3RIJKomzqSoHPIS7PAYP3V3LN7auTYMcDK4mtdhpDlIGjqZY71L+e9mNYQnoY/GI3Is8lSpt241qgexbxHZG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=codethink.co.uk header.i=@codethink.co.uk header.b=Ve2KMQzL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codethink.co.uk header.i=@codethink.co.uk header.b="Ve2KMQzL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED297C116C6
	for <patches@lists.linux.dev>; Thu,  5 Mar 2026 18:59:40 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key) header.d=codethink.co.uk header.i=@codethink.co.uk header.b="Ve2KMQzL"
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Thu, 5 Mar 2026 18:59:38 +0000
Resent-Message-ID: <aanSmnxd5Sk9j3LX@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by 172-238-120-221.ip.linodeusercontent.com (Postfix) with ESMTPS id 4F9492025C
	for <broonie@sirena.co.uk>; Thu, 05 Mar 2026 18:46:42 +0000 (UTC)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 39D30600AE
	for <broonie@sirena.co.uk>; Thu,  5 Mar 2026 18:46:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 00064C116C6; Thu,  5 Mar 2026 18:46:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 25DF1C19422
	for <broonie@kernel.org>; Thu,  5 Mar 2026 18:46:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 25DF1C19422
Authentication-Results: smtp.kernel.org; dmarc=fail (p=reject dis=none) header.from=codethink.co.uk
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=codethink.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=codethink.co.uk; s=imap5-20230908; h=Sender:Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:In-Reply-To:
	References; bh=kgNmsKBmhUkX1t3WvtaENtNK/Lx0t9YyuiRYKr/Ea9Q=; b=Ve2KMQzLf0uHc8
	KkpzjWyJ3Ryj+4AzNfYN2CI8OeVz7YfYxJMdx1pb1m83dffyZBfYuymD0pIt/RMVF8WQApk3k+1ks
	G3kwKDNGFOzpoYoqm3hzxCheH0f4tfZd97+7uFrNBct2WiIVkG108sU8PvlIj/o7e2YMIUE3MltBy
	buBchP6pt7jVNzmh2tGBtYLtc2SMrYcp3sp+kRR8R4uUYm4y22/eXSGld+cnElIsuHiCJtQ9dCxTL
	Vd8Wm5O2Ktt0OtGj3sLBBipe97xaJ+5MXyv2YmZoFkftZs++ls/6FUDpFk+g541hnvuGb4aRr8KGd
	0ZZOnmjjKJNnvtZJc+2Q==;
Received: from [167.98.27.226] (helo=rainbowdash)
	by imap5.colo.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
	id 1vyDiO-002Z6U-PJ; Thu, 05 Mar 2026 18:46:28 +0000
Received: from ben by rainbowdash with local (Exim 4.99.1)
	(envelope-from <ben@rainbowdash>)
	id 1vyDiO-0000000AvER-2Ga8;
	Thu, 05 Mar 2026 18:46:28 +0000
From: Ben Dooks <ben.dooks@codethink.co.uk>
To: lgirdwood@gmail.com,
	broonie@kernel.org,
	linux-kernel@vger.kernel.org
Cc: Ben Dooks <ben.dooks@codethink.co.uk>
Subject: [PATCH] regulator: max20411: show failure on register
Date: Thu,  5 Mar 2026 18:46:23 +0000
Message-Id: <20260305184623.2603269-1-ben.dooks@codethink.co.uk>
X-Mailer: git-send-email 2.37.2.352.g3c44437643
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: srv_ts003@codethink.com

It is easy to use %pe to print a error-pointer so add this
to the dev_err() if the devm_regulator_register() fails.

Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
---
 drivers/regulator/max20411-regulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/max20411-regulator.c b/drivers/regulator/max20411-regulator.c
index 02d7009ea0e61..6c0ebb970e902 100644
--- a/drivers/regulator/max20411-regulator.c
+++ b/drivers/regulator/max20411-regulator.c
@@ -133,7 +133,7 @@ static int max20411_probe(struct i2c_client *client)
 
 	max20411->rdev = devm_regulator_register(max20411->dev, &max20411->desc, &cfg);
 	if (IS_ERR(max20411->rdev))
-		dev_err(max20411->dev, "Failed to register regulator\n");
+		dev_err(max20411->dev, "Failed to register regulator: %pe\n", max20411->rdev);
 
 	return PTR_ERR_OR_ZERO(max20411->rdev);
 }
-- 
2.37.2.352.g3c44437643

