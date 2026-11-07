Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062479;
	b=xaP8LVFskghXdqxI/WL2Scuo8cYnLO7lLImLjXZFH23+6y02DdYKfJawEwYVLBYskd9d
	 /uShj5XAxYdd0P0xUZg+Gtx+6qPco8sjspoLUeQBP9b6Us52diYq1PZ+LCfAgbi2s7ipD
	 RCj7F1Vr4yqKRzrDhAJ5SLN6418Upk06Ki7S0SYT2zFA72LkTxAiuUphaWpQzwORnuT75
	 LvWkxATXo7VL3WAPAdU0AMwZUJgfjGKdow8KGElw2mJN/bMwlrYOXg/f56mDdDGbKgaaI
	 8Uu00DVASVjEAfVzjmDzKiobTWc+IQx46CcEBGYv/Vf8jXTfCkQa4DU85F/qU68+j8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062479;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dasLuIzrCkEifpC7niCWGv5efn4ZcHq/iT3GaHNk7uU=;
	b=2zvOEUzy6QhP0Z0pxwzrdzaW0MiUSQKy7OmsfVecrX15i1UmsI8RJRKzYqKmqvBZckUp
	 6QnfGsMyqgz3id1UjZLlt0pqUxjwInDQ+WyQalIMSiSvF6LhX1H++mUu6sCS19sQxYRb/
	 MRid66bF5Jkh7jmRhYvkIaLD9yF8t6KriIEg2ys8b6Q4qHnFA4bOz3yuK9BWdW+d4cWi3
	 cw70h0EJNEBXwhwVfASbMEtdbm7AxetyLqUYSl4xY07s5R20IVeymYcl3aSwMY8opsmN9
	 HlO2FeQN4wBzGUl87kktSGjyQR//EOZYTfO7tE17sQkbX8Kv5+LvZYeYx9Eu3Vk044g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UGPerfFz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F1CE60A3815;
	Sat,  7 Nov 2026 14:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UGPerfFz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C52BF1F0089F;
	Sat,  7 Nov 2026 14:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062479;
	bh=dasLuIzrCkEifpC7niCWGv5efn4ZcHq/iT3GaHNk7uU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UGPerfFzHzEHmiZLYAh6GIf2j00XG1v5jCwHjVjg/BM4pSJgEXGmYrp8qe51IepAE
	 6kUKqg2YOgbDdkAxwfa3AWSo6sdSv3C63xgCp5YXc6I5TYjrM96RKCwki70iHXOa6o
	 2Qgpt+5YoZKc1JRkbub1mZ9WaCV2aMVbN4X0NJJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wayne Lin <wayne.lin@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1381/1536] drm/amd/display: dont WARN when removing an unallocated MST payload
Date: Sat,  7 Nov 2026 08:56:37 -0500
Message-ID: <20261107135036.622222445@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit b18a7c6d75bcc883b39497863cc88c9ef4c6c85f ]

[Why]
On an MST teardown that runs through the reset path
(dcn31_reset_hw_ctx_wrap -> link_set_dpms_off -> deallocate_mst_payload),
fill_dc_mst_payload_table_from_drm() is asked to remove a payload whose
vcpi is not present in link->mst_stream_alloc_table and trips:

  WARNING: .../amdgpu_dm_helpers.c:275 fill_dc_mst_payload_table_from_drm

This is a legitimate case, not an error: deallocate_mst_payload() can be
called for a stream whose MST payload was never programmed into DC's
HW-maintained table (a new stream created for a modeset whose enable
never completed, as already documented in deallocate_mst_payload()).
There is simply nothing to remove.

[How]
Drop the ASSERT and fall through to the fill loop, which rebuilds the
allocation table from the remaining entries. The table ends up unchanged,
which is correct: the payload being removed was never in it.

Note the loop must not early-return here - the caller passes a zeroed
proposed_table, so returning early would zero the whole link's table and
drop the other MST streams sharing the link.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/5875
Reviewed-by: Wayne Lin <wayne.lin@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Ray Wu <ray.wu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 88a27f624dc0ebc14a7ab274a84d977ce8513cb6)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
index 9752548cc5b21..8e0ac3f236ab9 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
@@ -194,7 +194,7 @@ fill_dc_mst_payload_table_from_drm(struct dc_link *link,
 				break;
 			}
 		}
-		ASSERT(i != copy_of_link_table.stream_count);
+		/* Payload absent from HW table when never allocated: nothing to remove. */
 	}
 
 	/* Fill payload info*/
-- 
2.53.0



