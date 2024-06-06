Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 550C919DF79;
	Thu,  6 Jun 2024 14:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683506; cv=none; b=E4K6rU+kH3kbMJZX4AdNjB9cnGYZsjTf+Ma3dU8nnXjt2+0Z5MMdGV5sL5EzzMfvEqfEnVn8xk/a45+6a+l3R03zMY5hp15vWULw8aKXkGZhW9K5QbR0b70dvlUOSdeRg5V/T0yV6EYztNKEGM+rJ6hUger6WjQcSg0Y8efwxNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683506; c=relaxed/simple;
	bh=PrgS+GP8Ssu9JqHGM8qzQ1bbKxs1xKKbU67kKPxAcKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=njEE1NqsDgjZ5Wxg122dCh21j/b3DWX66eCOGDJKZ4Q6v59BaSH17cEe5HHb2IMwQrMgp+cDtG7C1uKvW/9inlouH/ou6h4BUioqJu4EgqvJTKRdusojCEKFUdP7dWVPQNlP1CcXvK0YkwEj/gW4EqkXlCtBjBnqhoPuy7wtNDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2acE/1TQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2acE/1TQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 245D7C4AF09;
	Thu,  6 Jun 2024 14:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683506;
	bh=PrgS+GP8Ssu9JqHGM8qzQ1bbKxs1xKKbU67kKPxAcKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2acE/1TQW1g33wUu8porWbJQvuqz4YrgD8x4VWAAHUpqAt8Gl5s+ovTQ6MzZfMrL6
	 aLk0LI7ATgN+IFIbsWRUl7s5z9spQHp3NpLfUAplpGvmhlp4a/CLJpKoX3VfjW8o/c
	 cbl2pO7x4mLGqqSvgdEcD+kuxwKUOV+bBaakfyAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 395/473] null_blk: Fix the WARNING: modpost: missing MODULE_DESCRIPTION()
Date: Thu,  6 Jun 2024 16:05:24 +0200
Message-ID: <20240606131712.889380321@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/block/null_blk/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
index b7a26a12dc656..220cedda2ca7d 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -2306,4 +2306,5 @@ module_init(null_init);
 module_exit(null_exit);
 
 MODULE_AUTHOR("Jens Axboe <axboe@kernel.dk>");
+MODULE_DESCRIPTION("multi queue aware block test driver");
 MODULE_LICENSE("GPL");
-- 
2.43.0



