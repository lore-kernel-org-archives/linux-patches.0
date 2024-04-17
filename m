Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03A8D17334F;
	Wed, 17 Apr 2024 18:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713378285; cv=none; b=RrPuqDQHJYOhsFTKoONf3KKlpdtOHMp/KAgvudCvhPKcbWPxZJsCHbHVPxT9lCiXEMigYpxW5PRHz1HDsAI5t9i1x7iO99ERv7qHbPMgCZKbf/+TKH/tkNtEWbnS8g3u3Fy1aK2cOdF6Y6RpwUd5o8KsJYWdgdKvRPzLCJ7Hbyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713378285; c=relaxed/simple;
	bh=fYkwEx2Fnvr2iiX6XX+36THAG6KdQSDvo+yNuCVygkk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Spk1NC6nlblnxlkA9zB/WLllgYCNALYsb7nZ/cWnF59t3/+V46plVVNkUusHh+frpODnLSRJqqE9a3PASQ0TBrPnRN09kZQ5F8TRRYpNyIJAteUFPUvfE7GobK95zMbN+wctOSKF6PYnSvkFxy4f8kCbFcXfIAGYAESYCJ8Iotc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CMR2uWEg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CMR2uWEg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4DAAC2BD11;
	Wed, 17 Apr 2024 18:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713378284;
	bh=fYkwEx2Fnvr2iiX6XX+36THAG6KdQSDvo+yNuCVygkk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=CMR2uWEgo4NDGIc9UsEPhCV7R4WDsr9DvuuPtbA0z7wvDzU/KlkmyqpsboU7ric6+
	 s1Kx+jcSnJTMHFfq59lrxBr+cQ5A7rd+/jm5+n2Mx2PCjQSUx3VF+8KYkS6x8JUS3N
	 jVVPIY0Htl3bUtErCaaawyQs62ovh3qr+zIsg8niLj3h9JpI87AnzH4Im/TLgG5Yk/
	 kx1eQjU+d6+SF8JwMQ/Z7TpU1OETfRH1RMIhV99/NoVIcQUqDS85WMHMPdJYx1YrqW
	 gNK4N75VBn5b/ZUs85Dp/JIaB7l/zuZpj51bbZrc6qQ7T0Utk3jsKZFDPc0JcrhbkV
	 D0t3WEoSuwLKA==
From: Nathan Chancellor <nathan@kernel.org>
Date: Wed, 17 Apr 2024 11:24:35 -0700
Subject: [PATCH 1/3] s390/vmlogrdr: Remove function pointer cast
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240417-s390-drivers-fix-cast-function-type-v1-1-fd048c9903b0@kernel.org>
References: <20240417-s390-drivers-fix-cast-function-type-v1-0-fd048c9903b0@kernel.org>
In-Reply-To: <20240417-s390-drivers-fix-cast-function-type-v1-0-fd048c9903b0@kernel.org>
To: akpm@linux-foundation.org, arnd@arndb.de, hca@linux.ibm.com, 
 gor@linux.ibm.com, agordeev@linux.ibm.com
Cc: borntraeger@linux.ibm.com, svens@linux.ibm.com, wintera@linux.ibm.com, 
 twinkler@linux.ibm.com, linux-s390@vger.kernel.org, netdev@vger.kernel.org, 
 llvm@lists.linux.dev, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.14-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1919; i=nathan@kernel.org;
 h=from:subject:message-id; bh=fYkwEx2Fnvr2iiX6XX+36THAG6KdQSDvo+yNuCVygkk=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDGkKwq98EljjvxjHLVYW3JenwOTf4epu8GfnbptM6bOcL
 4qnnZ3WUcrCIMbFICumyFL9WPW4oeGcs4w3Tk2CmcPKBDKEgYtTACayeRkjw9fVWwKVvrn0Hqzq
 VopYl23/5Fr/YaHbvh8+O3lEGU99vIXhf/njrz8q/u8NVDGS2Mx6a7t34ys2R63SO7NKzrXMYni
 0iBUA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Clang warns (or errors with CONFIG_WERROR) after enabling
-Wcast-function-type-strict by default:

  drivers/s390/char/vmlogrdr.c:746:18: error: cast from 'void (*)(const void *)' to 'void (*)(struct device *)' converts to incompatible function type [-Werror,-Wcast-function-type-strict]
    746 |                 dev->release = (void (*)(struct device *))kfree;
        |                                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  1 error generated.

Add a standalone function to fix the warning properly, which addresses
the root of the warning that these casts are not safe for kCFI. The
comment is not really relevant after this change, so remove it.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/s390/char/vmlogrdr.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/s390/char/vmlogrdr.c b/drivers/s390/char/vmlogrdr.c
index d7e408c8d0b8..8f90f58b680a 100644
--- a/drivers/s390/char/vmlogrdr.c
+++ b/drivers/s390/char/vmlogrdr.c
@@ -722,6 +722,10 @@ static void vmlogrdr_unregister_driver(void)
 	iucv_unregister(&vmlogrdr_iucv_handler, 1);
 }
 
+static void vmlogrdr_free_dev(struct device *dev)
+{
+	kfree(dev);
+}
 
 static int vmlogrdr_register_device(struct vmlogrdr_priv_t *priv)
 {
@@ -736,14 +740,7 @@ static int vmlogrdr_register_device(struct vmlogrdr_priv_t *priv)
 		dev->driver = &vmlogrdr_driver;
 		dev->groups = vmlogrdr_attr_groups;
 		dev_set_drvdata(dev, priv);
-		/*
-		 * The release function could be called after the
-		 * module has been unloaded. It's _only_ task is to
-		 * free the struct. Therefore, we specify kfree()
-		 * directly here. (Probably a little bit obfuscating
-		 * but legitime ...).
-		 */
-		dev->release = (void (*)(struct device *))kfree;
+		dev->release = vmlogrdr_free_dev;
 	} else
 		return -ENOMEM;
 	ret = device_register(dev);

-- 
2.44.0

