Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FFF378C9C;
	Sat, 12 Sep 2026 15:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225934; cv=none; b=RYKVpaHISADdu1O8x0SWtiDGhSbl6qJZ9AKSvoKtfIBWCQTTcWO/z4aCEs7AogVHZ1TtoPm0QZhz2RZfQi5KQvsZRe2uOunEiFkhe5fRJ42faCVq3GWMuzHsSun487s+1xcrxEsREcSZ5DYguitU1vkyuAFew0Kxi0d9d8565P4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225934; c=relaxed/simple;
	bh=QAWdh+O1y30SV5wlAqwxkEZq+EfOwzNqu16Y2NUWhr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JcJC1qt5m2UBEckkp8xf4e8BSPEtwdnqj9Lph96ePjZi57Tj72eLk3JFiS7sbnsCCRmvblqKBE5C6m2mJCFor0kD6V4RMLLEEGgGV6lUYYh8fyHtMVvt8erxNtDO6Igml5P04CG8CACCITmuBPbUPveVTwbFlaysWhI8gQS3Kgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AL3dXx2h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AL3dXx2h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F3E61F000FF;
	Sat, 12 Sep 2026 15:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225933;
	bh=88CYZrkBTtZ0oSb5PTiKYhOMVJZKdn5YQzSVFu+4DPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AL3dXx2hzwt0liwUXtunQrMYioD+ZfhDhJej28IHy0ldrQh0Cs+DofV9aTVMh9JW8
	 n3AamFgJmioNFErpXZXRveYOx5JqXUkMN8sR+jxSwyuq8Do6dpvRDsapPvras3m8Bu
	 sRstnXYq3wlWtCpXRKSHGKYmf+wSLhNIq18IM40s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Kulikov <nikolayof23@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1299/1424] mlxbf-bootctl: fix the build error with FIELD_PREP()
Date: Sat, 12 Sep 2026 09:02:11 +0200
Message-ID: <20260912065636.358304408@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikolay Kulikov <nikolayof23@gmail.com>

[ Upstream commit 46b14c6f11f558362391e308f4f184ee867ef58f ]

rsh_log_store() calls the FIELD_PREP() macro without including the
required header file, resulting a build error:

  CC      drivers/platform/mellanox/mlxbf-bootctl.o
drivers/platform/mellanox/mlxbf-bootctl.c: In function ‘rsh_log_store’:
drivers/platform/mellanox/mlxbf-bootctl.c:429:16: error: implicit declaration of function ‘FIELD_PREP’ [-Wimplicit-function-declaration]
  429 |         data = FIELD_PREP(MLXBF_RSH_LOG_TYPE_MASK, MLXBF_RSH_LOG_TYPE_MSG);
      |                ^~~~~~~~~~

Fix this by including the <linux/bitfield.h> file.

Fixes: e9d1b2d0f7d0 ("mlxbf-bootctl: Add sysfs file for BlueField boot log")
Signed-off-by: Nikolay Kulikov <nikolayof23@gmail.com>
Link: https://patch.msgid.link/20260810-mellanox_fix_implicit_declaration-v1-1-352e647b8f28@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/mellanox/mlxbf-bootctl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/mellanox/mlxbf-bootctl.c b/drivers/platform/mellanox/mlxbf-bootctl.c
index e278092f889b9..2996b57564576 100644
--- a/drivers/platform/mellanox/mlxbf-bootctl.c
+++ b/drivers/platform/mellanox/mlxbf-bootctl.c
@@ -10,6 +10,7 @@
 
 #include <linux/acpi.h>
 #include <linux/arm-smccc.h>
+#include <linux/bitfield.h>
 #include <linux/delay.h>
 #include <linux/if_ether.h>
 #include <linux/iopoll.h>
-- 
2.53.0



