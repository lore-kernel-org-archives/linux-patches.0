Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87AAC23741;
	Thu, 18 Jan 2024 10:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575346; cv=none; b=Kb/pioj0yCA3lJHpY8zlXYXUF730niOXvn31LjwfONJaDI0ILeixU+Tp7QW7Af/KrQ6uccHVjLHHn6GlR84/V22vNnm2+/157Fy78Hebohw+mSSe6zaRspi1RPwBMJJli5d1B0zdVW1iLhWXGTHz5/YS6FhZ2OACWMv6caVVo0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575346; c=relaxed/simple;
	bh=gGDPzRIpp8EwK9tcB7qR+enTeIpnsd5WMHdRC+nwNA0=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=hk14wc853S2Txf49F2n+8Bjng5INrPqd8IfmgDEvFjEzzRNADA0Uy7k5fv8ZDOzU6z9dTfG1a9OHkFG/uZB+iHcVPTBq47NOwYfpr6tAAF96ZbDb82Ws001Np1NKZAr7v4PO87vGU7jplHsDGa6AB2uZ5bwDlExo7s8GxEWNWjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jqauxi9Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jqauxi9Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1CDEC43399;
	Thu, 18 Jan 2024 10:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575346;
	bh=gGDPzRIpp8EwK9tcB7qR+enTeIpnsd5WMHdRC+nwNA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jqauxi9YUmBsUnl6ltMHJT2/5W7c54nbmhiEYSNUSdS+NMnOvgushRR9Kgi+a+KsO
	 jCV+YTby7FeUB+yIuSwakdHQz/uD7KQazov4xcsTmU0ZwIuhQDcJg34PrgJziTEoLB
	 tCV5toxozk2hVyVnVkqnjJ44wwYFFsO60c+PX3Ww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Ryan McClelland <rymcclel@gmail.com>,
	"Daniel J. Ogorchock" <djogorchock@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 100/150] HID: nintendo: fix initializer element is not constant error
Date: Thu, 18 Jan 2024 11:48:42 +0100
Message-ID: <20240118104324.677565403@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
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

From: Ryan McClelland <rymcclel@gmail.com>

[ Upstream commit 0b7dd38c1c520b650a889a81919838671b689eb9 ]

With gcc-7 builds, an error happens with the controller button values being
defined as const. Change to a define.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202312141227.C2h1IzfI-lkp@intel.com/

Signed-off-by: Ryan McClelland <rymcclel@gmail.com>
Reviewed-by: Daniel J. Ogorchock <djogorchock@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-nintendo.c | 44 +++++++++++++++++++-------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/hid/hid-nintendo.c b/drivers/hid/hid-nintendo.c
index 10468f727e5b..7644edee996a 100644
--- a/drivers/hid/hid-nintendo.c
+++ b/drivers/hid/hid-nintendo.c
@@ -325,28 +325,28 @@ struct joycon_imu_cal {
  * All the controller's button values are stored in a u32.
  * They can be accessed with bitwise ANDs.
  */
-static const u32 JC_BTN_Y	= BIT(0);
-static const u32 JC_BTN_X	= BIT(1);
-static const u32 JC_BTN_B	= BIT(2);
-static const u32 JC_BTN_A	= BIT(3);
-static const u32 JC_BTN_SR_R	= BIT(4);
-static const u32 JC_BTN_SL_R	= BIT(5);
-static const u32 JC_BTN_R	= BIT(6);
-static const u32 JC_BTN_ZR	= BIT(7);
-static const u32 JC_BTN_MINUS	= BIT(8);
-static const u32 JC_BTN_PLUS	= BIT(9);
-static const u32 JC_BTN_RSTICK	= BIT(10);
-static const u32 JC_BTN_LSTICK	= BIT(11);
-static const u32 JC_BTN_HOME	= BIT(12);
-static const u32 JC_BTN_CAP	= BIT(13); /* capture button */
-static const u32 JC_BTN_DOWN	= BIT(16);
-static const u32 JC_BTN_UP	= BIT(17);
-static const u32 JC_BTN_RIGHT	= BIT(18);
-static const u32 JC_BTN_LEFT	= BIT(19);
-static const u32 JC_BTN_SR_L	= BIT(20);
-static const u32 JC_BTN_SL_L	= BIT(21);
-static const u32 JC_BTN_L	= BIT(22);
-static const u32 JC_BTN_ZL	= BIT(23);
+#define JC_BTN_Y	 BIT(0)
+#define JC_BTN_X	 BIT(1)
+#define JC_BTN_B	 BIT(2)
+#define JC_BTN_A	 BIT(3)
+#define JC_BTN_SR_R	 BIT(4)
+#define JC_BTN_SL_R	 BIT(5)
+#define JC_BTN_R	 BIT(6)
+#define JC_BTN_ZR	 BIT(7)
+#define JC_BTN_MINUS	 BIT(8)
+#define JC_BTN_PLUS	 BIT(9)
+#define JC_BTN_RSTICK	 BIT(10)
+#define JC_BTN_LSTICK	 BIT(11)
+#define JC_BTN_HOME	 BIT(12)
+#define JC_BTN_CAP	 BIT(13) /* capture button */
+#define JC_BTN_DOWN	 BIT(16)
+#define JC_BTN_UP	 BIT(17)
+#define JC_BTN_RIGHT	 BIT(18)
+#define JC_BTN_LEFT	 BIT(19)
+#define JC_BTN_SR_L	 BIT(20)
+#define JC_BTN_SL_L	 BIT(21)
+#define JC_BTN_L	 BIT(22)
+#define JC_BTN_ZL	 BIT(23)
 
 enum joycon_msg_type {
 	JOYCON_MSG_TYPE_NONE,
-- 
2.43.0



