Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BA5A6D6DC;
	Mon,  8 Jan 2024 15:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="otq9hQIq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C621C433CA;
	Mon,  8 Jan 2024 15:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704726913;
	bh=EHXghXOUoPM9YXNtyZpEnMwFZi7CsVoL6x84+knCvo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=otq9hQIqeLZdMtvhiS9eGtdGak+Z+vWIi63PemjgvCeGuUmwcrY0fQuVNTOZwlIkw
	 IMcQgt3/28Z2mv0nI5cRzfxExSPvflU0J5/18rqaHjtttnRT4QnuyljZ9ixgrV+wQT
	 1WX2TO1/sxlUWbkkKT8O771mHG2tDAvRmuliy5UA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <error27@gmail.com>,
	Nuno Sa <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 089/124] iio: imu: adis16475: use bit numbers in assign_bit()
Date: Mon,  8 Jan 2024 16:08:35 +0100
Message-ID: <20240108150607.086349987@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108150602.976232871@linuxfoundation.org>
References: <20240108150602.976232871@linuxfoundation.org>
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

From: Nuno Sa <nuno.sa@analog.com>

[ Upstream commit 1cd2fe4fd63e54b799a68c0856bda18f2e40caa8 ]

assign_bit() expects a bit number and not a mask like BIT(x). Hence,
just remove the BIT() macro from the #defines.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/r/202311060647.i9XyO4ej-lkp@intel.com/
Fixes: fff7352bf7a3ce ("iio: imu: Add support for adis16475")
Signed-off-by: Nuno Sa <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20231106150730.945-1-nuno.sa@analog.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/imu/adis16475.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/imu/adis16475.c b/drivers/iio/imu/adis16475.c
index 0a9951a502101..6c81dc5bf2c7a 100644
--- a/drivers/iio/imu/adis16475.c
+++ b/drivers/iio/imu/adis16475.c
@@ -63,8 +63,8 @@
 #define ADIS16475_MAX_SCAN_DATA		20
 /* spi max speed in brust mode */
 #define ADIS16475_BURST_MAX_SPEED	1000000
-#define ADIS16475_LSB_DEC_MASK		BIT(0)
-#define ADIS16475_LSB_FIR_MASK		BIT(1)
+#define ADIS16475_LSB_DEC_MASK		0
+#define ADIS16475_LSB_FIR_MASK		1
 
 enum {
 	ADIS16475_SYNC_DIRECT = 1,
-- 
2.43.0



