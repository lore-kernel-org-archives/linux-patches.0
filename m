Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70391FC08
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:39:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB63BC433EF;
	Mon, 15 May 2023 17:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684172390;
	bh=ojc58rMjtvQJnZH5ift4m2BaI2Ddu85cIVhMmcACl14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=asHTf1br/lIebbE24H/ii55XtAwZNcchPvdaZzZ8CZe6J93vUKGwXTVv1fAUNHnRP
	 9PMuNCovMgjjapxfPOlOJMXeVj3c8f+BtDTC963FXRn7F7G+C4v29MaB5YjpxK/V8t
	 7RokOqJJqPe9fWO8o/Wty75+9vVilwraRHmeuW/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Alexey V. Vissarionov" <gremlin@altlinux.org>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 130/381] wifi: ath6kl: minor fix for allocation size
Date: Mon, 15 May 2023 18:26:21 +0200
Message-Id: <20230515161742.702838850@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161736.775969473@linuxfoundation.org>
References: <20230515161736.775969473@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexey V. Vissarionov <gremlin@altlinux.org>

[ Upstream commit 778f83f889e7fca37780d9640fcbd0229ae38eaa ]

Although the "param" pointer occupies more or equal space compared
to "*param", the allocation size should use the size of variable
itself.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: bdcd81707973cf8a ("Add ath6kl cleaned up driver")
Signed-off-by: Alexey V. Vissarionov <gremlin@altlinux.org>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20230117110414.GC12547@altlinux.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath6kl/bmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath6kl/bmi.c b/drivers/net/wireless/ath/ath6kl/bmi.c
index bde5a10d470c8..af98e871199d3 100644
--- a/drivers/net/wireless/ath/ath6kl/bmi.c
+++ b/drivers/net/wireless/ath/ath6kl/bmi.c
@@ -246,7 +246,7 @@ int ath6kl_bmi_execute(struct ath6kl *ar, u32 addr, u32 *param)
 		return -EACCES;
 	}
 
-	size = sizeof(cid) + sizeof(addr) + sizeof(param);
+	size = sizeof(cid) + sizeof(addr) + sizeof(*param);
 	if (size > ar->bmi.max_cmd_size) {
 		WARN_ON(1);
 		return -EINVAL;
-- 
2.39.2



