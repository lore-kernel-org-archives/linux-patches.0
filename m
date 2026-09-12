Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 058BF361DDC;
	Sat, 12 Sep 2026 13:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218808; cv=none; b=kHT6RoERIas0XUsRXSJXegtPjNSK5mU+tLBYIvAx5uAEEvCf5IKxTIm84gzT2foCI+cgWe0OU9h+PLW4u+KnAfns0BT2Oof/G7y1NMJJTIDKxgZnJqImK+JE6Wm1KGdkz0yi9m4WWtka6Q6y3tnQdBnkd52o24NjycybP5T8ryM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218808; c=relaxed/simple;
	bh=x30b1wa3TZLtGFYJTvylVH02ahtU1kVM9fmEoW5MBX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i9CDYQtmqyND6YynxnhmyqOGgx93/LAjgZIIznxcu7ZrK7Q9DGvI5lWKpETmUUXIAsMR+JXKguJ7JPGgpPehPI9ckPOuaHCCHRoL3psuGw1IhXiST67QVLbKlWkG0wz1JcgmPq5bbboZ7xnd8XM3SFNo+LdS+hOklSxAwh4wWUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v0V7BzEs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v0V7BzEs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3977B1F000FF;
	Sat, 12 Sep 2026 13:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218806;
	bh=eRV3jaK+e/O12naa2GWe1OmhFfzZ6s/Vl3lF4/LCKsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v0V7BzEsWCtULumIEmlyFIU1rG2QJl0WolOT+pBA7cTT2djeRUBPyuPYv7M+Q+UDT
	 stjMQ6H9E8kIvVNA1yrTogUxM9Xo1DGZMaHsac/eHZmK3ysOoi6jd4mWkrLB+3To5Q
	 9VaaxMO2WbGFM0W0W2L4x5xUeyxNh2eCXpzHaqJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Kulikov <nikolayof23@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1221/1376] mlxbf-bootctl: fix the build error with FIELD_PREP()
Date: Sat, 12 Sep 2026 09:00:47 +0200
Message-ID: <20260912065634.762491940@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index dd5f370c31682..73f74c61df2a6 100644
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



