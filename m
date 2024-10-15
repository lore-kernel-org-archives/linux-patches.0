Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF9CA1D9A5F;
	Tue, 15 Oct 2024 11:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992565; cv=none; b=cgpj72/qPgdei65zoYQ1irV0zoTVy3jXkSKkJwBvgVstovcdv9lRgdpLIK6W2d7bmLJEJq/IMbSzuiCIHWPYzuad9Mp/L3WGoa7Zhfwn1WkW05CYjOoBsPDIKaG+ZIUjRRBgzT69jWX8j5pfZardSdp/Phj50JUqJwq1ubZqwNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992565; c=relaxed/simple;
	bh=SJxzoV9Q0JpEuDWoxpCpcV33srxHrI8oqmja+tRnKjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f/YTLxkv2bWYoKjxJquL1kqB1K8rQ79Z/LFKFKs4p/p+kOnWsko8LmOkIaklFtgBjSyyVp9dukdNPS+6GS2qTHiuBoZu4KsdmvvvN6k+nZ/MoJF0cISI0Hny+R1xRfBW7frDWyfCgBkkRWsQSRVKw4q+qjv5a7qqO3biordC5aQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sAl5vUCu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sAl5vUCu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA758C4CEC6;
	Tue, 15 Oct 2024 11:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992565;
	bh=SJxzoV9Q0JpEuDWoxpCpcV33srxHrI8oqmja+tRnKjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sAl5vUCu91OOZ+vOVB8qkBjz88MMSX3uR1z8Jar7OCfunmVPNR7wl8RRJVL3Nspgz
	 BSUVi46Xa9LwkyFhk0MXzE+zgJsuQtVyjwHQ9s6JuDyG/iY8D5LUcl7BSlc4ODPEpU
	 mzbsnuIBJPVKwbsMK+ksW7QW4gwyVy1HfX5UjK/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuntao Liu <liuyuntao12@huawei.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 154/691] hwmon: (ntc_thermistor) fix module autoloading
Date: Tue, 15 Oct 2024 13:21:42 +0200
Message-ID: <20241015112446.468501544@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index cf26c44f2b880..4414c6b313238 100644
--- a/drivers/hwmon/ntc_thermistor.c
+++ b/drivers/hwmon/ntc_thermistor.c
@@ -55,6 +55,7 @@ static const struct platform_device_id ntc_thermistor_id[] = {
 	[NTC_NCP21WB473]      = { "ncp21wb473",      TYPE_NCPXXWB473 },
 	[NTC_LAST]            = { },
 };
+MODULE_DEVICE_TABLE(platform, ntc_thermistor_id);
 
 /*
  * A compensation table should be sorted by the values of .ohm
-- 
2.43.0



