Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9CF15678C1;
	Wed,  9 Sep 2026 14:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963188; cv=none; b=knsI4FgY8mfbgkvMFsI1mp3Gy2y813x5rl01Ix6gczUAgLyaJzaKMUYliMJTv8dQvfOzJNXZSD9CqnkpRn7ZK2/Ox7Kb6U9XMrMEXmZvZIt4jKQX3M6zgk2VCXrzgPYEHgKmLMwU0eBCx9/4h2xKOKVb7BFjnKV5U6NEXefSoFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963188; c=relaxed/simple;
	bh=IF7I45RVeCmj5PX1HUf51B52pyE9xiNPK6DgucfeVPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tr9TN4h0cczvYlzYTSElJcsUv9SW2P803hmCiGpZsqAVh+Z4p4Zg+UBw8H27RN3Q1ln3HCS0C/yY2z/zV7UKiw9oYSbHkznxRal2+PsW7aVj/ssXc3wiPeRUqnEEL/kKfILWqc3MbvMxxT/YWMeMZQy+uVopbNqgGqHH8HD+h4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q9v+Qb5j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q9v+Qb5j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 422411F00A3A;
	Wed,  9 Sep 2026 14:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963186;
	bh=nSTIRCUqnUlzvCno9B8hNneEK3VX24neAHqQTizOZxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q9v+Qb5jaN88D8OAVcD1PCAqELoon81DlIMDNfOAt03VsE8umcS5AqnU7ItK/P1xK
	 2APPbZMln8dlT+zVsN3BJprKjmnvRqMcT2+OQf6Mbapb+GJCGD1PI/ZujpXcLIzmAH
	 W6Szk5SkNZZ7rzQ7j7xiYk9BGzF2OQFPpQsan2pw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 548/556] remoteproc: qcom: pas: Guard dtb metadata release with dtb_pas_id check
Date: Wed,  9 Sep 2026 15:43:48 +0200
Message-ID: <20260909134249.665622034@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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
[ changed qcom_pas_metadata_release() to qcom_scm_pas_metadata_release() for the older branch API. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/remoteproc/qcom_q6v5_pas.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- a/drivers/remoteproc/qcom_q6v5_pas.c
+++ b/drivers/remoteproc/qcom_q6v5_pas.c
@@ -240,17 +240,14 @@ static int qcom_pas_load(struct rproc *r
 		ret = qcom_mdt_pas_load(pas->dtb_pas_ctx, pas->dtb_firmware,
 					pas->dtb_firmware_name, pas->dtb_mem_region,
 					&pas->dtb_mem_reloc);
-		if (ret)
-			goto release_dtb_metadata;
+		if (ret) {
+			qcom_scm_pas_metadata_release(pas->dtb_pas_ctx);
+			release_firmware(pas->dtb_firmware);
+			return ret;
+		}
 	}
 
 	return 0;
-
-release_dtb_metadata:
-	qcom_scm_pas_metadata_release(pas->dtb_pas_ctx);
-	release_firmware(pas->dtb_firmware);
-
-	return ret;
 }
 
 static void qcom_pas_unmap_carveout(struct rproc *rproc, phys_addr_t mem_phys, size_t size)


