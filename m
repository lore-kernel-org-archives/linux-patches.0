Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D42FE215048;
	Thu, 12 Dec 2024 15:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016776; cv=none; b=GqAtouLYMr6q+RbkRVSvEvC14NWBZ1RcgPcqxxrKEqji/zf98ifM108qBSW3Ua8VvFxLSyLc7961lE+zNo2CVGEGSyYAyDjEVG7LMUgivMRn8oDEKefy5d4zcJmb9RGt6Fg626gInfYUzHKoDUm9AATQmXSqAjF0TNR/UcrLt+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016776; c=relaxed/simple;
	bh=P7hu3zgoa2Ca/Q01UX2xcVCE2VmnFt3sdZlHYIY0sgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QEeaIRm9MRiL+jwo+WdTprr8sCTRgGaPzYK/iF7fh2Hb5gF4njNW1ctRuiOIDDie4UmTknIJkXoGECok35BUy0NvCx2WZNIalNdPVi9AwsbygpvJ+zPJK5m/oVWj+RAKjb32DFhx5sVAMi8AaEDz1hN059telQkfE7M7lHM6OLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B9yBmIPd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B9yBmIPd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A2F9C4CECE;
	Thu, 12 Dec 2024 15:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016776;
	bh=P7hu3zgoa2Ca/Q01UX2xcVCE2VmnFt3sdZlHYIY0sgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B9yBmIPdCTNiyw9GdYbPh/tdsf5Expqs4nWuA0GQ4ScINa/IfZ4RdDzj6N4AAV5iL
	 3zGXF2tINcafZsNY3UmVzG31QJajlrrN8igT3KZuRU0NPY+CZWAHJWgWFEGYW2jcsT
	 6tSzOYqzY4VQkExppAttWZEEnGtPqHiwGaa3CaSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liao Chen <liaochen4@huawei.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 263/466] drm/bridge: it6505: Enable module autoloading
Date: Thu, 12 Dec 2024 15:57:12 +0100
Message-ID: <20241212144317.189139025@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liao Chen <liaochen4@huawei.com>

[ Upstream commit 1e2ab24cd708b1c864ff983ee1504c0a409d2f8e ]

Add MODULE_DEVICE_TABLE(), so modules could be properly autoloaded based
on the alias from of_device_id table.

Signed-off-by: Liao Chen <liaochen4@huawei.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240902113320.903147-2-liaochen4@huawei.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/ite-it6505.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/bridge/ite-it6505.c b/drivers/gpu/drm/bridge/ite-it6505.c
index 65b57de20203f..008d86cc562af 100644
--- a/drivers/gpu/drm/bridge/ite-it6505.c
+++ b/drivers/gpu/drm/bridge/ite-it6505.c
@@ -3507,6 +3507,7 @@ static const struct of_device_id it6505_of_match[] = {
 	{ .compatible = "ite,it6505" },
 	{ }
 };
+MODULE_DEVICE_TABLE(of, it6505_of_match);
 
 static struct i2c_driver it6505_i2c_driver = {
 	.driver = {
-- 
2.43.0



