Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045653;
	b=nz1odYonOT0v1Wkg87WkBPIpm0u7vZHi3mKXoYbAfghyJtIzQZc9CzNTQ28vPYJNtUnd
	 A96DbEOKu6bNvTT0Sd4KPzWVyoU66vsVFNKglReqryO0+MkZxZX5lXbJky8JmN099NLo3
	 n2/8IINGn9u5qiof3U+dC7osQrexNL9z4VerZLswgKL3ADIbGK4vzMmfIhfmBaI5gUfhi
	 A+05QvI4EmFvnt7sbDDERtcJSe8orr/LS8P1Dw3Tvj8V1TH7B09RGMC7kOzE0OCfaYxhh
	 1/WrOX1tUKE5Xp4YkhB15KdDQRc0SQorqVzw0NBcaJX8haTjXF0msAKVPGq3KHJDrng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045653;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZfW0OerJvnfmdd31hvzycOc7TC6KNS8sdPZgC1GkGYc=;
	b=ml8T/Bn0ioRlyB/Hznpi0Qomf7OxJe2/jGfqJ6669YmNszYl7LucQuLWFaiqedAQ8g5w
	 aqnH0c9CUh/Xkgxpw23vtQ+GvVRBGzoJFtuJBvgXsXexoSdr1ORAN/B6y8+2uFBsoJmHX
	 I2WJ4eSvPb1d35tkSg9cRCO0qjJbdXHWcpf+2NO9Ce4qUj0TPQO+0kEybzshcTx5/z0ba
	 3Nb05rPqUWrjXh9XThX3yT27zWVNZAD+OVzB9NU8NKZkAwJQgiYk0zEY081qOZt4QbREx
	 Df09O+7aehbAU3QxfOrcRfwBYrWtwsXYZWTJk5242BpBLqlf5o0CHtwe//I+C8HEH8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U1U9rObb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62AD4606A32C;
	Wed, 18 Nov 2026 23:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U1U9rObb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89E1C1F000C4;
	Wed, 18 Nov 2026 23:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045653;
	bh=ZfW0OerJvnfmdd31hvzycOc7TC6KNS8sdPZgC1GkGYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U1U9rObbL21l69eTw4XESZ8SQUit53867RG7kYBRRLVx3fho8qRR5wZZ/1uDYLXys
	 bzSN2HsQWdRUL5AStVhIn7MtJBv3qZ//BXXwLGaqZxigbL3Mm2fZgz81Q/e7jEk0a6
	 Qk5SyzOuA9dOlOZXqdfJaLqssdCba7qpdyhaEBts=
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
Subject: [PATCH 6.1 1001/2857] drm/amd/display: dont WARN when removing an unallocated MST payload
Date: Wed, 18 Nov 2026 15:33:55 +0100
Message-ID: <20261118150237.641931832@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
index 9dc41f569a761..0a57571b84f25 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
@@ -180,7 +180,7 @@ fill_dc_mst_payload_table_from_drm(struct dc_link *link,
 				break;
 			}
 		}
-		ASSERT(i != copy_of_link_table.stream_count);
+		/* Payload absent from HW table when never allocated: nothing to remove. */
 	}
 
 	/* Fill payload info*/
-- 
2.53.0



