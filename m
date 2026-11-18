Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039793;
	b=qrndJzZ/Jgj5dJ5jPwepZrjx3ojH/gLb6v0DrOm/vqpJ42G2zt8ddjBhQVsmNwtZ5cKH
	 r3BR3X+uqbntW5YtUaX163N0zhn4EraSb3JsuULVKzqv57w7fDm3bA8KvjNXmng67+U5+
	 fg21NHl6/pcptVglBJw+Pr12cb/fmjaB2g3gBW8PaWAm6SQ79rAKs7U+uCxg+J4LhTCKb
	 wuBgnBJmmQ+6vSGTE/eVuyB3vDKTlAVUxTnD2J8gd+PYLjriLV+XVoMS+0RWBsXYTEmB9
	 di/5a484zTC+7xIWbPWD+HrR1qlxaxemYlzBUCv+E+n+QEQiU0IOGOJpdVurALTn5Ow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039793;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=54Z/OwYPAsoXZZLVQUltV83iUz/PYFAFzmBUEvPJSVk=;
	b=pdmmnYwVfuA9QK5p4YCWcsXGcJRKMc02oiElDyJTFBRhgPWGx8KgOp7hQcT3UTi3Lr/G
	 fnYO0Qifxb1U7IBfM0r2OlZ0uMcmjh/gBJEd/Syfjj9/R0hgaj0KJDHBm/paQntPsebnJ
	 yd/A1YiBAu0CIzUerfZ5Nzna44oT+KHpGlAbPRoc6+P7DmrOt1oVFLcKPPBbCk4CVMlZ8
	 yNGILNv0qcIlxxUEUo5uYGcy4HGSZ+8JbTfXPXbnaB0TlTKhvXYOlxSWANUptpnzWo1Qd
	 8Rr2z4zMybOlDMM2yi648cJFsf09OmnuAIY2L8H3JvSQN/XqJ7WxiTRI2Em8M4pcimw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BaoF3Krc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E651606A320;
	Wed, 18 Nov 2026 22:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BaoF3Krc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62DF61F000C5;
	Wed, 18 Nov 2026 22:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039792;
	bh=54Z/OwYPAsoXZZLVQUltV83iUz/PYFAFzmBUEvPJSVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BaoF3KrcMFap2rq0iIxz6fNuXtljIKYumRlbWIZG1LtCXprLvtoaia2D/4bI1QU0V
	 CaiUSwLKx7r94FmIQxUIJSjEkGzntY5eAIdojk9AMdRbxkIdBIFI7jB3v05b44VEs0
	 5EJf5cTM4CDyZkKfBg/zPt6/AxlxJQ4/2RV4qlME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonghao Zhang <hyz3367@gmail.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2225/3318] remoteproc: core: Set trace buffer name for diagnostics
Date: Wed, 18 Nov 2026 15:47:27 +0100
Message-ID: <20261118150428.634948617@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index cba79fcb87d59..d0abed199d232 100644
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



