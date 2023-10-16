Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E400B1A5A7
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 09:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zaN2LVJK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EC5EC433C9;
	Mon, 16 Oct 2023 09:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697446938;
	bh=u/twJOzuDdkjoh3v7rrhvMJkphHCSG3t1ZRJf958IPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zaN2LVJKV9MKJ9KogK0kkXMc6jobi07uK2RsCd7x7Qu4dUyfNZW+CBlDf39b5N6Mm
	 /L4sql9h/O3RA11WnDx3RTxvVtggyKGhyHDHS/EEqhoJm9KtF11O8Z7tGt7ONgDWdW
	 GPszXgrjCFp0em0JXCGx+E875casxTl3ZngOy5io=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charlene Liu <charlene.liu@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Daniel Miess <daniel.miess@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.1 092/131] drm/amd/display: Dont set dpms_off for seamless boot
Date: Mon, 16 Oct 2023 10:41:15 +0200
Message-ID: <20231016084002.353509339@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084000.050926073@linuxfoundation.org>
References: <20231016084000.050926073@linuxfoundation.org>
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

From: Daniel Miess <daniel.miess@amd.com>

commit 23645bca98304a2772f0de96f97370dd567d0ae6 upstream.

[Why]
eDPs fail to light up with seamless boot enabled

[How]
When seamless boot is enabled don't configure dpms_off
in disable_vbios_mode_if_required.

Reviewed-by: Charlene Liu <charlene.liu@amd.com>
Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Daniel Miess <daniel.miess@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -1183,6 +1183,9 @@ static void disable_vbios_mode_if_requir
 		if (stream == NULL)
 			continue;
 
+		if (stream->apply_seamless_boot_optimization)
+			continue;
+
 		// only looking for first odm pipe
 		if (pipe->prev_odm_pipe)
 			continue;


