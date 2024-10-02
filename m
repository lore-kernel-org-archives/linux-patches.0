Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E98821D0799;
	Wed,  2 Oct 2024 13:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876477; cv=none; b=VA7C6kfWbqjt5zGR9LxF5kqGMof/OXcWZvurA4nh6NstRfa1iiI66LgMB98wWFPLaZPU4poPV11x8GBS0qgHGA2rCIBkR9zoyNJfl+zmEGd3IxAKakcAIIN8cS0ZKNDisM9BITftOjvywwTUJNwEr6wLILAMdlkEaaNqQzlc9Ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876477; c=relaxed/simple;
	bh=MqFKLycfPgclbMLZ77qiZN1XTyxK7X7Ev96bN4c3iY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XVNzVpqc5oTbmuD6UHYMKa9DxSeejgCUoC70kSkd3ofBG/2za/g+xVqm+MUZQqanrp8dp8ej0Zy6rkRfnhXwIps+iRzsUmhJJmWIKJKhlkm8obApARw+5nOTZPmN9zwvZR1kLxOsEXMFoRd6vIHcXWqwNn+Ks5eMs2nGqoeJn6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C7sSDXw5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C7sSDXw5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73960C4CEC5;
	Wed,  2 Oct 2024 13:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876476;
	bh=MqFKLycfPgclbMLZ77qiZN1XTyxK7X7Ev96bN4c3iY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C7sSDXw51oCPZlNs/gr9Az2TvT4RW6H/dYDVrgEmfAA0wDnAE71PKuu1KMeWCifvj
	 1h8Xrwe93T3ekdC4JzFw4UCOdyEgWok/VkjwF9yiZWdW37HjBZ2B5sG9Rm3lUA5fPE
	 HMLCOEdfPHtBqGPL4Z7aDEUeLCmreFcZ3St17IIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Hawking <maxahawking@sonnenkinder.org>,
	Jon Mason <jdmason@kudzu.us>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 426/695] ntb_perf: Fix printk format
Date: Wed,  2 Oct 2024 14:57:04 +0200
Message-ID: <20241002125839.464338655@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



