Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05CEC1974F2;
	Thu,  6 Jun 2024 14:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683092; cv=none; b=CBru03zUGFc8vwQbTeEBthzxeOx1e0jt4yyJfwI6xU46MS4jXwGePg45BQFrq00N9fFZsN5gmhSTd7dpkN4OGDZ/gHya7hzEctvqkpOgY9uKxUMKz6ycpt2gO0EhqbsWYakV0ueIyb5f3A/rzICDSYMDeXlDwor6Rifxj0VgW9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683092; c=relaxed/simple;
	bh=JS8mTgZzDWJujUUT14QrV2T0kX9g7tytj6iBlGNCF7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wxy27repm+/HdIZgbMgL0m0ZvY/uhNnNuRlDpKy+M+CM5R7Z51XE0hmJtzqGRe15fPjLcfBlokbIUJZpBey/rwJCSDs01n0sAyAFVwQ1s01cdPUl2BcyWGjsvhIdC0zOAqacD3HVuSzBaPXFL/1xBJoIvL5xudsyRDLZhF9aqgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LLEhHrmH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LLEhHrmH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8BFAC2BD10;
	Thu,  6 Jun 2024 14:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683091;
	bh=JS8mTgZzDWJujUUT14QrV2T0kX9g7tytj6iBlGNCF7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LLEhHrmHwMbTU9RhLz1rhTP46ISGUb+D1OJUoKhvAFHp0rr7+ZxIxqXjVbXbK8wO3
	 rGMZsG4V0iYjcR0aJSuKudqXO0KZdh62fZS+Qoo14J60J/si5Vy+SPcUST89fx/FP2
	 +MRTHRUQi4bgXuIF8ezfXbuvqa9IK8C5T6gOulLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Colberg <peter.colberg@intel.com>,
	Matthew Gerlach <matthew.gerlach@linux.intel.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 361/374] hwmon: (intel-m10-bmc-hwmon) Fix multiplier for N6000 board power sensor
Date: Thu,  6 Jun 2024 16:05:40 +0200
Message-ID: <20240606131703.978784138@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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



