Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214366;
	b=jV2xBDlCNzEagDXbDm/Uc02dupXdhwOD+Wp2VpOczFxGxeDR0WBhjnnUNUoIWmg+Ftby
	 bltcb5TMHWwFkf3zJQnYZcLdLaSEhyJZoLWszlctYFINWBs4tgNftQ+cShsIcwxKPu9Kt
	 vyyyBR3LXPbybWCy/YDuoDipB52M/hX2Jg/rmBDSvCMRKq8WlcudRIAOdPjAqRX4veqYO
	 IRGQPQn13WMYdFRSRfOaJ/x7AmCbckA3aCJuXW/iUdkkrOfQ6W9YymOI/oKM5aAxB2rcB
	 schZDUkO9xcfWlRgMu3v1e7i9n1M9rhk/R+73dFn/LAKquEQwNjYrveqpOr6xDt//2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214366;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b04mQX3BKZGepUvwrsB5es36HbJXnKNlqKlyZCG2VD4=;
	b=1537gmgxLCAfae2QSd1mB/po+6r9uWcECxx4fTtMhamSPe1rZaphKy8hVfkGIPHFnSaj
	 +3dvW070cAthPv6NpoisvlFGfnYxnnQYqIbFJ5AelSR0/UZBIJp3vWhS4PApX+VqjSTGn
	 8V7rN7KmLsIfdGk4v89gc087IcAXMLwSTD1tgmUX/dkwd4jZNZZJvo+cOFmhKOzgz/gaZ
	 8ZBLWqXOnLfBSix/5PggFlQnWI8wlpkQJ8IaRzDwNeuklxWOsAlInho9RX8ueyMqVb8KU
	 I/liOQbz48hzWrnzxhGp/XBDC89Xlb1j5w04R0yHwipKwaNLAXSKsEeX6fF3xpiLCCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O7atEqPP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01A5860A2639;
	Wed, 28 Oct 2026 19:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O7atEqPP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20EDE1F01825;
	Wed, 28 Oct 2026 19:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214365;
	bh=b04mQX3BKZGepUvwrsB5es36HbJXnKNlqKlyZCG2VD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O7atEqPPpsqxV21x1FgWfKsv+XfDmj3Ws0RGiNyel1PZ4FkrjN8sFo4q6+b6XvYAx
	 eLlX6IkisSXPhnbpJZ9xF4EW3501AHYSJplo0Kupt/ICtVWeTlAbooA/5YJJqIjbd4
	 pN9n1yRs5vPzwFKPj6R4t+DUfE/eOdowePds3K3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Siyang Liu <Security@tencent.com>,
	Roman Li <roman.li@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0833/1887] drm/amd/display: fix a Null pointer dereference vulnerability
Date: Wed, 28 Oct 2026 17:48:49 +0100
Message-ID: <20261028170518.381515466@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Siyang Liu <Security@tencent.com>

[ Upstream commit 1bcf63a44381691d6192872801f830ce3250e367 ]

[Why]
A null pointer dereference vulnerability exists in the AMD display driver's
(DC module) cleanup function dc_destruct().
When display control context (dc->ctx) construction fails
(due to memory allocation failure), this pointer remains NULL.
During subsequent error handling when dc_destruct() is called,
there's no NULL check before dereferencing the perf_trace member
(dc->ctx->perf_trace), causing a kernel null pointer dereference crash.

[How]
Check if dc->ctx is non-NULL before dereferencing.

Link: https://lore.kernel.org/r/tencent_54FF4252EDFB6533090A491A25EEF3EDBF06@qq.com
Co-developed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
(Updated commit text and removed unnecessary error message)
Signed-off-by: Siyang Liu <Security@tencent.com>
Signed-off-by: Roman Li <roman.li@amd.com>
Reviewed-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 9dd8e2ba268c636c240a918e0a31e6feaee19404)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index 7594aaf79a101..cfcd4ed1666d0 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -831,16 +831,18 @@ static void dc_destruct(struct dc *dc)
 
 	dc_destroy_resource_pool(dc);
 
-	if (dc->ctx->gpio_service)
-		dal_gpio_service_destroy(&dc->ctx->gpio_service);
+	if (dc->ctx) {
+		if (dc->ctx->gpio_service)
+			dal_gpio_service_destroy(&dc->ctx->gpio_service);
 
-	if (dc->ctx->created_bios)
-		dal_bios_parser_destroy(&dc->ctx->dc_bios);
+		if (dc->ctx->created_bios)
+			dal_bios_parser_destroy(&dc->ctx->dc_bios);
 
-	dc_perf_trace_destroy(&dc->ctx->perf_trace);
+		dc_perf_trace_destroy(&dc->ctx->perf_trace);
 
-	kfree(dc->ctx);
-	dc->ctx = NULL;
+		kfree(dc->ctx);
+		dc->ctx = NULL;
+	}
 
 	kfree(dc->bw_vbios);
 	dc->bw_vbios = NULL;
-- 
2.53.0



