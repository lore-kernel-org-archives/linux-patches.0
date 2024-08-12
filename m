Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57AAA186E5B;
	Mon, 12 Aug 2024 16:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723478806; cv=none; b=ADfRcFUXNBKx22Y0Nqhfi+q5feU8+2C1ml43yY3w8Xb4qN2C/FAOlQM1zaXK+YCnGuiHUCh6Om+leIe0V3I4VXVIGtlC41dlWLJ8U5SEI6XfqTaVCjkDPq8cwQr5Ku+10Pt1+I07bOdsWzZi/Fbyt+4Kj/n/Wr1s+8BMfX0qg34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723478806; c=relaxed/simple;
	bh=/5QwyBd7M9uT/85GE/UvH5f8pPxL5GcmG578i4cBGWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IGIrmOgYaWIE5Wu2YIk1TPUXcF0E/f1fhpR4ljJs0p7kA+o3+kvsbz+mY6OwHdUhziyLfFXX98k9uXXHPf+/G18eqqvTec+8A9Pc9znaDpvCwBxdicshlbEk3OXYRAQannt3Vjilbt7VZQJ9+781aBSusxQs6XtoTayjeANe6ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hOs+yBgq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hOs+yBgq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9752C32782;
	Mon, 12 Aug 2024 16:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723478806;
	bh=/5QwyBd7M9uT/85GE/UvH5f8pPxL5GcmG578i4cBGWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hOs+yBgqwqWObgTW2ZYlnEdNIndK3V+DwIPoDmZfmjqbLgwqFIJJ0p/TvKm6SD2hV
	 ly3EZwyIfuFEfP3F4bVM9WdFw/feZ07F7u3va0GVydf6pAQ9ALmM/Qbg3va0Ix59pw
	 rDs51q/Ci5LWTcnUIKbiixfYZ3V8oWniQXoWJ9po=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 042/150] drm/amd/display: Add null checker before passing variables
Date: Mon, 12 Aug 2024 18:02:03 +0200
Message-ID: <20240812160126.788434928@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160125.139701076@linuxfoundation.org>
References: <20240812160125.139701076@linuxfoundation.org>
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

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit 8092aa3ab8f7b737a34b71f91492c676a843043a ]

Checks null pointer before passing variables to functions.

This fixes 3 NULL_RETURNS issues reported by Coverity.

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Acked-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 31bae620aeffc..6189685af1fda 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -2636,7 +2636,8 @@ static int dm_suspend(void *handle)
 
 		dm->cached_dc_state = dc_copy_state(dm->dc->current_state);
 
-		dm_gpureset_toggle_interrupts(adev, dm->cached_dc_state, false);
+		if (dm->cached_dc_state)
+			dm_gpureset_toggle_interrupts(adev, dm->cached_dc_state, false);
 
 		amdgpu_dm_commit_zero_streams(dm->dc);
 
@@ -6388,7 +6389,8 @@ static void create_eml_sink(struct amdgpu_dm_connector *aconnector)
 		aconnector->dc_sink = aconnector->dc_link->local_sink ?
 		aconnector->dc_link->local_sink :
 		aconnector->dc_em_sink;
-		dc_sink_retain(aconnector->dc_sink);
+		if (aconnector->dc_sink)
+			dc_sink_retain(aconnector->dc_sink);
 	}
 }
 
@@ -7121,7 +7123,8 @@ static int amdgpu_dm_connector_get_modes(struct drm_connector *connector)
 				drm_add_modes_noedid(connector, 640, 480);
 	} else {
 		amdgpu_dm_connector_ddc_get_modes(connector, edid);
-		amdgpu_dm_connector_add_common_modes(encoder, connector);
+		if (encoder)
+			amdgpu_dm_connector_add_common_modes(encoder, connector);
 		amdgpu_dm_connector_add_freesync_modes(connector, edid);
 	}
 	amdgpu_dm_fbc_init(connector);
-- 
2.43.0



