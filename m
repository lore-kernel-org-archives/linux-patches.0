Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 324AF43DA5C;
	Tue, 21 Jul 2026 22:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672736; cv=none; b=ngkHESi7seQrwC9nIpQpP3+UBY8aIW5QRm/p+WfX6OrwJAoTKX02olOU1+Q2uMdcCj1iK8deqVi5VN99iaLfvayjybWXEApnOoMgNv32NFT4Td1dT+UVOzO2kCLCu2pMt3J2wxMLu1d0Uhh0Q5gi5pEWqmEoRpT9K0u5ZnAoB6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672736; c=relaxed/simple;
	bh=l7dVKqHnkujt0/JrroGfMSYF8YCLwe2IVPP3t2KYaaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XzSadKhaEWS+/IWMcSS8WIcFF+YyhXUDi7nv8GrJ8muL7DX9uOZNiDk+isPq7ou5/LbcAziMnP0Il0lV5fxmw+aT+p3JKH26FF+vIh4su2j4z+9T5PITHxjKtYyQQhYxHlH/QEF4hLLBygrPxfcXUCgIi1xFh2S2X+V1INzHnyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oi/dL0e1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oi/dL0e1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96CF41F000E9;
	Tue, 21 Jul 2026 22:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672735;
	bh=CmmGaNu3zce/67ngOVWZUvnDaJAn/UyfHsShMt2EEiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Oi/dL0e1YebcktRVyUT0pXGITY4YuwxhsbhdCMjeWRym7bmHQtN6PLLjmYehGhlat
	 QaxpGp/MojYdURgxMpoODulRBe2hVrikqCl9e4WMgfknKz9BylZi9v5oMYnlnvLsM5
	 SIg1aTKfh3wzllN/Ku52TAMrRIgW5HryexrsUMnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 738/843] iio: invensense: remove redundant initialization of variable period
Date: Tue, 21 Jul 2026 17:26:13 +0200
Message-ID: <20260721152422.649710559@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Colin Ian King <colin.i.king@gmail.com>

[ Upstream commit b58b13f156c00c2457035b7071eaaac105fe6836 ]

The variable period is being initialized with a value that is never
read, it is being re-assigned a new value later on before it is read.
The initialization is redundant and can be removed.

Cleans up clang scan build warning:
Value stored to 'period' during its initialization is never
read [deadcode.DeadStores]

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Acked-by: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
Link: https://lore.kernel.org/r/20240106153202.54861-1-colin.i.king@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: affe3f077d7a ("iio: imu: inv_icm42600: fix timestamping by limiting FIFO reading")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/common/inv_sensors/inv_sensors_timestamp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/common/inv_sensors/inv_sensors_timestamp.c
+++ b/drivers/iio/common/inv_sensors/inv_sensors_timestamp.c
@@ -105,7 +105,7 @@ void inv_sensors_timestamp_interrupt(str
 	struct inv_sensors_timestamp_interval *it;
 	int64_t delta, interval;
 	const uint32_t fifo_mult = fifo_period / ts->chip.clock_period;
-	uint32_t period = ts->period;
+	uint32_t period;
 	int32_t m;
 	bool valid = false;
 


