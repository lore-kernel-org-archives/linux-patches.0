Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5127744C6F;
	Thu, 13 Jun 2024 12:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281354; cv=none; b=lZpEGJrCu8P68PnrzJpG2rhnwEZ/QK3ywVWq+NqUHRN28tIRPHCs8tqc4gLlTEjiKqqVGmAhu4cjoGBYSis5jqzEcYnlV/lnvDe5lWeuohusg61HcY+yHatXcQgZHSzi6upoiS5St9TkHHhG7EjCzx/Dxi+dwbryPaMHwSs1i7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281354; c=relaxed/simple;
	bh=OQtA2uPmxjpf02clBF6BB5oBypDEWkjRC1VblbI75w8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RCryjr7I5W5iENJnprzLncHrmMSMXN1aGf39CP9KjtymSajP9bqVBn63+lFEdjrEgkSfDKYht1O5Txm/QQvFFPQ4xSXM+xMVSG4t0Fao43snQ7h40l9iG3Ti40TbTuciknX6RZ4vtEukeWkIBARD/rRZ/cCT3Uo1EtdxwjmvAos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OYowfwmF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OYowfwmF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC904C2BBFC;
	Thu, 13 Jun 2024 12:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281354;
	bh=OQtA2uPmxjpf02clBF6BB5oBypDEWkjRC1VblbI75w8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OYowfwmF1tUSzrCTTfUvoCLZg/3t0tKLbubC1XCoHiEympvUbms1rsLRvuw9KMnbB
	 fmcd8+0d29DAyX5yP+HKQD3B3HAE21tGhrTn1SHwRQjJL8CbcJ15TfDo62pgWfzIl0
	 eUyncXFaduTGsh6lx+SA1KGP/iKdoCqhTzdHBCDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 225/317] null_blk: Fix the WARNING: modpost: missing MODULE_DESCRIPTION()
Date: Thu, 13 Jun 2024 13:34:03 +0200
Message-ID: <20240613113256.256595963@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index ee1c3f476a3a0..862a9420df526 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -2040,4 +2040,5 @@ module_init(null_init);
 module_exit(null_exit);
 
 MODULE_AUTHOR("Jens Axboe <axboe@kernel.dk>");
+MODULE_DESCRIPTION("multi queue aware block test driver");
 MODULE_LICENSE("GPL");
-- 
2.43.0



