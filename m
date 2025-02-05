Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 361B0151988;
	Wed,  5 Feb 2025 14:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766224; cv=none; b=GGHCnQcXe/FV5V5ZrXADNSZHkgnkzH0HwA0JSprO2XGT+I2xIVQLx0wCPIBxFFgFL4R3QUEf6JdJnqjd9pUPcxvDM3cr4WeC6eNBsmJH8otQ4v4X0nEoQGzxnnIkvmpH1CZpDRgKJB0eVmVOajsxsaxcHjnuygstiRgvvjk4JA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766224; c=relaxed/simple;
	bh=RkOVEreQ+2gd2fJBJ81Suq00epC2NZNVYq3km6bVzus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i9RumsM74KKfsogy1Zh251Y1yQljPiEFHbFY0sDzv/maioV9NMqj2nSNdYtQXem1g+mUj7bSHzjm0Y5GRWlkLgOeBvDx8nZcBC12OuycBDBNpf2RT6L6hbwz9pamUPvlTG4WraDoBBjcHoSxjd+hbfA3ZAmcvbFjTmGLoUyMQd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qDoqw0A4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qDoqw0A4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E340C4CED1;
	Wed,  5 Feb 2025 14:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766224;
	bh=RkOVEreQ+2gd2fJBJ81Suq00epC2NZNVYq3km6bVzus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qDoqw0A4XCCoS6KmExrH0QPh9cSnwRngdE7au8XhzrHy4+5pOWLrIloLhZMWVVkvi
	 wEZyRFxVSrKTziGcRJu088RQrc4REGgwq81i4Mrzwvu4KTZfrRxWXNhw07nUCVIksK
	 BMx2eEbr6YaocEQBq/fIA8feY+Gqt0cQpJPoGAag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 322/393] regulator: core: Add missing newline character
Date: Wed,  5 Feb 2025 14:44:01 +0100
Message-ID: <20250205134432.633563596@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 155c569fa4c3b340fbf8571a0e42dd415c025377 ]

dev_err_probe() error messages need newline character.

Fixes: 6eabfc018e8d ("regulator: core: Allow specifying an initial load w/ the bulk API")
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Link: https://patch.msgid.link/20250122072019.1926093-1-alexander.stein@ew.tq-group.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index c96bf095695fd..352131d2df4ca 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -4876,7 +4876,7 @@ int _regulator_bulk_get(struct device *dev, int num_consumers,
 						       consumers[i].supply, get_type);
 		if (IS_ERR(consumers[i].consumer)) {
 			ret = dev_err_probe(dev, PTR_ERR(consumers[i].consumer),
-					    "Failed to get supply '%s'",
+					    "Failed to get supply '%s'\n",
 					    consumers[i].supply);
 			consumers[i].consumer = NULL;
 			goto err;
-- 
2.39.5



