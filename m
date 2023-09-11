Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D4CE1170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:19:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFFC5C433C8;
	Mon, 11 Sep 2023 14:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441994;
	bh=QO2s9s/mpykLteIBYl3nm1HO8kTYHsaZKNH7uqGOP/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IjviTvm11WN4+VO2LfZmf01mHXk8Bzdis9zTQ8lIKgCgQPfP+xGI6/2T4i9EdIv3e
	 x6/6439UA2WUIY7gtO5uHW7CWZDOVvJWfgAsjGwGy8FjNnPfKFr5ByC7s7cz3C1CcA
	 zP7RO80R2z+Ec96d/W7EFd4fmAVuWyJ0q3wvNvAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Michael Walle <michael@walle.cc>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 582/739] nvmem: core: Return NULL when no nvmem layout is found
Date: Mon, 11 Sep 2023 15:46:21 +0200
Message-ID: <20230911134707.362381398@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit 81e1d9a39569d315f747c2af19ce502cd08645ed ]

Currently, of_nvmem_layout_get_container() returns NULL on error, or an
error pointer if either CONFIG_NVMEM or CONFIG_OF is turned off. We
should likely avoid this kind of mix for two reasons: to clarify the
intend and anyway fix the !CONFIG_OF which will likely always if we use
this helper somewhere else. Let's just return NULL when no layout is
found, we don't need an error value here.

Link: https://staticthinking.wordpress.com/2022/08/01/mixing-error-pointers-and-null/
Fixes: 266570f496b9 ("nvmem: core: introduce NVMEM layouts")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202308030002.DnSFOrMB-lkp@intel.com/
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Reviewed-by: Michael Walle <michael@walle.cc>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20230823132744.350618-21-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/nvmem-consumer.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/nvmem-consumer.h b/include/linux/nvmem-consumer.h
index fa030d93b768e..27373024856dc 100644
--- a/include/linux/nvmem-consumer.h
+++ b/include/linux/nvmem-consumer.h
@@ -256,7 +256,7 @@ static inline struct nvmem_device *of_nvmem_device_get(struct device_node *np,
 static inline struct device_node *
 of_nvmem_layout_get_container(struct nvmem_device *nvmem)
 {
-	return ERR_PTR(-EOPNOTSUPP);
+	return NULL;
 }
 #endif /* CONFIG_NVMEM && CONFIG_OF */
 
-- 
2.40.1



