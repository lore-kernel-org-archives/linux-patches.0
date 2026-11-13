Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590487;
	b=MYpoPse6PVYnx7v/wHGXhaiKedc4VVfw7DcJBQFKa+W7vNkmI0KNvYctHq4VnkIfengd
	 FH08x0eM6xvoY5HzqCQgWtoyiPaBi61ckybPtVNUR/2ZIPasYtQxqG0Z1JXBNJ1kj/sVc
	 kedOjGDTfTiuJyrHt4Oj6AxPpR58RPbV/+Pcmhrx3/4XHWMjFQChxKQAaQGLiUioOGZgc
	 oiwkuI5vRYP14XjxoUdn34FXMR4rqZHjqcAijHNt+q4pZfmB1b7p/R4DxhsuKRbvfW/YV
	 kiXYGNObGWUgXG8xPJAgXl+I8SXcZ0YAgPBeHrSjqHHwzvuI+aVIHF6sS0sM1p33vrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590487;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=t0eBzkaPyKmLIUHwlMHOVf4Ep9DLMD1OGS/0tP3GQ8U=;
	b=mkmK2fnvJapf1JNhNAcW9qwVcTIfqbnKvP+K1W1d4OotIRg0sdc3+ytPDYWT4LRE76Ou
	 hXu85WnEd7r3Ho4EN7ZCh4LAZ4e8KNz0/Y6cQjD9RG9SmUcLNjeSq29syADY3MGYQfVTk
	 VmxlfiyVXc3fW5PG1VtZfw7cesCp2Mb3yIyPXgGsrTg3WJ0KD4qP3ww+nk3ou4OLcpXUB
	 60io4qKUwUj+5lr7sJVfzJC7aV1xMn7dN0RX8Np9G8dda7URc4TH4xSlHOeoCkliYSrR5
	 qsAgjieGvX22VwUkZZYbgDeg2C9BEXzjp7liYnZdM46X80TwJ1zWIYzVgpMCfRyHcJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nB1pfXr5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C87AD606B82D;
	Fri, 13 Nov 2026 17:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nB1pfXr5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 753891F000C4;
	Fri, 13 Nov 2026 17:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590487;
	bh=t0eBzkaPyKmLIUHwlMHOVf4Ep9DLMD1OGS/0tP3GQ8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nB1pfXr5eXSLf3FE+mu73cRUQ9d1DW4DjRdFB10zndkSLB2ozwsSghNb4uddw675a
	 KvjvOP3RxwuYwdsyv0ubAh2PUtzHfNXcZGnAkBVz9q3QO8uVUQ17RvDPew1rD5dTb4
	 YG3PTs2yz4+LIJ/NBt6aNnm3w3EV5WDJ3n6ovPJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kylie C <kyliepc@proton.me>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 411/686] drm/amd/display: Dont select zero V_TOTAL_MIN/MAX on seamless boot
Date: Fri, 13 Nov 2026 10:49:04 -0500
Message-ID: <20261113153834.902794599@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kylie C <kyliepc@proton.me>

[ Upstream commit d13f36e4e055cce03761de590bc8dc6346b1d5c8 ]

Initialize V_TOTAL_MIN/MAX to V_TOTAL before enabling the selectors if
they are still 0, as optc1_program_timing() does without seamless boot.

Tested on Renoir (DCN 2.1) eDP with amdgpu.seamless=1.

This removes the flash between the bios logo & plymouth on my laptop.

Signed-off-by: Kylie C <kyliepc@proton.me>
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 1ad7473e82b9242c4ee7eea82ab16d3f82f01651)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/optc/dcn20/dcn20_optc.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/optc/dcn20/dcn20_optc.c b/drivers/gpu/drm/amd/display/dc/optc/dcn20/dcn20_optc.c
index e7a90a437fffb..06edf66136597 100644
--- a/drivers/gpu/drm/amd/display/dc/optc/dcn20/dcn20_optc.c
+++ b/drivers/gpu/drm/amd/display/dc/optc/dcn20/dcn20_optc.c
@@ -452,6 +452,13 @@ void optc2_lock_doublebuffer_disable(struct timing_generator *optc)
 void optc2_setup_manual_trigger(struct timing_generator *optc)
 {
 	struct optc *optc1 = DCN10TG_FROM_TG(optc);
+	uint32_t v_total, v_total_max;
+
+	REG_GET(OTG_V_TOTAL_MAX, OTG_V_TOTAL_MAX, &v_total_max);
+	if (!v_total_max) {
+		REG_GET(OTG_V_TOTAL, OTG_V_TOTAL, &v_total);
+		optc->funcs->set_vtotal_min_max(optc, v_total, v_total);
+	}
 
 	/* Set the min/max selectors unconditionally so that
 	 * DMCUB fw may change OTG timings when necessary
-- 
2.53.0



