Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 089EA17BDD;
	Sat,  3 Feb 2024 04:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933598; cv=none; b=BeZRfoCNtABdzNMPzjoSb4CiosVMt6ao0YIPNuYpbEcP1RaTBbqoPgO3i6/gesWNHFuIjrYUfrVY2sxYMDxa0ZiMklAoDgqXJ+uhwEeL0XYmuF5gtTgOQp5aNZhajd95yiF3vd49H079M3nRjWNPn4vlz+YL6T4jT/jVpF6RuC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933598; c=relaxed/simple;
	bh=+/7fe3ELrqWbQknTY1UQv5NrpJ0lKgDCOnGxsG6VnoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jr1OQvbWxw99yumoNbAKO2ZoEQlZcNrZyYJ8SiX5qqaZ0bBcaxBei8vZk8oTWa9vcpv0xOPzKefpZP9Vm/mAX1y355NqXxxmjDhrhMBWQgW8kZaK4ReBzNtjVpYDQ3nn88vvwuFZAsIAUQnZgUbfd+zKsNzn+WwaY6/x9wd9vK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I4DIrWgv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I4DIrWgv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE8B8C43390;
	Sat,  3 Feb 2024 04:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933597;
	bh=+/7fe3ELrqWbQknTY1UQv5NrpJ0lKgDCOnGxsG6VnoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I4DIrWgvWRCxY+8JthMcXLeXJgxTx7jEjkxrp7njpfX44bKOBpckbDdjfN+Ky1gob
	 j3C9KD6IC4tVFUBL7fw4GPORnY9vzNBV/B7hbPjuAsWPT3dVtf84BPx2moCJOYmt6b
	 e1iLC4qaZHstkF7QFXhIo/pPiuhAMAFp0TmpC/s0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Meenakshikumar Somasundaram <meenakshikumar.somasundaram@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 165/322] drm/amd/display: Fix tiled display misalignment
Date: Fri,  2 Feb 2024 20:04:22 -0800
Message-ID: <20240203035404.568961980@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Meenakshikumar Somasundaram <meenakshikumar.somasundaram@amd.com>

[ Upstream commit c4b8394e76adba4f50a3c2696c75b214a291e24a ]

[Why]
When otg workaround is applied during clock update, otgs of
tiled display went out of sync.

[How]
To call dc_trigger_sync() after clock update to sync otgs again.

Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Acked-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Meenakshikumar Somasundaram <meenakshikumar.somasundaram@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index 8cdf380bf366..46b10ff8f6d4 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -1948,6 +1948,10 @@ static enum dc_status dc_commit_state_no_check(struct dc *dc, struct dc_state *c
 		wait_for_no_pipes_pending(dc, context);
 		/* pplib is notified if disp_num changed */
 		dc->hwss.optimize_bandwidth(dc, context);
+		/* Need to do otg sync again as otg could be out of sync due to otg
+		 * workaround applied during clock update
+		 */
+		dc_trigger_sync(dc, context);
 	}
 
 	if (dc->hwss.update_dsc_pg)
-- 
2.43.0



