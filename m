Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD9B8285057;
	Tue, 17 Jun 2025 16:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178669; cv=none; b=I9/ezgncRLpE/HqFA07JEmA4bZf7kaKBIUsKh5Pn2R4c36AAsUkRlx34R2U9Wkt3tFWq8FAZQTCofUwSatrqGI20O7XAV2aLzrngD8J8pGivCYN7AfCLFNSyCJZxuKPCboB9q/44krbo6ZgDLHx9TXWGBaDPjqEZp5FUTnIspBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178669; c=relaxed/simple;
	bh=aTSApfd6aXIyWHUlGVVMclZYun12D6MpX6ABvTQOCoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VBmr8o42yLDR4ubvrLdAhTfBCn3V65T9N7NdDnXhm5pJy6DIVfH6LL1POCUEJZ6M+0Va2jpn3WJe15MleJyzoQOqWUy+VYM9u0SW2FK5DbS6DxUOvMd2b7Lp0nK20PmilHcMuIp3FTrbrHVDEEU427HRiJGDZ7I7HnvgUuxBvqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A229LR5O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A229LR5O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E994C4CEE3;
	Tue, 17 Jun 2025 16:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178668;
	bh=aTSApfd6aXIyWHUlGVVMclZYun12D6MpX6ABvTQOCoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A229LR5ORKUo+XLbpwmkpt2s8/b5QL8yhKriNFuS8IAfMflnCS0YS4pnHvnSY2dGB
	 XxLuLm7+Ijq8W50QDwMrZAbJJbOHd8irlvvs+oaTLZYBR5i2svlCPp+3qezOVXprzM
	 DzcYNAHbySDF7rboQ78VZlIUVUubPdrwF/xqwQIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Winchenbach <swinchenbach@arka.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 518/780] iio: filter: admv8818: fix band 4, state 15
Date: Tue, 17 Jun 2025 17:23:46 +0200
Message-ID: <20250617152512.604787238@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sam Winchenbach <swinchenbach@arka.org>

[ Upstream commit ef0ce24f590ac075d5eda11f2d6434b303333ed6 ]

Corrects the upper range of LPF Band 4 from 18.5 GHz to 18.85 GHz per
the ADMV8818 datasheet

Fixes: f34fe888ad05 ("iio:filter:admv8818: add support for ADMV8818")
Signed-off-by: Sam Winchenbach <swinchenbach@arka.org>
Link: https://patch.msgid.link/20250328174831.227202-3-sam.winchenbach@framepointer.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/filter/admv8818.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/filter/admv8818.c b/drivers/iio/filter/admv8818.c
index d85b7d3de8660..3d8740caa1455 100644
--- a/drivers/iio/filter/admv8818.c
+++ b/drivers/iio/filter/admv8818.c
@@ -103,7 +103,7 @@ static const unsigned long long freq_range_lpf[4][2] = {
 	{2050000000ULL, 3850000000ULL},
 	{3350000000ULL, 7250000000ULL},
 	{7000000000, 13000000000},
-	{12550000000, 18500000000}
+	{12550000000, 18850000000}
 };
 
 static const struct regmap_config admv8818_regmap_config = {
-- 
2.39.5



