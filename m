Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6FBC200A6
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:04:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 336B4C433C7;
	Fri, 21 Jul 2023 19:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689966267;
	bh=pUDx32jMgVGVXpcOrqcmaoyvJr+Gcc7wslI7cwjPAgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QftUp+VEtN0STGr0r4ze+RxxizVoQAtdh79OJ5ZbABWo3sMxkaCtGMu7rQ+MOmdb5
	 fYqZNpr0E8d6ACaVBVWfzYmFgYg3ftAwnoDXk9oxlL7zxZxxXKe1ecPDph7am+cKOz
	 +6OXrCMR5e6y/fq63gEHSiLiaYJ9Mw1EBHyrEwMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Chanwoo Choi <cw00.choi@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 282/532] extcon: Fix kernel doc of property capability fields to avoid warnings
Date: Fri, 21 Jul 2023 18:03:06 +0200
Message-ID: <20230721160629.702775849@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
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

[ Upstream commit 73346b9965ebda2feb7fef8629e9b28baee820e3 ]

Kernel documentation has to be synchronized with a code, otherwise
the validator is not happy:

     Function parameter or member 'usb_bits' not described in 'extcon_cable'
     Function parameter or member 'chg_bits' not described in 'extcon_cable'
     Function parameter or member 'jack_bits' not described in 'extcon_cable'
     Function parameter or member 'disp_bits' not described in 'extcon_cable'

Describe the fields added in the past.

Fixes: ceaa98f442cf ("extcon: Add the support for the capability of each property")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/extcon/extcon.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/extcon/extcon.c b/drivers/extcon/extcon.c
index 6b0681666e8e1..6a0d55d627ad0 100644
--- a/drivers/extcon/extcon.c
+++ b/drivers/extcon/extcon.c
@@ -200,6 +200,10 @@ static const struct __extcon_info {
  * @chg_propval:	the array of charger connector properties
  * @jack_propval:	the array of jack connector properties
  * @disp_propval:	the array of display connector properties
+ * @usb_bits:		the bit array of the USB connector property capabilities
+ * @chg_bits:		the bit array of the charger connector property capabilities
+ * @jack_bits:		the bit array of the jack connector property capabilities
+ * @disp_bits:		the bit array of the display connector property capabilities
  */
 struct extcon_cable {
 	struct extcon_dev *edev;
-- 
2.39.2



