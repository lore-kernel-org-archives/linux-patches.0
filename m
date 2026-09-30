Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4AE34BFE95;
	Wed, 30 Sep 2026 17:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788310; cv=none; b=iTH5eWmROdjqQnK7p/0KU7sGj6paepvKai15wp5Fb7MpOqXqyBcSQThCtvQeyWZyfMdj5wtH9GsZczoEjMiOKidA6uX/TzIcO0YaZt5oSwpj/uq5Wd4dFpTxoUscYC6TPATZwA67Q+qwkH66QNKJH4Cj311mOCdpZfQ56H2hvNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788310; c=relaxed/simple;
	bh=qCuORPTxUE6cJKoGhb+o6vpKmCj9oHmaLHmiy4Cyuq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CiIml402QvIbrOQlv9xXhgZhpyU+NoCCa3U6g+x3qq4RiiV+Tgd8F5lybilmO0eujH2ViCUUjyZo/IbIBKqGEr43klLied4qlXYdRmukyf+CoYIdHAz2sYB7/rRNCwf9K4v1NBgtzSSYUMu5RzBxducYmJJ8DcWxTRxHGvngnzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MD5V1Kt/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MD5V1Kt/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F7A21F000FF;
	Wed, 30 Sep 2026 17:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788308;
	bh=pCbL4dlAm+OhX3Ejtiw7jUCTD3itPvz9z1fLTRo2kts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MD5V1Kt/oLA8NgYv1vgjZtukr1cMAl+41DjKpqNR+ZzL3DFFd97D9K4UUVnYV+gX0
	 nle9MalKk1LMcnFvLXtnoy2IZeV51IjlDtrEHOY+kVYpjUXnelYRd7umwfMNCIn1Tb
	 CiXnAUpklna2IJMx4OOE8CILeHfZ1j42eP+LnV1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 080/877] scsi: qla2xxx: Fix the ql2xfc2target parameter description
Date: Wed, 30 Sep 2026 17:16:31 +0200
Message-ID: <20260930152416.466903970@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 7a78cff128cfa..e2c0c99a5b052 100644
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



