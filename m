Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CCF934F466;
	Tue,  6 Jan 2026 17:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720487; cv=none; b=qs8ttHlG06e1JHlsCKXrilnfCcWBSiOUeEzxq53I4TTT3Bdsa8YrCDrPJvzBYwFfgenh7DJgpqL5eQZGrUOuw9yAb8e4rmS7NEAWjz4pI3mfWJWP1zOJmpraIKsbPtoenVP4d1GGFERUwDRHid8K9AXgqXQsHnga3gpPZUlDlQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720487; c=relaxed/simple;
	bh=z5jCHRXehiBTHyf0l2rz0tIR7E9QFSYay91R9jl81wo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZgP/HdRb9ewCpAIu3iReSyZf6YSPKuhNqXoVNqH5kkTLUrmAfuf+qkq7cyF6rqx49RZdzedUpXH22zy6KS0gdE9h15WFGJz9BkGL5p+V+K7uYRwLYebIE47+5NH4ybCVIdlvXJPwiOBARO/qxeFScrigzqXhcboJkJtq6wn0nZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vuTx6knt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vuTx6knt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF3A9C116C6;
	Tue,  6 Jan 2026 17:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720487;
	bh=z5jCHRXehiBTHyf0l2rz0tIR7E9QFSYay91R9jl81wo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vuTx6kntuDZhjOYGrINUwzSjufVwfIaAjldJ9+KaGUymUSqOcukuJ+LPLjPVp/erA
	 hSsnLfIEC6uPietHCJChF4SCZjA+mcFhbkerTughmBLEU7cwLCw/7IUD2O6r2YjljM
	 id1XAVYQcdn+P7Op5q00hjxmA77dATBKoxNyvH8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 252/567] drm/amd/display: Use GFP_ATOMIC in dc_create_plane_state()
Date: Tue,  6 Jan 2026 18:00:34 +0100
Message-ID: <20260106170500.636700141@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Alex Deucher <alexander.deucher@amd.com>

commit 3c41114dcdabb7b25f5bc33273c6db9c7af7f4a7 upstream.

This can get called from an atomic context.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4470
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 8acdad9344cc7b4e7bc01f0dfea80093eb3768db)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_surface.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/core/dc_surface.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_surface.c
@@ -93,7 +93,7 @@ void enable_surface_flip_reporting(struc
 struct dc_plane_state *dc_create_plane_state(const struct dc *dc)
 {
 	struct dc_plane_state *plane_state = kvzalloc(sizeof(*plane_state),
-							GFP_KERNEL);
+							GFP_ATOMIC);
 
 	if (NULL == plane_state)
 		return NULL;


