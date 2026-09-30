Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18ABF51FCA3;
	Wed, 30 Sep 2026 17:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789702; cv=none; b=rZQDoowKezFyeCfhEHrHiBVhNIrN9Y1aKmOs1latTtzzX6BMh8StC/jMnhWH01nRpBwIZOWW15AUTN80r+o+FO87YgEBNdftBg541ppZ1PBd0mMjDVss9rPfuoNRTN6fu25Z4tDsaxyJJQwlsJfrWW9MZ37FaQZznv7+qtkJ2A0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789702; c=relaxed/simple;
	bh=nJvaww99Z3iMgwb0cbmdN54LMDGJzjeNMdJtGYJMCLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nbqk27N0YHflKQYELd6QFU5BE5zStgAF0rT3Ee7LLRbXRtC+In3DxHg2Ep11u9vpbSNSH4GrcmBio7RI14W952tBrYabIy80Kur5gVQcvbKLylSKbaq4otPJsIJHjnAFNvA9lv5ePcC4qWmxmRQWBjNMv8+FBO4RirSsAhbi3SA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vjG9GdEY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vjG9GdEY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DDB01F00899;
	Wed, 30 Sep 2026 17:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789701;
	bh=jrv9MRMWheg1ofooongatufC/nhERSqtoXZdK9TCUdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vjG9GdEY/Sk00/mEyxY5EPhWsu+wL7DbgqZ9jWs40Vl0aTQkOVvdAHZTotb+8GPwb
	 ljWNb0qaB2IDEZEChvzqKjWeNYYIsL/b3cF0zClANx3RhM4kalJiD4h+21Dyp/eOj1
	 bwtxztDbOqXCB+tiL1cCmLxb/PJYVHZkYm0LrYPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 570/877] remoteproc: qcom: pas: Guard dtb metadata release with dtb_pas_id check
Date: Wed, 30 Sep 2026 17:24:41 +0200
Message-ID: <20260930152426.941807714@linuxfoundation.org>
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

From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>

[ Upstream commit c06c5ab4945392d2c2aded6d832ab6b58cabe351 ]

All other call sites of qcom_scm_pas_metadata_release() for the DTB
context are guarded by a check on pas->dtb_pas_id, but the call inside
qcom_pas_load() was not. Fix this by moving the call to the guarded
block.

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Fixes: 29814986b82e ("remoteproc: qcom_q6v5_pas: add support for dtb co-firmware loading")
Cc: stable@vger.kernel.org
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260724182858.1868271-3-mukesh.ojha@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/remoteproc/qcom_q6v5_pas.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- a/drivers/remoteproc/qcom_q6v5_pas.c
+++ b/drivers/remoteproc/qcom_q6v5_pas.c
@@ -247,17 +247,14 @@ static int adsp_load(struct rproc *rproc
 					pas->dtb_pas_id, pas->dtb_mem_region,
 					pas->dtb_mem_phys, pas->dtb_mem_size,
 					&pas->dtb_mem_reloc);
-		if (ret)
-			goto release_dtb_metadata;
+		if (ret) {
+			qcom_pas_metadata_release(pas->dtb_pas_ctx);
+			release_firmware(pas->dtb_firmware);
+			return ret;
+		}
 	}
 
 	return 0;
-
-release_dtb_metadata:
-	qcom_pas_metadata_release(pas->dtb_pas_ctx);
-	release_firmware(pas->dtb_firmware);
-
-	return ret;
 }
 
 static int adsp_start(struct rproc *rproc)


