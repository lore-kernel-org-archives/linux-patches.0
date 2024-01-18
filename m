Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E396023765;
	Thu, 18 Jan 2024 11:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575762; cv=none; b=OJNvCAeGgJ02mrpJnXeRhTgbQHZPYVTDKPJ+ySTh6QkVjQiI9xYTcdhfyHX38eMl5BQIkEMZOTlI/ZgL9BEz5myoC1tSqVQUy0KtH2qPbHIuxTMeP8/E9lFE3PwhpiZG0VVxeGNhSAr+eCvx+9BcXbUmnvdUabSAAc0Vq2XNV+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575762; c=relaxed/simple;
	bh=R3sJQdEP6yFMB6YxRkNMXNByQnbJOMurA3TPTgYtpBQ=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=p9IthzfSRZZsWZq82hmRAU0+uELcxfrgL/w2DTUoN38Xm94k+JflxqnNj492EAatMdcJ4ryY4a6YuuvIZhtJT3VUVTo174Y1XdHcMMo5YMNnhR/sUzI6tgyyVs4qafdaun18neRhXA0f20v2cstC+/M4XDUzSfVDh/FI2xump1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PM3+ne+W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PM3+ne+W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61C4EC433F1;
	Thu, 18 Jan 2024 11:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575761;
	bh=R3sJQdEP6yFMB6YxRkNMXNByQnbJOMurA3TPTgYtpBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PM3+ne+WuZQfSSQm1bY9cq303qtjcxD2GCsyURAycXQBzKpQVBpVB0dc4JYwl9xxA
	 Z7zq0V13X/TCYG8iA3+Psyl+xcoC84YBA64WMk+sGu8JuugDr+/Mh7S/iQaHUx8zFl
	 LPYhPWbS54ofJl9riG3RfNdy4L9Ve5OhHKQbFEO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Ryan McClelland <rymcclel@gmail.com>,
	"Daniel J. Ogorchock" <djogorchock@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 065/100] HID: nintendo: fix initializer element is not constant error
Date: Thu, 18 Jan 2024 11:49:13 +0100
Message-ID: <20240118104313.763216284@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104310.892180084@linuxfoundation.org>
References: <20240118104310.892180084@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 8a8a3dd8af0c..907c9b574e3b 100644
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



