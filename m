Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D02C117334F;
	Wed, 17 Apr 2024 18:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713378286; cv=none; b=rGgw+LtbfCB+IX228gigWyPdxgTwL4TIlPdqMcreG4IshRJ9/i+30Zuks/PuYE08/UKombAqOtGEBQ3bhuB2syapCPqh9S0ULDOB9DW9cBPgdQKhrYzII7fy0UiY/BsGj2aKFLt0ljawSpNpl0Coi/n8wmIf8MMQcwe59CPc0b4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713378286; c=relaxed/simple;
	bh=nEun7+YsGqgETIh2CQWzBUeHv6f1xNemQ0VR5R/gRWc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=VFIEE9itKlmLepDNB5+luKyDtC5a1MgQYHg04REm/mnoZDjZAH0HPAZ8Au7rOll07S6Qm++AVKwhUv6XRo73Onj3nV8kIHaRoWY56v3mlzx7SLQptbsBNuOKBFqEZXy2GKAbT4mcf0V8Bn2vAaFC+w3VjoQZ408zTO+u7Bk4T10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hN93gTRK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hN93gTRK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A12C4C2BD11;
	Wed, 17 Apr 2024 18:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713378286;
	bh=nEun7+YsGqgETIh2CQWzBUeHv6f1xNemQ0VR5R/gRWc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=hN93gTRKrjYPCb1+0gz+eDV+wDtk1IgXCe/6TAckp2SwJHGuNISeAMjDxPep+mdlx
	 1zYjF705ARtG37EJ0CiJ0Fj8/UWP21j1P4DtBv06Yewn/kNmk9Ou66qhYlIWzxTqMy
	 IpI1Ss/saQkpjNxNpSglJVYee7aOE/VCA1Xy2k8uWvGfFEGaCveUDvEkqf57Wf7KF2
	 VV6A1iQ4E5/NV8CK1Y8F8YI7XeumEgKLvo3u7pss8H3inUb81I0oD8oITADUFpAayd
	 iGy8CqSq8VUrB9AhMXJEp0cMf+miAgkGb7BLK4/YJVA/iw3PFd895WbVp+dOOF7JcO
	 CTnAo3gbZ65yA==
From: Nathan Chancellor <nathan@kernel.org>
Date: Wed, 17 Apr 2024 11:24:37 -0700
Subject: [PATCH 3/3] s390/netiucv: Remove function pointer cast
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240417-s390-drivers-fix-cast-function-type-v1-3-fd048c9903b0@kernel.org>
References: <20240417-s390-drivers-fix-cast-function-type-v1-0-fd048c9903b0@kernel.org>
In-Reply-To: <20240417-s390-drivers-fix-cast-function-type-v1-0-fd048c9903b0@kernel.org>
To: akpm@linux-foundation.org, arnd@arndb.de, hca@linux.ibm.com, 
 gor@linux.ibm.com, agordeev@linux.ibm.com
Cc: borntraeger@linux.ibm.com, svens@linux.ibm.com, wintera@linux.ibm.com, 
 twinkler@linux.ibm.com, linux-s390@vger.kernel.org, netdev@vger.kernel.org, 
 llvm@lists.linux.dev, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.14-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1920; i=nathan@kernel.org;
 h=from:subject:message-id; bh=nEun7+YsGqgETIh2CQWzBUeHv6f1xNemQ0VR5R/gRWc=;
 b=kA0DAAoWHWsmkXHAGpYByyZiAGYgE+qh3gsFwNEnvzcg5HY8FBgtb3aYry0Nq1Q+kQmwOr4c5
 Ih1BAAWCgAdFiEEe+MlxzExnM0B2MqSHWsmkXHAGpYFAmYgE+oACgkQHWsmkXHAGpYXHgD8Daiz
 ac+yXVMKrxcZgCXYbjjlpzeCS+Mp2DM/qKhmCawBAIC6xHahD/N5BqKhdTmjVbkXV14EQ46GIwv
 zjycqkdYL
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Clang warns (or errors with CONFIG_WERROR) after enabling
-Wcast-function-type-strict by default:

  drivers/s390/net/netiucv.c:1716:18: error: cast from 'void (*)(const void *)' to 'void (*)(struct device *)' converts to incompatible function type [-Werror,-Wcast-function-type-strict]
   1716 |                 dev->release = (void (*)(struct device *))kfree;
        |                                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  1 error generated.

Add a standalone function to fix the warning properly, which addresses
the root of the warning that these casts are not safe for kCFI. The
comment is not really relevant after this change, so remove it.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/s390/net/netiucv.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/s390/net/netiucv.c b/drivers/s390/net/netiucv.c
index 8852b03f943b..11df20bfc9fa 100644
--- a/drivers/s390/net/netiucv.c
+++ b/drivers/s390/net/netiucv.c
@@ -1693,6 +1693,11 @@ static const struct attribute_group *netiucv_attr_groups[] = {
 	NULL,
 };
 
+static void netiucv_free_dev(struct device *dev)
+{
+	kfree(dev);
+}
+
 static int netiucv_register_device(struct net_device *ndev)
 {
 	struct netiucv_priv *priv = netdev_priv(ndev);
@@ -1706,14 +1711,7 @@ static int netiucv_register_device(struct net_device *ndev)
 		dev->bus = &iucv_bus;
 		dev->parent = iucv_root;
 		dev->groups = netiucv_attr_groups;
-		/*
-		 * The release function could be called after the
-		 * module has been unloaded. It's _only_ task is to
-		 * free the struct. Therefore, we specify kfree()
-		 * directly here. (Probably a little bit obfuscating
-		 * but legitime ...).
-		 */
-		dev->release = (void (*)(struct device *))kfree;
+		dev->release = netiucv_free_dev;
 		dev->driver = &netiucv_driver;
 	} else
 		return -ENOMEM;

-- 
2.44.0

