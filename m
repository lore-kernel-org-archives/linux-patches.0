Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2E5713A244;
	Tue, 27 May 2025 16:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364274; cv=none; b=h9tRyvs6uNn8nJeyExI676ZbcGXROQai0ttb9jWhpd5d4PaofwB4FUJ8GBb6iXkLGnp/dkTRr91df58oEm1ai1MIfsNL1iLRCCj3fF3jVPNQF0ayEYkogk++SuIGxXEj4HzFJgXenL16GaO+fnnYzrZreKY9EpaY4V2NCMrYxEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364274; c=relaxed/simple;
	bh=GwzMhpAVQhZQedbyqYGqT8fEbkHyiJrioEx6hsRzThA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E49vp715DQcOj3SVuXKQqX9aHpFC2kmE15bX6qST6wWY8Bentyd42xl11ICfeFI7LWMkFaxdnfyVL1Ra8CYyGB26mDpw33JQbTFyU3pclc2KLqpYqcW1oOpAeXMjs4VLq6DqwGiX/lfCw0di7e2+4w8Amxmq0b0ON8Ro2xpkLCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2DJRtrXH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2DJRtrXH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CF7BC4CEE9;
	Tue, 27 May 2025 16:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364273;
	bh=GwzMhpAVQhZQedbyqYGqT8fEbkHyiJrioEx6hsRzThA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2DJRtrXHfNw5i74UVJGv53fOLt41xuzrdu2jJeXwYtr8buvxuuNYS37s59advy9yT
	 iHNifopJkMBIeiWfPpM9+FtL2ojzlKEYMuRVhA9wi7W1APUBxVefRoCdbOv/Ti4Go2
	 28K05MKLxYXqFIma6DrXst0nOB9ehv33sweB/c8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charlene Liu <charlene.liu@amd.com>,
	Zhongwei Zhang <Zhongwei.Zhang@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 003/626] drm/amd/display: Correct timing_adjust_pending flag setting.
Date: Tue, 27 May 2025 18:18:16 +0200
Message-ID: <20250527162445.190540557@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhongwei Zhang <Zhongwei.Zhang@amd.com>

[ Upstream commit 34935701b7ed1a1ef449310ba041f10964b23cf4 ]

[Why&How]
stream->adjust will be overwritten by update->crtc_timing_adjust.
We should set update->crtc_timing_adjust->timing_adjust_pending
and then overwrite stream->adjust.
Reset update->crtc_timing_adjust->timing_adjust_pending after
the assignment.

Reviewed-by: Charlene Liu <charlene.liu@amd.com>
Signed-off-by: Zhongwei Zhang <Zhongwei.Zhang@amd.com>
Signed-off-by: Tom Chung <chiahsuan.chung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 874697e12793 ("drm/amd/display: Defer BW-optimization-blocked DRR adjustments")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index 3392746f1d420..a76e6fc3fef78 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -2979,8 +2979,9 @@ static void copy_stream_update_to_stream(struct dc *dc,
 	if (update->crtc_timing_adjust) {
 		if (stream->adjust.v_total_min != update->crtc_timing_adjust->v_total_min ||
 			stream->adjust.v_total_max != update->crtc_timing_adjust->v_total_max)
-			stream->adjust.timing_adjust_pending = true;
+			update->crtc_timing_adjust->timing_adjust_pending = true;
 		stream->adjust = *update->crtc_timing_adjust;
+		update->crtc_timing_adjust->timing_adjust_pending = false;
 	}
 
 	if (update->dpms_off)
-- 
2.39.5



