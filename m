Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B5061DEFF4;
	Wed,  6 Nov 2024 12:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730894933; cv=none; b=nEfJHPaKaVAif/nzm/IVBQFqKxBHo+bRsrNuB3sqMx8CcOnq3cYCTpEa2DcyputdbEFAKvyeUiLhRZ+DwdA2uX96J6XZ807YgicBIgsjuHuJHIbfGv5IqejKJo2ehf63REr5zmiN0qMoeGqYCUPFDHF5o5bhU1L6WIRKS5VyQhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730894933; c=relaxed/simple;
	bh=zSnThIPb0gXNTyP9K0hwNHETQtQPEb8L2RXUUfuQzBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F76VRPdCpJOKq9DcnBYw4BQJAMs7e54ZQyrCjs8ijXemxQfhDbIX96z48lgDEkfAH2G91GWVP7+yXbCHNsg5RiZlFYAu/BsefA3uzaQTRq7EsWLQokQiA4xjho+CCwjOdb+I7TSdcOT2QBttAlBdp8T0J5WYuJCJwbbPvmSAL08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=otEQYGoH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="otEQYGoH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8247C4CECD;
	Wed,  6 Nov 2024 12:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730894933;
	bh=zSnThIPb0gXNTyP9K0hwNHETQtQPEb8L2RXUUfuQzBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=otEQYGoH2g76BxlGrxynReyZufNMt96nRgCAPUEY31zYi/eMr2qD4tGhEXarsnjYp
	 9+wLI9GdGBhDGT/Rd4rYbYVaK4l18Bp9iOHRasUcmiJdgeJEiawcRosjqhi00IquW4
	 yAB1vl+QNYeNmBVvnU4WVTpVa6KTN24gHr6ax46w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuntao Liu <liuyuntao12@huawei.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 047/350] hwmon: (ntc_thermistor) fix module autoloading
Date: Wed,  6 Nov 2024 12:59:35 +0100
Message-ID: <20241106120322.049287271@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuntao Liu <liuyuntao12@huawei.com>

[ Upstream commit b6964d66a07a9003868e428a956949e17ab44d7e ]

Add MODULE_DEVICE_TABLE(), so modules could be properly autoloaded
based on the alias from of_device_id table.

Fixes: 9e8269de100d ("hwmon: (ntc_thermistor) Add DT with IIO support to NTC thermistor driver")
Signed-off-by: Yuntao Liu <liuyuntao12@huawei.com>
Message-ID: <20240815083021.756134-1-liuyuntao12@huawei.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/ntc_thermistor.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hwmon/ntc_thermistor.c b/drivers/hwmon/ntc_thermistor.c
index c52d07c6b49f9..6e4c1453b8ab5 100644
--- a/drivers/hwmon/ntc_thermistor.c
+++ b/drivers/hwmon/ntc_thermistor.c
@@ -57,6 +57,7 @@ static const struct platform_device_id ntc_thermistor_id[] = {
 	{ "ncp15xh103", TYPE_NCPXXXH103 },
 	{ },
 };
+MODULE_DEVICE_TABLE(platform, ntc_thermistor_id);
 
 /*
  * A compensation table should be sorted by the values of .ohm
-- 
2.43.0



