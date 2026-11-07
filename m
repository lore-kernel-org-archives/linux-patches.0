Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065141;
	b=4LIrcbozYo9jNpmkhSjt2qpY66So7xhg3fvuNbrtTIhT/2AQFgxtidXDG5Ah87TpJ6AA
	 csdlRXXL1Vue4FvWxbT7haV1FH6/OyyTzpYJCz1thUkqql9YGxXWE8ZPwT4lB4KmWH1Cq
	 j/RGAEGm0RsyFAEaB6hfBnPlL4mJcvHcWncXFxUFMnBsQ6CtByWFlcsx0a+Ifd7d+c84J
	 wetVbC7IlLXX91/3qKWvZrSFsIapA9y+kNkhakvUqmMl54p6p6qjQOhpjJ2gIPAZ0o/uG
	 REjw1E7OpHSDEY2dCZ5190/bvqp8YQHucTnQmqd04Hqzsw19nJ2dysVWE/aCZH0z+2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065141;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0fNXYo44ZBx/LOBhFyk6wsmtXH5jkBRGWLmrJf4zWiM=;
	b=F96ecQ/4gxVwTb1wGB9A3AnMK4gusXiC1KJHfjMvhgRAGzGWIEJq5vEnf80YIJWph7o3
	 MomDGK4/u3w0ouWoE4bf9pbmIEmo375AAXwql/NVfyRK8VMY7TQGjhyqBb9AtOnBYjeCN
	 EaWJxGgZML2grb83wYZIE5dvUnZ9c+k8301pE1iBZzlCZmpx/6uQshvN9xCYre6VOETB6
	 fBFGPPRdaEnZg8QzpdNjvlj4vpPM47PZmqfJhs2I0RwBUw75fXTuwB6hgcFr5QDr3AV/C
	 gcEZKg3nc+E58ADsVrlPF2z8OyA32Xp5E9rVEAFlNgF0XqdrimPbNS11LQ1thczuhrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="G/17HS3R";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 297EB606A32F;
	Sat,  7 Nov 2026 15:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G/17HS3R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 848771F0089F;
	Sat,  7 Nov 2026 15:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065140;
	bh=0fNXYo44ZBx/LOBhFyk6wsmtXH5jkBRGWLmrJf4zWiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G/17HS3RT3N1Ntp4WXgTh4YV/N3O68AbCkoyshA4/CEqmhqnddqUY1f3qBitCG/rP
	 XIG9jCCUhiIscxUOc2TP/L+pysrkiWhKC8AiEUK5+3YxghwrJmpD4RNlKwZQY3PIad
	 CvmN2D5kSxTToBQTugQMvTSt6NoaWg4+z/7nzz9E=
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
Subject: [PATCH 7.3 0958/1257] drm/amd/display: dont WARN when removing an unallocated MST payload
Date: Sat,  7 Nov 2026 08:54:14 -0500
Message-ID: <20261107135005.800436677@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index ced8b3d2d762e..bf6f013fdfc58 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
@@ -283,7 +283,7 @@ fill_dc_mst_payload_table_from_drm(struct dc_link *link,
 				break;
 			}
 		}
-		ASSERT(i != copy_of_link_table.stream_count);
+		/* Payload absent from HW table when never allocated: nothing to remove. */
 	}
 
 	/* Fill payload info*/
-- 
2.53.0



