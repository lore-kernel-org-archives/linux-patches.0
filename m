Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 264863FFFAF;
	Tue, 21 Jul 2026 17:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656008; cv=none; b=XSJcZNjfG3+snV3oAaDGzmX0mgTRsHGrDbfqSF63iEJ8RlS6cti+4cZRMYJgywyUTBEH5JBKM/0KzKANhpOLbfz3fmE6Yn0hYNwoco/BKiBb03dO1iFMnuZVmwdGlamobCJyo8C7DTCnx9HTVpz0FRovd6xPWLW6bntF2Bpf77c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656008; c=relaxed/simple;
	bh=J2OyN0kmqpRPMZVJ6Tm1a35JG4Q27MSSMdeJPg8QXOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S8OI2gobN65DWomuQHDUlJvuC3ladRzmBzsOJ9OGpn+k2wQRcajB3YxBAiUDcrky6rSeFJLt8rb35xrz2CnJnZJ1LyN69Rna4iufCrno+c6KCi7MMcBHbWvCpCbYQWMhYFfsxwQOIheXOkLihjETfxGnEdmsOSZh575ktlhTkKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HVPYy+Cw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HVPYy+Cw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48A091F000E9;
	Tue, 21 Jul 2026 17:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656006;
	bh=r0grt9cote6QRvQgUu1igd2gRlEysWHhU0g1k6PeWJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HVPYy+Cwfxk3dvpm3BYGmFxCLsw72WrVxl10220S4sgo+1oZEKqvucKLd9NN53+Ec
	 OH8105BMILZUlAtYmsXcHjEOlLbtxaocaLRQOeO6d35LSFtCLTDE2YKVK2DaEiCJQQ
	 0S4sdNMjy8y6yRJtl715pHxY0wS0BzhJRmCURvNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0223/1611] driver core: Fix missing jiffies conversion in deferred_probe_extend_timeout()
Date: Tue, 21 Jul 2026 17:05:39 +0200
Message-ID: <20260721152520.018467860@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Danilo Krummrich <dakr@kernel.org>

[ Upstream commit f9e6da99fe49277979798a1c3b9790ae10aaa18a ]

mod_delayed_work() takes jiffies, not seconds. Thus, restore the dropped
conversion.

While at it, fix incorrect indentation.

Fixes: 1137838865bf ("driver core: Use mod_delayed_work to prevent lost deferred probe work")
Tested-by: Biju Das <biju.das.jz@bp.renesas.com>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/20260525012340.3860581-1-dakr@kernel.org
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/dd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index c42643e26e28af..175d9be6455dd2 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -328,7 +328,7 @@ void deferred_probe_extend_timeout(void)
 	 * start a new one.
 	 */
 	if (mod_delayed_work(system_wq, &deferred_probe_timeout_work,
-						 driver_deferred_probe_timeout))
+			     secs_to_jiffies(driver_deferred_probe_timeout)))
 		pr_debug("Extended deferred probe timeout by %d secs\n",
 					driver_deferred_probe_timeout);
 }
-- 
2.53.0



