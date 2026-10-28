Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213101;
	b=XVzOBtfa5f/I4nyxaLD7KgvdCfPlsNOorzRmEv6Nh+maugM1ALJAB6Uinos7rAW3xIUf
	 mf16A3QV3s0CMNGlvC9RgTUEhc5u93rsH4Wb95nsu6d4+xbg6ouK6xZ75UknlMxU/7SI3
	 ZLUNI+eP0fVmBXhtF/N4fmsB5Rwa7gkTb21BenGMlISy4MKMchGkRszcYtPjlXXPmowa0
	 JH8/tRVoK01BbopoMcJVRbX3nt3jzcLC/H5DSElZvA8vHRx0kR0m9aHPkRtbN5fP8B7IY
	 b9TyOweLQcyybqZ0RjyEi1Kev7Dv0Vu8pBdXxPxSl5dRtLURSjW2lkzizJVbgHwK0jw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213101;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YyqlF8KyaTBgH4aIxB2OpgFrwJd7X2pjXnJzpYKTD4c=;
	b=nwzGoZ+8QxS8wpLq7+xML0HNUrheAqCXb235JDJXlqIhF3MVDosMAWhBU6A9CimOiNmz
	 iLuA6ept8qQT4Noh6flgvfouCoIktqqGtcVFr9fYJ6KNLiaKKQuill1wfILhFOoJl9pR5
	 P06UAmg9cTaWEYMOvItoLv4ALib13vY66vCHMyp0BwKfKej4CkHofTeJcdE5SDZFnjyz0
	 p93LGf9M5mm/riRC2ewYZ41zwRwaybZkqBxkbpgz2TLzcRDSyyaFnL7TJnGc6kZ+6+h38
	 1A+OtyUiKZCNlkdnBqJwXQoaHKXMZ7HeUx0OPQuv7nI0ox1IaY/pLM53t3yKRLw1t6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KmTmycfp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45C2B606A321;
	Wed, 28 Oct 2026 18:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KmTmycfp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFF001F01825;
	Wed, 28 Oct 2026 18:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213101;
	bh=YyqlF8KyaTBgH4aIxB2OpgFrwJd7X2pjXnJzpYKTD4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KmTmycfppz/SxMOsgu4M4mTtEFTGTYzLDsC1DU5iV0EbyvGEtr08HnFMJtH/bEM67
	 uyGjSABlRqkxYgIPzgNPS2feyFY7bWwBdmy5Sk/IAZ++/CuwyZ/xywyA7LP2S6aAcn
	 LXTOqKJVIOpc6rZBrSWscFlQdmjmC3s1aTEucqtI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Alan Stern <stern@rowland.harvard.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0385/1887] usb: ohci-spear: Remove unnecessary NULL check before clk_disable_unprepare()
Date: Wed, 28 Oct 2026 17:41:21 +0100
Message-ID: <20261028170507.995911726@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit a891b9aebcc7406fe2f439d184bac3948fb08645 ]

clk_disable_unprepare() already checks NULL by using IS_ERR_OR_NULL.
Remove unneeded NULL check for clk here.

Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20250617042050.1930940-1-nichen@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: b1b0f8bdbbc8 ("usb: ohci-spear: disable controller wakeup on removal")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/ohci-spear.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/usb/host/ohci-spear.c b/drivers/usb/host/ohci-spear.c
index 196951a27f3f2..0f646c35ca737 100644
--- a/drivers/usb/host/ohci-spear.c
+++ b/drivers/usb/host/ohci-spear.c
@@ -104,8 +104,7 @@ static int spear_ohci_hcd_drv_remove(struct platform_device *pdev)
 	struct spear_ohci *sohci_p = to_spear_ohci(hcd);
 
 	usb_remove_hcd(hcd);
-	if (sohci_p->clk)
-		clk_disable_unprepare(sohci_p->clk);
+	clk_disable_unprepare(sohci_p->clk);
 
 	usb_put_hcd(hcd);
 	return 0;
-- 
2.53.0



