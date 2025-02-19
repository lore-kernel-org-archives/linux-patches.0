Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4268B1DEFE9;
	Wed, 19 Feb 2025 09:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956982; cv=none; b=VEVAU/3bNZrhn36hauo/T5I7tQR9ydkSV15neJ5XquzLId1HPJIYuaNCpGMBSK/kBrFOxaQz761TOhezc3qaXFMVK6HKjDOyvi/LSHjvMz/XZcFwtZI/hSkiOnq8D1Nad0WXdtkCVninItMaTTAfQcm99FdBzINqR8vBSS8kyBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956982; c=relaxed/simple;
	bh=1cS+/uktUWUByPkNXPLnVGAYBJkhsp6RIPubh/v8YLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Am6M8NZxV17UR5iZ6N5Zev0CSdXr90A7b3MgSFCrfaHDDa/g9xJmEgqxDEp9mGLuXNVctCKJbFEfLCbmUE1ZnAmg09No6tilmDnD2h3FxtFF6hnHi0GDJVUPCytzB3i7DlGH7cieOjRw41ZoGqfz6r+r1oKLD4QyyJyhwE9H/JQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k8nPUdaE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k8nPUdaE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C139EC4CED1;
	Wed, 19 Feb 2025 09:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956982;
	bh=1cS+/uktUWUByPkNXPLnVGAYBJkhsp6RIPubh/v8YLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k8nPUdaEjLTmwst2Je/oHJYsiIPah47JSWSfmYqLRO7yhhQsHMNaJm3w8bTlusLOR
	 ODSBsLb/N+T4lawm4S2DnshCehzSgdKzaGz+C7u+t28ekX6UXkb0queFGI54RQuKQl
	 GWS6V1FCPBDrTu700/U6T5n1Rs1wp98EHijVqNS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wayne Lin <wayne.lin@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 350/578] Revert "drm/amd/display: Use HW lock mgr for PSR1"
Date: Wed, 19 Feb 2025 09:25:54 +0100
Message-ID: <20250219082706.789516167@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tom Chung <chiahsuan.chung@amd.com>

commit f245b400a223a71d6d5f4c72a2cb9b573a7fc2b6 upstream.

This reverts commit
a2b5a9956269 ("drm/amd/display: Use HW lock mgr for PSR1")

Because it may cause system hang while connect with two edp panel.

Acked-by: Wayne Lin <wayne.lin@amd.com>
Signed-off-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dce/dmub_hw_lock_mgr.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dce/dmub_hw_lock_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dmub_hw_lock_mgr.c
@@ -65,8 +65,7 @@ void dmub_hw_lock_mgr_inbox0_cmd(struct
 
 bool should_use_dmub_lock(struct dc_link *link)
 {
-	if (link->psr_settings.psr_version == DC_PSR_VERSION_SU_1 ||
-	    link->psr_settings.psr_version == DC_PSR_VERSION_1)
+	if (link->psr_settings.psr_version == DC_PSR_VERSION_SU_1)
 		return true;
 	return false;
 }


