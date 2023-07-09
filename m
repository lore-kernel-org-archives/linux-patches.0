Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 981CF4699
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:17:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15D04C433C8;
	Sun,  9 Jul 2023 11:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688901435;
	bh=7cc0PnaJmdFU76YjjptSHjlQuxq+M58aSoWEzgtEz9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qq5Bs2ulqzHA68tsw3M2sVtVKulgFkiKUGSPIlrJrpQkcs5U7kMiXSwtmwTuuO8RS
	 nqj6jjpqaxYjaJOO9GN6ZDH2T4DvqqzhXSuRyRRFoIJvNCRu7sSSwErXunB+0Jpx7g
	 zZ1ZjFd01dz8AytdMS3fPwPh7+Wm/zOCw+Qugq4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Jeff Layton <jlayton@kernel.org>,
	Jani Nikula <jani.nikula@intel.com>,
	Lyude Paul <lyude@redhat.com>,
	"Limonciello, Mario" <mario.limonciello@amd.com>
Subject: [PATCH 6.3 002/431] drm: use mgr->dev in drm_dbg_kms in drm_dp_add_payload_part2
Date: Sun,  9 Jul 2023 13:09:10 +0200
Message-ID: <20230709111451.163952244@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jeff Layton <jlayton@kernel.org>

commit 54d217406afe250d7a768783baaa79a035f21d38 upstream.

I've been experiencing some intermittent crashes down in the display
driver code. The symptoms are ususally a line like this in dmesg:

    amdgpu 0000:30:00.0: [drm] Failed to create MST payload for port 000000006d3a3885: -5

...followed by an Oops due to a NULL pointer dereference.

Switch to using mgr->dev instead of state->dev since "state" can be
NULL in some cases.

Link: https://bugzilla.redhat.com/show_bug.cgi?id=2184855
Suggested-by: Jani Nikula <jani.nikula@linux.intel.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230419112447.18471-1-jlayton@kernel.org
Cc: "Limonciello, Mario" <mario.limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/display/drm_dp_mst_topology.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/display/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/display/drm_dp_mst_topology.c
@@ -3404,7 +3404,7 @@ int drm_dp_add_payload_part2(struct drm_
 
 	/* Skip failed payloads */
 	if (payload->vc_start_slot == -1) {
-		drm_dbg_kms(state->dev, "Part 1 of payload creation for %s failed, skipping part 2\n",
+		drm_dbg_kms(mgr->dev, "Part 1 of payload creation for %s failed, skipping part 2\n",
 			    payload->port->connector->name);
 		return -EIO;
 	}


