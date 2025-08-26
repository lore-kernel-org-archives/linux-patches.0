Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E551A2AE7F;
	Tue, 26 Aug 2025 14:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216904; cv=none; b=mIS65c0C9PHmsHpe1u0iICPfQSPB1Mh4sk/HkNGE9UASVZTvvLfaI1VfP6dQ7nL8Q8XG4a0uVeHm2sBkHSnjVfmmixO9CUyOJTD4O0b1zTcyEOq4O0yhOCCZkLR+aSHgr8jCantSlWkfovgomD036tZj7FPfvM6tOZX4LGC0C04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216904; c=relaxed/simple;
	bh=XzVamd1rf5efMgbJmDOI/ZsESUE7vZj9cEaYW8oT0TY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KwaFRoe/UT5pNWAl1algvqu3W6XX8dcC3PRnfDBwVRVPPntc5imahJrBCpTOBaO0bVXbTF0i3YBAqCDzA/etG74Lvhh7Kfl18cY/JhaaUdEF9iPXJV9/jOzwsanEn0Mq2pftf1uXefCZ4TgG/TQsJ1g0uCX0a3vQaShdPbq0Bzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WlrT8mxb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WlrT8mxb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78D5DC4CEF1;
	Tue, 26 Aug 2025 14:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216903;
	bh=XzVamd1rf5efMgbJmDOI/ZsESUE7vZj9cEaYW8oT0TY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WlrT8mxbscaSH7LRPl4kqEEYyXk+tkHDBRd2fPyXTmfJLILQYcyhbrCoAr4DvJNrG
	 5Qxq9uWDpsPcCWGlVfYsfdDgiDjIeuVCLFLuKGiA7Y5oAKVxB95lb5bvkHrPaWF8S/
	 M6mNF53I+JAkq3VVsW1T2PcuZQ4q/4AGGxzU7P7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 5.15 569/644] drm/amd/display: Avoid a NULL pointer dereference
Date: Tue, 26 Aug 2025 13:11:00 +0200
Message-ID: <20250826111000.631647339@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

commit 07b93a5704b0b72002f0c4bd1076214af67dc661 upstream.

[WHY]
Although unlikely drm_atomic_get_new_connector_state() or
drm_atomic_get_old_connector_state() can return NULL.

[HOW]
Check returns before dereference.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 1e5e8d672fec9f2ab352be121be971877bff2af9)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -7105,6 +7105,9 @@ amdgpu_dm_connector_atomic_check(struct
 	struct drm_crtc_state *new_crtc_state;
 	int ret;
 
+	if (WARN_ON(unlikely(!old_con_state || !new_con_state)))
+		return -EINVAL;
+
 	trace_amdgpu_dm_connector_atomic_check(new_con_state);
 
 	if (!crtc)


