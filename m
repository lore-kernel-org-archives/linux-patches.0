Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 011287B
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 08:55:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61CB1C433D6;
	Wed, 23 Nov 2022 08:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669193717;
	bh=BUm0QnloEu5jTmCS/qr9CvSCsce7s8EsWk/BKN/eiN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RCccc3vbm0rMh7gUujN9QsDW50CuqvHF88B54fzFQJLXz4zhUSQcl39YNbvCn5caZ
	 Vw+jHigrofXjJVsQDKdURtgKArs5kBzUPN7xluDhOZFn3++9UODJD3BwjzbDGvzJCa
	 PcIDFevMzcu1gUDIQiEC2xFNV+4mc5QwAjSmZcn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang ShaoBo <bobo.shaobowang@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 41/76] mISDN: fix misuse of put_device() in mISDN_register_device()
Date: Wed, 23 Nov 2022 09:50:40 +0100
Message-Id: <20221123084548.082137362@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084546.742331901@linuxfoundation.org>
References: <20221123084546.742331901@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wang ShaoBo <bobo.shaobowang@huawei.com>

[ Upstream commit 2d25107e111a85c56f601a5470f1780ec054e6ac ]

We should not release reference by put_device() before calling device_initialize().

Fixes: e7d1d4d9ac0d ("mISDN: fix possible memory leak in mISDN_register_device()")
Signed-off-by: Wang ShaoBo <bobo.shaobowang@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/isdn/mISDN/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/isdn/mISDN/core.c b/drivers/isdn/mISDN/core.c
index 5cd53b2c47c7..e542439f4950 100644
--- a/drivers/isdn/mISDN/core.c
+++ b/drivers/isdn/mISDN/core.c
@@ -231,7 +231,7 @@ mISDN_register_device(struct mISDNdevice *dev,
 
 	err = get_free_devid();
 	if (err < 0)
-		goto error1;
+		return err;
 	dev->id = err;
 
 	device_initialize(&dev->dev);
-- 
2.35.1



