Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66940D512
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:34:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D642EC433D2;
	Mon, 15 May 2023 16:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684168460;
	bh=l9ihL4LLSdP9ilZPWjq3E58wqc+k9I3wi/q0FWPZEjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dRtOUDGbtZc5oBydlf0yqL63DYGKKXbNg3OCb4+w31hDtO8HcRfs24XUGH+YMN9r1
	 VcEJbWEL05WOQuVslxOK0FwJlC54EsII9uTFgXXW1YTC1kIfNTN8LRMknWNWDMQdnh
	 wwOp7f1RvcCWya4bK9hk2x6QwpJue+Ay0zShC6Tk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Alexey V. Vissarionov" <gremlin@altlinux.org>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 027/116] wifi: ath6kl: minor fix for allocation size
Date: Mon, 15 May 2023 18:25:24 +0200
Message-Id: <20230515161659.179124029@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161658.228491273@linuxfoundation.org>
References: <20230515161658.228491273@linuxfoundation.org>
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
index 334dbd834b3a6..8380ee76bdde7 100644
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



