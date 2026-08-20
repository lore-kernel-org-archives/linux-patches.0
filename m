Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57A8B47A0DA;
	Thu, 20 Aug 2026 16:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243457; cv=none; b=BJ69RIzaIokorjePK+I2Y8C0gZRRmcbQGgvpFKEdAMWk408rC8puGYsL/oxCRbHU4QU047jisckkqbYgjRiifz2WD2gQqiFAvxTHdp5RvvuTQNGdwPcRk5VVncmlcWdI27DdcafAtyzYDEO5aqBprKLXv2O5WZAHJBk98gyjQno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243457; c=relaxed/simple;
	bh=Tm+pI2XNySqSPnfOUuCNYxCsHMyUFEP/MPUgXDJYlIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A6IHiRA/hDNgrnElbzDuubt68JebQRiyfKH2iVFSualll3RKRmyDH25M695VzG9OnnFxq5aOKJyJIBWMs7xYDiaJYQJ9vVIErgqd7FTtMKXlZOCx5vAe404+DEiezl52pCnT2C141nk89YrX1aatGO5nVtI6ErutK5QN4c0md7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PCpcwRCG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PCpcwRCG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACB5C1F000E9;
	Thu, 20 Aug 2026 16:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243456;
	bh=0WebkbxHcpn3zHF8Ao3j7R7DLF/ZQqGicLlrOux5WXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PCpcwRCGqHT25S83zxMxd2MkmqgtMDe7jfi497RaRwUf7qcYCCQ8cop29MGaoh+uL
	 XCgeQXUZxUHSQ5IsZLTgOlZrQZnZrViYtRZtCnVnd8dIkGeVbjnFRHNYvTZybMR9kP
	 khBGbjgm7zX6iLpKEtEeO1PxfO/Vt6lAMkxdIv1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mukesh Ojha <quic_mojha@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 101/272] remoteproc: qcom: fix sparse warnings
Date: Thu, 20 Aug 2026 16:54:45 +0200
Message-ID: <20260820145234.301874732@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mukesh Ojha <quic_mojha@quicinc.com>

[ Upstream commit 2554dd0ac362738f588ba073d8333eb9b14f9587 ]

This patch try to address below sparse warnings.

drivers/remoteproc/qcom_common.c:126:27: warning: restricted __le32 degrades to integer
drivers/remoteproc/qcom_common.c:133:32: warning: cast to restricted __le32
drivers/remoteproc/qcom_common.c:133:32: warning: cast from restricted __le64

Signed-off-by: Mukesh Ojha <quic_mojha@quicinc.com>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/1675180866-16695-1-git-send-email-quic_mojha@quicinc.com
Stable-dep-of: ecf9fc18e62c ("remoteproc: qcom: Fix leak when custom dump_segments addition fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/remoteproc/qcom_common.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/remoteproc/qcom_common.c
+++ b/drivers/remoteproc/qcom_common.c
@@ -123,14 +123,14 @@ static int qcom_add_minidump_segments(st
 
 	for (i = 0; i < seg_cnt; i++) {
 		memcpy_fromio(&region, ptr + i, sizeof(region));
-		if (region.valid == MD_REGION_VALID) {
+		if (le32_to_cpu(region.valid) == MD_REGION_VALID) {
 			name = kstrndup(region.name, MAX_REGION_NAME_LENGTH - 1, GFP_KERNEL);
 			if (!name) {
 				iounmap(ptr);
 				return -ENOMEM;
 			}
 			da = le64_to_cpu(region.address);
-			size = le32_to_cpu(region.size);
+			size = le64_to_cpu(region.size);
 			rproc_coredump_add_custom_segment(rproc, da, size, NULL, name);
 		}
 	}


