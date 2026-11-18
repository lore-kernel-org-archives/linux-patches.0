Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043094;
	b=0+xGFuhvyI3g5GjpJpP3S5PFu/44iFwOdNbsRzjazyCD8bxYS3AoC4IdNRXrhUCQU75d
	 UVIn6zvyyB5qw72YCcHmyiUPTPXYsucyFh5SDKaGAtxpYO5uluKTnPRsoRRuiPPTfBhdU
	 TFUO5JWCvB0o0j3WuO7xpy2KFENB3DJyabXlafhTCcN4EeVTDWno8XyGpQb3g7Sai+zHs
	 zCeR/VX6dHJ1aRO8CPSAeTV61ALIFPSAMzwOSbblzGTGFXrFVS02pZyfElJKdwTCI8MKf
	 c8Wfnk27soE3B/R6SPjiqTqx1CJblvDgHxamHgEzygxwek+XqGn2UzRoXhJz4ls2/gQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043094;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZTImoLPaXZvn8JUOiNkXd8/0XH1Op6n/PxNOxQfy74I=;
	b=MQK/fbO9FtiR1/r6Qckt4WL7hZa2wC7elImAk6o2ki+iJ04TiP5CQdGxmm4jGa4TSuT1
	 4LTx7gjytF8Q9LCAqIzkvXjebQtp3QDRjC0Hqg1Ib9gVS6A8hkoIFurCFaVhyChR92bwG
	 FMBIX1rxZxMu42X+87Y7WpAH81BE7rmk/PZCgz1vvrmTIkKUwlyBXCv/kRGwz2hb7becn
	 pl+v3eXXLhcOgInMV1M9swvnN5nRa7eQsMjYwVQCV5bSYIyOWJ5z66gYDV8fOeEdmjAan
	 mq5ZODbDUeWU/uzWO3GLZ8IziEiOKy8zdGd0amb2nvIMGEJjmxDSPBGuOB5HEqqlLMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sTQ7rhWH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6AD7606A32C;
	Wed, 18 Nov 2026 23:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sTQ7rhWH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1907F1F000C4;
	Wed, 18 Nov 2026 23:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043094;
	bh=ZTImoLPaXZvn8JUOiNkXd8/0XH1Op6n/PxNOxQfy74I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sTQ7rhWH0JsK8zxSArzC2wUSRTSRwjML12mUAmxFmHP7w0YGQ93x3gOF3o4abVtOp
	 QgCunDisghcomfvNQ7ALlQ4lOfTdkr0UYMDhw/dAcZINEch3973txXuWW9wkefND72
	 GUdhZp3/K99WYZegBjYVtjX47f5XmNIFAlxyijWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tanmay Shah <tanmay.shah@amd.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0061/2857] remoteproc: core: Full attach detach during recovery
Date: Wed, 18 Nov 2026 15:18:15 +0100
Message-ID: <20261118150203.499567785@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tanmay Shah <tanmay.shah@amd.com>

[ Upstream commit d93ffd549fb4df18c934ca7a47d4128a18c718cb ]

Current attach on recovery mechanism loads the clean resource table
during recovery, but doesn't re-allocate the resources. RPMsg
communication will fail after recovery due to this. Fix this
incorrect behavior by doing the full detach and attach of remote
processor during the recovery. This will load the clean resource table
and re-allocate all the resources, which will set up correct vring
information in the resource table.

Signed-off-by: Tanmay Shah <tanmay.shah@amd.com>
Link: https://lore.kernel.org/r/20260630004806.3835488-2-tanmay.shah@amd.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/remoteproc_core.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index fc92de3cc0de2..80ea239394875 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -1782,7 +1782,20 @@ static int rproc_attach_recovery(struct rproc *rproc)
 	if (ret)
 		return ret;
 
-	return __rproc_attach(rproc);
+	/* clean up all acquired resources */
+	rproc_resource_cleanup(rproc);
+
+	/* release HW resources if needed */
+	rproc_unprepare_device(rproc);
+
+	rproc_disable_iommu(rproc);
+
+	/* Free the copy of the resource table */
+	kfree(rproc->cached_table);
+	rproc->cached_table = NULL;
+	rproc->table_ptr = NULL;
+
+	return rproc_attach(rproc);
 }
 
 static int rproc_boot_recovery(struct rproc *rproc)
-- 
2.53.0



