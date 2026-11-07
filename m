Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063539;
	b=iDtSrrK/kla6lSZiU1eijwr1Wr7+z2SlTmehtx64H/uhq7ec4Ih+PU18ZdDq1WRU9BYd
	 nE2LFLlI1ol4wd0aSYwL5Ts9HoOeCfM/O1Yqx6GWrn3O817tiaVsmIUXaaMz+kOnriXos
	 tAmzMSfgjYx1O4buiIf29lm0UAZP39WSwYIDd/GzspfucY2YcQu5ZkZGMnIFqikm2DeyJ
	 oSrlFR59wleH4938RD/Gidz/MdanVmENfhYPtMSQ7Qwwtmuzapcl6D3PWtpVOR9NDN/Rk
	 htP8S8Vnju6aWcDNkKnHi2C1fMrLk3jQ8nCUAI62NbEqudsFWC2gbSq86GVzD26+Jiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063539;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=///jhV8ipz4x3ptB/WxEpfyTqyiawQ/mXJ/Oukk9YiY=;
	b=J/sJXxPJsPwQY2K3YHY0kP3qo3ukmGXNsBWOKFTA693C5s4RWPvuuRVa+SPeu2BFaIRD
	 VrR2LsRd/0SksZCPTM3bRDVx0vfB6iOaRH0WclVgVZJRGErw7OFbLyntAcg4DWUZ/4QCS
	 pK5yBPWjoUMqxOinBZR4UqxMPVt1pu9FsyByU4x9tMNo8k66RUA9vunc3ZAUouESBOa56
	 lo+3Szfl2bdNENKxPrM+umXtoGAFCYGBuLIwNHLoZqqqT3Gur7gN95jcNp0S5Roac4R3D
	 7zfStGbD5Ym8Ja2XPUpN/Iwh3Y5aKbcxVR5e4akwPJ8KlUExuJd1d7+oSVFVQ7adKPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jDVEmUF6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44EB3606D802;
	Sat,  7 Nov 2026 14:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jDVEmUF6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E98A71F0089F;
	Sat,  7 Nov 2026 14:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063539;
	bh=///jhV8ipz4x3ptB/WxEpfyTqyiawQ/mXJ/Oukk9YiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jDVEmUF6pxGYGs1sdeCVudzYUEa5rDzkZW0B3/HOM3wepOvubg9vCPkGS5QeENAkG
	 XHSrf4m6mf5G0d5lNG1g1BsaKDP+0TWsYQc+n/QmDf1qEl4RGiOsSlf5jCf8elKnER
	 2Cy+ZGoGa2dhUOsj5EIiFVmhPnq6qsawD6tA0RR8=
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
Subject: [PATCH 6.18 675/869] drm/amd/display: dont WARN when removing an unallocated MST payload
Date: Sat,  7 Nov 2026 08:55:57 -0500
Message-ID: <20261107134915.981677876@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 7633af2429198..e8f4e7b7af570 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
@@ -225,7 +225,7 @@ fill_dc_mst_payload_table_from_drm(struct dc_link *link,
 				break;
 			}
 		}
-		ASSERT(i != copy_of_link_table.stream_count);
+		/* Payload absent from HW table when never allocated: nothing to remove. */
 	}
 
 	/* Fill payload info*/
-- 
2.53.0



