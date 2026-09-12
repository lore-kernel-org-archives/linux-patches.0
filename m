Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B361E2F8EAE;
	Sat, 12 Sep 2026 14:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221660; cv=none; b=r+ZbTSmUcSLgfVsBbKB3BpAgWeNoDEa1dIzgLGSnxIy8ioPtuiApW+yK7oKxyC5wFkq/Zhz/4i/OxL/o3fWzhCnIDqbBR1ZwsGsIR7dmXk5/AGaQw6fvfdAc44++y6iWLxufbMoyY60lz8bYWYtbZYVc6t6Wj+7yMWF0pAocXFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221660; c=relaxed/simple;
	bh=GxhlxEx00eO+I6MgH4BxwTIWeFgGKKgTo/DnkqikVC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I1f/pbe9x9rt18uoUQt/lKGO4FQZRSsOCQPqq/zlgWMXoo4+ru5WojJdUgYr6eqDiHa7JOFNPsEsYBZ7w/l8GhrWFDoWYolFM//C0f7GFi+lkkgKTDdYM8Po+e/4656pXLNMTmppAVX7/vfH/dyhNRmI/dxygFDqx9p81IUS7t8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VRXIg/1D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VRXIg/1D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CE801F000FF;
	Sat, 12 Sep 2026 14:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221659;
	bh=FI9Th67VYuYPtEd1E8bxLdMdorafnfJO0sxjvvZqZGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VRXIg/1D31NdFyH3HFPX19ScnFohdH2uXqFqdjq5xPDTwwWH7JmlTJSun5gOhtUxs
	 PDr7n9u7sy3jApbQ+3caHhjA574XUV1L2tpjrYy8M4lQf22znWe1H0AEkcO7IhcSan
	 mmZuwgu1yyIX5b9MqoIfXtEqxBIAF3bNMOpUY69E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikhil Gautam <nikhilgtr@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.6 0427/1424] iio: light: opt4001: Fix reversed GENMASK() arguments in fault count mask
Date: Sat, 12 Sep 2026 08:47:39 +0200
Message-ID: <20260912065616.846622192@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/iio/light/opt4001.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/light/opt4001.c b/drivers/iio/light/opt4001.c
index 2448d6330489..aa3d87995b7c 100644
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
-- 
2.55.0



