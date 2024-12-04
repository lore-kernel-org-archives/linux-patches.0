Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC4C12391AA
	for <patches@lists.linux.dev>; Wed,  4 Dec 2024 19:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733341690; cv=none; b=V1qR5OdjzKJnN4jcao1khh1hwTv4EZft17stOZ509edgvjLa0imvb6/Lhp2XpumwUEm4LM8LghJnSQ7BnqD3c3yrOxd9E5s0n/YjUICPeJSdYZEPNvWrBGCKltQIAq9S5422MxbpeUTCsZiLNBLLSAnSbLe0bjoLdVkf9V3s1eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733341690; c=relaxed/simple;
	bh=q7JXgsd9lm7WjrZOIsZzvR9UT80iuPtsmbmChSe9FoY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NDsf6RXw7kDwiIBO5UdyWozisiybkyXToQf9rrhlEq8w0RGsUfSjOo6yy5rLmKdd/EHPvsGqAQcFYYiJPUcg7Gi7KafO4tD1zqy6VoUdV/z7RL9Y5wXpY/tW+tmdkDI3ahgs+V5Vt4AinvQNoqK6V9eIYsIcgsXNZRybTD87lTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=ExX6mNds; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="ExX6mNds"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-2ef28f07dbaso139583a91.2
        for <patches@lists.linux.dev>; Wed, 04 Dec 2024 11:48:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1733341688; x=1733946488; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ch5dOO0x4WGkBLvzcx+h/YLN0SfrSosFkimPazJD86Q=;
        b=ExX6mNdssuMOgjA/zMWU1rK8WK/YFHPONtGuT7E+t8BuTnzl3sOkDOl2Lptfkm+V7b
         4tb9irAKAAcYI+YGJ+9xhGUbi5Mgigqwt7KdHZttgL/+jsVQ5c1Yq+2GgwVnT2vnx5I6
         8VGtpvq2yR9DMsokDYogUvHrZgNhu7JzRsx3w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733341688; x=1733946488;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ch5dOO0x4WGkBLvzcx+h/YLN0SfrSosFkimPazJD86Q=;
        b=SUOo7u26r7mxg+ipiR8Y2ie5yPvUFpv6igznzVnVZz7+rZgfJer5j/PxZmsZnUw8TR
         8pYdCnWtfV35va9SEUBEiBFhpyQN5gqmJgJQ6fVTZrLabuNzzUDZ2xkNJeEXv3tKxqC5
         AbjhPbvzWkq+QcjprdIJVb6ANXJgsZdE3b7Zz9b+ZzA759LhZDjC3UiouEwUL+f00SMb
         idNuRnwByVbOaAgvFNO2OhGWqjTxuKHX7Ac4TViNwORKjJFO9hKflckzQwU0vUje/ib9
         easHw4uWMeq7+IOfpDiYM6tmj1USCb3jZcs7ohNbldZmbIXSdM8SxHw+WgvcZhNeSCr3
         hkRQ==
X-Forwarded-Encrypted: i=1; AJvYcCVy9uBLnC0Rd5ZWH+oiTarHNmA0aFrGOi/SIj072qm0XIj/g0jTZTgXXl2F8xKh3RQNVOEJIwVC@lists.linux.dev
X-Gm-Message-State: AOJu0Yxsvt+arWMszFiKQIBMBXdc5+lZsUiuFbUKDlyAiC0hfRUbqNb+
	6TUVao1vknKdf2CxUHihyMeR9+SMvblHXIbE/4vCrN/eesQXioA1gcW+8LdAjQ==
X-Gm-Gg: ASbGncvF9WCF0SosOTrb3u7idotnGI5lcVGZqO5+WbewOKKQ4lO9hCukbBytep+JfkB
	7fPbrpGR1QGELEm4AFf49Ifq/k9jt7JLPnMdxoPvRcftav0iDubER8zNI46/3l5lGnfLE7l3Vmw
	YMVZ2FyVR+9TvoBQ0YPXob6lNFs07hByQ74vL8OaMu518A8BCQUqZ9sq9X1jBfpGax4M/eJd0ov
	kQBCmJasxwj+lBS/4OqICzg8kfxem/be+HAmeaZdpaIVvnkLmPr4QoK0Yg7aLfWTjFNnh+20Y33
	m5ggbqay+kAyOA==
