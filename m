Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058373;
	b=D2iHQvV6GwP1HoI0shfxBP7kqGHKf+fGx8XTJc+zLKOjWOJOPEmKHWdVFgAo9gtRNsRu
	 NL/HWmrN8oDZb1GW0FGtw0ysI6RECfduykmWZ9R89/7h/IJd25/gQzIay77pAvpvCRCo7
	 3kT56SuknQ1Nzntc77F9hUfIPdzrfrLWXCbMvw+g1o012G55YarU9qKAnMTLcLRJhVMei
	 cpcWcqZ8AUZjFRcbgzbaywCtx5ImQ/qllFU13LhXlr2uCVm9UoBhUR0wGrFnFT59QPnFn
	 bfgewjzIOj8KXYM96i4avBiTIoXoRIEl8Iyih1hud9996ZwwcB2RQ157rnXWbWpHzIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058373;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ARhRrvZvwp0tBltKcmgmMFsIF2zmgGJP84C3Mg81zf4=;
	b=Mwu/2wCyb1Q8BsthYczO6rmaXnDnCvePHjrDvLifJy/sy4pRDkQzjnWSjAz2h2yBoZNM
	 Dd5pu/Kva6vpxjYobVQCrziNpAPsE68SieWCUAMCtnyvdvsYbdpS3tT2bsIvUZ8e+CsVm
	 jRQWfjdZxSyoOMe1olkP4F2YcHueBZ4Pxvgle3LqD7CTOk8MdShxjrqnhS7Ao3+EWcAZ/
	 nMGJzTNa0qtLbvoplzoQ2dKRuZns7MSnvvv+nqgPvUcRvFn6WEdyI3JG0To1eiczTrbqK
	 /vIm2+TzCO/d8jC2++gC/zo8r84bCmeiGIpm5PzadDobWClma/TFoH318ODnS7LKUHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m53qqKgI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ABB8606A325;
	Thu, 19 Nov 2026 03:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m53qqKgI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C08931F000C4;
	Thu, 19 Nov 2026 03:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058373;
	bh=ARhRrvZvwp0tBltKcmgmMFsIF2zmgGJP84C3Mg81zf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m53qqKgIvzNAWqaOH5vDbRJah3bk3OvKl3F8QxU67VQ4ff0nBAj+XXTUy4jDWOJ0z
	 ZtET9Dtip8IbzbZzgl7EgOlPSwXiP+zHAYUeEbn7sCuXXrcdv3SGDvm9Hd4+AsgjvT
	 36j3wbbJCQT2cZJzv06g4+o4SHP1lRhM3iEE6mhQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <blum@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0462/1848] hwrng: ba431 - fix reported byte count
Date: Wed, 18 Nov 2026 15:41:40 +0100
Message-ID: <20261118145933.751788770@linuxfoundation.org>
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

From: Thorsten Blum <blum@kernel.org>

[ Upstream commit 7e638679883ceff5b6e7b6dcad09c21a105e941f ]

Use the size of the buffer element instead of the pointer size to report
the number of bytes read. Since data is a u32 pointer and sizeof(data)
is 8 bytes on 64-bit systems, using the pointer size reports twice the
number of bytes actually read.

Fixes: 0289e9be5dc2 ("hwrng: ba431 - add support for BA431 hwrng")
Cc: stable@vger.kernel.org
Signed-off-by: Thorsten Blum <blum@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/ba431-rng.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/ba431-rng.c b/drivers/char/hw_random/ba431-rng.c
index 410b50b05e210..d3f771d0a7916 100644
--- a/drivers/char/hw_random/ba431-rng.c
+++ b/drivers/char/hw_random/ba431-rng.c
@@ -148,7 +148,7 @@ static int ba431_trng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
 		}
 	}
 
-	n *= sizeof(data);
+	n *= sizeof(*data);
 	return (n || !wait) ? n : -EIO;
 }
 
-- 
2.53.0



