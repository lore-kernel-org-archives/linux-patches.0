Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F596125AE
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 15:02:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E34E0C433C8;
	Thu, 24 Aug 2023 15:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692889372;
	bh=iO4Q/2DFLRWJ9ys6mDfOIWpa6XxkSQ/ikEl6BqCL7PY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KY0LV1A0CIxOb/TZxdKRWMPb/8n+7sAJuGn5F2UJuXhxziFeBcDix7l9Aj4qMW3i8
	 rHZ1xSbAg29SMh92kfi61h9wSdvU010m6Sz/LEt1UCGxOjTik6NljO6ME+vrco3IJs
	 i6xN7qVybjNM00dmNr2r3HS1DKXaaAdkqxVjKbac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.10 112/135] mmc: wbsd: fix double mmc_free_host() in wbsd_init()
Date: Thu, 24 Aug 2023 16:50:55 +0200
Message-ID: <20230824145031.795448135@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230824145027.008282920@linuxfoundation.org>
References: <20230824145027.008282920@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Yingliang <yangyingliang@huawei.com>

commit d83035433701919ac6db15f7737cbf554c36c1a6 upstream.

mmc_free_host() has already be called in wbsd_free_mmc(),
remove the mmc_free_host() in error path in wbsd_init().

Fixes: dc5b9b50fc9d ("mmc: wbsd: fix return value check of mmc_add_host()")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230807124443.3431366-1-yangyingliang@huawei.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/wbsd.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/mmc/host/wbsd.c
+++ b/drivers/mmc/host/wbsd.c
@@ -1710,8 +1710,6 @@ static int wbsd_init(struct device *dev,
 
 		wbsd_release_resources(host);
 		wbsd_free_mmc(dev);
-
-		mmc_free_host(mmc);
 		return ret;
 	}
 


