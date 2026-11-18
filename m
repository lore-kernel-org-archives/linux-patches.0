Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016300;
	b=epJGhxJF9k9dDf1G9pE/8yMKG9TSZ+mv1WuHxRnxTCHO24lbHLyFlTtw4f8puYbehMNM
	 9bLoRmUnshPLfmXxJ4xlEQl9nzvk6ZyuR/JacTv8dldhfOU+lico0VPTF0j3bAhVTI+1O
	 VdfWwAhCXHj++yafuFJp+IuzRAMkt559dnVWQrYJDWAFj+aD7GTsJ51ShuGTPTRd11n2j
	 sjojCsTIWH8Yo7IiPSvW3nXl0Y86GgumqSzii/RhjH5tIrgsj6Vxe/PEV6Xi8uWoY0N7L
	 BQtVQ2ANN6zTN6zYTH2tXp04625FGotZrBkxewm4r38eYnVCONGg1Q5Hbty+xQBzC7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016300;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ImzTUWSI3iv0yLh+deTzM2MwKxqYzizRE7lLQbYqjuk=;
	b=fIQx/zgxtzcJTQmRNnvGRkDgilCzK/C/nYnSDh//vAos5I3ve0eWgvb1PNUR2ZFHTcPj
	 Im1f5tdZMcpB0YZQii9rx7yQXI2IyCMIza0GANb9wbTJ57I5LuoAmc43vdb2MG1lg4YmP
	 jxiyVLxTwei7C/otKnT47S92LCbi955p59+n5j5YuPg75eNa/XHjGQMSoE07OatTKBiBD
	 UyrH1Y2jIWZCfp3t/SKUDVBSywroqKnZlgLWim3SyVJkTBoAjC6foK9hcshvE21cQUBTo
	 o0ZnaVk2TC9Srrsc3OKGkIcdxzzj7ExtMBDTB+G1VO4wZgrh7B96/GUqf1x0jAgdSag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vbBSt156;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D016960A2627;
	Wed, 18 Nov 2026 15:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vbBSt156
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31A491F000D2;
	Wed, 18 Nov 2026 15:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016300;
	bh=ImzTUWSI3iv0yLh+deTzM2MwKxqYzizRE7lLQbYqjuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vbBSt1563IFiKsICEjocDPm5fStEdKdoeP2OEXsClpE2pa0OpdE670O4cTfUurObP
	 VWAX1gUv1gnfMVTF6YpQrJosjs9THLCi3RKk9J28nm40nit3p2y6c9wzjX/WB1owFu
	 oN2j6vzGFSFC17qcNVdreBfdCeOrg5B6hdXSFbro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonghao Zhang <hyz3367@gmail.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0481/2651] remoteproc: core: Set trace buffer name for diagnostics
Date: Wed, 18 Nov 2026 15:28:41 +0100
Message-ID: <20261118150305.098141789@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yonghao Zhang <hyz3367@gmail.com>

[ Upstream commit e23eab619b0d2dd796618406ba25da62f4d539a2 ]

rproc_trace_read() (in remoteproc_debugfs.c) prints the name of a
trace buffer whose device address could not be resolved, but nothing
ever assigns trace_mem.name, so that the diagnostics always prints
an empty string:

	Trace  not available

Copy the generated "trace%d" name into the memory entry, so the
diagnostics identifies the buffer failed to translate.

Fixes: a987e6b91a5a ("remoteproc: fix trace buffer va initialization")
Assisted-by: Claude-Code:glm-5.3
Signed-off-by: Yonghao Zhang <hyz3367@gmail.com>
Link: https://lore.kernel.org/r/20260911081810.740028-1-hyz3367@gmail.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/remoteproc_core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index 1ed4067148491..263e12f022ea8 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -574,6 +574,9 @@ static int rproc_handle_trace(struct rproc *rproc, void *ptr,
 	/* create the debugfs entry */
 	trace->tfile = rproc_create_trace_file(name, rproc, trace);
 
+	/* keep the name for the diagnostic in rproc_trace_read() */
+	strscpy(trace->trace_mem.name, name, sizeof(trace->trace_mem.name));
+
 	list_add_tail(&trace->node, &rproc->traces);
 
 	rproc->num_traces++;
-- 
2.53.0



