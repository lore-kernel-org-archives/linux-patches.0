Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF0029712A;
	Mon, 12 May 2025 18:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073512; cv=none; b=RvQNDR2U1o5LrPD+ZLfpTm9SzLs72kaOJer5v0pxC4zNsxgYS5jrKGqjUNkIlQjTdCCfh9Ed5QAQRuPWWhvsd/6GzVSMHRdleK6ogXTeOkicT/P13xvpTOAqY64bKG6nv19zZj6N5h6pJ8MQlzJ8p8wiFnS+hAZOdP0RFKkIAmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073512; c=relaxed/simple;
	bh=RqU2YrplKjxKkEdVzq5olS3dza6qihtqYdmVA3HYNcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dgX2x4FlWfUuUBeIEqEDFwt9BgGysjvFCDNqkAYgj4c+TTh1YI4yDauzIQmtJxzlda2jvA9giAhOuePyXmIu+8VhMbWI3Pj5dSPFeg5tdbHxo81qETb9Zi8fHFFCi19/1KtXSp2rAenQRm/8HTFNjVKnCrHa4ffy//B2vcCG/gA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C3gl3uFm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C3gl3uFm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EBC4C4CEE7;
	Mon, 12 May 2025 18:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073512;
	bh=RqU2YrplKjxKkEdVzq5olS3dza6qihtqYdmVA3HYNcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C3gl3uFmjODYggijGtua1yNM8//eQl0stDPeGdyYMEtb8UxSHiORZV9X6nLHvA2ak
	 5k3BROrhpV2h357Qs26f36YXZhiMEkkKcm+qGH51bQYX33NoKKPZX4Ck2gOawaWdAx
	 J5q5D6KubeUDAWjJFjSu8kPBgjt18ZQQxtxfJBfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 082/113] iio: accel: adxl355: Make timestamp 64-bit aligned using aligned_s64
Date: Mon, 12 May 2025 19:46:11 +0200
Message-ID: <20250512172031.022468199@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172027.691520737@linuxfoundation.org>
References: <20250512172027.691520737@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit 1bb942287e05dc4c304a003ea85e6dd9a5e7db39 ]

The IIO ABI requires 64-bit aligned timestamps. In this case insufficient
padding would have been added on architectures where an s64 is only 32-bit
aligned.  Use aligned_s64 to enforce the correct alignment.

Fixes: 327a0eaf19d5 ("iio: accel: adxl355: Add triggered buffer support")
Reported-by: David Lechner <dlechner@baylibre.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Reviewed-by: David Lechner <dlechner@baylibre.com>
Link: https://patch.msgid.link/20250413103443.2420727-5-jic23@kernel.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/adxl355_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/accel/adxl355_core.c b/drivers/iio/accel/adxl355_core.c
index 0c9225d18fb29..4973e8da5399d 100644
--- a/drivers/iio/accel/adxl355_core.c
+++ b/drivers/iio/accel/adxl355_core.c
@@ -231,7 +231,7 @@ struct adxl355_data {
 		u8 transf_buf[3];
 		struct {
 			u8 buf[14];
-			s64 ts;
+			aligned_s64 ts;
 		} buffer;
 	} __aligned(IIO_DMA_MINALIGN);
 };
-- 
2.39.5



