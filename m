Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C4E64F5DE6;
	Thu, 17 Sep 2026 17:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665725; cv=none; b=T6/QK3q68+7FD0e9Bbf93VVjtmfRkCJTXdtiiqs4Kaa2vGrdfahDGmfs7GpXCnUL7EEtgqSLOacsn8/LMhjZx8PhP/sR6uHSFdHl560l0zc9WY7IC6b67Z60SpHIYQOJJnQRYmtntDLQCwLESZwsGNbJi3DqvCOPEr+7MeVUBNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665725; c=relaxed/simple;
	bh=USmbzBR3YoGdXO5v1/OszSW9WtJ6JFVDxPLboddPB0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=avVFgehasQkUpm1BeCxs1QmfPIEZna6y1Aevsq+emGfYuqQkWQXLiKKYuoFPix06Wo2mr3O/kBdg5+91h0qvU/+cPfIfkCuWVkpxU4bY/DyZNaCJxfiJkkwHG9Eqc+c5GkvDIzxXEy2VX9lVAIO1icZHpYDwiADYI5ftK7DZDWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ADovpkly; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ADovpkly"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D47951F000FF;
	Thu, 17 Sep 2026 17:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665723;
	bh=G45pLO1HXaNViyLAw8HUSjOVM+TLsCHD+B8d7O30Lho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ADovpklyqB+SW8roSMn9LNYN94WW6/oRgBaTtVmXm1BBBzX/qcx68Rsmo0vgH9C1P
	 vJAUgc7NLTxmEiy1hAzImBM3i9ApjE1F8Jr5VxoULQ4HhgLiu94080Eps6nbL7pc52
	 ufVrpZMiSODFOTSVAU6IcryeUmc1dixPiWfJYrN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jori Koolstra <jkoolstra@xs4all.nl>,
	Alexandra Winter <wintera@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0799/1250] dibs: change dibs_class to a const struct
Date: Thu, 17 Sep 2026 16:09:54 +0100
Message-ID: <20260917151613.559786667@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jori Koolstra <jkoolstra@xs4all.nl>

[ Upstream commit ad3dfa80be765757f612da04318248f6d20e4f71 ]

The class_create() call has been deprecated in favor of class_register()
as the driver core now allows for a struct class to be in read-only
memory. Change dibs_class to be a const struct class and drop the
class_create() call.

Link: https://lore.kernel.org/all/2023040244-duffel-pushpin-f738@gregkh/

Suggested-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Jori Koolstra <jkoolstra@xs4all.nl>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
Link: https://patch.msgid.link/20260303163104.3749311-1-jkoolstra@xs4all.nl
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 1668a31e3b1a ("dibs: Unregister dibs_class after error")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dibs/dibs_main.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/dibs/dibs_main.c b/drivers/dibs/dibs_main.c
index d6ea178e70c44..c3ec36e8c10fc 100644
--- a/drivers/dibs/dibs_main.c
+++ b/drivers/dibs/dibs_main.c
@@ -20,7 +20,9 @@
 MODULE_DESCRIPTION("Direct Internal Buffer Sharing class");
 MODULE_LICENSE("GPL");
 
-static struct class *dibs_class;
+static const struct class dibs_class = {
+	.name		= "dibs",
+};
 
 /* use an array rather a list for fast mapping: */
 static struct dibs_client *clients[MAX_DIBS_CLIENTS];
@@ -140,7 +142,7 @@ struct dibs_dev *dibs_dev_alloc(void)
 		return dibs;
 	spin_lock_init(&dibs->lock);
 	dibs->dev.release = dibs_dev_release;
-	dibs->dev.class = dibs_class;
+	dibs->dev.class = &dibs_class;
 	device_initialize(&dibs->dev);
 
 	return dibs;
@@ -248,9 +250,9 @@ static int __init dibs_init(void)
 {
 	int rc;
 
-	dibs_class = class_create("dibs");
-	if (IS_ERR(dibs_class))
-		return PTR_ERR(dibs_class);
+	rc = class_register(&dibs_class);
+	if (rc)
+		return rc;
 
 	rc = dibs_loopback_init();
 	if (rc)
@@ -262,7 +264,7 @@ static int __init dibs_init(void)
 static void __exit dibs_exit(void)
 {
 	dibs_loopback_exit();
-	class_destroy(dibs_class);
+	class_unregister(&dibs_class);
 }
 
 module_init(dibs_init);
-- 
2.53.0



