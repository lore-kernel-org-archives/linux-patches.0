Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016992;
	b=0wLaCJfqDDD79NQJf/iKtEllyVc90CowhSOtgUjHrjywGd2OQMbj5ptzsv/zSyxniEWY
	 6LJh1fCfDRj+xcH6442zSuXgczNLXFseZFLuPD9rfiFYT2AupgjtY5mMVxouopTVICh+V
	 NcNuyF+474+bBrOOlCV9Rmg499qTBnNtacQAPLdb6DOuHN4eFPTBnX4DL6eGILf827bpp
	 tbsMEkRW772RdoB9WoObpoFVeN75Ppe2aeLr5SrLVwoZb1f1UIkH9/265D7oAX8kC7u92
	 4PDmWJIQwGAALtrdlsmBhhmrLvGjgEjU+aDcGKLZHH8UpgBwwqhEX6Blm5PzMjkmPbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016992;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nTc/EWzVxGucQs5uZnSqDrtDSm2DlOGQRoDTyZDLojk=;
	b=WiCPOmVY+icmQwRKMslDmRG5ZRfq0pbNidGIDyCLc1kD947xaOBFbJIfDHK9XVkNBHh3
	 q03ESOZLPYAjW0iuBg1cHPJfY7MWI1VfcbBFXtYZxuva8+FWyq/AAeja82lRFKn0qY3Bb
	 uxLo7wX7MU1dVt+2jIgaebExmtInZAR790aMNPiu+ju06WSIF4kfOxFpXbufzFbw/Q8wP
	 wWhkPHDIHPh9/d2sncs7PAtQDXdRpWjwf6tJorR9gWEDQye6voR11SWS4i/f5wSW+xnpU
	 IjJD6rf0icIPSdvDI+BndvBuA53h8Rggy771ewHwPlVqEzqzdrkVRc6jDMBun5PidZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OOSXzz1J;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11176606A31C;
	Wed, 18 Nov 2026 15:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OOSXzz1J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 158061F000C4;
	Wed, 18 Nov 2026 15:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016991;
	bh=nTc/EWzVxGucQs5uZnSqDrtDSm2DlOGQRoDTyZDLojk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OOSXzz1JoyM/REp/phRCFsBBZRHkptIglGWSJ/5A6JzFxzLDUzwc1AB9KGClRLaQ8
	 C/d2k5TyDwFHaRLccJ1qJxOTgpbnEHB4SjnkgyExJr9L0PcpLLUZ26jVqoCkcR5pl5
	 KWa4dRaIdV33vsQQSgLHDrxd4dOFShMlzmRYEcAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0724/2651] media: staging/ipu7: release ISYS firmware resources on remove
Date: Wed, 18 Nov 2026 15:32:44 +0100
Message-ID: <20261118150313.936059541@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit 628a575c99e767d6fac81215fca1190b61867148 ]

isys_remove() tears down the registered ISYS devices but does not call
ipu7_fw_isys_release() after a successful probe. The probe error path
already uses this helper after ipu7_fw_isys_init() succeeds.

Without the matching release, resources initialized by
ipu7_fw_isys_init() remain allocated on normal device removal.

Call ipu7_fw_isys_release() after unregistering the ISYS devices to match
the cleanup performed by the probe error path.

Fixes: a516d36bdc3d ("media: staging/ipu7: add IPU7 input system device driver")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/ipu7/ipu7-isys.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/media/ipu7/ipu7-isys.c b/drivers/staging/media/ipu7/ipu7-isys.c
index 601e5a79ef8ec..a54393fbb9db6 100644
--- a/drivers/staging/media/ipu7/ipu7-isys.c
+++ b/drivers/staging/media/ipu7/ipu7-isys.c
@@ -590,6 +590,7 @@ static void isys_remove(struct auxiliary_device *auxdev)
 
 	isys_notifier_cleanup(isys);
 	isys_unregister_devices(isys);
+	ipu7_fw_isys_release(isys);
 
 	cpu_latency_qos_remove_request(&isys->pm_qos);
 
-- 
2.53.0



