Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED3144EFFB6;
	Thu, 17 Sep 2026 15:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659746; cv=none; b=k3vOXwsewpoj9F5OlWMPbxX76oliUomoYDrSiYg0B3eqV5WKDcUSg9bfrgw3d1sdo/T/2oU83AMH3GVJmH9ilBP1O9UoYqdubbzqroQqQwfh8TpX4aATlUqmN6vyQQlAH1nKG4at73DTBRdGac5KBdTygcK93Op/MmdBRA6QcR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659746; c=relaxed/simple;
	bh=G6kJkzuPllWx48FSH/WU2YwH3Xi0+ucM1aNoG95bDKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kAAyAxFNTXTVgtecR8Yfhxf/lSmmjBkjPJcrRSgV+FrZ+q7hncBvSmNPxK9ShUWJPWbVEAedsED8F0cO+poxN5yn6RblNc5+rcPGWwcNvhG+SyZNjt8wF38s5HSjhZHo7zGEn+EjzIvcCXIuR3jW4nS1Rm7M+eQAk8c2QwE6ags=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z+UzNeeM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z+UzNeeM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70D821F00893;
	Thu, 17 Sep 2026 15:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659738;
	bh=bHhFFpnhGVzP+oL2j+elMwA3ufDcyJuhg5X/yb85yCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z+UzNeeM/BrNgR3qbuPGzhpkeKFnafENm84MHmdVqjxwX0sEdamneE+mqkWepva0T
	 nVSNWQJDh54HUgeFD1zxO9SY+Or8S3YO3IAGHbKl4YMMPrCcDas/GH5KJUKyPVLYTo
	 0X6L5LCuAuYbk/as2GCHojDXO03Xt02//GoUHqoA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	hanzhijian <hanzhijian1991@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 330/733] hwmon: (yogafan) fix non-kernel-doc comment
Date: Thu, 17 Sep 2026 16:10:38 +0100
Message-ID: <20260917151359.743699679@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: hanzhijian <hanzhijian1991@gmail.com>

[ Upstream commit 100eb7c7d0b28c52ad1b25d51c316fdc46c27c71 ]

The file description comment starts with "/**" which is reserved for
kernel-doc comments, triggering a kernel-doc checker warning.  Change
it to a plain "/*" comment since it does not document any function or
struct.

Fixes: c67c248ca406a ("hwmon: (yogafan) Add support for Lenovo Yoga/Legion fan monitoring")
Signed-off-by: hanzhijian <hanzhijian1991@gmail.com>
Link: https://patch.msgid.link/20260821115720.2017516-1-hanzhijian1991@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/yogafan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/yogafan.c b/drivers/hwmon/yogafan.c
index 605cc928f21f3..314ee61955dd8 100644
--- a/drivers/hwmon/yogafan.c
+++ b/drivers/hwmon/yogafan.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/**
+/*
  * yoga_fan.c - Lenovo Yoga/Legion Fan Hardware Monitoring Driver
  *
  * Provides fan speed monitoring for Lenovo Yoga, Legion, and IdeaPad
-- 
2.53.0



