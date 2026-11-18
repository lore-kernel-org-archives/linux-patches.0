Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036752;
	b=qeJS4+cwHaOQGMuV5gkyuFecaWI97L3pvYs+zVWj3vN8WZ+u+Iv4QHQ+z9sYbrbLRah9
	 hfxa6pTXKQcV8qwxk5QiAXDsdYTKusmOIlGQhgNKkspJ58/miFHe65Dn0Rf44Bo3hGvil
	 rYcCQ19DwPDLMfChpBNeu4s/0SoYtc+QmqA5Xu4Zn6ZDwfsb7cSkyw6pvpWtaBJRH+MZw
	 4xFbbogXknGVZg+fNRKE6bZlmSN32kvUQjTz4InOyLCmhzdKF+pDtaizZ29CmuwODqCM7
	 fy9BqRKzYLCmVP8pE5w1619VGhDgum6ebP6b35Yms517hgcJI/Fkn+APyXTNp4aDgfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036752;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7d76koS2e91Gwrdb6BGER+1EIsNJj1LS3j88yTVBbrA=;
	b=j6wJPe0VXzZdB6RBeJVH+ZC53k7gcCDj8E5ASB3PhSX2kNj637IyHy8zaqD2IWtroDLS
	 eKtANo/SlTp87ahCWaoWA0I7knribkIdAhsONlqqCxDc/6vHG3UujBiCrA2B4XYU+n+U+
	 Qxj23M4I0QJo65heVhWvmxMOg4bxM4E2QjectHf9Vi9rK2l0ccpAaOeq1oGlx3YdUeVlS
	 uE/4Qmc4c0g/2eNTcaMcW83Ofe6xs72bT9C1ziAZ+WKR+DgLQAO/5pVTZT1EdR7HsLiRt
	 vW2PaWTrGQjBbosDwvpNAY3MCGarG1kbR3IqQeOL++levQNMJojDYHP8PYY6l8/+6mg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="dAi3/RXb";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50F29606A31C;
	Wed, 18 Nov 2026 21:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dAi3/RXb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69C5E1F000C4;
	Wed, 18 Nov 2026 21:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036751;
	bh=7d76koS2e91Gwrdb6BGER+1EIsNJj1LS3j88yTVBbrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dAi3/RXbNPisSFIy9ixcpDVV/4qVrRVlKmR1ReXsM4CIY2HBUuyGrLni99DYJKfvd
	 j4swg2/uDT8SXH+R3dUZ3rKlC8cb2sVEUvDxxvWcvxDDL/uRWDnTvBA0nrCFAUetVq
	 Iq4McuJDjyY6ZHYV4xbQsqI2u1ml2umkyUME1zbc=
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
Subject: [PATCH 6.6 1172/3318] drm/amd/display: dont WARN when removing an unallocated MST payload
Date: Wed, 18 Nov 2026 15:29:54 +0100
Message-ID: <20261118150355.289163126@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 3a16de55f43c9..a8ba727d1b689 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
@@ -191,7 +191,7 @@ fill_dc_mst_payload_table_from_drm(struct dc_link *link,
 				break;
 			}
 		}
-		ASSERT(i != copy_of_link_table.stream_count);
+		/* Payload absent from HW table when never allocated: nothing to remove. */
 	}
 
 	/* Fill payload info*/
-- 
2.53.0



