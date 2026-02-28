Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20C0C36C9C4
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302224; cv=none; b=ISZjYyhvUr4oawLsH9Kl4G09T4Ch1eAPmSdw5Wf7vWy77o9/uZJSsw7qnDQ1sBUoJ4ATsIdzBuQoN97K6qNv3jS2BUU6d3u8niw55MjptsSh7M6SW9/thGUoDU7zS7JBQYbBK7PgdA7guGglMZPn3/7S+nUagTeRXpRQW7CKKks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302224; c=relaxed/simple;
	bh=nPImifieEDw0FI+JvboMIK2Elcg6GCi8CvxvEErTs68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L0qsHjJM98CC4/FdV6q0wFkRkWfeWp8tuSE5rlm5c6djYJ3Kwg8ozi4JuTf/KxsZzqz9p03/zTomOLdP/i8svlttDYMvBtReL4aHtJ6pjNG4GhvAKQlTur5gJY9OPy0KtmmHAKm3N4f1w6Ey88FSxBM6UjSHXx5JPbOlWk5+EwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L+8/sjrf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L+8/sjrf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D466C116D0;
	Sat, 28 Feb 2026 18:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302224;
	bh=nPImifieEDw0FI+JvboMIK2Elcg6GCi8CvxvEErTs68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L+8/sjrfxIuVQSMkbNytj9Gunq+UHF1EmgGZWqbKNT5/qvucCtjEcBN/kpk0H+bEc
	 0q1mc0UH20bxb8jm5mF+6QaZ+xPYoO0nRx2Cq9f2tLX31cnJaj1CB8TpLnv8AevYV2
	 S3jiEbI7h8mGR8qz3D6fY7npvfAHDp+9oX84pdbMEEsdbb4YL614NGAAPykGvhpC06
	 GotI9JowvyaqxmH6gLVZzX8NkoKXllX1VZN8ZpYdH15oIddZujoEH/b1xPL6uWtpwC
	 LsmG38wfiW6LBt8Glm3LuUknoBcLLYzScMW8lUFykEu8OweUj3MnpDK4S2gKLTvk5K
	 9tzRBArNLhB2w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Petre Rodan <petre.rodan@subdimension.ro>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 232/283] iio: pressure: mprls0025pa: fix scan_type struct
Date: Sat, 28 Feb 2026 13:06:14 -0500
Message-ID: <20260228180709.1583486-232-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
index 829c472812e49..566c21bf3ea0d 100644
--- a/drivers/iio/pressure/mprls0025pa.c
+++ b/drivers/iio/pressure/mprls0025pa.c
@@ -132,8 +132,8 @@ static const struct iio_chan_spec mpr_channels[] = {
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

