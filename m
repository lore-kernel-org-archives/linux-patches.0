Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4CAF362139;
	Wed, 20 May 2026 16:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295147; cv=none; b=DWTbfsYbmdUU0ZgZL7lTxu8/aK9A/cmhXQAF9WJ6AK4V5smLS51pAGizGu4X3OKfcuNXb7cfRT2tf3opgTVKW0saO6S8kGDiQgZdn5WI4fUzWdHTZYsQid5xaxBusCUabmmo9njuTR75D7/IxW/T+clXKSgbNnAhU0ohsGT5d3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295147; c=relaxed/simple;
	bh=Yn3QM6vS4lhc5WE5FQHN6E+RB3cAIX9hLRPjGq92dAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IrLQYLjJDUWahzG5zv5TITQ8Q+pgCgDUeknVP7Hi7KKcBpPilMxFHk6l4brBXhLuHMrYUTJknc1tUhPilbze/J7WvaFEzPLhSEXYqYTLVhv7vbrn9i+YzihcBOblzhbitNVgZmOYy76McXEHiHH+CfYDwWy0nqiKsQvpwH7nYv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aK5VB5dc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aK5VB5dc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE8071F000E9;
	Wed, 20 May 2026 16:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295145;
	bh=KzpV77TXBhRIz60IffAQ90BFOw5gYMPGXQsikKr4P3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aK5VB5dcnCNH2pTxMMNyH59m8K0zwEgWFt49J1qZDz2DbRtfO4xO8IzvMDspcDqYz
	 NdgCHAS8xolI4IlO9Lgh0u9gCKK8Ls3vhFDisyQgo7QJXwaA3zqAxpVH6QOQrB2rgk
	 8G7GEdfD7gbRAL9dD1MC8ATtk5a7YNbVB1WZ1myQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"haoyu.lu" <hechushiguitu666@gmail.com>,
	"Lizhi.hou" <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0309/1146] accel/amdxdna: fix missing newline in pr_err message
Date: Wed, 20 May 2026 18:09:19 +0200
Message-ID: <20260520162155.197206873@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: haoyu.lu <hechushiguitu666@gmail.com>

[ Upstream commit d1c73884858cb3ce2a0f761988a6f279bff32b91 ]

Add missing newline to pr_err message in amdxdna_mailbox.c.

Fixes: b87f920b9344 ("accel/amdxdna: Support hardware mailbox")
Signed-off-by: haoyu.lu <hechushiguitu666@gmail.com>
Reviewed-by: Lizhi.hou <lizhi.hou@amd.com>
Signed-off-by: Lizhi.hou <lizhi.hou@amd.com>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20260323034933.216-1-hechushiguitu666@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/amdxdna_mailbox.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/accel/amdxdna/amdxdna_mailbox.c b/drivers/accel/amdxdna/amdxdna_mailbox.c
index 46d844a73a948..e681a090752df 100644
--- a/drivers/accel/amdxdna/amdxdna_mailbox.c
+++ b/drivers/accel/amdxdna/amdxdna_mailbox.c
@@ -499,7 +499,7 @@ xdna_mailbox_start_channel(struct mailbox_channel *mb_chann,
 	int ret;
 
 	if (!is_power_of_2(x2i->rb_size) || !is_power_of_2(i2x->rb_size)) {
-		pr_err("Ring buf size must be power of 2");
+		pr_err("Ring buf size must be power of 2\n");
 		return -EINVAL;
 	}
 
-- 
2.53.0



