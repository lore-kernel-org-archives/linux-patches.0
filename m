Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D726D9443
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:28:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C35EC433C8;
	Sun, 13 Aug 2023 21:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962130;
	bh=Ls5BNfmws4uTdC2/F0Q72rzg2EiC9GZo4M/heEL+woA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MC8hhe3hUZTro8NbhCKszXcCU/W+Qxyx5yVf3y6xnh0N/n9MKiz5vSVJnpLxhULLw
	 OKV/ETqgeQV9uRQY2R96FZydH7ZmSaAdA142uhpzdoBUVIlUPTDCUCBJAoZKPsSYch
	 pQHE7XrRldoVIDStiD/Pgrn+iVanjXgI8wL+zlt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alejandro Tafalla <atafalla@dnyon.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.4 094/206] iio: imu: lsm6dsx: Fix mount matrix retrieval
Date: Sun, 13 Aug 2023 23:17:44 +0200
Message-ID: <20230813211727.756480539@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211724.969019629@linuxfoundation.org>
References: <20230813211724.969019629@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alejandro Tafalla <atafalla@dnyon.com>

commit 6811694eb2f6b7a4e97be2029edc7dd6a39460f8 upstream.

The function lsm6dsx_get_acpi_mount_matrix should return an error when ACPI
support is not enabled to allow executing iio_read_mount_matrix in the
probe function.

Fixes: dc3d25f22b88 ("iio: imu: lsm6dsx: Add ACPI mount matrix retrieval")
Signed-off-by: Alejandro Tafalla <atafalla@dnyon.com>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://lore.kernel.org/r/20230714153132.27265-1-atafalla@dnyon.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
index 6a18b363cf73..b6e6b1df8a61 100644
--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
@@ -2687,7 +2687,7 @@ static int lsm6dsx_get_acpi_mount_matrix(struct device *dev,
 static int lsm6dsx_get_acpi_mount_matrix(struct device *dev,
 					  struct iio_mount_matrix *orientation)
 {
-	return false;
+	return -EOPNOTSUPP;
 }
 
 #endif
-- 
2.41.0



