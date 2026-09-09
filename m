Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48D1F3D967A;
	Wed,  9 Sep 2026 14:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962440; cv=none; b=huvQItoxuoKPkLaIYX2FlcjJ419OP/TGzQSI+OAM5fVhLFVjMeCJ+XQZGetigZEMtpX17a7ttZSJM+PlGNbYE5cbnGSJhzVKwY0XaxcStT1TbMLRIXhHDbP2dYmn+ZsY4YeYXQBuzZmWQNGTFjfYkWsl71c9gt62ppAxwQAP9N8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962440; c=relaxed/simple;
	bh=DcllqopzArz7yV0+EbUkAm0IDfD3EVOV+IL2eqtgwnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lwtn1YbxYrgJ4jTXzSXwVkRLVi5XHePkowBK7x9bgVYwX39GPYaEPlLF+5UsUr4Dw4kCxuB/dkUnhAkEkyr0v7hPALGFm/JWSC5wDy8H/UT6V9ozCf/YFpV2gUjfJCEHSvXBBXQB9lFAc71KvmfVT6bRhv+FE2m7s+12p/n55Bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=McBCgECM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="McBCgECM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A128A1F00A3A;
	Wed,  9 Sep 2026 14:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962439;
	bh=XA5PTtrKdW2ncTAETqJOYOpUbRVEIjqdH5bO1ltfYZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=McBCgECMLtuvq7Jsx+tAJ7inoI6IoMWRxupZrn/hIzxi0TsQEOkxmg3pqhLyWjWIB
	 Ciq/ujvS14kxSDpmG5s3pPEwk1OX0qCTrftSDfq3MAmM2NvD0z7mCKFU3woj39umfo
	 U381/8cuX87Jjgqm7W0JqgnYYOwacMJmwSZWWcTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikhil Gautam <nikhilgtr@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.2 290/556] iio: light: opt4001: Fix reversed GENMASK() arguments in fault count mask
Date: Wed,  9 Sep 2026 15:39:30 +0200
Message-ID: <20260909134240.886401033@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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


