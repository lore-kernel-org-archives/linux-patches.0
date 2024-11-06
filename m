Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AC441DFD9D;
	Wed,  6 Nov 2024 13:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730899041; cv=none; b=PzlnFO1PpXjLtYhHp4k4hxtzCh1CXeZXCCvm036slfpofi1o2+HsTy1bWOx0O6xVaFAbyxIQva/YVfn+Dbcm0qMsB2IFbZE3iukPpSnYZnrEyqAZUlrZ3wpusYNGE72WgTYCTKDhD94baHwGlAVJ7rdXcG7aWfZJR1OU1rNJlTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730899041; c=relaxed/simple;
	bh=QG83wDktA8bMXzn2LPFATbCP//I0S08wHIt2vPNxzY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b1mzPYXfpyDla6yacHc+l2IOdE+rpsI242iGt074M+0FiOSlB4mMRqVU3q3Q2PINKCEwnjpaQ/gayOoMSVIqe6ii88GFJW1KcYxw3Ik3vROnP+RuNUsCDn+g2rnjvSzWoQlLdHP6J+31gK3XPeQNYkvYT88fzT7Gmyoc4o5KvL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WPDscdGu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WPDscdGu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EFF8C4CED3;
	Wed,  6 Nov 2024 13:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730899041;
	bh=QG83wDktA8bMXzn2LPFATbCP//I0S08wHIt2vPNxzY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WPDscdGu4TjH1GetednASfL5zvxpzUTVitqbVbFVjCwhjUXU2Dj0rWt81/PVLXet1
	 cV37RGqN5quJ4dlTzvSgmY1TB3erLkaUsKWJr0MvLjHxfug0tg5nyxSS6Yiy3kt4wu
	 8NWFGm/AGFjw94eLWQuDAUMH1c1WtcN8oErod7Bs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zhong jiang <zhongjiang@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 442/462] drivers/misc: ti-st: Remove unneeded variable in st_tty_open
Date: Wed,  6 Nov 2024 13:05:35 +0100
Message-ID: <20241106120342.418481200@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: zhong jiang <zhongjiang@huawei.com>

[ Upstream commit 8b063441b7417a79b0c27efc401479748ccf8ad1 ]

st_tty_open do not need local variable to store different value,
Hence just remove it.

Signed-off-by: zhong jiang <zhongjiang@huawei.com>
Link: https://lore.kernel.org/r/1568307147-43468-1-git-send-email-zhongjiang@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: c83212d79be2 ("firmware: arm_sdei: Fix the input parameter of cpuhp_remove_state()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/ti-st/st_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/ti-st/st_core.c b/drivers/misc/ti-st/st_core.c
index c19460e7f0f16..7a7a1ac81ad02 100644
--- a/drivers/misc/ti-st/st_core.c
+++ b/drivers/misc/ti-st/st_core.c
@@ -709,7 +709,6 @@ EXPORT_SYMBOL_GPL(st_unregister);
  */
 static int st_tty_open(struct tty_struct *tty)
 {
-	int err = 0;
 	struct st_data_s *st_gdata;
 	pr_info("%s ", __func__);
 
@@ -732,7 +731,8 @@ static int st_tty_open(struct tty_struct *tty)
 	 */
 	st_kim_complete(st_gdata->kim_data);
 	pr_debug("done %s", __func__);
-	return err;
+
+	return 0;
 }
 
 static void st_tty_close(struct tty_struct *tty)
-- 
2.43.0



