Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D027D173343;
	Wed, 17 Apr 2024 18:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713378286; cv=none; b=N8YocnjkZP40ESCLBpP48EilfU9lnK07pP9zqJQOzC9hiOSTta/V4pYT4rxU8BSP8v27GOxsNt/27WGzEtSMMjUW/FqPGaI1131ZML9tarv0+DFSJc+G3spJw88UruPrShy+LMkOm0oSa7NkOPLWSRXHiN2C+feBxPwy38ioMOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713378286; c=relaxed/simple;
	bh=/LatZDnAc+vgqE3L8FVtiqj1mUYyLWoT1eujxn6J/Io=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=vA2N++bk6L0xlA9elfUSjdopHsJQCEvMJiJvED+oNGZtVS1jFXNINRNOyyaFB/Rze2SY+0xjAJ6zZvnOuwJdmtumrQeqt7FMMBOJO98g3h5v4maSqQobd+447XK3ocD2wttFOmeHPV3HtZL1x0E8kPoM6P7evD6JgN88pJYdAUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o43CVmIh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o43CVmIh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2426C4AF07;
	Wed, 17 Apr 2024 18:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713378285;
	bh=/LatZDnAc+vgqE3L8FVtiqj1mUYyLWoT1eujxn6J/Io=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=o43CVmIhb4mu6BTBhKQzMgxVTtYuPRgnWi2vqDLJjd+cxqGro7g+uHa2yfInWaVvE
	 MU398yDtsheKFcAG+ciRCJSXugKHz+A5thSULSohsOBevU6Xu00pHP50OrwLuT/Si+
	 bPGrayteP4D2ftW9/5QP2S/YCIdFcxZsXfdfb4hX1p7qJMnj+w9nuLYMsj1RRvtVnr
	 e5gX5HPf1Jc/i4cPzX+/F+wCTNPwpkl442zslgBVJ+P26onLPTQGKqKFDKvoSfggJb
	 m8eywcyIJYdD4N9S6vKuvjXFhKkxmyH61k0pfKD87bINvCYdk0DutIltUkSjlI0A38
	 QyLpB0nD7dcag==
From: Nathan Chancellor <nathan@kernel.org>
Date: Wed, 17 Apr 2024 11:24:36 -0700
Subject: [PATCH 2/3] s390/smsgiucv_app: Remove function pointer cast
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240417-s390-drivers-fix-cast-function-type-v1-2-fd048c9903b0@kernel.org>
References: <20240417-s390-drivers-fix-cast-function-type-v1-0-fd048c9903b0@kernel.org>
In-Reply-To: <20240417-s390-drivers-fix-cast-function-type-v1-0-fd048c9903b0@kernel.org>
To: akpm@linux-foundation.org, arnd@arndb.de, hca@linux.ibm.com, 
 gor@linux.ibm.com, agordeev@linux.ibm.com
Cc: borntraeger@linux.ibm.com, svens@linux.ibm.com, wintera@linux.ibm.com, 
 twinkler@linux.ibm.com, linux-s390@vger.kernel.org, netdev@vger.kernel.org, 
 llvm@lists.linux.dev, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.14-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1603; i=nathan@kernel.org;
 h=from:subject:message-id; bh=/LatZDnAc+vgqE3L8FVtiqj1mUYyLWoT1eujxn6J/Io=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDGkKwq/8JR74rIyNuFo/N062rmOee031q4meZu9+n2v3V
 z9ytSeso5SFQYyLQVZMkaX6sepxQ8M5ZxlvnJoEM4eVCWQIAxenAEzkyVeGf7YejyfdXZi8T12H
 Te7+vB13pPQcdjW/1eCuWrv8EBPbq++MDIs0Vuh71W2/8FnoZ9GbOxWuzCG2kf6cs95cjvPjP7k
 1gRUA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Clang warns (or errors with CONFIG_WERROR) after enabling
-Wcast-function-type-strict by default:

  drivers/s390/net/smsgiucv_app.c:176:26: error: cast from 'void (*)(const void *)' to 'void (*)(struct device *)' converts to incompatible function type [-Werror,-Wcast-function-type-strict]
    176 |         smsg_app_dev->release = (void (*)(struct device *)) kfree;
        |                                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  1 error generated.

Add a standalone function to fix the warning properly, which addresses
the root of the warning that these casts are not safe for kCFI.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/s390/net/smsgiucv_app.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/net/smsgiucv_app.c b/drivers/s390/net/smsgiucv_app.c
index 0a263999f7ae..390aba4ef7ad 100644
--- a/drivers/s390/net/smsgiucv_app.c
+++ b/drivers/s390/net/smsgiucv_app.c
@@ -64,6 +64,11 @@ static void smsg_app_event_free(struct smsg_app_event *ev)
 	kfree(ev);
 }
 
+static void smsg_app_free_dev(struct device *dev)
+{
+	kfree(dev);
+}
+
 static struct smsg_app_event *smsg_app_event_alloc(const char *from,
 						   const char *msg)
 {
@@ -173,7 +178,7 @@ static int __init smsgiucv_app_init(void)
 	}
 	smsg_app_dev->bus = &iucv_bus;
 	smsg_app_dev->parent = iucv_root;
-	smsg_app_dev->release = (void (*)(struct device *)) kfree;
+	smsg_app_dev->release = smsg_app_free_dev;
 	smsg_app_dev->driver = smsgiucv_drv;
 	rc = device_register(smsg_app_dev);
 	if (rc) {

-- 
2.44.0

