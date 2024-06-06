Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E12A1A255F;
	Thu,  6 Jun 2024 14:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683758; cv=none; b=okD3Jf7DgTST7kKFnyESiJr9HRUgBvQda6dI9PHN5f1Mpc++MVVes+/Yjqte9ZQfLG3eqWX5VIpYlqToD0nE1KV2W4/lrXKS1kl3T8W24h8QceB5eK81UeXXxOEAnB5Jss/LyFLKE+JzgYh7qk9CCvj5lrAi96FqoUeuArSwCq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683758; c=relaxed/simple;
	bh=RjWuq2yp5FIf+nZWD5CycvN+4ik/zRYflXGk8FVXops=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MTPG83kjpIPmX6p/xvLmIpLl6UJWWfHUU3h+gEW07fhwMBf1RTLVuGfzmgtPRAf3jyyoigsCBuNDgM/PZso6WK0kkYDmQziYM8AfaU25U4o38xG45MnIuwezniCxvXqEoXSQS1+erT5+OKMjYvIOcKDhCGlumvaMXQFuJ2Rk2Z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eHONS+Y0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eHONS+Y0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C84CC2BD10;
	Thu,  6 Jun 2024 14:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683758;
	bh=RjWuq2yp5FIf+nZWD5CycvN+4ik/zRYflXGk8FVXops=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eHONS+Y0jPUxTrM287Lsj/MUFUmucyI9ji/0xVQPg2QwLcu5ykl0MMwflAtEH6+Mu
	 TdxSLGdBl4cAw9R5LdVQW+skDeTxaNmYBvCsV6pqT4/K0OyNZkBGYH5GxCn+bX4/0a
	 +5uuXimmCURVyoLMa1sVNA4rfPYvbswA1LyZFYWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Colberg <peter.colberg@intel.com>,
	Matthew Gerlach <matthew.gerlach@linux.intel.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 733/744] hwmon: (intel-m10-bmc-hwmon) Fix multiplier for N6000 board power sensor
Date: Thu,  6 Jun 2024 16:06:45 +0200
Message-ID: <20240606131755.974923507@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Colberg <peter.colberg@intel.com>

[ Upstream commit 027a44fedd55fbdf1d45603894634acd960ad04b ]

The Intel N6000 BMC outputs the board power value in milliwatt, whereas
the hwmon sysfs interface must provide power values in microwatt.

Fixes: e1983220ae14 ("hwmon: intel-m10-bmc-hwmon: Add N6000 sensors")
Signed-off-by: Peter Colberg <peter.colberg@intel.com>
Reviewed-by: Matthew Gerlach <matthew.gerlach@linux.intel.com>
Link: https://lore.kernel.org/r/20240521181246.683833-1-peter.colberg@intel.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/intel-m10-bmc-hwmon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/intel-m10-bmc-hwmon.c b/drivers/hwmon/intel-m10-bmc-hwmon.c
index 6500ca548f9c7..ca2dff1589251 100644
--- a/drivers/hwmon/intel-m10-bmc-hwmon.c
+++ b/drivers/hwmon/intel-m10-bmc-hwmon.c
@@ -429,7 +429,7 @@ static const struct m10bmc_sdata n6000bmc_curr_tbl[] = {
 };
 
 static const struct m10bmc_sdata n6000bmc_power_tbl[] = {
-	{ 0x724, 0x0, 0x0, 0x0, 0x0, 1, "Board Power" },
+	{ 0x724, 0x0, 0x0, 0x0, 0x0, 1000, "Board Power" },
 };
 
 static const struct hwmon_channel_info * const n6000bmc_hinfo[] = {
-- 
2.43.0



