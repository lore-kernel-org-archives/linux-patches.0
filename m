Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE6F22ACEE;
	Mon,  2 Jun 2025 14:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875559; cv=none; b=DoXVAUW2oJrrz64NXC/gapiBJrGAp3lqJP9sCqJ82xMXcRx4m8lDeqGtGxYCy7m/VGP2yShz2PwEp1FDD4NxJeNxr5x7LK4d68U3WV+BUzlTr0B2mayqt6jvtPECSoMt8csx4k0nA1Kuhhgok7Y3A2ZGgKyEHjDgme4kbqFFN/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875559; c=relaxed/simple;
	bh=BLAxL9x/guuc9bBvGXx3TAD2K0RKO9eJUQGdbQMFmYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SQddAS22KJRSwhTy/xPn7Q8Gyy5XWTUjyzD/aqseciph5GBO1baoQtCISP/dsdpfmAaebJyHbRcbrgOO7o08Px6OCAfujBV6a8H7qLdOs8MmwrBnEoWODr6wQsFFiU+iLEF2BSS3tFmpPqbLcBSmKbtG28s93A8GTgv2U1Bt2jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d8a/zO56; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d8a/zO56"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AB06C4CEEB;
	Mon,  2 Jun 2025 14:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875558;
	bh=BLAxL9x/guuc9bBvGXx3TAD2K0RKO9eJUQGdbQMFmYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d8a/zO56YccQUZMaeM1aqNblrUeRJvS39XvkFapU0vKY4YwTVSZEUO+bDQ5CR5X7W
	 8qOuuVa9L15jt0vZBQ0p2k6yGpEZKfPv1VZ33gRcecW0OZmjAsZnpQibF9JVeXhE2Z
	 97JScNu6NsDpnmY298cigdttWGsAFlLEcTi1dznM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ang Tien Sung <tien.sung.ang@intel.com>,
	Kuhanh Murugasen Krishnan <kuhanh.murugasen.krishnan@intel.com>,
	Xu Yilun <yilun.xu@intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 173/270] fpga: altera-cvp: Increase credit timeout
Date: Mon,  2 Jun 2025 15:47:38 +0200
Message-ID: <20250602134314.291697495@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuhanh Murugasen Krishnan <kuhanh.murugasen.krishnan@intel.com>

[ Upstream commit 0f05886a40fdc55016ba4d9ae0a9c41f8312f15b ]

Increase the timeout for SDM (Secure device manager) data credits from
20ms to 40ms. Internal stress tests running at 500 loops failed with the
current timeout of 20ms. At the start of a FPGA configuration, the CVP
host driver reads the transmit credits from SDM. It then sends bitstream
FPGA data to SDM based on the total credits. Each credit allows the
CVP host driver to send 4kBytes of data. There are situations whereby,
the SDM did not respond in time during testing.

Signed-off-by: Ang Tien Sung <tien.sung.ang@intel.com>
Signed-off-by: Kuhanh Murugasen Krishnan <kuhanh.murugasen.krishnan@intel.com>
Acked-by: Xu Yilun <yilun.xu@intel.com>
Link: https://lore.kernel.org/r/20250212221249.2715929-1-tien.sung.ang@intel.com
Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/fpga/altera-cvp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/fpga/altera-cvp.c b/drivers/fpga/altera-cvp.c
index 4e0edb60bfba6..d107ad73a188c 100644
--- a/drivers/fpga/altera-cvp.c
+++ b/drivers/fpga/altera-cvp.c
@@ -52,7 +52,7 @@
 /* V2 Defines */
 #define VSE_CVP_TX_CREDITS		0x49	/* 8bit */
 
-#define V2_CREDIT_TIMEOUT_US		20000
+#define V2_CREDIT_TIMEOUT_US		40000
 #define V2_CHECK_CREDIT_US		10
 #define V2_POLL_TIMEOUT_US		1000000
 #define V2_USER_TIMEOUT_US		500000
-- 
2.39.5



