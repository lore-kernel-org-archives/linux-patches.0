Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035843;
	b=TBEf2XA6YA8f21yWXbRQurb6TTfY8PDnPrqRuCICWE39vXwICAZ4p6/LaO2WfPo637Mx
	 YiPc+Tb34Tj4zxnK5dEz/rbWcf9CH0OUgZM9/d64X9UB8lBSzIdaz7ruXKQRxnEu3yhnl
	 pPmiaOfoOZyfDRsDDn335TpdFCGrGpZq/GX9RXACnnGSUuX8n12eHvd7s1P3HWOtr2CMK
	 rnYAtBuiAKLH/IeiR2fFIlSixBbgS9HPb4puuXfc9p4xktHQ3Y10CTHmTg8EdVkfkLcPH
	 QnmuECOF7/idUrCoQ4x0ryzvEIfkUoS5Xsowu/6xk0j8sUzCXvKCO6DGjzhS6/siFKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035843;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zzwmpB0HlVvZYw0vfVIk2bKZBTl40jJXUZgfXrvNFvM=;
	b=JG6K/w3zfjo+1aGxmTODIIT7QO3vBJ53wpc40cLaQpxhi9fQoZlE6zJFwdekCrTd1csQ
	 jIsHEPzju3CuCQy2g4lHtgI85sEx/iGMopgqu8/g5Xl5vHfHiIEBrObMJIYMyjIoJ5/0C
	 kvd/tNA3mpAp89UrLk8MiWTpwkBE0wHck3eMoXrzH2G7RuIrhCxNHNv+fBI/TtQTsRwGt
	 JokZNHwr+1nsHHKc9z6wiBpfzwF19ItJl0pEX9MBnOCbJGMS+BO3Cqtjz7owV1iAxL5XH
	 okMNqVDSSykCd0DNtIjZ0/1oMYdU6dBIcGPn0ygmKC9jckx8d3PBqG++y6iVBaaWUMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lfr47RMX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A1DE606A91B;
	Wed, 18 Nov 2026 21:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lfr47RMX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 200311F000CC;
	Wed, 18 Nov 2026 21:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035843;
	bh=zzwmpB0HlVvZYw0vfVIk2bKZBTl40jJXUZgfXrvNFvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lfr47RMXb/jkSIrCYIkejMOCKlKSiN2a73Se9qT+C59VHVLjRPubS6G4kA07y0bxn
	 ozZv07nzIg3mPxLkwpLaXjrT4ngf1FtIxVuvT+6owDgAJJeoGhJgiyWGgrwx/VM/Vv
	 SK+s+Nh8Ow4/MVjufDEHuFr27jwPWTL/95Sa0TeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Balakrishnan Sambath <balakrishnan.s@microchip.com>,
	Eugen Hristev <ehristev@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0848/3318] media: microchip-isc: fix PM runtime leak in AWB work handler
Date: Wed, 18 Nov 2026 15:24:30 +0100
Message-ID: <20261118150344.641453000@linuxfoundation.org>
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

From: Balakrishnan Sambath <balakrishnan.s@microchip.com>

[ Upstream commit 21ad8225822a892c4c273bf1368d477a83a19dbb ]

Early return when streaming stops skips pm_runtime_put_sync(),
leaking the reference and preventing runtime suspend.

Fixes: 314c96e5203d ("media: atmel: atmel-isc-base: use mutex to lock awb workq from streaming")
Cc: stable@vger.kernel.org
Signed-off-by: Balakrishnan Sambath <balakrishnan.s@microchip.com>
Reviewed-by: Eugen Hristev <ehristev@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/microchip/microchip-isc-base.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/microchip/microchip-isc-base.c b/drivers/media/platform/microchip/microchip-isc-base.c
index 6b79d91b643c8..8bafe1824ca15 100644
--- a/drivers/media/platform/microchip/microchip-isc-base.c
+++ b/drivers/media/platform/microchip/microchip-isc-base.c
@@ -1474,7 +1474,7 @@ static void isc_awb_work(struct work_struct *w)
 	/* streaming is not active anymore */
 	if (isc->stop) {
 		mutex_unlock(&isc->awb_mutex);
-		return;
+		goto out_pm_put;
 	}
 
 	isc_update_profile(isc);
@@ -1485,6 +1485,7 @@ static void isc_awb_work(struct work_struct *w)
 	if (ctrls->awb)
 		regmap_write(regmap, ISC_CTRLEN, ISC_CTRL_HISREQ);
 
+out_pm_put:
 	pm_runtime_put_sync(isc->dev);
 }
 
-- 
2.53.0



