Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48C78524C2;
	Thu, 30 Nov 2023 16:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iPLCvOd+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7DBCC433C8;
	Thu, 30 Nov 2023 16:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361573;
	bh=jEPMfLXENFZP2Wp4UQFzCB4dT5bGm9Bssnwrclg63W0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iPLCvOd+xew0xen2xfKHYepYriSGHIht1RGFS5NVXQlgJKbxTuBbxmrp7NmaWXRj8
	 CQsmxNyEXSiL4gW5SiG7pYYe6x9fiAEE+mM9guQ0IG0qHyFxNUGrJCqrOxfQUkUmBK
	 r8p+6lp369E+2uYKhnGyuR/AqLfBHqqicEmOW2F0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.6 075/112] platform/x86: hp-bioscfg: Simplify return check in hp_add_other_attributes()
Date: Thu, 30 Nov 2023 16:22:02 +0000
Message-ID: <20231130162142.710913410@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162140.298098091@linuxfoundation.org>
References: <20231130162140.298098091@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

commit c5dbf04160005e07e8ca7232a7faa77ab1547ae0 upstream.

All cases in switch-case have a same goto on error, move the return
check out of the switch. This is a cleanup.

Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20231113200742.3593548-1-harshit.m.mogalapalli@oracle.com
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/hp/hp-bioscfg/bioscfg.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/drivers/platform/x86/hp/hp-bioscfg/bioscfg.c
+++ b/drivers/platform/x86/hp/hp-bioscfg/bioscfg.c
@@ -630,21 +630,19 @@ static int hp_add_other_attributes(int a
 	switch (attr_type) {
 	case HPWMI_SECURE_PLATFORM_TYPE:
 		ret = hp_populate_secure_platform_data(attr_name_kobj);
-		if (ret)
-			goto err_other_attr_init;
 		break;
 
 	case HPWMI_SURE_START_TYPE:
 		ret = hp_populate_sure_start_data(attr_name_kobj);
-		if (ret)
-			goto err_other_attr_init;
 		break;
 
 	default:
 		ret = -EINVAL;
-		goto err_other_attr_init;
 	}
 
+	if (ret)
+		goto err_other_attr_init;
+
 	mutex_unlock(&bioscfg_drv.mutex);
 	return 0;
 


