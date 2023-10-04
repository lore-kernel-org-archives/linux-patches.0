Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC19B1D68D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:14:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F052C433C8;
	Wed,  4 Oct 2023 18:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443258;
	bh=D128Sz8R+qCz9h3RDET6CDj8yts09kMSMciXmBfMQHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lT87kqo2juACdK+vbX07Y5Nu92Jb0Z83S8qfzxXLSIytJVbQAcd1ZvREqWWFKKKgh
	 WN/HLvcwrRwYw3sjYNRHr+vf6DhanVMaTvoS/2t11s9i8wPkiQ127NjmQOXzCHMmQe
	 DsOB97IIUE2w+K6YH6iJfaipvROFQ95zfVt7IoBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Scally <dan.scally@ideasonboard.com>,
	Michal Simek <michal.simek@amd.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 091/259] i2c: xiic: Correct return value check for xiic_reinit()
Date: Wed,  4 Oct 2023 19:54:24 +0200
Message-ID: <20231004175221.531603834@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175217.404851126@linuxfoundation.org>
References: <20231004175217.404851126@linuxfoundation.org>
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

From: Daniel Scally <dan.scally@ideasonboard.com>

[ Upstream commit 59851fb05d759f13662be143eff0aae605815b0e ]

The error paths for xiic_reinit() return negative values on failure
and 0 on success - this error message therefore is triggered on
_success_ rather than failure. Correct the condition so it's only
shown on failure as intended.

Fixes: 8fa9c9388053 ("i2c: xiic: return value of xiic_reinit")
Signed-off-by: Daniel Scally <dan.scally@ideasonboard.com>
Acked-by: Michal Simek <michal.simek@amd.com>
Reviewed-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-xiic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-xiic.c b/drivers/i2c/busses/i2c-xiic.c
index b41a6709e47f2..b27bfc7765993 100644
--- a/drivers/i2c/busses/i2c-xiic.c
+++ b/drivers/i2c/busses/i2c-xiic.c
@@ -420,7 +420,7 @@ static irqreturn_t xiic_process(int irq, void *dev_id)
 		 * reset the IP instead of just flush fifos
 		 */
 		ret = xiic_reinit(i2c);
-		if (!ret)
+		if (ret < 0)
 			dev_dbg(i2c->adap.dev.parent, "reinit failed\n");
 
 		if (i2c->rx_msg) {
-- 
2.40.1



