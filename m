Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016491;
	b=QD2wEaycejtrdfTGPwdjSgaVyKFek4FFl0vx2c+g/JeEwNx9IwqO/LxagScJm4CWRRiC
	 W0ZSwEYYb7k+U6wjZu4YpbZoc3KcRclSqlBx1NjHSjaTJ2TtxdtMjpp1Uzac7UQtCydsa
	 U0FxLpmcAPqUB5ZNtcM+yy0jctj+UAijeLKy0SlnWKEE2OzhNM3MGGOorsKBRC5qGMiBx
	 FWfssIrL9k7YbBYJ1YwnRoYtMS8npxQvUBgO2WQ14W6PRLg16H1yP8Ef1b/TCM1g2xHIs
	 5jlM15TRG9FyjSJgaA+Mu/v3iTzwSepeZZmm7pOmU5ySHjHgc2wyYT+4f0maz7J1sxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016491;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Y8PQcyYBeVJ0GxmtRBsVv8CKPsJZD5xsgqpFg0TQbXU=;
	b=qxCcandHNQ6MSBrsdrnIuwcIj6GmMw6cdyieiYiMo6dhzxBZoT1xojsgG29ENhQM6EyZ
	 iR3lMpc2tpGvxXcP/0Sp2HsPc2RTZoZHyPgEO7b9NwccHPJynBr5gWlhyID7Wcx/hAlz8
	 BxKcWQj+pJoOmLH8PaIwVkrJ+6bYF41zfZCFNMBXOJICdmnKTrUMeRlSoO/Q2+HCgvNpM
	 VpIDDbE3Il6cOczfNCVkmiU+rGTIL4b+X8q2/1gO0pP4tXcViIgAqKozoUkSCKlqY/oBz
	 ijEbcXHdW/oFUV6UckpUeQjEPi5QdWD6vFBjtQDo+xVO6Ebv0ll/AgGKnOVNUW0UaVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RbNPhdnx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE31D606A31C;
	Wed, 18 Nov 2026 15:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RbNPhdnx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38C901F000C4;
	Wed, 18 Nov 2026 15:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016491;
	bh=Y8PQcyYBeVJ0GxmtRBsVv8CKPsJZD5xsgqpFg0TQbXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RbNPhdnxdt8xkGyoqfNaL29SyzaYYs+Mm3p7jF6tjBMvQ+zrHZtLePUr64G7bLosc
	 wTUaxPvv2wrCXGE6u10WwdjncVNvKqBWSGPAJ76wZ3DHh0CivHrkJRaU+/F3+xliBd
	 6b4g9PKPzTDzD6vEC5crk2cHisslyJ+gTkSOPxac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0547/2651] media: ivsc: Fix csi_dev use-after-free in mei_ace_setup_dev_link()
Date: Wed, 18 Nov 2026 15:29:47 +0100
Message-ID: <20261118150307.438817618@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit f9be93338c2fbaffdbda4f89045e879932e827ca ]

device_link_add() only takes a reference to the supplier when the
link is created successfully.  When it fails it returns NULL without
taking one, so the put_device(csi_dev) before the error check can
drop the last reference to csi_dev and dev_name(csi_dev) then
dereferences a freed device.

Move the put_device() below the error check and release the
reference through the existing err_put label on the failure path so
that csi_dev is no longer touched after it has been put.

Fixes: 765abb76f51f ("media: ivsc: Release csi_dev reference early in mei_ace_setup_dev_link()")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/intel/ivsc/mei_ace.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/intel/ivsc/mei_ace.c b/drivers/media/pci/intel/ivsc/mei_ace.c
index b306a320b70ff..bb57656fc85a3 100644
--- a/drivers/media/pci/intel/ivsc/mei_ace.c
+++ b/drivers/media/pci/intel/ivsc/mei_ace.c
@@ -414,13 +414,13 @@ static int mei_ace_setup_dev_link(struct mei_ace *ace)
 	/* setup link between mei_ace and mei_csi */
 	ace->csi_link = device_link_add(csi_dev, dev, DL_FLAG_PM_RUNTIME |
 					DL_FLAG_RPM_ACTIVE | DL_FLAG_STATELESS);
-	put_device(csi_dev);
 	if (!ace->csi_link) {
 		ret = -EINVAL;
 		dev_err(dev, "failed to link to %s\n", dev_name(csi_dev));
-		goto err;
+		goto err_put;
 	}
 
+	put_device(csi_dev);
 	ace->csi_dev = csi_dev;
 
 	return 0;
-- 
2.53.0



