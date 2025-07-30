Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 222354A32;
	Wed, 30 Jul 2025 09:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753869087; cv=none; b=jbwXJ3w8teE05Z/RRHe/McjMfO5i+MA4DgaC3s6C/pELjfNM0frunYbPBMmcn1rSKlifqjaoGnQECg6Nu5meXucQay53uwezkwBKb2y1bL9baOMdSopFBS0UAg6VCUzRb5TnX+AOhNcJNG3L67Y79MGccfEEIb5AjlXY7p6xR1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753869087; c=relaxed/simple;
	bh=n915jj5kfh+lm+XtOoHUQrZN35J+ZalCkF4GGfSF5LI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sZNh7ls03upOUNscCNM0R6lCoslr2lc3D1Twtb5XvI0Zyc9EyVMY3yVU3Q3k/CR47qx6L1Qpcvsk6Xo+UFy0lGV22fi1EJvbIjprNBoEvc1/vmH6KIGMjN+A+Kam8+z6YizPrhGGyf3eU+fhvbjMFrm7QJLuNAfVIvZCbzZI7p8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BIJYlXwl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BIJYlXwl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69F57C4CEF5;
	Wed, 30 Jul 2025 09:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753869087;
	bh=n915jj5kfh+lm+XtOoHUQrZN35J+ZalCkF4GGfSF5LI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BIJYlXwlALTjSJYoVRZmbgzs9GIz4UyeaOV2erPjbwgnKEs8/A0wYWolHSFgIfvY/
	 /GGF9AGnAYz0IwbOnT8Y9z1t5YBk64M9fdtBsY19Wm0hukKmBUHiQGUO9BOygajqDp
	 1JdWFVhJ5/HVbYxKj/5C+znObfwkj0nrzhoDC+ek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rahul Chandra <rahul@chandra.net>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 06/92] platform/x86: asus-nb-wmi: add DMI quirk for ASUS Zenbook Duo UX8406CA
Date: Wed, 30 Jul 2025 11:35:14 +0200
Message-ID: <20250730093230.880455356@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093230.629234025@linuxfoundation.org>
References: <20250730093230.629234025@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rahul Chandra <rahul@chandra.net>

[ Upstream commit 7dc6b2d3b5503bcafebbeaf9818112bf367107b4 ]

Add a DMI quirk entry for the ASUS Zenbook Duo UX8406CA 2025 model to use
the existing zenbook duo keyboard quirk.

Signed-off-by: Rahul Chandra <rahul@chandra.net>
Link: https://lore.kernel.org/r/20250624073301.602070-1-rahul@chandra.net
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-nb-wmi.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/platform/x86/asus-nb-wmi.c b/drivers/platform/x86/asus-nb-wmi.c
index 3f8b2a324efdf..f84c3d03c1de7 100644
--- a/drivers/platform/x86/asus-nb-wmi.c
+++ b/drivers/platform/x86/asus-nb-wmi.c
@@ -530,6 +530,15 @@ static const struct dmi_system_id asus_quirks[] = {
 		},
 		.driver_data = &quirk_asus_zenbook_duo_kbd,
 	},
+	{
+		.callback = dmi_matched,
+		.ident = "ASUS Zenbook Duo UX8406CA",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "UX8406CA"),
+		},
+		.driver_data = &quirk_asus_zenbook_duo_kbd,
+	},
 	{},
 };
 
-- 
2.39.5



