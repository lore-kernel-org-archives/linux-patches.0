Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E331311703
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 19:59:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63C3FC433C7;
	Mon, 21 Aug 2023 19:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692647953;
	bh=7a8AK98anMFfua3NLL8RUEamcE2sPD8UDE4T5o3pr8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o1SkIJXyfaPzh5hx/c1zQDVIWfGlv53+CHZR3gHDe38Ma/T62Iz0QYNRkoHSgfh4L
	 o75lNEKArVbi/345N9tru7CLuF7UOo78CpqTPpWWvcAEKMA8sNMbIoWGRUaSYGqeey
	 uCl6HLSuj002EA5iwET+z9eah+5xvLwtrFJ31Lyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.1 158/194] mmc: wbsd: fix double mmc_free_host() in wbsd_init()
Date: Mon, 21 Aug 2023 21:42:17 +0200
Message-ID: <20230821194129.655817446@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194122.695845670@linuxfoundation.org>
References: <20230821194122.695845670@linuxfoundation.org>
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
 


