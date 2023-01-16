Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52FC646B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:28:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEC54C433F0;
	Mon, 16 Jan 2023 16:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673886512;
	bh=U5Mey/rQLwvtLP/hNqwdG1LV3MWIzt7O65pHqfQOdzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vJjOSl7bjSfzuRn8dJNGCEU0RnuRDgXzoUZ4d8saAVeMvJtVMvgIWpPCYAgksk0K/
	 yQPuhYPYjBv0FKu1ZxxCm1h0QpHVdj5qQuY/L8NckMhvQj/Z0cw3Aa9NC8+rKytI/P
	 8c0kOeOCYTP7nfYT6zu9KRSeGu4cZQ+XsjsI0XsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 459/658] nvme: fix the NVME_CMD_EFFECTS_CSE_MASK definition
Date: Mon, 16 Jan 2023 16:49:07 +0100
Message-Id: <20230116154930.494301155@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 685e6311637e46f3212439ce2789f8a300e5050f ]

3 << 16 does not generate the correct mask for bits 16, 17 and 18.
Use the GENMASK macro to generate the correct mask instead.

Fixes: 84fef62d135b ("nvme: check admin passthru command effects")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/nvme.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/nvme.h b/include/linux/nvme.h
index 3eca4f7d8510..ff0ee07b1e8f 100644
--- a/include/linux/nvme.h
+++ b/include/linux/nvme.h
@@ -7,6 +7,7 @@
 #ifndef _LINUX_NVME_H
 #define _LINUX_NVME_H
 
+#include <linux/bits.h>
 #include <linux/types.h>
 #include <linux/uuid.h>
 
@@ -469,7 +470,7 @@ enum {
 	NVME_CMD_EFFECTS_NCC		= 1 << 2,
 	NVME_CMD_EFFECTS_NIC		= 1 << 3,
 	NVME_CMD_EFFECTS_CCC		= 1 << 4,
-	NVME_CMD_EFFECTS_CSE_MASK	= 3 << 16,
+	NVME_CMD_EFFECTS_CSE_MASK	= GENMASK(18, 16),
 	NVME_CMD_EFFECTS_UUID_SEL	= 1 << 19,
 };
 
-- 
2.35.1



