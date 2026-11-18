Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029627;
	b=wgeMy3Rzs6FId+UabXjtgktpYg84CXV8DF1Ev1FKf/T728Wvu6++SjCySTh80DqYKgqW
	 44dwH3XWDlGbpkF00kwwaG6j/CDQq/WgsMvWEhqTFMppmyW2i1AfytWaBYBEqeqGgP/YY
	 LukguBK52/bzqf3fG0qkfUJOnYqECl120ls24aNAr/jqpG1au3EjhPnsjnfbGrDZvcXVz
	 h/siEi4KkCNIvjFN5OiBJUkFrLO3aJDwGze1V/yNpJXsQhSEfVmRLYPbeDOpZO1erooyv
	 uKCB5LNxeA6HMWWeKvRjZjJ3tk4hF3IHeM5Bc3zzezs99OC5dFDl0hzX6F3hgwU0lvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029627;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZYgAA1GDUQUMICrNoFAySd22xNMhkRtTzVx0QCinEi0=;
	b=SvsGyKTKHOwV9tRydQI1P+sJGwqN1Byk/92tbouQNRQtnhhPLrH02w3PS0AMwklJDkTT
	 7lq/1v/kfVV8xCVSrHYiU9MiLhAWCFpqh4r2icstPnOXTGwaGW3qBzEC34+LxuxDJmWtf
	 6IUNdw+Oz99psWwEjMDCF0zNBRbibNd4h7GRfdhT3vjh6ov0Bp7ncXo08+G+fXQ5QCq5z
	 u5Mp95fjI3or2O6SkmDYyEaLjHBa32GMbZXePOWQj3B0PiK43EUW4/V9kwHEyv7Jb1PVy
	 +kcO2TVIwIqEsqbHXyEXaBeLNnO4tWz0KEDOsGHO34TL6oZtUp7r3ee0ZbleB1bjolw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n3kMSWnK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 437E7606A320;
	Wed, 18 Nov 2026 19:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n3kMSWnK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91DA71F000C4;
	Wed, 18 Nov 2026 19:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029627;
	bh=ZYgAA1GDUQUMICrNoFAySd22xNMhkRtTzVx0QCinEi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n3kMSWnKNr/DLt6p/lDlbauZek+hPr6OPyoo6JJs/ojIKoVgA81JkiyWaUg0UOvCk
	 GhjggR0gBMDI6uUpS6HgHtMvpTbJEKBW3lMQNhfkte3s+kbKwBaAptyvhmSP3p93Zz
	 0QiUvkKSiSLNrGDI6H4FcYOmN7Qwhb1DyPZ79JKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonghao Zhang <hyz3367@gmail.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0415/1756] remoteproc: core: Set trace buffer name for diagnostics
Date: Wed, 18 Nov 2026 15:42:22 +0100
Message-ID: <20261118150025.248778406@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 323d368d455c5..172e25241c834 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -579,6 +579,9 @@ static int rproc_handle_trace(struct rproc *rproc, void *ptr,
 	/* create the debugfs entry */
 	trace->tfile = rproc_create_trace_file(name, rproc, trace);
 
+	/* keep the name for the diagnostic in rproc_trace_read() */
+	strscpy(trace->trace_mem.name, name, sizeof(trace->trace_mem.name));
+
 	list_add_tail(&trace->node, &rproc->traces);
 
 	rproc->num_traces++;
-- 
2.53.0



