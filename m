Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058473;
	b=qqCn0X7MvJV4jQ1qSijeUXxD47ilvo5h/3gdSpc9cN2Jh02SrTMbUYg64Qifx6bkyJwN
	 RK2iZ8GwMs5+1LgR6rM5KHGk/LFzX3U8D4bgPRjSkKPl0hpdPLTNxTJ/+9ki+mYBXNgrh
	 AuAowCKFz8SR/u2/vMUkSVA6E5ABwSTOrKJFoPpaIJ7IWiD3VOyuXgJZe2p2DTja/dGdq
	 wnghnZcHyMQbX6+m2lQk3Qek1Kt1t6UgOHYQ+nj2A19Zufgqk+eC0Mz8EJ8DpEBrxJVEX
	 ntzZLMF32P34lq6Iy5ByAWnHel3iSjY/r3aYr6BVr5cXXPjKWhuL5PrpefOs1RZuLsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058473;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ops2mLli224g1a72jExr1/u376JMa1Y/I+PjpMxa7Pk=;
	b=TtZQcF/ltElwXicMFQDXbYvSrnaJnkQgB19D9TH2vfrYjpDPEpCm+8rdrBP+N8uPGUYZ
	 UpJds5p1QuzucoaUkr5XhHuvK9z/cVBem79JHipDaliwP3991ZqICCBMj/O7d5+J7rc1b
	 m/xjO2PxYFVrPcWb1TTKnxeIVG7ZlPbjc8KExEhjNV8VfFL0Eamb+UccsO9P47aZwRMj6
	 ojDLPn/1cb4kHFcXiHAqCv93++imUtX1DpMgPZac1uGaSAcZnS5uuW+h3Srm5q5ZLcGQX
	 no6p6OafASu2OTIsu+jJtKVjr/Q1R8+ozuACe1eq7N2i0D+2cPzXTlny2z+BwqG3NpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DWrZzKHs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7C90606A333;
	Thu, 19 Nov 2026 03:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DWrZzKHs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EF941F000C4;
	Thu, 19 Nov 2026 03:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058473;
	bh=Ops2mLli224g1a72jExr1/u376JMa1Y/I+PjpMxa7Pk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DWrZzKHszdNefJRTHsjk1xzrjPYeWUUblJygzgfpF9on2/JoaigiPmYjpGuGmau5q
	 ktyudlgCc7QJgg0Lwne32tZmUOJgusUF7xAHnE/CZd+dwZ/TSKNlyw12MloTIRPHwB
	 10zOcrxn5AinjvVzyzjDCsWELfDbTS655pQwK3MY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zongmin Zhou <zhouzongmin@kylinos.cn>,
	Srinivas Kandagatla <srini@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0499/1848] slimbus: messaging: fix leaked PM vote on tid allocation failure
Date: Wed, 18 Nov 2026 15:42:17 +0100
Message-ID: <20261118145935.525784735@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zongmin Zhou <zhouzongmin@kylinos.cn>

[ Upstream commit c26cc979e28f5193310e4379e14aa6417375c565 ]

In slim_do_transfer(), when a transaction needs a tid and
slim_alloc_txn_tid() fails, the function returns directly instead of
jumping to slim_xfer_err. The runtime PM vote taken earlier with
pm_runtime_get_sync() is then never released, leaving the controller
permanently powered up.

As txn->tid is still 0 at that point, jumping to slim_xfer_err drops
the vote exactly like it is done for other failed transactions.

Fixes: d3062a2109309 ("slimbus: messaging: add slim_alloc/free_txn_tid()")
Cc: stable@vger.kernel.org
Signed-off-by: Zongmin Zhou <zhouzongmin@kylinos.cn>
Signed-off-by: Srinivas Kandagatla <srini@kernel.org>
Link: https://patch.msgid.link/20261002101448.1084691-2-srini@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/slimbus/messaging.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/slimbus/messaging.c b/drivers/slimbus/messaging.c
index c1171ec5efeb6..551d2f78a77b1 100644
--- a/drivers/slimbus/messaging.c
+++ b/drivers/slimbus/messaging.c
@@ -138,7 +138,7 @@ int slim_do_transfer(struct slim_controller *ctrl, struct slim_msg_txn *txn)
 	if (need_tid) {
 		ret = slim_alloc_txn_tid(ctrl, txn);
 		if (ret)
-			return ret;
+			goto slim_xfer_err;
 
 		if (!txn->msg->comp)
 			txn->comp = &done;
-- 
2.53.0



