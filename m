Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEF9F224F6;
	Mon, 23 Jun 2025 21:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714214; cv=none; b=a945p9WyByk+VhXC8+CLxuaWLkMvFDQUSR9AtNkhOXUSjc/3JdSSo5A2C+R5V1wmtLR5Jr2f9sb6Vi5F2UTmfpz0fu0le/nHP8O4VUhamyXiv2MxQNICnqVvMPAV3B/3+dLnt4cMiCR+pmNOwcxaJjAiREQ5aWhjmzDM+mC9b+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714214; c=relaxed/simple;
	bh=1HcPeYZJDVouU69ODzfJYlezdEZo4Dhlyw9doazfQhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZYY95RIZq8IRkA5HeEdC9daoAyXKlko1D6t/JtXudYDHy71U0dGWwrsAMdOkoQHNAUZKf7cIWsCPEEBY8U6hBQcqryjK/i6Z3kE/+5RZtW5lGgJAVkDJG4SitlNVtWTctTUuUn09m2uDu7wYCGXKK6NHTMFuMAkZValvBWhdCO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Csg22rsf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Csg22rsf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A75FC4CEEA;
	Mon, 23 Jun 2025 21:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714213;
	bh=1HcPeYZJDVouU69ODzfJYlezdEZo4Dhlyw9doazfQhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Csg22rsfbe1VAJcm1tL6oPDTQMkWBvtu4FamFiNqUGgmfeFZfXuAWyvvh53Y6H9yz
	 2USr3rzZ2oiGGKR8+p9mll4SDghrrq/qyN7XTj55YQUdf8/13d1LVbijIOa0WGa3ui
	 wtWZGWeIyqEScc11KrIk9AM1B1de1N5j+GfykmSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Winchenbach <swinchenbach@arka.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 158/508] iio: filter: admv8818: fix band 4, state 15
Date: Mon, 23 Jun 2025 15:03:23 +0200
Message-ID: <20250623130649.165514129@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c7f5911f9040d..a50a8ea2f8dda 100644
--- a/drivers/iio/filter/admv8818.c
+++ b/drivers/iio/filter/admv8818.c
@@ -102,7 +102,7 @@ static const unsigned long long freq_range_lpf[4][2] = {
 	{2050000000ULL, 3850000000ULL},
 	{3350000000ULL, 7250000000ULL},
 	{7000000000, 13000000000},
-	{12550000000, 18500000000}
+	{12550000000, 18850000000}
 };
 
 static const struct regmap_config admv8818_regmap_config = {
-- 
2.39.5



