Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A21F30C60F;
	Sat, 12 Sep 2026 11:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213591; cv=none; b=KxYhFuxfuITzyELt5yS/X4dX9gsbeFsHxcADdQFB7cp8d8pyMKSZANGsAjDkM5oQkdjvh8RAuPGUm5lq7boWFRJAjjUueuL0MXauvt/TmI6oPCE2Hq96CTTe6C1mluqHOWL0kYZ/gcDsYcpkviNsILXhNNU530UJ/4jO+OhVbJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213591; c=relaxed/simple;
	bh=Iq7t/2S/e47Ps2XDQTdIOAV3uaPjALMr6hMsxcclBJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FdE8AC771g90/1TZIpuGWTepzGKD5N9lA1gYdOJPGhNCYnysrc010YvjYuQ6zTvpX1l4MFkLBr3BcDLXIT3fXwaUw47vdBk5d5M4ZX70kYy0ibg/qNkxwHRvUFatPZj8Tm/niKjzes3yuzTZP/Pye3Rl/vTDXrnhAbR3pPqsmH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LQn+sb/y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LQn+sb/y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E5891F000FF;
	Sat, 12 Sep 2026 11:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213590;
	bh=kRL8gHwT+MzFKagXOkbGW9ihoUfmCWSZ5nn7wfM93EE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LQn+sb/yIMHWIhC0elYC0dRBvpLbHHxKdVE39zAjg+qoVES0bEuT5alzPS/dEC1AC
	 TjwWfn9pK/KQGuNHW62FqSiZDB6mg7kUYboTawyJReoUV+ovewxEo7K1moKOKu52Ro
	 dHjIBUB7uQwJUWM989yGTh4PTsKbGhwZvnH7ghZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikhil Gautam <nikhilgtr@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.12 0154/1376] iio: light: opt4001: Fix reversed GENMASK() arguments in fault count mask
Date: Sat, 12 Sep 2026 08:43:00 +0200
Message-ID: <20260912065610.982807845@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Nikhil Gautam <nikhilgtr@gmail.com>

commit d64bfd9f3352b9d9bdeca06de1a0a1c1bd47b896 upstream.

GENMASK(h, l) requires h >= l, but OPT4001_CTRL_FAULT_COUNT is defined
as GENMASK(0, 1). The define is currently unused so there is no
functional impact, but fix it before anyone builds on it, and add the
_MASK suffix for consistency with the neighbouring definitions.

Fixes: 9a9608418292 ("iio: light: Add support for TI OPT4001 light sensor")
Signed-off-by: Nikhil Gautam <nikhilgtr@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/opt4001.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/light/opt4001.c
+++ b/drivers/iio/light/opt4001.c
@@ -39,7 +39,7 @@
 #define OPT4001_CTRL_OPER_MODE_MASK      GENMASK(5, 4)
 #define OPT4001_CTRL_LATCH_MASK          GENMASK(3, 3)
 #define OPT4001_CTRL_INT_POL_MASK        GENMASK(2, 2)
-#define OPT4001_CTRL_FAULT_COUNT         GENMASK(0, 1)
+#define OPT4001_CTRL_FAULT_COUNT_MASK    GENMASK(1, 0)
 
 /* OPT4001 constants */
 #define OPT4001_DEVICE_ID_VAL            0x121


