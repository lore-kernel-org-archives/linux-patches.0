Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F6EA26E17F;
	Tue,  8 Apr 2025 12:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114861; cv=none; b=bzvn+uJFcDFb1wTJ9D5BV+uGT0FVS021O+O745rQFXbGGjN0wa8IIXZR85YfOnyWJm4yaKrjw4VVeC8qIpCz6nlNba7WPn2l814g+34HEmJmAk696xjcpNr9J6loWN/187ahwso/aMLvZ6FMPfffCuluJ1+hY9nCv+MDBU9mToU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114861; c=relaxed/simple;
	bh=Yk04aHctlkrfxzBequU+qkOTl4Fcb7ayFQD7qYI4p/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GYP7CJUQjU4lTyZ/iRd2dMIDkWJK2dcbzOcScux8/fRLfFblgdmm4cqwwZazGbUH3+A7xsU/AiRZGIAc3Q5bnMihkR0tUH/VdHQNos4eUvBTKThSoAdqNdpm2cyBfNXJ5rmNfKXXPrgPdPRf0Ui2CTyh28J6G8Culjvszmo87HE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PcLwhvrK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PcLwhvrK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F4126C4CEE5;
	Tue,  8 Apr 2025 12:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114861;
	bh=Yk04aHctlkrfxzBequU+qkOTl4Fcb7ayFQD7qYI4p/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PcLwhvrK7SX5d2Hm8HXyEMTFzlS/hN2xpteSSICTPxnk6ygsetwZxHeaSwvqkpsnR
	 uwiyycCXTZzXk/nPAyZQmIQ7mPaVwOkeNhJ/+sRNN9Ut/HCPajAB0qjCX3EJLIhe2a
	 3dRuXMrQkoJ/GiI33SFPCy24T0brbHtRnPDRp+0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 263/499] staging: vchiq_arm: Register debugfs after cdev
Date: Tue,  8 Apr 2025 12:47:55 +0200
Message-ID: <20250408104857.777347417@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Wahren <wahrenst@gmx.net>

[ Upstream commit 63f4dbb196db60a8536ba3d1b835d597a83f6cbb ]

The commit 2a4d15a4ae98 ("staging: vchiq: Refactor vchiq cdev code")
moved the debugfs directory creation before vchiq character device
registration. In case the latter fails, the debugfs directory won't
be cleaned up.

Fixes: 2a4d15a4ae98 ("staging: vchiq: Refactor vchiq cdev code")
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Link: https://lore.kernel.org/r/20250309125014.37166-2-wahrenst@gmx.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
index a4e83e5d619bc..e2e80e90b555b 100644
--- a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
+++ b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
@@ -1386,8 +1386,6 @@ static int vchiq_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	vchiq_debugfs_init(&mgmt->state);
-
 	dev_dbg(&pdev->dev, "arm: platform initialised - version %d (min %d)\n",
 		VCHIQ_VERSION, VCHIQ_VERSION_MIN);
 
@@ -1401,6 +1399,8 @@ static int vchiq_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	vchiq_debugfs_init(&mgmt->state);
+
 	bcm2835_audio = vchiq_device_register(&pdev->dev, "bcm2835-audio");
 	bcm2835_camera = vchiq_device_register(&pdev->dev, "bcm2835-camera");
 
-- 
2.39.5



