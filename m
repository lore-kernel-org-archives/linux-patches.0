Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B34C379EF1
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301901; cv=none; b=lJ8TDBkKrm2Qle1cWnyPVPNJYGhI8r2p10Ea5JVCrxNyBGD1AFMKZ+P6tYxsqOKMrRN7k3+lEdvwmYS1ZG3UTRW41rQrPweOy1keASAIjBQ167B+8TDhDrXwqACu6YM2FenzD+Ftg1K4y0uM8lB77LFhS79Fz+BpBYVhcy8GHwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301901; c=relaxed/simple;
	bh=UjwpdonoHHNRoB4Sq29DVk7N3h17GMi3uVWtIx7G7rQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M45PiziuTdE0CJaRnIysKQfQUG+nZL4z3ePlCNHC0yH/HK5PcdnQEg9x4AilSa28cuBRl5ACyt4hMYsEbBlvxx/0vSKBiyNvCViR65O7wCRSuQpmRrJBORdXINrVN4s764uaYrwqbeXN6TOgGttmKWOwNTcB7tC1yuxTOwa5mTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UiCp75O+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UiCp75O+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C333C19424;
	Sat, 28 Feb 2026 18:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301900;
	bh=UjwpdonoHHNRoB4Sq29DVk7N3h17GMi3uVWtIx7G7rQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UiCp75O+s+GF6HGzKLanxh3SwU/kAWZdWe/IVh637oFOcIYjO0fZGmKnkiBU03zR2
	 9uO0frIqP5ZnRt06d/wlGCfifRlj6wmPl92HvTFGaCpj/em+HAlCBjL6WdjGDCNkiC
	 nOrqPvpsbxkDRdf1wp5Z4qNEEWY53P2gRGyBhNvN3YUzjpoRcUo1gKjd0yvBU8VHEn
	 jeIlg0QdqboIzkEXChrFAxROQc9WeDC7PuCexkvlrk0hh5xqDAbtMtNDqvNq5f98hd
	 /CT05u8H8U0GfzJb1AnBbOlmMdTvGAnh6umz0UKypuf8wLSX4Amx5z74PVV9BNDMIy
	 Y3GwP7XD2RnAA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Petre Rodan <petre.rodan@subdimension.ro>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 330/385] iio: pressure: mprls0025pa: fix scan_type struct
Date: Sat, 28 Feb 2026 12:59:12 -0500
Message-ID: <20260228180011.1568201-330-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Petre Rodan <petre.rodan@subdimension.ro>

[ Upstream commit 8a228e036926f7e57421d750c3724e63f11b808a ]

Fix the scan_type sign and realbits assignment.

The pressure is a 24bit unsigned int between output_min and output_max.

 transfer function A: 10%   to 90%   of 2^24
 transfer function B:  2.5% to 22.5% of 2^24
 transfer function C: 20%   to 80%   of 2^24
[MPR_FUNCTION_A] = { .output_min = 1677722, .output_max = 15099494 }
[MPR_FUNCTION_B] = { .output_min =  419430, .output_max =  3774874 }
[MPR_FUNCTION_C] = { .output_min = 3355443, .output_max = 13421773 }

Fixes: 713337d9143e ("iio: pressure: Honeywell mprls0025pa pressure sensor")
Signed-off-by: Petre Rodan <petre.rodan@subdimension.ro>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/pressure/mprls0025pa.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/pressure/mprls0025pa.c b/drivers/iio/pressure/mprls0025pa.c
index 7ecb928655421..367644269fec4 100644
--- a/drivers/iio/pressure/mprls0025pa.c
+++ b/drivers/iio/pressure/mprls0025pa.c
@@ -160,8 +160,8 @@ static const struct iio_chan_spec mpr_channels[] = {
 					BIT(IIO_CHAN_INFO_OFFSET),
 		.scan_index = 0,
 		.scan_type = {
-			.sign = 's',
-			.realbits = 32,
+			.sign = 'u',
+			.realbits = 24,
 			.storagebits = 32,
 			.endianness = IIO_CPU,
 		},
-- 
2.51.0

