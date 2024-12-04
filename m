Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DB322F4A
	for <patches@lists.linux.dev>; Wed,  4 Dec 2024 00:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733270660; cv=none; b=b6+VP3mSnQl9iyckyb5FN9LPGncxApLRcErHo987Zt/OfQQ1OiIiMqzF6E/6ez6DoiM+X7TfbTB7NkQ0sA8NUePNoep/2CfUCNeiEfxtqeMRRxudreY2oHCzldm0uXwvHl8AvOQAE12aDNJrfigwZ9lnbIOBVUhXwqUeohPvK0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733270660; c=relaxed/simple;
	bh=+ipD/Vuf+WHiBO3am03cEGfuJhA/9jJW/6w7HvVxhiM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=biXeHJpZQl+ZQ760YsK3hMU7lctRj1gJJQcXPzVJbWgU+eFC6HnVtBYdoL2GIsLngTejZYxvk60M3YQffmloA6iHd906rdiAFDH5C1/AIb8SsRvnUOsJUoTp2r4b0k2hPhYYY51E48nm/udWWXwvtk7BGU2jdUj+mDELdMEb6X8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=m8y3Kxwn; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="m8y3Kxwn"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-7fc22a88bcbso4702830a12.2
        for <patches@lists.linux.dev>; Tue, 03 Dec 2024 16:04:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1733270658; x=1733875458; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4m7pNMsdgNYxzBIEAAkmRSEO/6g/enlI6isMmxPuL6o=;
        b=m8y3Kxwnc8l5PIRsay7+RNhCMGc6ItuC7Nq0S8mVVAskEdhu3W4uznQBoOse1KpTrg
         dnppJNFCck5wAQL1KUMhjedL7MWiy8xtkHXunC8ZEbArbAbjGDGch3L/WdMgPQ+n7L6j
         0vYpChG5KWd5Ml1o5xfNeX/2Z4qAJSRIyXTto=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733270658; x=1733875458;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4m7pNMsdgNYxzBIEAAkmRSEO/6g/enlI6isMmxPuL6o=;
        b=lU5sJqFGVjEitLmCEbNplyYswTGsJ9cy89jpdiy8xrEVKOunVWDXsLwJz0EOZ8iSp3
         vrRIriui99IY5XqeEGxiUiRaj3FKpvnWD8sBby2PeFoVF+gy6iug9baaTqVonwLZ/64W
         ihed3G9ic8pMau6ua04Yw6AI6yxVnAWYXXQVQ1H378OUP25hP3XESPTx7wjIL/08Mgwj
         oCMw3t0m9JSXwiq9qdecF7hOdaas25GEvB2+yBv2njQqsXjfNu6WnUCZs3T7s9xoa6nB
         o/FLzQAxmoFYMl2AZGar/Q3VfHWEgMv4NK5swLr1srGrSZ2Emj2+dTzW3p9o1l9ZK1Ez
         nwbA==
X-Forwarded-Encrypted: i=1; AJvYcCVA24hpKppficWz2uOLwk09vMcnJqkc/Ei3FjNZZUlab54z1ubFUsUMuqUK4by6q1aR1jvcyePZ@lists.linux.dev
X-Gm-Message-State: AOJu0Yz7hBbLjTRrzy5ShXc86+GqDNUKsSIVmM1prUGeqxY96Ef+KkiE
	tSB5MpdFcPD0LzQXrlBiszfI8Zad49am6ZmLdFb3bZWfMzh0j+uG6SvM1q79tA==
X-Gm-Gg: ASbGnctpIquPXUQILrp7p2ePoJInmbACJYRofuFysE9BZFXNDlRknbqlEslAsvfaMe/
	AHBXJr+owJJhUkCjKicMxDWBhsbbYYpvgl6gS2w6+n8ReF8eWjCbLbr0D0QYpYP7YfZU0K/xlkE
	+Fih4nyXWx2UPdr9oGMfAXXc1Q7FB+ZdDq/I99an1tNX+4VICv4cq4DfuvONiH8U5POZ0rGps1B
	fvrMqRJwIdtyBlDrKbZ1E30S6ahYPOoOfmUci+jtLwnjPVPKbD5LzBe0C7YXqJgiuniyrkHJQlw
	N8UyJkmN/Viliw==
X-Google-Smtp-Source: AGHT+IHYAWFOhMRMmsJogPCN+keqI5onO24l06foMGQMmqGxtDSAhpXuUqKm8NyRO5YVeG1E5lAVvQ==
X-Received: by 2002:a05:6a20:430d:b0:1db:ebf4:2cb8 with SMTP id adf61e73a8af0-1e1654132b6mr7413981637.38.1733270657782;
        Tue, 03 Dec 2024 16:04:17 -0800 (PST)
Received: from localhost (188.139.125.34.bc.googleusercontent.com. [34.125.139.188])
        by smtp.gmail.com with UTF8SMTPSA id d2e1a72fcca58-7254176f3ccsm11049434b3a.56.2024.12.03.16.04.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Dec 2024 16:04:17 -0800 (PST)
From: Stephen Boyd <swboyd@chromium.org>
To: Rob Herring <robh@kernel.org>,
	Saravana Kannan <saravanak@google.com>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	devicetree@vger.kernel.org
Subject: [PATCH] of: Hide of_default_bus_match_table[]
Date: Tue,  3 Dec 2024 16:04:12 -0800
Message-ID: <20241204000415.2404264-1-swboyd@chromium.org>
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
 drivers/of/platform.c       | 2 +-
 include/linux/of_platform.h | 2 --
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index 9bafcff3e628..f09dc183975b 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -24,7 +24,7 @@
 
 #include "of_private.h"
 
-const struct of_device_id of_default_bus_match_table[] = {
+static const struct of_device_id of_default_bus_match_table[] = {
 	{ .compatible = "simple-bus", },
 	{ .compatible = "simple-mfd", },
 	{ .compatible = "isa", },
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

