Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1DF2308F32;
	Mon, 13 Oct 2025 14:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367509; cv=none; b=tORzrUyDgDRnCHdud8zwKaUzHZDgglbOT1QZIX4HYHWy2IZFaph5+BUEb9RtqaK5etwOHy2RStmZKxVa+8qwcVQ82MQcTPrHku8OK5dhhfEScAcDQIHBgLiN6djGwItwqrsA7CHLERMGOwbRelS/kHKcgJl9unxweOmPd89fzG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367509; c=relaxed/simple;
	bh=axFZr0YFp7MZIBUSgrMFDvkoLrfCw6+V2WSqYtRNL+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d2OnKu5qNcXgJCZ+jg8ya/uFTYtE8ILVP2Us8e/bof02wrgHvB3CVkoQgBdCz9K+ulHdp98mM0aYgJwtYOA0ThbtPrf17VoCGyk84K436jEjWgM/McLHhEqYtUGhg3EwhLyufpR0fZtBKOvcWP87dlPgVF30M6IxgEZrBAFxlXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QWEyiBEZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QWEyiBEZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C75FC4CEE7;
	Mon, 13 Oct 2025 14:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367508;
	bh=axFZr0YFp7MZIBUSgrMFDvkoLrfCw6+V2WSqYtRNL+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QWEyiBEZoroOBuHXVWocwbWWgAWFC47o9tGxSya7f4Y331yBfUic+VcW8e9+CMKLR
	 PpTgzBMV/oaQ4u4/pWscdCZB7LWEw7ZX7ThGdC0PMiWXfPHDjdsqma0KrujjdPSOay
	 LFemSFPt183VMb1ixCzRDUKwwF3U1G3WWDYm6gdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	John Garry <john.g.garry@oracle.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 029/196] block: use int to store blk_stack_limits() return value
Date: Mon, 13 Oct 2025 16:43:40 +0200
Message-ID: <20251013144316.250316076@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qianfeng Rong <rongqianfeng@vivo.com>

[ Upstream commit b0b4518c992eb5f316c6e40ff186cbb7a5009518 ]

Change the 'ret' variable in blk_stack_limits() from unsigned int to int,
as it needs to store negative value -1.

Storing the negative error codes in unsigned type, or performing equality
comparisons (e.g., ret == -1), doesn't cause an issue at runtime [1] but
can be confusing.  Additionally, assigning negative error codes to unsigned
type may trigger a GCC warning when the -Wsign-conversion flag is enabled.

No effect on runtime.

Link: https://lore.kernel.org/all/x3wogjf6vgpkisdhg3abzrx7v7zktmdnfmqeih5kosszmagqfs@oh3qxrgzkikf/ #1
Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Fixes: fe0b393f2c0a ("block: Correct handling of bottom device misaligment")
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://lore.kernel.org/r/20250902130930.68317-1-rongqianfeng@vivo.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-settings.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 021994f6d2d82..a891f27ff834d 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -553,7 +553,8 @@ static unsigned int blk_round_down_sectors(unsigned int sectors, unsigned int lb
 int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 		     sector_t start)
 {
-	unsigned int top, bottom, alignment, ret = 0;
+	unsigned int top, bottom, alignment;
+	int ret = 0;
 
 	t->max_sectors = min_not_zero(t->max_sectors, b->max_sectors);
 	t->max_hw_sectors = min_not_zero(t->max_hw_sectors, b->max_hw_sectors);
-- 
2.51.0



