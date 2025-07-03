Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D7322EF672;
	Thu,  3 Jul 2025 15:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555479; cv=none; b=GGnx3905DCNLIVvWpCAVYp929kXO45yxroghxFJb7rNstSiG3E7U/oc6qlKrOOEF9V9QxTdWbaAQXk9FcxgADIgKZDlJ2ejo69N0sgCKtf1JanZDei6LDIbgK2W3bskajJAWMVe2gdFBVfJZQIhHpUTemLtpPfP98m3uQleaz7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555479; c=relaxed/simple;
	bh=vh0BSDKE5z9PTiFb7v0fbs1CrT+vOVeAIbQzN0mq/bo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N1Coy5IoXYlxE5wa29l2nf8BR0qIiTm9Vao7PwiiIo9tLytXoN6DsS0Wfk0T5VGW+MiZcESFTbQ2chuBoTs/KZlkDxqhgtZvt0OaUXMyI9VXsQHn+NwSzGSM0hibVP3SKx5NO7AWjw3VQp9lQDrm6EdZBas0nCt+tTvxb3b0zzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1HZb6rVl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1HZb6rVl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23000C4CEE3;
	Thu,  3 Jul 2025 15:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555479;
	bh=vh0BSDKE5z9PTiFb7v0fbs1CrT+vOVeAIbQzN0mq/bo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1HZb6rVllsKGn85q4dBlFbf+c6tsE0P0q21CHAUCA2CTZx9LxcA2K0rCynWa9ccl2
	 n9oOwexZGjT1atpyOfAYyY+fcXuhCByfaFnGW2VTmkApMFwctToLgVWsc3A1nNMQFg
	 g6LGpahHPgld9PNAGPJWE4WIzGbM6fHpwc2eTnEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 026/139] iio: pressure: zpa2326: Use aligned_s64 for the timestamp
Date: Thu,  3 Jul 2025 16:41:29 +0200
Message-ID: <20250703143942.205508324@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143941.182414597@linuxfoundation.org>
References: <20250703143941.182414597@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit 886a446b76afddfad307488e95e87f23a08ffd51 ]

On x86_32 s64 fields are only 32-bit aligned.  Hence force the alignment of
the field and padding in the structure by using aligned_s64 instead.

Reviewed-by: David Lechner <dlechner@baylibre.com>
Link: https://patch.msgid.link/20250413103443.2420727-19-jic23@kernel.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/pressure/zpa2326.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/pressure/zpa2326.c b/drivers/iio/pressure/zpa2326.c
index ef1d0349f4247..a1c694199c989 100644
--- a/drivers/iio/pressure/zpa2326.c
+++ b/drivers/iio/pressure/zpa2326.c
@@ -582,7 +582,7 @@ static int zpa2326_fill_sample_buffer(struct iio_dev               *indio_dev,
 	struct {
 		u32 pressure;
 		u16 temperature;
-		u64 timestamp;
+		aligned_s64 timestamp;
 	}   sample;
 	int err;
 
-- 
2.39.5



