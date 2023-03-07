Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A3DDBA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:25:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3638C433EF;
	Tue,  7 Mar 2023 17:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209945;
	bh=hcFT8IsqXJCj3rGjIlzW3DWcsEEmsg/ZyBSjz7ZayTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EQy96cAjgdRBu+lKmBMRegN/iy/MejKsAL5hX/atwf9ypRyWwXN3IcdvgE4YWJWBn
	 6nrONq2d1KKKzkzYk58/B6NwpgcgLnqZYbrwMUxIyh4RGNFyw0A78UrK9Q/fsgKq2I
	 xuNaBkuMfgumZW9DDhYK/xzVDK6miUfQ/jCjw52I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	farah kassabri <fkassabri@habana.ai>,
	Oded Gabbay <ogabbay@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0382/1001] habanalabs: bugs fixes in timestamps buff alloc
Date: Tue,  7 Mar 2023 17:52:34 +0100
Message-Id: <20230307170037.951615833@linuxfoundation.org>
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

From: farah kassabri <fkassabri@habana.ai>

[ Upstream commit 1693fef9e95dbe8ab767d208a02328fff13fbb94 ]

use argument instead of fixed GFP value for allocation
in Timestamps buffers alloc function.
change data type of size to size_t.

Fixes: 9158bf69e74f ("habanalabs: Timestamps buffers registration")
Signed-off-by: farah kassabri <fkassabri@habana.ai>
Reviewed-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/common/memory.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/habanalabs/common/memory.c b/drivers/misc/habanalabs/common/memory.c
index 5e9ae7600d75e..047306e33baad 100644
--- a/drivers/misc/habanalabs/common/memory.c
+++ b/drivers/misc/habanalabs/common/memory.c
@@ -2089,12 +2089,13 @@ static int hl_ts_mmap(struct hl_mmap_mem_buf *buf, struct vm_area_struct *vma, v
 static int hl_ts_alloc_buf(struct hl_mmap_mem_buf *buf, gfp_t gfp, void *args)
 {
 	struct hl_ts_buff *ts_buff = NULL;
-	u32 size, num_elements;
+	u32 num_elements;
+	size_t size;
 	void *p;
 
 	num_elements = *(u32 *)args;
 
-	ts_buff = kzalloc(sizeof(*ts_buff), GFP_KERNEL);
+	ts_buff = kzalloc(sizeof(*ts_buff), gfp);
 	if (!ts_buff)
 		return -ENOMEM;
 
-- 
2.39.2



