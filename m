Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040604;
	b=CTKKBdyuksVq26NhSmMsncfzgUNsVUiae+ghB5tVRfvZi9qGdOWta0BUkNvjEtisDuK6
	 L8RwTaz51wqd6Gug8MQzC9hGisPcy4SonyUw8QGTc7z6nMEv0lOMK/zSBFzrPENQanHG9
	 akKoNVIG6u8/Q3/alLOh9KmCb99c3xatcxIm6uF3XQGL0BqC9KqMLhTJlphO6ejFMuBEJ
	 Xdmo/7nZlV4iI/8KSe91tL7f+mRLgVmYIiFEqfOduUipvSibWFNaUFUsZiPbo9xHwLeQe
	 Wpasn5rkD9t55nFVB/hTYkM7Mz4EMJFICyPeY2C8ViP/2FQab6w2dSyaXIULOuFeVhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040604;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qCYZRoRltOadSajQ8+jmPaArSaBqtN543bHw/ccNY7A=;
	b=bavBqgP48nVfOuKR7uSw9uiFSoWOgi7TVQffs5FP7RKXnZsKwnmMR/ctgVKvxkxwKAlj
	 UzeWl8gMLHVmlHMP72VRQzGa1cujr1jHnrD5y81Ij7v452DbdC7ozdpvf7dW3FcvW5NIy
	 AxEvNbqgkf/5Iikw9aGv4SPmqK4O537c2OGxVrxvpVmJkLFpVxHU20Xi9kp75XWGRNVR9
	 ePv4mBQ0mNvUc0d+Ci63aipjBaX1jHpqIbN+MmahUyQJ+4bRdmMCJdCalUDxn01S8OxlU
	 P8HMdBvQmXc+qJRnPm4ie+jIOnP/NmtXJcwncgZmEixNs/3RH1hflBBhXnD5gSSDJ4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D1Y2WWYb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30D23606A320;
	Wed, 18 Nov 2026 22:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D1Y2WWYb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 822131F000C4;
	Wed, 18 Nov 2026 22:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040604;
	bh=qCYZRoRltOadSajQ8+jmPaArSaBqtN543bHw/ccNY7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D1Y2WWYbqt82k7E1Wgb9didS3jUefabMRJ/HMI2d74uVpQ7Klih3JYZStegV0y3H5
	 3VyARw13OIAqLNF636ZfDtbUYSr9zbJ7aFw4ALcA47YGk74/fma54iJRKlBQWVNX+C
	 5mitjwiusUkqvsXsoion3ivMIKeDsYNyBCpVhtz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <blum@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2516/3318] hwrng: intel - return -ENOMEM when ioremap() fails
Date: Wed, 18 Nov 2026 15:52:18 +0100
Message-ID: <20261118150436.854905278@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <blum@kernel.org>

[ Upstream commit 4c3ca7c8c152278332590bfd3df1b0f086364759 ]

intel_init_hw_struct() incorrectly returns -EBUSY when ioremap() fails.
Return -ENOMEM instead.

Fixes: c24c95a085c6 ("[PATCH] fix Intel RNG detection")
Signed-off-by: Thorsten Blum <blum@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/intel-rng.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/intel-rng.c b/drivers/char/hw_random/intel-rng.c
index 94f7116e96682..789a5c709ba87 100644
--- a/drivers/char/hw_random/intel-rng.c
+++ b/drivers/char/hw_random/intel-rng.c
@@ -318,8 +318,8 @@ PFX "RNG, try using the 'no_fwh_detect' option.\n";
 	}
 
 	intel_rng_hw->mem = ioremap(INTEL_FWH_ADDR, INTEL_FWH_ADDR_LEN);
-	if (intel_rng_hw->mem == NULL)
-		return -EBUSY;
+	if (!intel_rng_hw->mem)
+		return -ENOMEM;
 
 	return 0;
 }
-- 
2.53.0



