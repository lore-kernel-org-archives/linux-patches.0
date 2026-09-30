Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92C154F93A8;
	Wed, 30 Sep 2026 16:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785944; cv=none; b=NBv+kSvY1Zg0kUGqOflIidYD6XrSpiT4+qeD2PnAkmhd52nTzQgc6cZx7I6eWv3joErYwzjaZcfvti0pjr1vu9M+IB/2+iX5Wr20KYnsMtWwoOZgkvynhZKDcUbvj7ImwqTtU642w7vAAM5KI6e/ZuvgpLF5rUbLQhkKSWO2qKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785944; c=relaxed/simple;
	bh=+iO4QAH+322AxHhKVKOv3FMF7z8ogib3z0LjZF+hj/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FLCmppqEy7xatSvT2EeVMbMTaXa26o2wCmhWrJU5B04FfPwHm6fCZsyMIe/khEkFgRlaYoe4SFG31ZN75JRBeabLWemSrLNrVdtqCL6IZIXBO+xcWcixu/yNtC75kbjaWHCXegr+fsIHr3Bf4qlYhyWnX/ctFLcfM9bF+xYb2+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QLPc16/K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QLPc16/K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED0431F000FF;
	Wed, 30 Sep 2026 16:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785943;
	bh=w1kyUQKrvY84yd6jXr9P6DItO9VscAzHbVyfQxw7Clo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QLPc16/Ke5GWYD0ZsLQjU3E2J/p9Sy6Y7R0Neev4haJRxbQ5GG15+MtwDZclLoGHF
	 W7IB6hGKUWOO99xx2S5nZTXTLlRLZEev3j5MV1amLwoIDamv0y6yivXLuhSKCZr0Pc
	 EUPAQd3o0IxXREBa5Dp5Xkq07n7l1pfMl+Kr+BY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 642/982] scsi: qla2xxx: Fix the ql2xfc2target parameter description
Date: Wed, 30 Sep 2026 17:22:58 +0200
Message-ID: <20260930152430.557315786@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 3fdb120507419..e1578808e27ee 100644
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



