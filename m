Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A9AEBA48
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:21:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 162D1C433EF;
	Tue,  7 Mar 2023 18:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678213279;
	bh=shNNeHqfHJ88zT8GZ66H30xyasgCDChVa5CUgly7KCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f6moAhtVD+lAZzZFg4/U09yrwanws5ivU+4GBDUOqH1HYqOKNWuzGn1F/8WcAqKbp
	 j9LNYai0HOTg+mKAY+sTjOpUQQW+g90TLYwdLNdNvuYA13kX/l319lTVT9TmMlxKGN
	 iEzdAuqqjksnYtcIzxntuqPRfOjfjDuiNfzEkBZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 439/885] mei: pxp: Use correct macros to initialize uuid_le
Date: Tue,  7 Mar 2023 17:56:13 +0100
Message-Id: <20230307170021.487383509@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 503b676dde2780330c90a10b37a844686601a784 ]

GUID_INIT() is for internal guid_t type and shouldn't be used
for the uuid_le. I.o.w. relying on the implementation details
is layering violation. Use correct macros to initialize uuid_le.

Fixes: c2004ce99ed7 ("mei: pxp: export pavp client to me client bus")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Tomas Winkler <tomas.winkler@intel.com>
Link: https://lore.kernel.org/r/20221228160558.21311-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/mei/pxp/mei_pxp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/mei/pxp/mei_pxp.c b/drivers/misc/mei/pxp/mei_pxp.c
index 5c39457e3f53d..412b2d91d9459 100644
--- a/drivers/misc/mei/pxp/mei_pxp.c
+++ b/drivers/misc/mei/pxp/mei_pxp.c
@@ -206,8 +206,8 @@ static void mei_pxp_remove(struct mei_cl_device *cldev)
 }
 
 /* fbf6fcf1-96cf-4e2e-a6a6-1bab8cbe36b1 : PAVP GUID*/
-#define MEI_GUID_PXP GUID_INIT(0xfbf6fcf1, 0x96cf, 0x4e2e, 0xA6, \
-			       0xa6, 0x1b, 0xab, 0x8c, 0xbe, 0x36, 0xb1)
+#define MEI_GUID_PXP UUID_LE(0xfbf6fcf1, 0x96cf, 0x4e2e, 0xA6, \
+			     0xa6, 0x1b, 0xab, 0x8c, 0xbe, 0x36, 0xb1)
 
 static struct mei_cl_device_id mei_pxp_tbl[] = {
 	{ .uuid = MEI_GUID_PXP, .version = MEI_CL_VERSION_ANY },
-- 
2.39.2



