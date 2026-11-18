Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048317;
	b=ORhnw9FC7LnF9KKKikJDaV6H+kRG238RShQuvhIyraG7o+1ia4UgLulL4Z2cN42sRK+T
	 +dBZbvhojnk/6CANfHnkul4SgS7KM/MwALc7t90DvV/BDlH39T842TY1jq3Ktk5VgR8zZ
	 pvegguGYjXYLzeYs2Cotq4OgMQ1DJ0dW4PI3b7rCD3dK7kpbsyOiGIrHjf0o0Gxkh2kTY
	 9pk7sb7QumhMh5VT33Ei0/fxoLd+gXoVJoEkCaoANoulPvmDPh+6dnuEeHBim1KO2XHZ1
	 HyvxySG3MGhoR+BcF2cqArVZyz9Fq15aeOc1W/bJ3LcmL8UD4le3Q9infaIJRB/vMwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048317;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MjvW3+PNaT8J7fDscFn9UHTN5pyea2VNCd0M494ixz8=;
	b=XGBoCjBnyfdc4sryTNQKzEzeyuzMTL89+Lx57qKmGVNtjhuhuKerurc+mTqmfxYC6f3k
	 eugp2sRlx7UmNRvMvvH2EXWkBHugU5EPVIvojDaHZviYNrt71Uym8vNammrn1fNBag3dP
	 MQzOTUFTsS3jMsxaZc2PrXB4BtH1lxUV3LSaxXfbeEDQQAAXeV8ZZpkGgLVBlec6mItny
	 jeKFrSL3JwnUQZfst4IxOIF6OgQAFAsIQ2se1i7n0DvVGP7QxPgZFtiINMZm2GGl8yhhv
	 b3lwM1Xny5l5Cek88KSjFAEPrt82FwAVMg7HivC3Or+vEP3nu/zSkJIz56vtPxL/dmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OQei9Zqb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22249606A31C;
	Thu, 19 Nov 2026 00:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OQei9Zqb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31D351F000C4;
	Thu, 19 Nov 2026 00:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048316;
	bh=MjvW3+PNaT8J7fDscFn9UHTN5pyea2VNCd0M494ixz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OQei9ZqbAUJAh/NO6S5XcZoZtjc+BaqCF8A9dKCaVFhctpSRqNbpRgKSvgS8h6pbT
	 0nujYzA6o7zM/3KVUajFf3w3ASwJmOhR6q08iEWIHfO61bFB0fCtvIwkOjVqnrXMLw
	 XWUfVv2VTbZBzFKBqqKBsJi4RTkljIpe4KHmEscQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonghao Zhang <hyz3367@gmail.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1944/2857] remoteproc: core: Set trace buffer name for diagnostics
Date: Wed, 18 Nov 2026 15:49:38 +0100
Message-ID: <20261118150311.211206997@linuxfoundation.org>
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
index ac6ec64f7db66..8b21c04ce60d5 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -578,6 +578,9 @@ static int rproc_handle_trace(struct rproc *rproc, void *ptr,
 	/* create the debugfs entry */
 	trace->tfile = rproc_create_trace_file(name, rproc, trace);
 
+	/* keep the name for the diagnostic in rproc_trace_read() */
+	strscpy(trace->trace_mem.name, name, sizeof(trace->trace_mem.name));
+
 	list_add_tail(&trace->node, &rproc->traces);
 
 	rproc->num_traces++;
-- 
2.53.0



