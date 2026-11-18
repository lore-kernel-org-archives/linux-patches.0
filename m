Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020079;
	b=wwPJH8izlu03AOdcTDSCXWL+u2C5DPzGWiKllOXR8x4i+JzfdxYsTQitIMU3j6aXezve
	 vQ6rWx/8JPKul/fFPqF73OzXUGITW7jkxtDQxlkPt2iP8OwT/UcRkzhk52DbrZVqUfGoT
	 R0hKZGMkoIDR95ln6El0GpREjFCNcLWCipW9/fZ8yqj6ZHj77uPLgMi6ej3IDq/WMDZTT
	 tG7z1xzH3bPjmOL583H2f7wcbU3L5BNnWY8XEQLpMxGlvZqXGr3TvMGcL36ozE3pPrngb
	 hMVf80HzatAZ3T26EkQXNwHaBDJepMIbRu+BS2BEfisgNfMd4Gp4soMURS/hsyDmPBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020079;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Obvaq2E/gfjrTtm6XtjrGF255QBJHzoq0QtCuLBK6vI=;
	b=hOfig9kjCM6cEKY6HkTFwBFL5j48G5p6IEoY/mYUUWjzqs4irINjTDyuf3tl/EOevJ6K
	 19UwaTod8vz8+fUQS9U6jn3ZWrQo1MsHh/3UBxRGBP6Jdj0/o18oxpvL8F3q57Dw90M1Y
	 ZPqMdlJ4BM0rOH9G7quYbPTLwOlYahqKwILBQHvPkXsheq4g3YeQmtcw7FsNt05FJrK7h
	 73tOLO38liof+UNRmJoGKRLP1lEmT6tR77sXIBcP7IarSfBCC8VCT+ZYXfwGYLTOSLoid
	 uhFbyFSF3wS2OHPosimDYTm53LetwUfCKDpyzsXUZGvZnCBeYKyM4PU0Nci9WTw1NPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UuactjeX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56D07606A325;
	Wed, 18 Nov 2026 16:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UuactjeX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79F8A1F000C6;
	Wed, 18 Nov 2026 16:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020079;
	bh=Obvaq2E/gfjrTtm6XtjrGF255QBJHzoq0QtCuLBK6vI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UuactjeXz1PNFgtFmwiEZQVOKop7NJCpFDyzWxBAJp9kXFIofWRFHuMq6eviyaA8l
	 w2aveW4dQhRF31nnDRhgzVQxP5jSoitoenIh5jMPUGVKKjPXYmeOeXcyU+TISZFQP5
	 e3emJEBSy9yOR1lQhnV8gs1raRVPdhgnTQT8JwZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Jeff Chen <jeff.chen_1@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1823/2651] wifi: nxpwifi: return timeout error from nxpwifi_sdio_poll_card_status()
Date: Wed, 18 Nov 2026 15:51:03 +0100
Message-ID: <20261118150352.797857629@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit f86bc8a7421defdff701addfb66b286c13abf024 ]

nxpwifi_sdio_poll_card_status() returns the result of the last
register read when polling times out.

If the final register read succeeds, the timeout is incorrectly
reported as success.

Return -ETIMEDOUT when polling runs out of retries.

Fixes: 73b01e57ed3e ("wifi: nxp: add nxpwifi driver for IW61x")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Jeff Chen <jeff.chen_1@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/nxp/nxpwifi/sdio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/nxp/nxpwifi/sdio.c b/drivers/net/wireless/nxp/nxpwifi/sdio.c
index 8ef0f6eb49e28..a0d7196c13a2e 100644
--- a/drivers/net/wireless/nxp/nxpwifi/sdio.c
+++ b/drivers/net/wireless/nxp/nxpwifi/sdio.c
@@ -665,7 +665,7 @@ nxpwifi_sdio_poll_card_status(struct nxpwifi_adapter *adapter, u8 bits)
 
 	nxpwifi_dbg(adapter, ERROR, "poll card status failed, tries = %d\n", tries);
 
-	return ret;
+	return ret ?: -ETIMEDOUT;
 }
 
 /* Disable SDIO host interrupt and release IRQ. */
-- 
2.53.0



