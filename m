Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98C672DCF7B;
	Tue,  8 Jul 2025 17:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751994165; cv=none; b=TELXXykbfvls6B2Loh3GK9vUvHi5bbzsTH8UlZQDWeyG0IB0QnEq9Q57a/J+byo8qyPQadspc+feHAzqLnLufFY8/ZR7xWoRAb3g+9161hOR3rM5kdbSND2DJmqVzBlnSuk66T0hueWqSL28MzHBSdtz3DpMYlw4evY7lIspX7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751994165; c=relaxed/simple;
	bh=kylhfAd70Zd2f/EkiP2HocIpkrmCNP5Cr5XdX9HCI3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Go+yBgFrChdM/CYUE/Nfl0ky61rCrkgL+QAx+8RlWZT/RmZGXrhwR73LdYU2JSKWTVchJlTBAZN++MjafL27LCbXWH37zVdmAEtymjRJDpX+HGdwvYwK4QI1usRqAGu0Zbn2/BFJYf/+aD8TTzOM5Dx+03i7JtjK2h0tuK4N4Gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1WkQLw5A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1WkQLw5A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 238B8C4CEED;
	Tue,  8 Jul 2025 17:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751994165;
	bh=kylhfAd70Zd2f/EkiP2HocIpkrmCNP5Cr5XdX9HCI3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1WkQLw5ANoSiw0j9FGZpJFAWR7oSHiJIt1YktuVtK1aMScJGCRA4yjcvEefamEgj+
	 r7FwsyOXVoMkPyhmrQj/iEiPS1YPAFN6ZGElp+dYKagPmHv29zyfWSLq03IJkZdruA
	 U5vXPkiJmmPJM1GS/VDF7n3aCeA5kijR1OMZ8lCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kurt Borja <kuurtb@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 148/160] platform/x86: dell-wmi-sysman: Fix class device unregistration
Date: Tue,  8 Jul 2025 18:23:05 +0200
Message-ID: <20250708162235.431286694@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kurt Borja <kuurtb@gmail.com>

[ Upstream commit 314e5ad4782d08858b3abc325c0487bd2abc23a1 ]

Devices under the firmware_attributes_class do not have unique a dev_t.
Therefore, device_unregister() should be used instead of
device_destroy(), since the latter may match any device with a given
dev_t.

Fixes: e8a60aa7404b ("platform/x86: Introduce support for Systems Management Driver over WMI for Dell Systems")
Signed-off-by: Kurt Borja <kuurtb@gmail.com>
Link: https://lore.kernel.org/r/20250625-dest-fix-v1-3-3a0f342312bb@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/dell/dell-wmi-sysman/sysman.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/dell/dell-wmi-sysman/sysman.c b/drivers/platform/x86/dell/dell-wmi-sysman/sysman.c
index ab639dc8a8072..ddde6e41d8f36 100644
--- a/drivers/platform/x86/dell/dell-wmi-sysman/sysman.c
+++ b/drivers/platform/x86/dell/dell-wmi-sysman/sysman.c
@@ -605,7 +605,7 @@ static int __init sysman_init(void)
 	release_attributes_data();
 
 err_destroy_classdev:
-	device_destroy(fw_attr_class, MKDEV(0, 0));
+	device_unregister(wmi_priv.class_dev);
 
 err_unregister_class:
 	fw_attributes_class_put();
@@ -622,7 +622,7 @@ static int __init sysman_init(void)
 static void __exit sysman_exit(void)
 {
 	release_attributes_data();
-	device_destroy(fw_attr_class, MKDEV(0, 0));
+	device_unregister(wmi_priv.class_dev);
 	fw_attributes_class_put();
 	exit_bios_attr_set_interface();
 	exit_bios_attr_pass_interface();
-- 
2.39.5



