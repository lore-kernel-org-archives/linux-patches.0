Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B3AD3AD517;
	Wed, 23 Sep 2026 14:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174343; cv=none; b=eKCNWs4KioYNcfvhoM5qUTEAs7js9X8zWRHluJCfe1+jwyAJm6Kja4ojxglmvcIuDNGiG+slLEqZPBtsiq9eUxQyDbXk4CCGTXRKLJqCC8yeYZ6mTk2ThBpfXVBk0Kw52wh8upzQJTAmZSsLwh8+C1O9YUtlwIuP5zYTuWuTPqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174343; c=relaxed/simple;
	bh=3sGcRQ4nBur/AltzHwrZE8foC7tXV032hC4P7j2hHw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bToG/xYJNI1G0+/paLs3wPm+gmm15LouCbwg1NZv4KPgKp3lwiTnGbB0MgzGVCtFVTiCu9xL2IPtESUMAQvSAWLriLRgcXD/4Ati5RNggBxo5mrgswSOf6McS4ZOTSMXWb7Vz7r3oZKCM2x7WMIjuOFHtTU/69YwF6go2gDIAeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gHK4UuUD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gHK4UuUD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 158CE1F000FF;
	Wed, 23 Sep 2026 14:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174342;
	bh=/31JAzn8tkLyAlYGhfhoKkjPrf5XLJNumkk9acxh8Kk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gHK4UuUDoOEzEdNcSQBnfJrrGp4V+ZLw/rrRUrK+OPzBrGKpABroa8gJjJmcoY3yk
	 KPKH1+dwNQ7E4nohce2wnbAb9kgdQ3TI6Zik6Ob6iEAKsNp45BBDQbz1j/m1u5ZG9k
	 de0ZOSFOc6WUmHE3KcLA6XEKlGQTAaSbW59Phl+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 084/398] scsi: qla2xxx: Fix the ql2xfc2target parameter description
Date: Wed, 23 Sep 2026 16:02:38 +0200
Message-ID: <20260923140645.613478518@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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
index 3e148e4e94593..07ccfe0226c5e 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -351,7 +351,7 @@ MODULE_PARM_DESC(ql2xnvme_queues,
 
 int ql2xfc2target = 1;
 module_param(ql2xfc2target, int, 0444);
-MODULE_PARM_DESC(qla2xfc2target,
+MODULE_PARM_DESC(ql2xfc2target,
 		  "Enables FC2 Target support. "
 		  "0 - FC2 Target support is disabled. "
 		  "1 - FC2 Target support is enabled (default).");
-- 
2.53.0



