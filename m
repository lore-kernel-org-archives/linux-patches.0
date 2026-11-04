Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831931;
	b=ypQ5pOEc+f+W9Rrl5OZlm3F6pK5LsWMKUizob4e2F+KY6K5glMq0E0o6TckXuRAdSuZ+
	 WtWVQhfyPyU0AJLSX/yDolbTK5agka0udkc/M/H8qYWIH+o7bG8KSxjJYf7qLlD4X4+G1
	 BfC0CTPseCW53EPnn+uzpRXfGXNJYQvohc+Giql3BKsl52Xce62wAwRn7uO/UsHBDe7cJ
	 sAuPzYkua7BcWp0O9JaTlXXE2faO1K8K+OCyaYpUgX5vFZuweIlx33EgAPdg3OSfkY7cI
	 taJ4gPiroxRtx2fIfW8HmKCOMAUi1Lh62bcUYxFGrp3c4ysqlA/kwMxkPWar430xupw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831931;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bU1dnDiiSUhyvSZhl2ygu9zYWzyjoqYdi/XzcHZ2YuY=;
	b=zz/38To/1146CYG+BX1p2S5al98t6aV0N+A54e7r9fnm9zunSB0gnZd+DJmIHMCEz9YF
	 lb6cfMBF7r8j8WIpI0vO4PU/EWF0y0X8nxoz9bsRIH5UkiZOHR7e5BNt2m7THiW85NX/O
	 Q5sEeYnpRHFOVo+p/5BE6A/1IvsfEe6DUGszNjJ8Q4fqibSIXoJW6NvyVP9atRz7tPJmR
	 jP3r9IgC0M3pY9eBY+M68yaqpb91cCmlccWBt7oMzi5iEgGaLq1EUKxT+2r8ytnCa5MCH
	 H0SSS9pU23i+Rmm6gN+DWLziqt9uQQF91hsDoJihRNME+Ms9hMxg/wU5Xih/G/764eQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jBGfrvY6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F91C606A326;
	Wed,  4 Nov 2026 22:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jBGfrvY6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A907A1F000C1;
	Wed,  4 Nov 2026 22:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831931;
	bh=bU1dnDiiSUhyvSZhl2ygu9zYWzyjoqYdi/XzcHZ2YuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jBGfrvY6zAaRuySTFqvOfaM+JuNpgrUkdqINjJE3J0Kl27Ry2XB//qzVLdr11k0YE
	 rwR2dNfGFuZhbKe96WuIDQuiMhswXenO9xQ0JDpPhE5Tf3TEEAgL3ZOJHtG2EeW6q8
	 Gr1zpBrYMUOG1Gp0jux7llDHIJVFOh5ZfdnhXjBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jori Koolstra <jkoolstra@xs4all.nl>,
	Rodolfo Giometti <giometti@enneenne.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0997/1005] pps: change pps_gen_class to a const struct
Date: Wed,  4 Nov 2026 16:12:10 -0500
Message-ID: <20261104211110.957869323@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jori Koolstra <jkoolstra@xs4all.nl>

[ Upstream commit 4dc0c899b14c3ea2c9b5f42b523301040d1c8100 ]

The class_create() call has been deprecated in favor of class_register()
as the driver core now allows for a struct class to be in read-only
memory. Change pps_gen_class to be a const struct class and drop the
class_create() call.

Signed-off-by: Jori Koolstra <jkoolstra@xs4all.nl>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: Rodolfo Giometti <giometti@enneenne.com>
Link: https://patch.msgid.link/20260302142436.3292766-1-jkoolstra@xs4all.nl
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: d19552611cb2 ("pps: generators: fix use-after-free when closing a removed device")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pps/generators/pps_gen.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

--- a/drivers/pps/generators/pps_gen.c
+++ b/drivers/pps/generators/pps_gen.c
@@ -26,7 +26,10 @@
  */
 
 static dev_t pps_gen_devt;
-static struct class *pps_gen_class;
+static const struct class pps_gen_class = {
+	.name		= "pps-gen",
+	.dev_groups	= pps_gen_groups
+};
 
 static DEFINE_IDA(pps_gen_ida);
 
@@ -183,7 +186,7 @@ static int pps_gen_register_cdev(struct
 				MAJOR(pps_gen_devt), pps_gen->id);
 		goto free_ida;
 	}
-	pps_gen->dev = device_create(pps_gen_class, pps_gen->info->parent, devt,
+	pps_gen->dev = device_create(&pps_gen_class, pps_gen->info->parent, devt,
 				     pps_gen, "pps-gen%d", pps_gen->id);
 	if (IS_ERR(pps_gen->dev)) {
 		err = PTR_ERR(pps_gen->dev);
@@ -207,7 +210,7 @@ free_ida:
 static void pps_gen_unregister_cdev(struct pps_gen_device *pps_gen)
 {
 	pr_debug("unregistering pps-gen%d\n", pps_gen->id);
-	device_destroy(pps_gen_class, pps_gen->dev->devt);
+	device_destroy(&pps_gen_class, pps_gen->dev->devt);
 }
 
 /*
@@ -307,7 +310,7 @@ EXPORT_SYMBOL(pps_gen_event);
 
 static void __exit pps_gen_exit(void)
 {
-	class_destroy(pps_gen_class);
+	class_unregister(&pps_gen_class);
 	unregister_chrdev_region(pps_gen_devt, PPS_GEN_MAX_SOURCES);
 }
 
@@ -315,12 +318,11 @@ static int __init pps_gen_init(void)
 {
 	int err;
 
-	pps_gen_class = class_create("pps-gen");
-	if (IS_ERR(pps_gen_class)) {
-		pr_err("failed to allocate class\n");
-		return PTR_ERR(pps_gen_class);
+	err = class_register(&pps_gen_class);
+	if (err) {
+		pr_err("failed to register class\n");
+		return err;
 	}
-	pps_gen_class->dev_groups = pps_gen_groups;
 
 	err = alloc_chrdev_region(&pps_gen_devt, 0,
 					PPS_GEN_MAX_SOURCES, "pps-gen");
@@ -332,7 +334,7 @@ static int __init pps_gen_init(void)
 	return 0;
 
 remove_class:
-	class_destroy(pps_gen_class);
+	class_unregister(&pps_gen_class);
 	return err;
 }
 


