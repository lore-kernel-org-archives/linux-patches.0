Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96C65133987;
	Tue, 20 Feb 2024 21:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463599; cv=none; b=aBdyqPOD77dQTJPmKbSIDYTSaWoZEN76YBTqzFimXWpwEpDBdTx83WfElCAGej+xPvRjFAZAn36rLC0irwMinkS9JqLNvKBw9tg0boeRG8XwwHfbGllIGu3XPySN93tdc6AkE8KyT5tOZR7i4JYz8Armoa3AAoAuDXEW7++XZlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463599; c=relaxed/simple;
	bh=YcMWs1nOxxd3lrFevfvHoaLZFp9OXvZP3DDBnV51cAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G3QQ56w6HzWT5fDo8v6zBVPhXqEaDPSj8IW0WgL0+w8NBKwbFEJdn3guUTakcLXbSiKO3yYbVQyPsqzgZsobCwKThoiIdigpJe35c1c7HxlFHYRhItjFC6v+Y9/4/tXMYwVCxW1DNPnbChI0F8X5rzM6hiaIlqzBg3E70xIBmqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pT8LXgi+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pT8LXgi+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93619C433F1;
	Tue, 20 Feb 2024 21:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463599;
	bh=YcMWs1nOxxd3lrFevfvHoaLZFp9OXvZP3DDBnV51cAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pT8LXgi+J56Ca4uFVncj3HrpLD7Z/ghC1BIHN7COQo8nP18ixDNIU2b3Y6UaupydY
	 c+/jb5flVn/UaryBp8HJyvjiMGna4qINli1d/lXbfQYZw1i3IaUohc2hPCbrvNEEvg
	 /NE/SW6/AnICkpfYusXdfUNJrPXQWZHETzX1tBhg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Tanislav <demonsingur@gmail.com>,
	Nuno Sa <nuno.sa@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 094/331] iio: adc: ad4130: zero-initialize clock init data
Date: Tue, 20 Feb 2024 21:53:30 +0100
Message-ID: <20240220205640.535891341@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cosmin Tanislav <demonsingur@gmail.com>

[ Upstream commit a22b0a2be69a36511cb5b37d948b651ddf7debf3 ]

The clk_init_data struct does not have all its members
initialized, causing issues when trying to expose the internal
clock on the CLK pin.

Fix this by zero-initializing the clk_init_data struct.

Fixes: 62094060cf3a ("iio: adc: ad4130: add AD4130 driver")
Signed-off-by: Cosmin Tanislav <demonsingur@gmail.com>
Reviewed-by: Nuno Sa <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20240207132007.253768-1-demonsingur@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad4130.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/adc/ad4130.c b/drivers/iio/adc/ad4130.c
index 5a5dd5e87ffc..bbdae66d1f1d 100644
--- a/drivers/iio/adc/ad4130.c
+++ b/drivers/iio/adc/ad4130.c
@@ -1826,7 +1826,7 @@ static int ad4130_setup_int_clk(struct ad4130_state *st)
 {
 	struct device *dev = &st->spi->dev;
 	struct device_node *of_node = dev_of_node(dev);
-	struct clk_init_data init;
+	struct clk_init_data init = {};
 	const char *clk_name;
 	struct clk *clk;
 	int ret;
-- 
2.43.0



