Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060592;
	b=J4NlxZFCbRsP0RnOXttkkA1vE10NTPPTrG0yC8CFVGXwshZH+/5DHZQrRxFDkbEDbuRV
	 1fpZmjifqtrceJE5moRKzUcAfuTEFkvgOAka4//1fHBi1dEbE+04RzG9KckKU/F2k5vz6
	 ZBELArOdxqr4POvD2UhppsdiiqmRLL2QoeIiLq27CznJJKHLf27+c+ki8h5E8azq4ppoi
	 5MWf8FeyJKLIDHNcpVW9Qb6STall2Q7pD4ow7H9cZu9M03gddxmnHOw4xrYvoO9ZLBcKs
	 uYk4R9RzyNzPIy8lIL1PrhYhTT/2LrFkLxEERY1Ry1ubpxG84TkH23XslIuiJp9d6eQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060592;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dRZHvO8lYJgP6YHD7FNxKzT0uVTkF46wLaOZvsIMlho=;
	b=w1EQhTi7VnCLfCbjsqsk45HtnZP8/76d3nYV9r5hIJjMHHM0LMcPi96DO44aJQSyBePS
	 B+LULk+6wyhKF2Igdm/sYdY2G9ccePxSnRJbuBXDi7Lj16qWl5wdFDloHP3IRjFFDZoXi
	 eLvT1YGv2NRphTAmQxJBHyqiSdvNzr/Y9382nanqt+jdAMCh6w6veQlMhbBx6jgymP+nL
	 sqejvB4McSVoTDJJz6RDbSAhDRkj2OehydS1VFhtHX8bh4wLU1iaKmB785WkrMNhBR45x
	 MSCDgelSUhk7r7zcuikvLo/vpWSx/y9PI4tuEuI4gm/qsJsvaoUeFpLqr5cqlLpCtCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jv2b3oeP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A71F5606A326;
	Thu, 19 Nov 2026 03:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jv2b3oeP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3B721F000C4;
	Thu, 19 Nov 2026 03:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060592;
	bh=dRZHvO8lYJgP6YHD7FNxKzT0uVTkF46wLaOZvsIMlho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jv2b3oePTMtZdoAYgwaZyqvCExOFQlskgBz1fV5/+RXR/SdYV+a0LkXe/jOHm3Khn
	 qufrNlQFJ8iWBSInkMJ7hkKFBMcd6LHxABjH6QpDEzXShy2Wu4/K5k6LcFkR770S5g
	 QzYdDJIA23ogazxPoaM23c/U4wzlZAEO7YY3bMCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonghao Zhang <hyz3367@gmail.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1255/1848] remoteproc: core: Set trace buffer name for diagnostics
Date: Wed, 18 Nov 2026 15:54:53 +0100
Message-ID: <20261118150012.289720204@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 3f8581e18c5e9..e4472ad211499 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -683,6 +683,9 @@ static int rproc_handle_trace(struct rproc *rproc, struct fw_rsc_trace *rsc,
 		return -EINVAL;
 	}
 
+	/* keep the name for the diagnostic in rproc_trace_read() */
+	strscpy(trace->trace_mem.name, name, sizeof(trace->trace_mem.name));
+
 	list_add_tail(&trace->node, &rproc->traces);
 
 	rproc->num_traces++;
-- 
2.53.0



