Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B96E1D0F7A;
	Wed,  2 Oct 2024 14:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880058; cv=none; b=MBAuu93Re6uN5Mf5UUFW2FBL1K7dtMwG46D1RXHHwOn6Kr/MW1zVYEUahxF0YoE26c9XF2FNRs5UFJ60S88Abm0zq8PNoiXEdDDuUHmIVbEbBJKXN8Rpg0ZxFTh8G3dOXEpVUcUBcO/85vFhJe5Do9E0WULCV6gJ4eUHjVDFrJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880058; c=relaxed/simple;
	bh=FcGZ9i0QKp6N7cXvRU9ardOXV8Oe9pTEnT2rBHZolPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ShqofUx8YFuxrpy/UblypjMEvjXUdGbD8IMDlAg18yVAspxSwnYKUXJpHp0PeR/MbiUkMAw3Kl5gWpxUxCIpDZGJJs0oKuJMHAl1bIEt9C4WpV+1ix1X4nwdaEFWf7aHGwk43rLgOMbnCNamuYguqIrf2W8iKC8FuTcWshkRyjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bW55cDfA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bW55cDfA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20897C4CEC5;
	Wed,  2 Oct 2024 14:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880058;
	bh=FcGZ9i0QKp6N7cXvRU9ardOXV8Oe9pTEnT2rBHZolPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bW55cDfAmBJwdENqsVTVfOpT8t69qrInu1KkhEbAtm3+uRqkkArGc4VRttrA8SH8k
	 eyY11YwdrTqB6ehcDD8WR1dqdK8FiNOpHeY8aY57dwo31GL1UBw5dAwVYngh709GCL
	 qf7Z5y9qZCPhL9zHQvIwZfl2XLtJGzcQi8KQ3n0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Hawking <maxahawking@sonnenkinder.org>,
	Jon Mason <jdmason@kudzu.us>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 328/538] ntb_perf: Fix printk format
Date: Wed,  2 Oct 2024 14:59:27 +0200
Message-ID: <20241002125805.377750874@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Max Hawking <maxahawking@sonnenkinder.org>

[ Upstream commit 1501ae7479c8d0f66efdbfdc9ae8d6136cefbd37 ]

The correct printk format is %pa or %pap, but not %pa[p].

Fixes: 99a06056124d ("NTB: ntb_perf: Fix address err in perf_copy_chunk")
Signed-off-by: Max Hawking <maxahawking@sonnenkinder.org>
Signed-off-by: Jon Mason <jdmason@kudzu.us>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ntb/test/ntb_perf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ntb/test/ntb_perf.c b/drivers/ntb/test/ntb_perf.c
index 553f1f46bc664..72bc1d017a46e 100644
--- a/drivers/ntb/test/ntb_perf.c
+++ b/drivers/ntb/test/ntb_perf.c
@@ -1227,7 +1227,7 @@ static ssize_t perf_dbgfs_read_info(struct file *filep, char __user *ubuf,
 			"\tOut buffer addr 0x%pK\n", peer->outbuf);
 
 		pos += scnprintf(buf + pos, buf_size - pos,
-			"\tOut buff phys addr %pa[p]\n", &peer->out_phys_addr);
+			"\tOut buff phys addr %pap\n", &peer->out_phys_addr);
 
 		pos += scnprintf(buf + pos, buf_size - pos,
 			"\tOut buffer size %pa\n", &peer->outbuf_size);
-- 
2.43.0



