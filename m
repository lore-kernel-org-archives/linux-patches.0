Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC4E173352;
	Wed,  3 Jul 2024 10:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003670; cv=none; b=gtouxFGCujmEUD7YfneuyxLzEBsqO1i2JoyZasONbVppo0UopdGlMoovf1IEesdAglfcUlxiK33EMUGjmDshw+rAum2z3o7ll7ifiKqygCgLf0gw/sjSybjun0KWuPDzrl3BTys9ILQmttmPMb2JT0cntZj11HMpN3b7FYOTafw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003670; c=relaxed/simple;
	bh=uAs7w6EovLHfjyFs9sUCLwPwyKDHyGEIxFbr5C8rfh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qHDqRkE252XgpF+x378QnoBmLt8xnWy6m5l6BJGGw0bQ3weUMth6f+g/bRzmjBc+HBPEV1dSuvjUD4rzSZjdpCJaIfxiiWM0SPGDJ5xED3sPnRHHgiubrQfki9y0/u5g3ag8L6RrjPI6A+0zhjZs8V0jY980gRVM4yMpXQXbpxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uUpzKIRx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uUpzKIRx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1993C2BD10;
	Wed,  3 Jul 2024 10:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003670;
	bh=uAs7w6EovLHfjyFs9sUCLwPwyKDHyGEIxFbr5C8rfh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uUpzKIRxkwn7kOJS8qqAf54jInQje9O02UkToENbz3FC/pP+ztCDQnQN28pulDIb0
	 XN4YnNi2QUi5EIRtTuOFxK/mvT+k0+1BZRTgBQ0ctRBea5Ag38+VfUhgGvs6xvOjhy
	 s5DFMTXLHzKZzA6sHWXy10EEpVVVSHINI0hpchGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Perches <joe@perches.com>,
	Suganath Prabu <suganath-prabu.subramani@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 093/139] scsi: mpt3sas: Add ioc_<level> logging macros
Date: Wed,  3 Jul 2024 12:39:50 +0200
Message-ID: <20240703102833.952003952@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
References: <20240703102830.432293640@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Perches <joe@perches.com>

[ Upstream commit 645a20c6821cd1ab58af8a1f99659e619c216efd ]

These macros can help identify specific logging uses and eventually perhaps
reduce object sizes.

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Suganath Prabu <suganath-prabu.subramani@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 4254dfeda82f ("scsi: mpt3sas: Avoid test/set_bit() operating in non-allocated memory")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_base.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 96dc15e90bd83..941a4faf20be0 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -160,6 +160,15 @@ struct mpt3sas_nvme_cmd {
  */
 #define MPT3SAS_FMT			"%s: "
 
+#define ioc_err(ioc, fmt, ...)						\
+	pr_err("%s: " fmt, (ioc)->name, ##__VA_ARGS__)
+#define ioc_notice(ioc, fmt, ...)					\
+	pr_notice("%s: " fmt, (ioc)->name, ##__VA_ARGS__)
+#define ioc_warn(ioc, fmt, ...)						\
+	pr_warn("%s: " fmt, (ioc)->name, ##__VA_ARGS__)
+#define ioc_info(ioc, fmt, ...)						\
+	pr_info("%s: " fmt, (ioc)->name, ##__VA_ARGS__)
+
 /*
  *  WarpDrive Specific Log codes
  */
-- 
2.43.0



