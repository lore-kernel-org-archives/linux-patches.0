Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035992;
	b=ncemPIIDmWigNzZzGPHttqmJykmGEjcvNxaPGL+smrNLU9A6AB5ic/pL5zd0MD1LNCpE
	 FUdMB7cHtPlNN8u9bu4rLgk9gXWsxrPQRGgMn5Uk7J79NryyA0w6e+d6Nkk6BKcM1rGlf
	 +etZoYKvXquVE8qhOGW8EovkacZ7lpDPMHNDd72ovUQk5SDYHlcx1CZ6S/tuSQUur5a/U
	 AliJtpHhduH5cPuz/4fsaZ9z6fp0pmruhA+1tQjWUEixerwCv6zZYZbV0PzPC8fk5K0O7
	 Y/jVRXJZwLEjp+qfI81LwsEzrCXnIOXaXvLmd8HedssFhWclCmHBAbSRp1o8EXilr6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035992;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zRiyvxcXTABwm4+G+6Fv9nopdm+vPUz4CqpYOPNEc28=;
	b=Ws7rXqDVFMujGU0CtKXhM6yJIzOfAV83OYf6p+NITZbnDqXWuGGqIMqSIpOPjVBXqq6+
	 zJvHvOwfL2Tv/Iy+d4IGZsPjlqj9xa2YPXG8ySA7WSHY8cnU2Bp2OqZEfbybj/2CL3ImC
	 8oQjPPh/4y/2LJ5l6pZtBLjf/CMpFCJ2+9q8r0XSPHKBPAgfzYwZUK/DMuCVFH3PqgrE0
	 lAL78q1uqkCoKMmeTIESKSE3ff6XG1F7K5KT13UQZ9tkoTra7MFnqakVz8HBDf0Bqr2wu
	 kOM1ONb6NcxxICVmcECh4FTBkce/fumdonVvLF+Sfk1+h18JiX5JqzAclZFmlW1DOZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=15XqntEM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C4EC60A2603;
	Wed, 18 Nov 2026 21:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=15XqntEM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE6FB1F000C4;
	Wed, 18 Nov 2026 21:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035992;
	bh=zRiyvxcXTABwm4+G+6Fv9nopdm+vPUz4CqpYOPNEc28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=15XqntEMtfZkpXJLjF49er7ldTEPTzhotPA95zasLePTMPUZLPvjBES6ezHbHuMli
	 qNg/DfD3yzGqTWa1/PuXbkFLLTFI3qCXY9fekjePJ5WPJ4cNe6q+Dw+bevfylj5CpU
	 KvzM838+O5nbMhyA0cfY79KVTMlXnCoCHOTQ7G+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0900/3318] media: ir_toy: Validate the maximum tx carrier
Date: Wed, 18 Nov 2026 15:25:22 +0100
Message-ID: <20261118150346.479740974@linuxfoundation.org>
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

From: Sean Young <sean@mess.org>

[ Upstream commit 27303392aa87b61692faadec8b00e0ca66bf98dd ]

Reject any carrier the hardware cannot generate. This also fixes
a divide by zero if a carrier of U32_MAX/16 is set.

Fixes: 8bff1386d62d ("media: ir_toy: allow tx carrier to be set")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Young <sean@mess.org>
Acked-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/ir_toy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/ir_toy.c b/drivers/media/rc/ir_toy.c
index 490de29b7ffbe..bc72ea107f49c 100644
--- a/drivers/media/rc/ir_toy.c
+++ b/drivers/media/rc/ir_toy.c
@@ -373,7 +373,7 @@ static int irtoy_tx_carrier(struct rc_dev *rc, uint32_t carrier)
 	u8 buf[3];
 	int err;
 
-	if (carrier < 11800)
+	if (carrier < 11800 || carrier > 3000000)
 		return -EINVAL;
 
 	buf[0] = 0x06;
-- 
2.53.0



