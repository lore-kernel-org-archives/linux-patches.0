Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 550652EAEE
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1rRJ6FQ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0840BC433C7;
	Wed, 15 Nov 2023 19:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077429;
	bh=jVnrWrpKQ0l2H+TLLDGhAyfDhSzxH1usQuUuYdiTtZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1rRJ6FQ+Box8Q57pDEBWcKTPDn+CC5KJk8qav4KixcjmOeS1w51YQDOSiU/7cy9hj
	 t+fBhE3sOIYSj/5UcrWtY7DGMIn5rFMsJpZFgBmjqmGycMVsq1DRtsVAsBeAjr9Orx
	 il2fn4WbRHgbThPh4eJfdiOemu33cbQOEfMRcoZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <error27@gmail.com>,
	Juergen Gross <jgross@suse.com>,
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 262/603] xenbus: fix error exit in xenbus_init()
Date: Wed, 15 Nov 2023 14:13:27 -0500
Message-ID: <20231115191631.445487643@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Juergen Gross <jgross@suse.com>

[ Upstream commit 44961b81a9e9059b5c0443643915386db7035227 ]

In case an error occurs in xenbus_init(), xen_store_domain_type should
be set to XS_UNKNOWN.

Fix one instance where this action is missing.

Fixes: 5b3353949e89 ("xen: add support for initializing xenstore later as HVM domain")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Link: https://lore.kernel.org/r/202304200845.w7m4kXZr-lkp@intel.com/
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Link: https://lore.kernel.org/r/20230822091138.4765-1-jgross@suse.com
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/xenbus/xenbus_probe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
index 639bf628389ba..3205e5d724c8c 100644
--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -1025,7 +1025,7 @@ static int __init xenbus_init(void)
 			if (err < 0) {
 				pr_err("xenstore_late_init couldn't bind irq err=%d\n",
 				       err);
-				return err;
+				goto out_error;
 			}
 
 			xs_init_irq = err;
-- 
2.42.0



