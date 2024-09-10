Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13420198853;
	Tue, 10 Sep 2024 10:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963248; cv=none; b=hoEPfDan2e56VZOpuD22iwrcFoLxaSfD4YuB6Di4J6IHalgFEuUxdG+XKyBIPpAcngL2z5Q3qm4Kn0O4pDfItpRl3BzXEvsSSAvcWEBlvV1yn337tfAVGIvJaurMZlC/H/IKzVOzAM1mx2zt+RB4OdCZvCNwGDXa2ReSLV4Ioa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963248; c=relaxed/simple;
	bh=baw3PKk6fNYzAlutoa/kWz+6mvrHxsMuszGZ6rJb61M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AZNj2C0OHoNrkYFWPk51+/ptwPXZzsQTenQLxMiK1QSwJJnaEppw0mxwgz0NeTXm01D/tuQmLbGIlx0vxxB6b17cdgpJ1qPk9cv5+GFuQNU7tIg86ys8rkXHAtgRsUyl8rVCfk5D8rWHzAe4OnyHoC/uB0wh32HB7zc+fzv+z4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rwDAK+gA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rwDAK+gA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ED79C4CEC3;
	Tue, 10 Sep 2024 10:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963248;
	bh=baw3PKk6fNYzAlutoa/kWz+6mvrHxsMuszGZ6rJb61M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rwDAK+gAScuVqKlIjk6MpWyf7EiswXMX47FiYpFLFGRxytHqNEKe86mfNf3Akv558
	 dWU8S9EZNfalb1wI5/REcP5Ue+xZKu92+lhoikxo5clg4b77ZHYxUt4iyLyjGmwbFk
	 KqH7giKuworCKce2aiUhnSbyIONfq4FfUb2VdxM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liao Chen <liaochen4@huawei.com>,
	Michal Simek <michal.simek@amd.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 185/192] gpio: modepin: Enable module autoloading
Date: Tue, 10 Sep 2024 11:33:29 +0200
Message-ID: <20240910092605.422139661@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Liao Chen <liaochen4@huawei.com>

[ Upstream commit a5135526426df5319d5f4bcd15ae57c45a97714b ]

Add MODULE_DEVICE_TABLE(), so modules could be properly autoloaded based
on the alias from of_device_id table.

Fixes: 7687a5b0ee93 ("gpio: modepin: Add driver support for modepin GPIO controller")
Signed-off-by: Liao Chen <liaochen4@huawei.com>
Reviewed-by: Michal Simek <michal.simek@amd.com>
Link: https://lore.kernel.org/r/20240902115848.904227-1-liaochen4@huawei.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-zynqmp-modepin.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpio/gpio-zynqmp-modepin.c b/drivers/gpio/gpio-zynqmp-modepin.c
index a0d69387c153..2f3c9ebfa78d 100644
--- a/drivers/gpio/gpio-zynqmp-modepin.c
+++ b/drivers/gpio/gpio-zynqmp-modepin.c
@@ -146,6 +146,7 @@ static const struct of_device_id modepin_platform_id[] = {
 	{ .compatible = "xlnx,zynqmp-gpio-modepin", },
 	{ }
 };
+MODULE_DEVICE_TABLE(of, modepin_platform_id);
 
 static struct platform_driver modepin_platform_driver = {
 	.driver = {
-- 
2.43.0



