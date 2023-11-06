Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D59224D0
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vrtdqdQk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3184AC433CB;
	Mon,  6 Nov 2023 13:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699277156;
	bh=6uI5E4n6CRiUGZxgyl2jXde94FZAJVYf8Mxu6VuNEc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vrtdqdQkCiLFbAwzJlauDkzbcyBbXOBChV2AWh+G3glS2dpzEGqIsT952omiBjoXQ
	 KpnfOWy9Aif1fl9h1Q58RprglhrMh4vfctR4kadmlF8nhfSiky5L3r2lg1tnKGsPiP
	 mYrixk9JBsyxQLPstsThEzSktMgA1e5fJ4W4zjwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liam Beguin <liambeguin@gmail.com>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 056/128] iio: afe: rescale: reorder includes
Date: Mon,  6 Nov 2023 14:03:36 +0100
Message-ID: <20231106130311.644479223@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130309.112650042@linuxfoundation.org>
References: <20231106130309.112650042@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liam Beguin <liambeguin@gmail.com>

[ Upstream commit cd717ac6f69db4953ca701c6220c7cb58e17f35a ]

Includes should be ordered alphabetically which is already the case,
but follow what is done in other drivers by separation IIO specific
headers with a blank line.

Signed-off-by: Liam Beguin <liambeguin@gmail.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20220108205319.2046348-6-liambeguin@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: bee448390e51 ("iio: afe: rescale: Accept only offset channels")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/afe/iio-rescale.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/afe/iio-rescale.c b/drivers/iio/afe/iio-rescale.c
index cc28713b0dc8b..b0934f85a4a04 100644
--- a/drivers/iio/afe/iio-rescale.c
+++ b/drivers/iio/afe/iio-rescale.c
@@ -9,14 +9,15 @@
 
 #include <linux/err.h>
 #include <linux/gcd.h>
-#include <linux/iio/consumer.h>
-#include <linux/iio/iio.h>
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
 #include <linux/platform_device.h>
 #include <linux/property.h>
 
+#include <linux/iio/consumer.h>
+#include <linux/iio/iio.h>
+
 struct rescale;
 
 struct rescale_cfg {
-- 
2.42.0



