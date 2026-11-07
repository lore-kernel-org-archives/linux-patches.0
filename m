Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064593;
	b=t82YXG4H90dj9v23aeKbEUuVyjn0yeIgbPzYtwIARsO1pktKKDPLYziEDYvsZbAX0CIa
	 jsR6hPHvJLvacM4BPO5Fi+wIyxdyaDajAJaV6qBJUTZ63ooThG5dhRxUwoy1z78VhjaXO
	 B3HwpgOGT15X/jpTanEl3a9gpWsEYpE5RRdVa+FWX6NvgfXaTsQbmic4A0ATHkN1lui4T
	 0CPTd7ZFFI23G2bfFnSLVen1djJ+n5GCVVfPXPiRhHvKQEb9Ma99vfx0Og3IrNFrLrzSm
	 esaVQbZwoJpRa8AHKLfvMrkNYq+c/MbFu4MIC8ehQbDM33FP9jl3pU7s06NXXlh7wEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064593;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fxzTEvmLH20vRZU3SnyWsnKyxbA+kUn1e3k+dSk4dR0=;
	b=QVdlk27m6i0VaYUjVdHWuGo/Hc8KMjNjT3plnlai802BpCQMFkhnAPNvUBB2TM31bsGP
	 2dDvTG6tSYeV7mJfLUG3ElqtqutpDDRA2NVbcGBgNfo5QYjUUVJ7PEh7FBjWEC0bQaROf
	 2K0mt00TX1fmSDMkkDlTyUBQp6/vAVSGF+cgyHu096Eyfh1BNUbuoWjrFkFHkYP8l5G4s
	 ynGsM+ROiKjj+nXVxA3EEwJxOee0hSHVV5J/ECbT6XvCn+HmXpB45No1RxUn9V1zxhEDB
	 YUDYC7q02VpiJpE66/Ys3pMWSUIFLntoJuMsizN2IZWgmxFV7jMWDEp4NBWlAZ+aupQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lnhDjdRB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA798606A9CE;
	Sat,  7 Nov 2026 15:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lnhDjdRB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 807451F0089F;
	Sat,  7 Nov 2026 15:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064592;
	bh=fxzTEvmLH20vRZU3SnyWsnKyxbA+kUn1e3k+dSk4dR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lnhDjdRB5XopUr6vblr01I4gn8jh7AfdAYcb3/b/Akz/FcMm6MdEl9eRTVEEs6Ska
	 a0dt7r4S8gYhIfs3fhbRufXXQ3PjXHAts0s81rEKz4/Idl2FkqAfNisbr02BkwbbIc
	 B3PHRrrpyy/ybWRGSslzeRSq/cpJ5ReviigEuEh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zongmin Zhou <zhouzongmin@kylinos.cn>,
	Srinivas Kandagatla <srini@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0608/1257] slimbus: messaging: fix leaked PM vote on tid allocation failure
Date: Sat,  7 Nov 2026 08:48:24 -0500
Message-ID: <20261107134956.103881080@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index e2dbe4a66b703..ee127ef42046b 100644
--- a/drivers/slimbus/messaging.c
+++ b/drivers/slimbus/messaging.c
@@ -139,7 +139,7 @@ int slim_do_transfer(struct slim_controller *ctrl, struct slim_msg_txn *txn)
 	if (need_tid) {
 		ret = slim_alloc_txn_tid(ctrl, txn);
 		if (ret)
-			return ret;
+			goto slim_xfer_err;
 
 		if (!txn->msg->comp)
 			txn->comp = &done;
-- 
2.53.0



