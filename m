Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33108101C5;
	Sat,  3 Feb 2024 04:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933395; cv=none; b=CHMkIDve8GOG6lopvwbC1DkAoc69PJdS3P/ydiGmMUS0dfbUlBTmNgrqj4Y2itVt55o+MePzYOV95n9l7RbAtxD1G997uDUosW/XECGRgOxJK9G7iBcC8hgBQC7qwHYNnnoABlBemDee8ZRckthFEYXy71rhnWQrPEoZoj6MpDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933395; c=relaxed/simple;
	bh=zYAAVnqMLMeGOnRVXxRc4Y+qkybT5PJeq3VUy95sDTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k9Rrk/w0TztbKTyAUGRyKSQ0Ca/36APKwlX464TkDJA8DK97GC6ZlPxXsFhyQHgqRzHmq0IMgg5kTMl5+rIoqYpfl2tiYT3lE6kzq+/alAlGSm2DxP7NPDfDPBIj3dZZn5Sv245RY97fkFNOfoBNDFYzvXbvuTB0nNN3y4R28Rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NnJI14L+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NnJI14L+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0EC3C433C7;
	Sat,  3 Feb 2024 04:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933395;
	bh=zYAAVnqMLMeGOnRVXxRc4Y+qkybT5PJeq3VUy95sDTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NnJI14L+MEHPPbpUMWZdCNnDN6zxE3iuZ7OQaUPqOXW2bo8Qj8334Hlvlfjuvu2L2
	 ayvRfTjWLtUi3INEjZmT+eJyxJC8C+u9+5LNOTg54Hb7hZf+PDTMYwKcj68/sXdQBd
	 T7zYomXdXV90Jq/5KnD/xtG71F+7rTWL3YeaYNsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Meenakshikumar Somasundaram <meenakshikumar.somasundaram@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 111/219] drm/amd/display: Fix tiled display misalignment
Date: Fri,  2 Feb 2024 20:04:44 -0800
Message-ID: <20240203035333.015331096@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 7a309547c2b3..f415733f1a97 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -1903,6 +1903,10 @@ static enum dc_status dc_commit_state_no_check(struct dc *dc, struct dc_state *c
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



