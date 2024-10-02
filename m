Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6728E1D0DE2;
	Wed,  2 Oct 2024 14:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877689; cv=none; b=ZGVmPQbwbEKn5DXbuVF+1YtyeAcxuUbIOFnxERC8sJirV3KDkZb8K3q8iVp9KS+TcdtnsHd2dpRHRx8zvy8JKPxbbG1cI/mpqL6eN0EWPMlkifXlIXIsE/Av2yuzAmKmuOMYZBU7yIyqevrSSQ7hu7/jslE5xRsGgm+kU1fv3vU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877689; c=relaxed/simple;
	bh=sjYkRy7MZ3Um2ChfE2YIpEfCY5pEFyANFFFSoumOCiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pBfHuo9MYKW+w3WZMCYUw4TaIjni+dWh5hCGaD8qKs6fRLGeFYmqx4+8kPTSyBIcjbjtp4gzckXiXYKnw7j+AIdqDyeKVhnO0ShbZ3Nps1Tj5dUFEv3yUW5CrcuQIxAlAB7vPRSnf7GP819Pe/fY/b+MV/3bCOpQSRwu/Dc9NrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WmjU0F/u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WmjU0F/u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6932C4CEC2;
	Wed,  2 Oct 2024 14:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877689;
	bh=sjYkRy7MZ3Um2ChfE2YIpEfCY5pEFyANFFFSoumOCiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WmjU0F/uC5Y1/qTz7srE8D/jSGdBvcp5hnVUj7dag4r5LXlo4qnygLKr+ffSLMxJr
	 gj3rwHhDy3uf0lnf2cPaoloqcKdl4L6jPih53ImT4N4BWxA54NmV4X3ivvduKAWYJZ
	 bV/sEhxhC6VsMBGMjdBUiizYIltUIo5Ulx7BJJhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuntao Liu <liuyuntao12@huawei.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 160/634] hwmon: (ntc_thermistor) fix module autoloading
Date: Wed,  2 Oct 2024 14:54:20 +0200
Message-ID: <20241002125817.427705456@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index ef75b63f5894e..b5352900463fb 100644
--- a/drivers/hwmon/ntc_thermistor.c
+++ b/drivers/hwmon/ntc_thermistor.c
@@ -62,6 +62,7 @@ static const struct platform_device_id ntc_thermistor_id[] = {
 	[NTC_SSG1404001221]   = { "ssg1404_001221",  TYPE_NCPXXWB473 },
 	[NTC_LAST]            = { },
 };
+MODULE_DEVICE_TABLE(platform, ntc_thermistor_id);
 
 /*
  * A compensation table should be sorted by the values of .ohm
-- 
2.43.0



