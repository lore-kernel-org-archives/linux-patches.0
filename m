Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2878A21B91D;
	Thu, 12 Dec 2024 15:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016559; cv=none; b=aX5Q9UaRltgqZLBlGx5/dxdPADGPvKd5own3LRSzw0mT+vu/8yezzpXObmOrD41qKP80OM1pg+Z7hTGr0u2wAgNM9f+ol31ENYUpgiIWWppq0YzeXyE4hDr2DcUtKZxReG/qS9IFSiI9jpmlVfVMJ2JxUNyucd6n+avMk9XYPWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016559; c=relaxed/simple;
	bh=MRBerEFv3EaQJZuDsbobaSa9OHWmR+W48bptJ4ecSTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oE2sx6tZLNvfMrDgTFxvO+QYZxIFfy9lNff3lB0Ba/mC1NJPKKUWX1sGFxRpXUyWRrWIX5lLsjHLin1IR0hCv7bwmzq5e/v9ggQLJALa8GTGJ/XruepIhmE2vOIgMb7/0Fdi0f+/I19aB3dcJmyU/BBkDHUKZC1TFkC+m1Wk3Qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fX0OkJtA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fX0OkJtA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A333C4CECE;
	Thu, 12 Dec 2024 15:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016559;
	bh=MRBerEFv3EaQJZuDsbobaSa9OHWmR+W48bptJ4ecSTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fX0OkJtAgZFSfcMpw/sqTRR8rtJ7mBBpFsBm6l8ZSkqbbuUUwf1k9gcif4AdqL96C
	 R+BuGz79UmrwUCTMo3M4Mo30CTUX0eF7wFMRn+PiqTt+NlC/alYXiev50CAz9ji+UT
	 Lx/XJ83dwzgGpY4c+6CuKUVs+UrgaOUAbSnh2QpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.12 233/466] iio: magnetometer: fix if () scoped_guard() formatting
Date: Thu, 12 Dec 2024 15:56:42 +0100
Message-ID: <20241212144315.985907188@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Rothwell <sfr@canb.auug.org.au>

commit 9a884bdb6e9560c6da44052d5248e89d78c983a6 upstream.

Add mising braces after an if condition that contains scoped_guard().

This style is both preferred and necessary here, to fix warning after
scoped_guard() change in commit fcc22ac5baf0 ("cleanup: Adjust
scoped_guard() macros to avoid potential warning") to have if-else inside
of the macro. Current (no braces) use in af8133j_set_scale() yields
the following warnings:
af8133j.c:315:12: warning: suggest explicit braces to avoid ambiguous 'else' [-Wdangling-else]
af8133j.c:316:3: warning: add explicit braces to avoid dangling else [-Wdangling-else]

Fixes: fcc22ac5baf0 ("cleanup: Adjust scoped_guard() macros to avoid potential warning")
Closes: https://lore.kernel.org/oe-kbuild-all/202409270848.tTpyEAR7-lkp@intel.com/
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Link: https://lore.kernel.org/r/20241108154258.21411-1-przemyslaw.kitszel@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/magnetometer/af8133j.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/iio/magnetometer/af8133j.c
+++ b/drivers/iio/magnetometer/af8133j.c
@@ -312,10 +312,11 @@ static int af8133j_set_scale(struct af81
 	 * When suspended, just store the new range to data->range to be
 	 * applied later during power up.
 	 */
-	if (!pm_runtime_status_suspended(dev))
+	if (!pm_runtime_status_suspended(dev)) {
 		scoped_guard(mutex, &data->mutex)
 			ret = regmap_write(data->regmap,
 					   AF8133J_REG_RANGE, range);
+	}
 
 	pm_runtime_enable(dev);
 


