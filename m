Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 244EB2ED86F;
	Thu,  3 Jul 2025 14:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751553948; cv=none; b=rx1hgh64O0wgoXJAFN3I+LSvNB97pypc+tR5pc4lADTZ2xXS6IzXPAZS05gl6D7BqTG+nC3bUGF8I67bH6qKyTd4RwUmaDOGFWV6YBSyIVFUv44YmxTC9teb9xkz051F1FYdiRMj623Z+gp4J/PdyLCwBeRkztUK7ZGRw2QubZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751553948; c=relaxed/simple;
	bh=dfpj9sXZSvV7VkEKVPXjW2TxPLcicNTpZ+dfwaIcg2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eivHWvqOdDlDR67wajeC6xgCvnDjv3V0WULGL1lal6PZgce6b+o/B2lZTr0KuMVCCe2Tp3bac6L55Cp7mGevuj9ZgM2/xh6+Qn5TeS+2yX7+2oswmHdwYbUOieGjHptyM1mg9MkHBWf+dnnRkrv1D1RtvutTUHIwDoRKV0vZ9uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OJ+ORxNa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OJ+ORxNa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CE97C4CEE3;
	Thu,  3 Jul 2025 14:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751553947;
	bh=dfpj9sXZSvV7VkEKVPXjW2TxPLcicNTpZ+dfwaIcg2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OJ+ORxNam1f1rxQPqwTU9bcRLkhBbDziwYT2NDlsXYdkbzRkxHL4KI9KWPjiXYWQ4
	 nw2+xzQqwux9n6gf7A2RKarx03c5vPEq91KDUdxeyLO3YNeYt9F33W33GGmkYZ81dk
	 LY5JMmxCeNvknETYPfed1DVI1QbtiV3duhoTX37w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 033/218] iio: pressure: zpa2326: Use aligned_s64 for the timestamp
Date: Thu,  3 Jul 2025 16:39:41 +0200
Message-ID: <20250703143957.278625070@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b4c6c7c472569..8fae58db1d639 100644
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



