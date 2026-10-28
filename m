Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214038;
	b=YQYog75PDin8BcsJQ7+jg8UoGVvw7j392/GOWpN78saxHC3RmicMlbwicrfssqj/RDHZ
	 Aki7Vceq+qoPo54CDXuzLJ1Q1JpqdZGtS5pLLx6med7GVb3hGiDmH2YDZdBrM7TxhO1Y/
	 dotlkh76IDSgPx9N2BenYenN9UI1raXbZpuxqHAjnHZgW3ip7smirB4/YmUZ9nL10qUVu
	 bsM+lWI2KUE3laFSECX0Faj+MJ++aTlQF5QK6qEQC7JNVcU2A9iA/2munoE6DpzWGK4I5
	 1kRzYVf400topMoQzveDkutMsWk6LFUZosA+FVuzkqfV3SwePNRyKPz2B1t4zW+0P/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214038;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hUkk3ES1Wl54RMeGF9rKX891/4kWjQ2nneY2TOz/kAw=;
	b=3FyIKT5aIu/EoH16D4zznd0o2QhHMyo88diOig+L6SP/RCZ1dNizjhdzURX7P9SxtwQs
	 QONhbUbidbnKnHsewucJ6zT2571MeKbba9NM4vdstwoNPUxMluhhgLo5u+EbRLk8Gvhti
	 c4u04Vu5B0yUaIAf7ufbS67ROtkMJaH8IOEEHMeWwfbtVL4uikvZP2e30RbnyTgMe4L4f
	 XyBP4naGvPrcNFUW1SJOq4UYWvWGwfuRLFpPgcsIORSNhwMUB+6MWkGwDOJt7t6r5/jhB
	 C1d7KAmu/bwj+HHNxiO+5b8FWiT2mknNLhc3m2avUXjzi6ixfBHVufeTBWjOCXIzcRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aisIhCtT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA059606A32A;
	Wed, 28 Oct 2026 19:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aisIhCtT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B278B1F01825;
	Wed, 28 Oct 2026 19:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214037;
	bh=hUkk3ES1Wl54RMeGF9rKX891/4kWjQ2nneY2TOz/kAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aisIhCtTYCUU7NjOAielzPWnVDPymru2hafGKfmOmkMnF646YNKb64PPr2U7fH7w3
	 9rpQ6GuE3iCnygZm237E6bJZ+ZP1qTM/y2jUYCEtUIBNCF3TX8/RakoPMWcV2rwzWu
	 1mq0js5jx/ZLAZLCMutF+W5l+E1SCH9WCeGfVqgE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Jerry Zuo <jerry.zuo@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0673/1887] drm/amd/display: Pass non-null to dcn20_validate_apply_pipe_split_flags
Date: Wed, 28 Oct 2026 17:46:09 +0100
Message-ID: <20261028170514.727037342@linuxfoundation.org>
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

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit 5559598742fb4538e4c51c48ef70563c49c2af23 ]

[WHAT & HOW]
"dcn20_validate_apply_pipe_split_flags" dereferences merge, and thus it
cannot be a null pointer. Let's pass a valid pointer to avoid null
dereference.

This fixes 2 FORWARD_NULL issues reported by Coverity.

Reviewed-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Signed-off-by: Jerry Zuo <jerry.zuo@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c | 3 ++-
 drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
index 2a567c4fd80b6..dbfb9552b52c0 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
@@ -2021,6 +2021,7 @@ bool dcn20_fast_validate_bw(
 {
 	bool out = false;
 	int split[MAX_PIPES] = { 0 };
+	bool merge[MAX_PIPES] = { false };
 	int pipe_cnt, i, pipe_idx, vlevel;
 
 	ASSERT(pipes);
@@ -2045,7 +2046,7 @@ bool dcn20_fast_validate_bw(
 	if (vlevel > context->bw_ctx.dml.soc.num_states)
 		goto validate_fail;
 
-	vlevel = dcn20_validate_apply_pipe_split_flags(dc, context, vlevel, split, NULL);
+	vlevel = dcn20_validate_apply_pipe_split_flags(dc, context, vlevel, split, merge);
 
 	/*initialize pipe_just_split_from to invalid idx*/
 	for (i = 0; i < MAX_PIPES; i++)
diff --git a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c b/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c
index dd71ea2568e2b..61e72ccd4a67d 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c
@@ -818,6 +818,7 @@ bool dcn21_fast_validate_bw(struct dc *dc,
 {
 	bool out = false;
 	int split[MAX_PIPES] = { 0 };
+	bool merge[MAX_PIPES] = { false };
 	int pipe_cnt, i, pipe_idx, vlevel;
 
 	ASSERT(pipes);
@@ -860,7 +861,7 @@ bool dcn21_fast_validate_bw(struct dc *dc,
 			goto validate_fail;
 	}
 
-	vlevel = dcn20_validate_apply_pipe_split_flags(dc, context, vlevel, split, NULL);
+	vlevel = dcn20_validate_apply_pipe_split_flags(dc, context, vlevel, split, merge);
 
 	for (i = 0, pipe_idx = 0; i < dc->res_pool->pipe_count; i++) {
 		struct pipe_ctx *pipe = &context->res_ctx.pipe_ctx[i];
-- 
2.53.0



