Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8C2A511E96;
	Wed, 30 Sep 2026 16:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786873; cv=none; b=TH6odFEB8IafnxqvrTROUGFMDQYaytosCAYBDrUwIxhBFSqAEYrfM49BOkvodKJsolCpdcp/YmPO7JahaZ20eJvFUXZq1/qjrKU+3gFpysAz9dOcxSnIBUxK1TRxLQ8+EK2Fi6UKhqXBoub0hIq3WnhOO/P3LNjOTOEAFRZajN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786873; c=relaxed/simple;
	bh=/ICoE4zy0VRkt1IZVmvTYTLq3mL2OV7In1O/MRjDyhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jycCl7FxZTrCIv5JkOCz2gXj9xzJllXBSA1IkTripLVFeVYkGO787aT1zeaTWqDc8v+kk9b4IHag4WxGwKkLJQw9MCk1xfEeiiiR4IMnilpj2+FQvhOR94VIsTHiErvTohDLMmCnpCixjBXuX1dYrgm/1NmOJo8BmSySUC1CjUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mZHjJAF5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mZHjJAF5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E0CB1F00893;
	Wed, 30 Sep 2026 16:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786872;
	bh=o6//4rD8fmwp5BdeztOZlLDF17lfC/wnrAFtzgGh8oA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mZHjJAF5U/8jmbs0oxRf1az88RrRyvIy3Ey/DvVz6O48pS9ihAR0Qj4maQxux3JjC
	 1Sw22lukkxkXlO1et1BSYuCl68i7chu9SvBLNUyT7SBCr1dxngTOwu6fHwY4eRdPIy
	 AOsFfm/7xPkvlMRjTPIhByZ72HxD/GU8hlqWR4oc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sanderson@brivo.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 032/457] pinctrl: meson: Fix typo in s4 group name
Date: Wed, 30 Sep 2026 17:22:17 +0200
Message-ID: <20260930152346.727581589@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Anderson <sanderson@brivo.com>

[ Upstream commit 692f32609a30f75ca3401e25b504bfd06bd5662a ]

One of the i2c pin groups has some junk at the end. The name should be
i2c2_scl_h1, and indeed that's the name used by i2c2_pins3 in
meson-s4.dtsi.

Fixes: 775214d389c25 ("pinctrl: meson: add pinctrl driver support for Meson-S4 Soc")
Signed-off-by: Sean Anderson <sanderson@brivo.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/meson/pinctrl-meson-s4.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/meson/pinctrl-meson-s4.c b/drivers/pinctrl/meson/pinctrl-meson-s4.c
index 872948699e9fe..365dafe457a9f 100644
--- a/drivers/pinctrl/meson/pinctrl-meson-s4.c
+++ b/drivers/pinctrl/meson/pinctrl-meson-s4.c
@@ -854,7 +854,7 @@ static const char * const i2c1_groups[] = {
 static const char * const i2c2_groups[] = {
 	"i2c2_sda_d", "i2c2_scl_d",
 	"i2c2_sda_h8", "i2c2_scl_h9",
-	"i2c2_sda_h0", "i2c2_scl_h1l,"
+	"i2c2_sda_h0", "i2c2_scl_h1",
 };
 
 static const char * const i2c3_groups[] = {
-- 
2.53.0



