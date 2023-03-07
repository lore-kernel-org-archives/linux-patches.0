Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0511BA44
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:55:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 702C7C433EF;
	Tue,  7 Mar 2023 17:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678211711;
	bh=7M9L0T+QRG74zQ5bRM7S4EarUW3h2ESkps+ret8hdQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qDo7qrYNiy22J/ZoEpsBZvUfw0XImWprudwo3pGtiDM8tVc7dh3JjhTdRa5KYtWzA
	 C0+4BsGNHBTcn+cj5VCTidoGWGY7UvTNvHVpPSYxvsfUjKv3Jy8rBNVscdAEpq55/7
	 y5zD9/DOCWNW4n/7ITeNkKPsyk0D+R6ifaU+WZSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tong Tiangen <tongtiangen@huawei.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
	Hanjun Guo <guohanjun@huawei.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.2 0951/1001] memory tier: release the new_memtier in find_create_memory_tier()
Date: Tue,  7 Mar 2023 18:02:03 +0100
Message-Id: <20230307170103.419580868@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tong Tiangen <tongtiangen@huawei.com>

commit 93419139fa14124c1c507d804f2b28866ebee28d upstream.

In find_create_memory_tier(), if failed to register device, then we should
release new_memtier from the tier list and put device instead of memtier.

Link: https://lkml.kernel.org/r/20230129040651.1329208-1-tongtiangen@huawei.com
Fixes: 9832fb87834e ("mm/demotion: expose memory tier details via sysfs")
Signed-off-by: Tong Tiangen <tongtiangen@huawei.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Hanjun Guo <guohanjun@huawei.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Guohanjun <guohanjun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memory-tiers.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memory-tiers.c
+++ b/mm/memory-tiers.c
@@ -211,8 +211,8 @@ static struct memory_tier *find_create_m
 
 	ret = device_register(&new_memtier->dev);
 	if (ret) {
-		list_del(&memtier->list);
-		put_device(&memtier->dev);
+		list_del(&new_memtier->list);
+		put_device(&new_memtier->dev);
 		return ERR_PTR(ret);
 	}
 	memtier = new_memtier;


