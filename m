Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 216E92E62DF;
	Tue, 15 Jul 2025 13:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587432; cv=none; b=kmd8E5XzqPs740scn/MRf4IZTe4C2znGNxJDS7MtcgdkG6l7j9fKOl3tG/JfiYM3zDKuvnPoXLZT1E0MUycYOLDpL9SUGH1sJaJi7bIQwFbu27LhUoDFeXstfSmC2M2hGNkzcQ0eddypqFg7bUcgI6zp7gNcSoNcmnrc/qb0HAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587432; c=relaxed/simple;
	bh=IcXh91AGKB9UOTaZE/F+ZkDid8YM4cn6ihbWJxXmIFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iQO2V6SPZpbLiYOT0nUVTXVTovF/4TsK5S7HaYYDLSz2F1OL13lU9Ij8bIBPtnhmfPHdQ9RCduYpGQgamzrXKSr3YKnvZMYoAgrxsraILX8TJvpEwPoWqvfIMuBCwGKN23kyFF6rE9c+bBRxODZuGEgDv4C9Dboal040+ql7Zyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DdezbKit; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DdezbKit"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 539EAC4CEE3;
	Tue, 15 Jul 2025 13:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587431;
	bh=IcXh91AGKB9UOTaZE/F+ZkDid8YM4cn6ihbWJxXmIFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DdezbKitjNd/mqgat0TsibDeUriXL0L/WhVOaaQ/txvylOPZV7w4hBjGt3hvGvSsk
	 sefhQVkcAkwesBTLCAePpnZHJ7YgwTU45jpVW/lxaJlV9ZU25S8u4d86Ap2lHIBiUB
	 iSF9058s3ndsS1WLEu+g1F3OOfdSv4ywO+4RQ7+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 010/208] iio: pressure: zpa2326: Use aligned_s64 for the timestamp
Date: Tue, 15 Jul 2025 15:11:59 +0200
Message-ID: <20250715130811.249990003@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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
index b8bc2c67462d7..00791bc65b700 100644
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



