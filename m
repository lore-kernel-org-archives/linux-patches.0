Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 802DB143C6F;
	Thu, 13 Jun 2024 11:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279023; cv=none; b=iHs+8UF5D3owNcLf2Y3sC3azS4eRdCMsx6UOl1JQ1fX0DNHbofQZOTNxUG5g88q2sjjlOKHHBK/7Fl+95500en119pQ7cTVNdvN8teNQqEGw3W0xYGXmWef0UvqGmD6m+ACkW7o5IXa4Fje9k1LV401LoipauK88ep6DUWX5sZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279023; c=relaxed/simple;
	bh=sIg4Th5rAHmTamL/WVUuZqE9W9CYeD3HLKbw5Xjqqtc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JsabVXFqHFLdjmlgbbXVAiPpnVvZ2px42/R5Jl0ZGXN6Hj6ZpugVWwyVO4N/Ps4JEP6pw9GpOOc317hmbfPfSQ3zPJZPsVm/413sJAumWQhLjk/VCWBu5VLzxhiJkBUTRhSYzvqEoK1PUymmSFUopdQKKau1Pvvrfm62HE9X0BA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R5oqJTl4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R5oqJTl4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F303AC2BBFC;
	Thu, 13 Jun 2024 11:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279023;
	bh=sIg4Th5rAHmTamL/WVUuZqE9W9CYeD3HLKbw5Xjqqtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R5oqJTl4lLwI0c3H1okBheXfnIx+WrIbWywLQS1i4cCgioEnh90W14PtGosAb70pr
	 4I+/w8g08bErMxlEpcNRaJGoiG7U0pWwmBmdro00ajNZPQLswTTO/zfnPWdkZehkXG
	 j0j7YrmDUaRDbhWGJfbuEZM8oYAKKeP/TpiCGym4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 119/213] null_blk: Fix the WARNING: modpost: missing MODULE_DESCRIPTION()
Date: Thu, 13 Jun 2024 13:32:47 +0200
Message-ID: <20240613113232.589213650@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhu Yanjun <yanjun.zhu@linux.dev>

[ Upstream commit 9e6727f824edcdb8fdd3e6e8a0862eb49546e1cd ]

No functional changes intended.

Fixes: f2298c0403b0 ("null_blk: multi queue aware block test driver")
Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Link: https://lore.kernel.org/r/20240506075538.6064-1-yanjun.zhu@linux.dev
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/null_blk_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/block/null_blk_main.c b/drivers/block/null_blk_main.c
index fb20ed1360f99..216c03913dd6d 100644
--- a/drivers/block/null_blk_main.c
+++ b/drivers/block/null_blk_main.c
@@ -1975,4 +1975,5 @@ module_init(null_init);
 module_exit(null_exit);
 
 MODULE_AUTHOR("Jens Axboe <axboe@kernel.dk>");
+MODULE_DESCRIPTION("multi queue aware block test driver");
 MODULE_LICENSE("GPL");
-- 
2.43.0



