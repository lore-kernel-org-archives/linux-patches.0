Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D1FB1ED38
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:21:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAC23C433C8;
	Tue, 25 Jul 2023 11:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690284088;
	bh=3bsLtJHhxKDF6/pgcaDeBDyvU9uqw5tFPhtQ66pF2IY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yDPiv83MbYqLuWf/3AvVHdgkOikyokh5XmIZTegHul8X3ngoB7binaMq68tZD30Sf
	 2JEI8fLLg2zPU2iFXVssc2qnIA9PZaU8MDafSE6TyiqMpP08AKIUawitYHIN+LDewr
	 j0YCPpjr/c7ZKaQ95VeP8E/uoWygD7SHqkhkAuAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Chanwoo Choi <cw00.choi@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 231/509] extcon: Fix kernel doc of property fields to avoid warnings
Date: Tue, 25 Jul 2023 12:42:50 +0200
Message-ID: <20230725104604.348045399@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104553.588743331@linuxfoundation.org>
References: <20230725104553.588743331@linuxfoundation.org>
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
index 356610404bb40..3bc83feb5a34b 100644
--- a/drivers/extcon/extcon.c
+++ b/drivers/extcon/extcon.c
@@ -196,6 +196,10 @@ static const struct __extcon_info {
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



