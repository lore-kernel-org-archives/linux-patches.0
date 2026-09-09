Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDBB2577E41;
	Wed,  9 Sep 2026 14:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963998; cv=none; b=Z2OFiHqTrAXITZkxRvq78PchvV1YRfVVQIthWmC/XQRokmlZzOCaPjI5eSYRPRpW+FKPa75xyZUs/fd7xr811aagh80XQ28cnKfFGEba9LWAWYQFO2f4wMUYq3na4lqYc4N62GN3UomoYkPsZzbmDp3s1y/5Z8wk9SAkjNLqEeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963998; c=relaxed/simple;
	bh=Y+RM2cpYPmRMX/EfbSqIluHdg+d7IHza4NCKQRVjslQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cLjfifJWJeDO61N7MbEF3dQtg1BcLzsOEAxE1jMcFFd1QGHqmH5qgwW2xp/HGnXamVe7MNkuMNHi/i4YJV1d0fOk8Vz5jt1rzME/qqwZbxwWHbVkDfaiJ7fSrppYdg4cwxekUqYQSbPPWXlDP8ewGC7MdWFInvn4utdtukPuDo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DoIqoSZc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DoIqoSZc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB1D31F00AC4;
	Wed,  9 Sep 2026 14:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963996;
	bh=7gQKwPyk9bfF4U2FhyL37uXPxwwRi7GnAzzhPbSQnjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DoIqoSZc8ad287ctchpcC90zsrkae3UlOi6X4LDffVSkhDvVUD98gLYDGTBya6by6
	 OpX7nNHrUzroeL5lxAk9D3l7M5sxF87mSMuXmJYYIJjShvA6cBmQREzZJ9orKs2QBV
	 8agxUd2S4bVIytpmJjcOnnBjO0dirJDwfJKf8TCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikhil Gautam <nikhilgtr@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.18 228/583] iio: light: opt4001: Fix reversed GENMASK() arguments in fault count mask
Date: Wed,  9 Sep 2026 15:38:33 +0200
Message-ID: <20260909134246.056002364@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


