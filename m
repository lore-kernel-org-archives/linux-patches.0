Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F9D869E08;
	Wed, 21 Feb 2024 14:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524219; cv=none; b=mxQlP71Bcv/nya+im41hLQt9xiLxvgst7r3BrV2hLWpJqvNhFtjGMkr/lF7bbTsfYS4aZL+om9fgnqEkMZrzYPyUUIt1hyUg9x1NPnmu8dq9NKyG6VqJtJ61EmvNd6AnyQsBbUZUhtL5Yz5KZm5bKG20fVv9K1DhUBqFO+SyBEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524219; c=relaxed/simple;
	bh=TUT4uzpSo1rWQzSi43CVaOmrCUHOOlOJM8QmWCA0lAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h75Ca1E1gzE1gRGrke2+VSApDuOIGFiAM0shwBuPEYvuXhDXD0lwLsn31Zx5HsTf2543H/DjgTudc/PxahAPKN6qg8Ae8w9fP+/bZa4QcK8ytiXU1HMCmsYVy2ChyvDQ5vWh3yiT1V0Z7TsGbUA+1QvM0vDfNwL5rsfEMZf3NNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Rip1DzU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Rip1DzU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96866C433F1;
	Wed, 21 Feb 2024 14:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524219;
	bh=TUT4uzpSo1rWQzSi43CVaOmrCUHOOlOJM8QmWCA0lAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Rip1DzUXiuzb77vfAHljlTzg4/jupvd1CjKzeSjwjz8KsD6qWxhlWsZ7MPUt5wZd
	 e3CwxfmilEgMl3Zjoso71EPAx76hsdJh8XjmXfHIaiOuOFLgTLaqjRVnCn35K1lNPy
	 0eQHBfzVQhdkFoVDQ8+TmcoRoLiE79bjyZnYn9xQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Meenakshikumar Somasundaram <meenakshikumar.somasundaram@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 180/379] drm/amd/display: Fix tiled display misalignment
Date: Wed, 21 Feb 2024 14:05:59 +0100
Message-ID: <20240221130000.233711447@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 36a9e9c84ed4..272252cd0500 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -1440,6 +1440,10 @@ static enum dc_status dc_commit_state_no_check(struct dc *dc, struct dc_state *c
 		wait_for_no_pipes_pending(dc, context);
 		/* pplib is notified if disp_num changed */
 		dc->hwss.optimize_bandwidth(dc, context);
+		/* Need to do otg sync again as otg could be out of sync due to otg
+		 * workaround applied during clock update
+		 */
+		dc_trigger_sync(dc, context);
 	}
 
 	context->stream_mask = get_stream_mask(dc, context);
-- 
2.43.0



