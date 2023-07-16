Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E65A8F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:20:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0525C433C7;
	Sun, 16 Jul 2023 20:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538831;
	bh=ySBpyD4vhc5XOzrhzFV1GKvekQKG/7f60M0NhKX/vMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hh0w2E3qm9Fw2K/SC3au0HSRCdPZGqiKFkKuIVueXqYii/KAQDOMRojWUe+1MRmK/
	 XxNIvpXz63EaBYYxSfPJlrAKIhOj7/QCm3uBpLSVMFq57Hh/Sv+xLzCTCokvvAAoBQ
	 pQ2okK/L59bRD0pIMCkVK1oqSeEXuETDM1WMc+yA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Chanwoo Choi <cw00.choi@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 590/800] extcon: Fix kernel doc of property fields to avoid warnings
Date: Sun, 16 Jul 2023 21:47:23 +0200
Message-ID: <20230716195002.804385825@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
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

[ Upstream commit 7e77e0b7a9f4cdf91cb0950749b40c840ea63efc ]

Kernel documentation has to be synchronized with a code, otherwise
the validator is not happy:

     Function parameter or member 'usb_propval' not described in 'extcon_cable'
     Function parameter or member 'chg_propval' not described in 'extcon_cable'
     Function parameter or member 'jack_propval' not described in 'extcon_cable'
     Function parameter or member 'disp_propval' not described in 'extcon_cable'

Describe the fields added in the past.

Fixes: 067c1652e7a7 ("extcon: Add the support for extcon property according to extcon type")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/extcon/extcon.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/extcon/extcon.c b/drivers/extcon/extcon.c
index d43ba8e7260dd..efaf234582d97 100644
--- a/drivers/extcon/extcon.c
+++ b/drivers/extcon/extcon.c
@@ -206,6 +206,10 @@ static const struct __extcon_info {
  * @attr_name:		"name" sysfs entry
  * @attr_state:		"state" sysfs entry
  * @attrs:		the array pointing to attr_name and attr_state for attr_g
+ * @usb_propval:	the array of USB connector properties
+ * @chg_propval:	the array of charger connector properties
+ * @jack_propval:	the array of jack connector properties
+ * @disp_propval:	the array of display connector properties
  */
 struct extcon_cable {
 	struct extcon_dev *edev;
-- 
2.39.2



