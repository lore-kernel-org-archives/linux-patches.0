Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051022;
	b=EzZcIYeoN5lCAakX42gYFtAWo7rHdpQww2a/UFlkRhzahbxOKp6oKLeFY/sUFUTZNSJG
	 mupMpS8J5DANInmQEtIQT9UXuvFnFasJB6fFQe0vd+A6O/vGke10oyGfmisRIjfBdOHXW
	 daKkprle+oOZw8m1ry7959aBpaOFh7Nl+1EUGhxYlKR+XyjecbqViOPjmfrdULvhv0L4x
	 4MMX3eWaK3jdKWm4qd96jk6vjdADsORAzSM9uB1I5El41XOB/W0qZmcAV1bhj+syEA82Q
	 zidfJLPSFwdltD4EtS3orM0XQSSEm8PY9RBY7GcZlGJeICSumJR7RLLlaK9nakghhng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051022;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=77K3LYd6t3ZZP8TZPjlXvb7SniC7I7hjnDXYlwWXO/Q=;
	b=xTstPal34DjjsGi7jWrmFVimxFnQnHlGMPgepWl01Ilz93h2M4cxY+3dfLQyGEAI/QY9
	 SBy6ooglMmPqbHXHTqeUkC7UTpgTjPPLLSb1IZaJeMZAIQ73liTsbFZD2X2fMcmOOy/7J
	 xuPv/R3+ZQeXCXeGi6zzYiWO8x3Ag3qZXsQOuwcyJWnwfgvkZlh3Io4rIGrQtAIzfSxhF
	 70uPhObVHHkRara07hUNeRs3ohfARQYJc8aMdGQri34l+fbUHi32FwcMI2Oo3Adx2ZPew
	 4fzFspmPhFznUK9xdT3ZHDrJCiaY30Z0jyMeUInwR2fG04THJPZ7ZQ73JQAptX8JJWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2bCsZZZv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A82A1606A331;
	Thu, 19 Nov 2026 01:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2bCsZZZv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 064571F000C4;
	Thu, 19 Nov 2026 01:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051022;
	bh=77K3LYd6t3ZZP8TZPjlXvb7SniC7I7hjnDXYlwWXO/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2bCsZZZvB0m6PSyHC8Mpu48wlt/YfIjxfD98uJoHjiFihib58VZ2/J1AFxCm/VRXD
	 zTQxauybtTGRoPDg3tVCKVxY1EMJXEaUq57FrucfKbKLCW7sY8At2QW4j8rA6dMrQT
	 SW9q6uNu6cGoTVpc3Ksq5+IVUn2d52My2nnfPOKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devansh Soni <devanshsoni874@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0061/2214] staging: rtl8723bs: fix missing unregister_netdev on sdio_alloc_irq failure
Date: Wed, 18 Nov 2026 15:28:57 +0100
Message-ID: <20261118150012.458127523@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Devansh Soni <devanshsoni874@gmail.com>

[ Upstream commit 51b554f1a758570159a770983c7a0ccd7c761491 ]

In rtw_drv_init(), if rtw_drv_register_netdev() succeeds but
sdio_alloc_irq() fails, the error path jumps to free_if1 and calls
rtw_sdio_if1_deinit(). However, rtw_sdio_if1_deinit() calls
rtw_free_netdev() without a preceding unregister_netdev(), freeing a
still-registered netdev but leaving stale sysfs entries behind.

Signed-off-by: Devansh Soni <devanshsoni874@gmail.com>
Link: https://patch.msgid.link/20260619125724.12458-1-devanshsoni874@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtl8723bs/os_dep/sdio_intf.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8723bs/os_dep/sdio_intf.c b/drivers/staging/rtl8723bs/os_dep/sdio_intf.c
index 3b5a6f685bce5..258f68c35dc07 100644
--- a/drivers/staging/rtl8723bs/os_dep/sdio_intf.c
+++ b/drivers/staging/rtl8723bs/os_dep/sdio_intf.c
@@ -382,11 +382,14 @@ static int rtw_drv_init(
 
 	status = sdio_alloc_irq(dvobj);
 	if (status != _SUCCESS)
-		goto free_if1;
+		goto free_netdev;
 
 	rtw_ndev_notifier_register();
 	status = _SUCCESS;
 
+free_netdev:
+	if (status != _SUCCESS)
+		rtw_unregister_netdevs(dvobj);
 free_if1:
 	if (status != _SUCCESS && if1)
 		rtw_sdio_if1_deinit(if1);
-- 
2.53.0



