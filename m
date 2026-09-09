Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BD08237180;
	Wed,  9 Sep 2026 14:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963260; cv=none; b=kszsLJw3Q5t8Wta42uo+r2uUs7QTYrZXibz3mzMkQXTv7V3BP5Nwe1RmiLTbHkBmid90Bbl1v9zzfAfm2OPR2b3vYCzGbxul5vtVHOkKHElM5XfT8S4PPf9dCJj00RrI/KZvSBWRWDjheOUapOZ5ozB7FGTvdkxsgmXQwbl3Png=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963260; c=relaxed/simple;
	bh=/Envc1M4TTcnJp5YP+dScfPxFhgwR6Ho7sZR7r2VWe8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=timJw2G1jCdSHo+Nc+yzrtTpUPndd9y6WTpkfc20m0+lDiZP3w3hz4+BJxk9lhfdITMVtOuU4UYEfJcYVe+buR+Of8X5R7XIl0MK02lwUVwJVTtKajCzKc1uj07JNtU2QUXGmQa1Ey00L5q3Lc52cVCj9XWU3+6ZyywOUHBBKOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eR5Mk9RN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eR5Mk9RN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E9041F00A3A;
	Wed,  9 Sep 2026 14:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963258;
	bh=0Aiv8hnS2kKRmh/6azW67nhDMFeoyXwHzCD5i+kbv3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eR5Mk9RNSSpzHQhxPygTWxbdXoVq76c4US2Vdq0Yvh9DD+9sqRYLjSvNu0Th8GpEN
	 anj0DTDDGy0AdIto1PFBEgMQbPg3iKPnT9TtSGZYKyoTf+vtP6jxVgEJ0XSJQwexIo
	 NMsBUJ1Mt+tflkTKfQjfTr2btyv+BFl2MNpxofu8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 6.18 018/583] usb: f_mass_storage: Bump local buffer size in fsg_common_create_luns()
Date: Wed,  9 Sep 2026 15:35:03 +0200
Message-ID: <20260909134238.447057311@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit 9f6f095beec82a80daa666a3b2186a5b95841e9a upstream.

GCC (Debian 14.2.0-19) is not happy about the buffer size:

drivers/usb/gadget/function/f_mass_storage.c:2970:48: error: ‘%d’ directive output may be truncated writing between 1 and 9 bytes into a region of size 5 [-Werror=format-truncation=]

Bump the size to get it enough for all possible values.

Note, although cfg->nluns is limited to FSG_MAX_LUNS (16), the compiler
doesn't realize this and complains about the buffer size.

Also note, the existing comment is wrong as size 8 for the whole buffer
doesn't cover 100 mil numbers, hence drop it altogether.

Fixes: b27c08c953e9 ("usb: gadget: f_mass_storage: create lun creation helpers for use in fsg_common_init")
Cc: stable <stable@kernel.org>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://patch.msgid.link/20260817161239.1448582-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_mass_storage.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/gadget/function/f_mass_storage.c
+++ b/drivers/usb/gadget/function/f_mass_storage.c
@@ -2961,7 +2961,7 @@ EXPORT_SYMBOL_GPL(fsg_common_create_lun)
 
 int fsg_common_create_luns(struct fsg_common *common, struct fsg_config *cfg)
 {
-	char buf[8]; /* enough for 100000000 different numbers, decimal */
+	char buf[14];
 	int i, rc;
 
 	fsg_common_remove_luns(common);


