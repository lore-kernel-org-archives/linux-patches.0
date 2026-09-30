Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFF6A4E4306;
	Wed, 30 Sep 2026 16:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786312; cv=none; b=CmX6541YWPqsD6mz+C62T/x0WAvadZuJIWH9oUgZRtjN1mSJurUIwP4DKEJaB1W2oqTJ/yPo9L+LUM9zcrMwn8388N4iLsycpMdO4BSPtJqPLR0UnbuMeIiDBXHln1nmnUjrFKJHRI278eUCefNF643AtidcWO0dOqJTq6JXjog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786312; c=relaxed/simple;
	bh=2MA8YHqBzqqSv7z6oPsxL5MwhgaEih/4VNPC790SYhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T4on2VR/a7MjCoLPV5yVIi3P/6+94x6bVhYJNBZaorPf/uRd4N3fz88m8SqNxFJBWTJuGeVdWtU14MacLXjkCZDlQpuCVRrXC/R8tCYDvnLARlf+An24dLkqfGCZMimjoiNVQzCFWVMTKa/9yq9C7qI8PSgaq2wxMow+vWxMNhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EmH2g27z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EmH2g27z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F98C1F00898;
	Wed, 30 Sep 2026 16:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786310;
	bh=Hc3bE44q7PCNeAllzTlvNNECwAZLDjLYg2lCIHXg6RM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EmH2g27zSV7XnC5v50/abYK2KgXjms4ue8I5kMQ9uysftFediyqTY8/GPyifmdHWT
	 TKnQRDxE4+vynZQX4fP5dgLFSNO8vBe7pQdHvsji0G/xZV99X/KXHx7p9OPosc/tiV
	 6YwClo7zNyfEJMceY5F4AeAdfTIZOM+IRcJK/uuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sanderson@brivo.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 816/982] pinctrl: meson: Fix typo in s4 group name
Date: Wed, 30 Sep 2026 17:25:52 +0200
Message-ID: <20260930152434.288176400@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index cea77864b8808..b61d562f9a9fa 100644
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



