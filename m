Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A57B3CAE8D;
	Wed, 30 Sep 2026 19:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796030; cv=none; b=ehPMwzCVBYWFqTDBQECwIg8sxxOWfFyT2/E2UYD3sLEk4pUs0Q9lqKv0JRClj5qonNl1SUQfXzS1uGGRf9SDGZ7JW6ixEUeOA7gBCjEaiU57TFjfpwxmGvqgocQHTLV1QN2aTgGC/tIOSK3//VoDBXuQ4uE0Gc9AqVBpnhe1c+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796030; c=relaxed/simple;
	bh=p1wVMtBXUTkfIO0j90qe+ulpI/Xeo/RrqyWLv1mYSWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KMonscmbW+Mq/tTXm+HnuegQgAB/r/zjHWSSvs7zWfiCF5feRrXGaVOwHQAoiR1q8vPgJr/a7aqhyT2PnO7+RF/oRksNArZsjSou62Y30/bztfKoKxaNOJFSyLNrvnwucxwjZSiC3lzqihJYwXn3F35AD/B9Sv+fLkqXBakJwMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xtwIjysi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xtwIjysi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B62C21F000FF;
	Wed, 30 Sep 2026 19:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796029;
	bh=RC0qEkd1wV/IYOXXcUvmtz/MTqzjpQxnjLJxcQ7VEkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xtwIjysiNRAgyciZlvdU44h8+yJ9yXJEN3Cg5Up9NpgGjVnJjOArjljqJACaWpMOO
	 goQnAiTP6mTc/fDok+oxm7zqpenrV/KmkYiax2l04TjMaD6/vRpMDk7hjMDc2MGMRX
	 EPbrqCRBD5IWFlb++0Xe2CVhDnOdRkl2I5QWxGNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0770/1193] scsi: qla2xxx: Fix the ql2xfc2target parameter description
Date: Wed, 30 Sep 2026 17:24:14 +0200
Message-ID: <20260930152451.363202936@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 779f202a92ef10a426efc07d0f4267918cb07ca3 ]

The module parameter is ql2xfc2target, but its MODULE_PARM_DESC() names
qla2xfc2target, so modinfo describes a parameter that does not exist and
shows no description for the real one.

Use the parameter name in the description.

Fixes: 877b03795fcf ("scsi: qla2xxx: Add option to disable FC2 Target support")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Link: https://patch.msgid.link/20260906171009.2560-1-kmehltretter@gmail.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_os.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index ba61b5ae433d4..ec165cd640336 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -363,7 +363,7 @@ MODULE_PARM_DESC(ql2xnvme_queues,
 
 int ql2xfc2target = 1;
 module_param(ql2xfc2target, int, 0444);
-MODULE_PARM_DESC(qla2xfc2target,
+MODULE_PARM_DESC(ql2xfc2target,
 		  "Enables FC2 Target support. "
 		  "0 - FC2 Target support is disabled. "
 		  "1 - FC2 Target support is enabled (default).");
-- 
2.53.0



