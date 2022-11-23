Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 794711C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:40:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8A6AC433D7;
	Wed, 23 Nov 2022 09:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669196444;
	bh=1KI/XL3dP3u5ToDBRNRYqK7q6h6denR/AjAnQMzJ4B4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yVbsFdqiBTNKfK4cs9fNf36L4EpgbG7QVpRsBcYW564XEhqATe7Lbli7NQzLLqh/b
	 NRdTSTdsKf3bDfR7S5gHmWwMI5G9kGoiBVc0BaS/Qm0k3ewt8/ucsVTIwYXokY+pc4
	 MeoQ1UtlciNG4AKgGIIioCmLVHBfCJz7RoKW8YUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 032/314] cxl/mbox: Add a check on input payload size
Date: Wed, 23 Nov 2022 09:47:57 +0100
Message-Id: <20221123084626.978485272@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit cf00b33058b196b4db928419dde68993b15a975b ]

A bug in the LSA code resulted in transfers slightly larger
than the mailbox size. Let us make it easier to catch similar
issues in future by adding a low level check.

Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Link: https://lore.kernel.org/r/20220815154044.24733-2-Jonathan.Cameron@huawei.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/mbox.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index 16176b9278b4..0c90f13870a4 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -174,7 +174,7 @@ int cxl_mbox_send_cmd(struct cxl_dev_state *cxlds, u16 opcode, void *in,
 	};
 	int rc;
 
-	if (out_size > cxlds->payload_size)
+	if (in_size > cxlds->payload_size || out_size > cxlds->payload_size)
 		return -E2BIG;
 
 	rc = cxlds->mbox_send(cxlds, &mbox_cmd);
-- 
2.35.1



