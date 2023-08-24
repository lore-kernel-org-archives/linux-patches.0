Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6DA714A81
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 17:20:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 184EFC433C7;
	Thu, 24 Aug 2023 17:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692897644;
	bh=aNjAAsADs4y1GQQYcs6Q5QeCpAFcKhPplqDkgTZN10k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1M4tyeFr1qFy2RBtEiea+mIYsCh6PX/ql8Btfj+HBnn19NuMTM6V518FC66AKjsdJ
	 7YJivrPryQVJ039Tkzxaw5OjRdJ6E3RGppHvw0RFazfMJHWIUXUSq0YT6pbcYOF1ak
	 VgMKCTlf3Qy8Gb1Un2Q+JvFIIM0Ru83XCA+Nz32I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.10 112/135] mmc: wbsd: fix double mmc_free_host() in wbsd_init()
Date: Thu, 24 Aug 2023 19:09:44 +0200
Message-ID: <20230824170622.133774113@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230824170617.074557800@linuxfoundation.org>
References: <20230824170617.074557800@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

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
 


