Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BC5B22259B;
	Tue,  8 Jul 2025 16:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992400; cv=none; b=Xr8616a9i1quuk3HW8a9Mh7i+rI5xcDCJ9nyi6X22TOP9Whtu+ClbxoS5eez5HCfStcDqRiRuWMHFAnxVXXeXyy/QGAMyw2y6tS090bEQsYMDHLLUEp/STPLWhsUmzyl8OE+mE6iu6tZ8Ume6FG5GVy7F5rwvzcmFQZeRNyFdB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992400; c=relaxed/simple;
	bh=l9SpcJa3n5ph0jFrnXVx4kD2igLy09nL10aw1fX7WH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PH22teDaq47NeBwOmEqzsDs7RORd+SkhVbXiS89QuinGSuX8tmwuVWHNqcLtYXhfO8bAmcZ6MnwJf3HtwTP5Zh7/CZmN0tLcSMbiyNTP2OlcsmorNG5vsXcfQLoZ7Ypd35JFUXI8cVP3k9+zB7JlF2nYtfUSRnK0iNqmgs5sH/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aahmkE0w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aahmkE0w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 052ABC4CEED;
	Tue,  8 Jul 2025 16:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992400;
	bh=l9SpcJa3n5ph0jFrnXVx4kD2igLy09nL10aw1fX7WH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aahmkE0w6AWaHbMgJ/hKtjbTiQ1Dk2fVCGP/Obm75E3OKbbDnUzibJEuEYWDDjwez
	 PdC1QmAKsseaB2e36kR/oRMPLqpc/ibHo98+fG8l2plTZZ/LLZ7L0W2vXuuZKWdbED
	 IH7sRNm5u9+ZRcHBnp13Y+BUz7DUhaVY+rbEBczU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kurt Borja <kuurtb@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 049/132] platform/x86: dell-wmi-sysman: Fix class device unregistration
Date: Tue,  8 Jul 2025 18:22:40 +0200
Message-ID: <20250708162232.097582877@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162230.765762963@linuxfoundation.org>
References: <20250708162230.765762963@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 3c74d5e8350a4..f5402b7146572 100644
--- a/drivers/platform/x86/dell/dell-wmi-sysman/sysman.c
+++ b/drivers/platform/x86/dell/dell-wmi-sysman/sysman.c
@@ -597,7 +597,7 @@ static int __init sysman_init(void)
 	release_attributes_data();
 
 err_destroy_classdev:
-	device_destroy(&firmware_attributes_class, MKDEV(0, 0));
+	device_unregister(wmi_priv.class_dev);
 
 err_exit_bios_attr_pass_interface:
 	exit_bios_attr_pass_interface();
@@ -611,7 +611,7 @@ static int __init sysman_init(void)
 static void __exit sysman_exit(void)
 {
 	release_attributes_data();
-	device_destroy(&firmware_attributes_class, MKDEV(0, 0));
+	device_unregister(wmi_priv.class_dev);
 	exit_bios_attr_set_interface();
 	exit_bios_attr_pass_interface();
 }
-- 
2.39.5



