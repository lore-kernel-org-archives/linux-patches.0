Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC51E1171A
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 20:10:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B8E3C433C8;
	Mon, 21 Aug 2023 20:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692648626;
	bh=7a8AK98anMFfua3NLL8RUEamcE2sPD8UDE4T5o3pr8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=scdfoHO90ogQFsM2dmwUchrpjXfWWYG03aRfHqZ+CufMyXfSz71FvidSTFrch3Slh
	 1RT48YpWqY5Sx3FZql1uCsHlAGsG3pibK3o2Z47mEwlM0yq0VAsoIaS/yhbzsBrSbc
	 wyNKEPbz/7uB/L8cz0uBcJQJvM6xmp1bAziRycVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.4 216/234] mmc: wbsd: fix double mmc_free_host() in wbsd_init()
Date: Mon, 21 Aug 2023 21:42:59 +0200
Message-ID: <20230821194138.423828380@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
References: <20230821194128.754601642@linuxfoundation.org>
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
@@ -1705,8 +1705,6 @@ static int wbsd_init(struct device *dev,
 
 		wbsd_release_resources(host);
 		wbsd_free_mmc(dev);
-
-		mmc_free_host(mmc);
 		return ret;
 	}
 


