Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81CEC52ED2F;
	Wed, 23 Sep 2026 14:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172901; cv=none; b=kFDjnKj6WQAM9jrosfG6nybbsQ9DT/41+ILhk57DOhFrLo9ZGnE8Li12S3Mh0gkx3ex4pKDtxgtZbryHi29wc53fyUpHB7GOu/bfwtCCu0wR+5m7Zc5B+y/EqxWqHNtpKpJts7GJAm0KP8VKHnL9hbGF49HAkh0+qGkGkesygE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172901; c=relaxed/simple;
	bh=h3f9E6uX83l+mTUYpCNW9GaVVycifIPPqmtcR2fcDYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jmPOA9ueGaBpZYmPcX1DolzByK2vcAT2eebPuGmfJqhno0jTdhJN4pA+FpNLLy+Lvr7wYJDM85ZIiIoh9fcCT5WD8yZXcpISjetzy5nzNUffUM7ATFiCDf6fgOn8yo3g0YS3bhD4Ft2/8FGLx5SpxbqBx4XpjQr9z51fis+yPN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ycjq67pX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ycjq67pX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2A6B1F000FF;
	Wed, 23 Sep 2026 14:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172900;
	bh=5TfL8wMFwr/VfEsdYPIy4daX8IcELjngTSx/9xK0z0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ycjq67pXjOLj43dZ1s2tux8cr2NaByyvrdXgZNvADg1voHSA3Cv0GzgH/aaFPPowF
	 lM16e9PBml2C+FdOjnO86KaNdP5LfTGwv41GxRxMg2smicpy+A1arJx/IQ/7iUPVWl
	 RJLhTBCM6Et/BOVpEwDlHTXcvbfj7cROJooozRhc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 094/438] scsi: qla2xxx: Fix the ql2xfc2target parameter description
Date: Wed, 23 Sep 2026 16:01:55 +0200
Message-ID: <20260923140647.215662012@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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
index e0c5732037adf..f2114b386fa0f 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -352,7 +352,7 @@ MODULE_PARM_DESC(ql2xnvme_queues,
 
 int ql2xfc2target = 1;
 module_param(ql2xfc2target, int, 0444);
-MODULE_PARM_DESC(qla2xfc2target,
+MODULE_PARM_DESC(ql2xfc2target,
 		  "Enables FC2 Target support. "
 		  "0 - FC2 Target support is disabled. "
 		  "1 - FC2 Target support is enabled (default).");
-- 
2.53.0



