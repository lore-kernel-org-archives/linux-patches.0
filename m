Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055138;
	b=E6wi1GWFD+sLSaM90PWUkqQbia8eqByzM7SMeNhzHTVq3VdEB06aiDAvzcQqfiyiW4El
	 iS5tkFxP5ffAmQR6E9Mmtm3F9JxZ35Chop0iHRChxNzkqQd1Y29DdFP30iX+wtt74/YNZ
	 AP25dNmTInSCP5AGmKQWBzH/BcHmE+/VVi3v1EoRpN0P8CI+1b4V5JyEAnpbzE6/yyRWu
	 LknWt/cNAxPKqVRjoZtMwk5sZX9UX2tLq8oV+FXXLatlhSFGHyZHtpq03zyj0BgEeYFw1
	 AcFABawUA5VU5c0H5yq0Q94RHbI6Baeso5M8mF8CVmyL9+dlNaN+X/ZjPClRouEGdhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055138;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WEcLZO6Hvr1Asw9U9BmavuEPkoxExyQjqARsv8RMnvw=;
	b=pjMyEa7VtQ03hQBx+5ULi+bdFuashWyz04K1YSlSd4tcC53w3zA2WrsELGrAgu1pRedw
	 JAdGkjA2wYtMpJRYcrIoIuKoNJcNfo3mLKsOtN0W7rhKJIoPp0KS2DujA/TgatY+SXPb0
	 WGE/h8hLr02iPZcgj6CnQbi2Oh+MirN8MAZWkZfiPsoPHxI1OvmZocsSThDK7mcGWnNIe
	 yO7xER28DfxjqgHZw8zsI956QXRvjZS6Wz4NJgDn3beojDJwwfXkR15oY+JZdNB4miiFB
	 kouudi46aoniLXNQ3Tc2OzFz2nWz30Rx+SH0DmmpeXkyu3wJHwdMrofEEVW3bB1w4Qw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QSKm7Snq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35CA7606A31C;
	Thu, 19 Nov 2026 02:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QSKm7Snq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CCC71F000C5;
	Thu, 19 Nov 2026 02:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055138;
	bh=WEcLZO6Hvr1Asw9U9BmavuEPkoxExyQjqARsv8RMnvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QSKm7SnqYVH5P+fnguyvSoZuW+CqpLdPIbIIdFDn6K1ah2M7v3M5vFzqn51ldSX6d
	 JzDYCID9+6KGGYbEHktZ7MaXYflpHKoOHlZFUtSZOaaDUozMxqy933Fy1dbQEXHrPV
	 kNquaj67DtYWd9uDMeYq1zuFhCQeGg8NrXrjpvzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonghao Zhang <hyz3367@gmail.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1507/2214] remoteproc: core: Set trace buffer name for diagnostics
Date: Wed, 18 Nov 2026 15:53:03 +0100
Message-ID: <20261118150112.282691644@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 0e12d45b551f5..998eae2f87430 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -690,6 +690,9 @@ static int rproc_handle_trace(struct rproc *rproc, void *ptr,
 		return -EINVAL;
 	}
 
+	/* keep the name for the diagnostic in rproc_trace_read() */
+	strscpy(trace->trace_mem.name, name, sizeof(trace->trace_mem.name));
+
 	list_add_tail(&trace->node, &rproc->traces);
 
 	rproc->num_traces++;
-- 
2.53.0



