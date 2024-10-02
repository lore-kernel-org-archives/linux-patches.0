Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C9BF1D0414;
	Wed,  2 Oct 2024 14:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878364; cv=none; b=OGg+CbFJFbdtFmYxGM0CdYbWCTWTUeonTYEG7ST5Em5Yld5MLDhuw65AcVStBaZygP/UOM3eKhCfOC30bCUHtSzbHIFwUlqlppFsk8/asrnBDSzLtiTkzuqCD2fj66GZTGU3ps0p5Ubkq54tJD+xavoKMgcRviIYAcBm3qCCNDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878364; c=relaxed/simple;
	bh=Q0nltm/ZCMGY2GSso9PBkbEh6cQ2zZ36LTVNvAvJklA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E5EUrVjoA1/EBNoWn7ALQXhkuWTPnglllf6ZjP17dCX02SpXvKSfStSkK8JOK6NaW5/B+meDgwsUyCPZk/BljIwsn9KPI6jkZcOpzv76hqUF4g3/8pdtW0RUlI0vGr5GBk30LM+FBM7AbUTuDDq2oRs56/dppAeqUhzkfrBn70A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RJx2ujV0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RJx2ujV0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE9AFC4CEC2;
	Wed,  2 Oct 2024 14:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878364;
	bh=Q0nltm/ZCMGY2GSso9PBkbEh6cQ2zZ36LTVNvAvJklA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RJx2ujV0i6DcX9/y3Vv7z/BxpmAyo5TA0jksPF8i1BdhlPoDafuZgXWJnBYHKyE9X
	 5aw/c6TZX/gryHqaNVMrUFjR7K6momrmfT9KUYooLPKcPBKuBsyUJ84wn4sDXxw8cl
	 DqhB5MILASN8awuCKbaPBFKOGpv0u+o/w15t1lw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Hawking <maxahawking@sonnenkinder.org>,
	Jon Mason <jdmason@kudzu.us>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 388/634] ntb_perf: Fix printk format
Date: Wed,  2 Oct 2024 14:58:08 +0200
Message-ID: <20241002125826.419347838@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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