X-Google-Smtp-Source: AGHT+IGILSlTnkkdJXjpUeU7Jq5yUV8aGe7A7pj7PQfhAd5EJruxK5hvz9fCHF1b+UJK7pbGQjQY9Q==
X-Received: by 2002:a17:90b:380c:b0:2ea:356f:51b4 with SMTP id 98e67ed59e1d1-2ef011fc89emr9494845a91.13.1733341688296;
        Wed, 04 Dec 2024 11:48:08 -0800 (PST)
Received: from localhost (188.139.125.34.bc.googleusercontent.com. [34.125.139.188])
        by smtp.gmail.com with UTF8SMTPSA id d2e1a72fcca58-7254176fc40sm12709672b3a.71.2024.12.04.11.48.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Dec 2024 11:48:07 -0800 (PST)
From: Stephen Boyd <swboyd@chromium.org>
To: Rob Herring <robh@kernel.org>,
	Saravana Kannan <saravanak@google.com>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	devicetree@vger.kernel.org
Subject: [PATCH v2] of: Hide of_default_bus_match_table[]
Date: Wed,  4 Dec 2024 11:48:05 -0800
Message-ID: <20241204194806.2665589-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This isn't used outside this file. Hide the array in the C file.

Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---

Changes from v1 https://lore.kernel.org/r/20241204000415.2404264-1-swboyd@chromium.org
 * Move of_default_bus_match_table into function so it isn't unused in
   different configs

 drivers/of/platform.c       | 23 +++++++++++------------
 include/linux/of_platform.h |  2 --
 2 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index 9bafcff3e628..c6d8afb284e8 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -24,16 +24,6 @@
 
 #include "of_private.h"
 
-const struct of_device_id of_default_bus_match_table[] = {
-	{ .compatible = "simple-bus", },
-	{ .compatible = "simple-mfd", },
-	{ .compatible = "isa", },
-#ifdef CONFIG_ARM_AMBA
-	{ .compatible = "arm,amba-bus", },
-#endif /* CONFIG_ARM_AMBA */
-	{} /* Empty terminated list */
-};
-
 /**
  * of_find_device_by_node - Find the platform_device associated with a node
  * @np: Pointer to device tree node
@@ -484,8 +474,17 @@ int of_platform_default_populate(struct device_node *root,
 				 const struct of_dev_auxdata *lookup,
 				 struct device *parent)
 {
-	return of_platform_populate(root, of_default_bus_match_table, lookup,
-				    parent);
+	static const struct of_device_id match_table[] = {
+		{ .compatible = "simple-bus", },
+		{ .compatible = "simple-mfd", },
+		{ .compatible = "isa", },
+#ifdef CONFIG_ARM_AMBA
+		{ .compatible = "arm,amba-bus", },
+#endif /* CONFIG_ARM_AMBA */
+		{} /* Empty terminated list */
+	};
+
+	return of_platform_populate(root, match_table, lookup, parent);
 }
 EXPORT_SYMBOL_GPL(of_platform_default_populate);
 
diff --git a/include/linux/of_platform.h b/include/linux/of_platform.h
index a2ff1ad48f7f..17471ef8e092 100644
--- a/include/linux/of_platform.h
+++ b/include/linux/of_platform.h
@@ -47,8 +47,6 @@ struct of_dev_auxdata {
 	{ .compatible = _compat, .phys_addr = _phys, .name = _name, \
 	  .platform_data = _pdata }
 
-extern const struct of_device_id of_default_bus_match_table[];
-
 /* Platform drivers register/unregister */
 extern struct platform_device *of_device_alloc(struct device_node *np,
 					 const char *bus_id,

base-commit: 40384c840ea1944d7c5a392e8975ed088ecf0b37
-- 
https://chromeos.dev

