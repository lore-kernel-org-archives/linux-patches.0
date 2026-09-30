Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73CF84CC63A;
	Wed, 30 Sep 2026 18:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792787; cv=none; b=VP0r7//DMRktD9okRewrbiFnAWppoq4CdN7v+ughLZtShBOIpClKF5K3B1O1zyYbpVMOQndV0uckKgfHnTzcZuJqEV0kq9SNdFFKB5Qh/k2siR/52hKuzXQXrWCyVplIbKl3SflyoqANlLlMrGqomoyByma7x+I7JXApQWHThOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792787; c=relaxed/simple;
	bh=9JQxb0qV1JD+fIoOwszHpbbZ+YzioEOvsz1rMCgThdc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Er4J7A39x9qkVffrnlJwY3k2owtxNhluuSp7VZcEMAI+BbvI/7wwnKzWO43rE0oyuhUo2ATfjFa647nrdwTL8qDNMobHh6P9hNMhfE2F6cUPY/jgvl5NjYujTearFt0WoIRBJjbRmDJ6P469ku6uRzq3SxcDBA5ivmRKCJLpFkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XVxWhQlu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XVxWhQlu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE3E71F000FF;
	Wed, 30 Sep 2026 18:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792786;
	bh=nOs9MySVrtexjr/M/cbcch2nycEmG+OMO2cIJrCw5hI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XVxWhQlulWizQpGmZ4q0WoZcSzTOQQcyh3xis9vyrCMjA15Bo4q9wB5BuG4D5nXs7
	 smhE9hQyrGsZNkjSlby8wkzqKzYsasuQFkEu3BrP93VCcxFBQej38uDqt48OHyKL9f
	 gA+WbsKQZNIkIqX6Yclt3o82SS55Sgv1/vZLTmnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sanderson@brivo.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 025/395] pinctrl: meson: Fix typo in s4 group name
Date: Wed, 30 Sep 2026 17:24:47 +0200
Message-ID: <20260930152341.164455328@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



