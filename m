Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 102F12EA149;
	Tue, 17 Jun 2025 15:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175993; cv=none; b=Ero+pS/OWHroPpzqg7V++r2Vj4N5Nv0UyMCS3bVC73wvE3l+O16DpZlpKp9gi1SIi+jlsM/ZbBTSomhC81+INXG6mqquyPGuD0OhjMVka3l1vfOKAVk0stuekAGDSboIHyT5vC1b4856Yhe/JTgWkMlUTKnM+KTWhz0aAbW/jGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175993; c=relaxed/simple;
	bh=0j22nBOeqlt/avGRhoyD1RQJACA5qOPq4ubGrgbn4yU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sZ9CZpjShteGIyo2E0p0IFEXArwU+rotQKJDyS9KdjyPT27OKegcDYpI62UDDQorRDPcdy9M8d1XKxamCruWHfT03d+CwNieSzEVImT5dQWHHt8DsP8qQejCeLCiAa608qpdxonJhDWgF7TgURAqslfi/u55BI11HXBwoR4xDOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Iz1xDvOn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Iz1xDvOn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73D24C4CEE3;
	Tue, 17 Jun 2025 15:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175992;
	bh=0j22nBOeqlt/avGRhoyD1RQJACA5qOPq4ubGrgbn4yU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Iz1xDvOn05fiIJUvhozNO8GSL/FOHKdXiUEKxzm12ftHjNukcTn8WghWAshDWMtlY
	 mfLCRuzo5D1COowsehpArh/XKGs/8TpK659Gk2yhEcBsVnDBgg8Znz83TEpTHMH8gg
	 6a5GHLir9GyOVOYffE1X6+8UC7hyTCsUzQh0iFzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Winchenbach <swinchenbach@arka.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 233/356] iio: filter: admv8818: fix band 4, state 15
Date: Tue, 17 Jun 2025 17:25:48 +0200
Message-ID: <20250617152347.573307206@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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



