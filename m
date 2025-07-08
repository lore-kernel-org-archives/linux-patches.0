Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6731A8F5E;
	Tue,  8 Jul 2025 16:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993457; cv=none; b=dMvM919g4XG1SjpbbyT7DGxnKsTd3/74COHqm72MybJlGuNQv6T29QhUK4h7eW/miimCI2zMg0LmWSMJOuGLAEMWJa/V5OUnzWH+N5GY/Esiw+WG/Tnze9FQZijdTisdOhsiBpNxUzOKYsxT2WJh8GAtnwKZQL4lzu/Uo9BPn84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993457; c=relaxed/simple;
	bh=Pn99kzf00f5xZZLeCTM7bCItJntvRt6SiJW1p+EezKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dUpI/yCoc8jFewMd0bfR0OxT02Fj9JY+PDxpFD2sURt25QXgDy6/0VgcdLUTfViMalfQ7YgUiCZITzlYq6tB09LCX7NJWyBZjt0mV0CXZubq2gUZTFvDzj9zoNC49IivA3Fq8G7UilumZYhJKKp52ozDUSWo8GPMkUZiY1QAEnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V6/UlL3J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V6/UlL3J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3E64C4CEED;
	Tue,  8 Jul 2025 16:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993457;
	bh=Pn99kzf00f5xZZLeCTM7bCItJntvRt6SiJW1p+EezKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V6/UlL3J0T4wcw23ob9MmuT+Ky08vcOXiTs2M1hosdeYHbJNGCVN+e0SwAw4hfXwl
	 CxhaIbcZCdRIvDkTZFFwTb7nS9eaA6U1u2Zm8wuWOsOVpkJRBfdUyOW/YQqmcA20hb
	 AaNueu/nEzfONFX5FFwGK53l3m1JgOMgO0XGFTOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kurt Borja <kuurtb@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 081/178] platform/x86: hp-bioscfg: Fix class device unregistration
Date: Tue,  8 Jul 2025 18:21:58 +0200
Message-ID: <20250708162238.795918471@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
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

From: Kurt Borja <kuurtb@gmail.com>

[ Upstream commit 11cba4793b95df3bc192149a6eb044f69aa0b99e ]

Devices under the firmware_attributes_class do not have unique a dev_t.
Therefore, device_unregister() should be used instead of
device_destroy(), since the latter may match any device with a given
dev_t.

Fixes: a34fc329b189 ("platform/x86: hp-bioscfg: bioscfg")
Signed-off-by: Kurt Borja <kuurtb@gmail.com>
Link: https://lore.kernel.org/r/20250625-dest-fix-v1-1-3a0f342312bb@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/hp/hp-bioscfg/bioscfg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/hp/hp-bioscfg/bioscfg.c b/drivers/platform/x86/hp/hp-bioscfg/bioscfg.c
index 13237890fc920..5bfa7159f5bcd 100644
--- a/drivers/platform/x86/hp/hp-bioscfg/bioscfg.c
+++ b/drivers/platform/x86/hp/hp-bioscfg/bioscfg.c
@@ -1034,7 +1034,7 @@ static int __init hp_init(void)
 	release_attributes_data();
 
 err_destroy_classdev:
-	device_destroy(&firmware_attributes_class, MKDEV(0, 0));
+	device_unregister(bioscfg_drv.class_dev);
 
 err_unregister_class:
 	hp_exit_attr_set_interface();
@@ -1045,7 +1045,7 @@ static int __init hp_init(void)
 static void __exit hp_exit(void)
 {
 	release_attributes_data();
-	device_destroy(&firmware_attributes_class, MKDEV(0, 0));
+	device_unregister(bioscfg_drv.class_dev);
 
 	hp_exit_attr_set_interface();
 }
-- 
2.39.5



