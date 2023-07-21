Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1425920F9D
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:19:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A081C433C8;
	Fri, 21 Jul 2023 19:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689967158;
	bh=4BKUYAv7ZlhAJgfaFLvS+ogdT2MKJSJZOmI57hMWrOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZtvY+6HzMm7jyvMMHB1zDsJDzZ3iKxtLY5pPej5rSs5uhK3t54M+iFkTN3XbLZY1k
	 wClco254JM3z2tJPpLnXY4Ox2TK/6tq0AQCxkJbfWaUgjUZPSHNrENME0D1UkzVRlW
	 7VwZTrwR0KdjPaJAEntkFFo031DyZGpWBBJLMsCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ankit Kumar <ankit.kumar@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 047/223] nvme: fix the NVME_ID_NS_NVM_STS_MASK definition
Date: Fri, 21 Jul 2023 18:05:00 +0200
Message-ID: <20230721160522.861993084@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160520.865493356@linuxfoundation.org>
References: <20230721160520.865493356@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ankit Kumar <ankit.kumar@samsung.com>

[ Upstream commit b938e6603660652dc3db66d3c915fbfed3bce21d ]

As per NVMe command set specification 1.0c Storage tag size is 7 bits.

Fixes: 4020aad85c67 ("nvme: add support for enhanced metadata")
Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/nvme.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/nvme.h b/include/linux/nvme.h
index d9fbc5afeaf72..e6fb36b71b59d 100644
--- a/include/linux/nvme.h
+++ b/include/linux/nvme.h
@@ -473,7 +473,7 @@ struct nvme_id_ns_nvm {
 };
 
 enum {
-	NVME_ID_NS_NVM_STS_MASK		= 0x3f,
+	NVME_ID_NS_NVM_STS_MASK		= 0x7f,
 	NVME_ID_NS_NVM_GUARD_SHIFT	= 7,
 	NVME_ID_NS_NVM_GUARD_MASK	= 0x3,
 };
-- 
2.39.2



