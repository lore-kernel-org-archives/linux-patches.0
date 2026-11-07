Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060704;
	b=K0CoxxbUJxewJikMevBmBYq0bP0Gi4PoNu2jlFxOj2n+unVXk4dnkjDfFEQ4SQiHMl01
	 7oPppKu1HpMZR1Al67nRVHBtUaJDuvbmj8IkBW1hzhBowKQHc40gmWJy0fke4bPyPo3w3
	 DM/J45xe1DvE2zQ5oqbH7O8PfXX2xA461yf/YcPFYMNaDEPDdlbw2P39/w1AT/5WbG76o
	 ZyxoB8WdBYQbkuEN3vB/fAhCVtar6zElUvRJqZ2QmJVaFuvipp1VxS8Bb7aLn9eI8uuIO
	 XMi4WmACis4X4YBgiZcn/UfudofEPET9f+DLgDDts5WFkw2Kv//m1/N6Hze/nFzl3bg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060704;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CUMtV2HvPWLEW09XOnPqPlwE9FxveY4tNeRuvlkLJaw=;
	b=22yzghVaKMoyQunMrbC3c6lLJDU7fBEaztMIl6jnbcSVFqV0IUiamIyQShEi6m9JVc7y
	 FrGiSzjHxnTCqgXCzpE+NxkFe+ZwjjInfAowoHhqJApbqAlFadxTRovikabmSjl7C/op7
	 8wrpqibM8PCVJ7gAdcRbedmnAZEDZd++312bWTQWcU1QKHsi3J+apCoPvPh6P6Eaeu/1Q
	 XG5cmW+nuLiYhBJZLQIZSooRGpLdadc8yAr+nUjQC3tZG5OuXwu1Kk5QSFZOcSCIgrtZK
	 hysDn6VAB18a01zAppZ4721wgK6ZUGyUnYofhN31f+MZB7xNdam2MpFpk9EW5XyAbkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BFImJTXz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C6E9606A326;
	Sat,  7 Nov 2026 14:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BFImJTXz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3616A1F0089F;
	Sat,  7 Nov 2026 14:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060704;
	bh=CUMtV2HvPWLEW09XOnPqPlwE9FxveY4tNeRuvlkLJaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BFImJTXzrLCTHu9y7kPtHQoaSa1PAl8UPog0Z7TTIbkWpsAbtcXsMQtWPYaWVgll6
	 0cOO4kawNng1fxK35mJ0xYFauhHcL0EM5R43ewpSbz6tMMQ52Yg0yp907zaZ1MzVo6
	 m33r1I6Zyyv2Oc3v+oKocl0EfFMAEcZEaq35Csp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jingyi Wang <jingyi.wang@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0133/1536] remoteproc: core: cancel crash_handler work in rproc_add() error path
Date: Sat,  7 Nov 2026 08:35:49 -0500
Message-ID: <20261107135001.425339086@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jingyi Wang <jingyi.wang@oss.qualcomm.com>

[ Upstream commit 0ec167625b4fea30b26da33c188e853ff25d5583 ]

Ensure crash_handler work is cancelled before tearing down rproc resources
to avoid accessing freed memory.

Signed-off-by: Jingyi Wang <jingyi.wang@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260623-rproc-attach-issue-v3-3-8e24310707ce@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/remoteproc_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index f412e3bf3516b..323d368d455c5 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -2359,6 +2359,7 @@ int rproc_add(struct rproc *rproc)
 	return 0;
 
 rproc_remove_dev:
+	cancel_work_sync(&rproc->crash_handler);
 	rproc_delete_debug_dir(rproc);
 	device_del(dev);
 rproc_remove_cdev:
-- 
2.53.0



