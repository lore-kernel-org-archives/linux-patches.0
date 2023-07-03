Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 770CB1094A
	for <patches@lists.linux.dev>; Mon,  3 Jul 2023 18:56:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0451CC433C8;
	Mon,  3 Jul 2023 18:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688410601;
	bh=FM2FZD3XMMZ4LcjN5nnVh4kN9kWa0KoC93RCCXXbGlM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DmC/2pd935D+Bp+VD/X2mwMeelGRtoNgDvwPgBvi09wjqY21NDg5us8iqSQroL0Sy
	 vbSi3zkGE+Xu77YnXG3t7wz8wXvDdtGchzNb280HO2Tu4I/cksGP9HlfEeSclSlVZB
	 EjwRMecV3JnTM49OyK9JXxRpkn5JsNaua8K9CoOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Broadworth <mark.broadworth@amd.com>,
	Aric Cyr <Aric.Cyr@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Alvin Lee <Alvin.Lee2@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 6.1 02/11] drm/amd/display: Remove optimization for VRR updates
Date: Mon,  3 Jul 2023 20:54:21 +0200
Message-ID: <20230703184519.190634362@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230703184519.121965745@linuxfoundation.org>
References: <20230703184519.121965745@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alvin Lee <Alvin.Lee2@amd.com>

commit 3442f4e0e55555d14b099c17382453fdfd2508d5 upstream.

Optimization caused unexpected regression, so remove for now.

Tested-by: Mark Broadworth <mark.broadworth@amd.com>
Reviewed-by: Aric Cyr <Aric.Cyr@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alvin Lee <Alvin.Lee2@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -401,9 +401,6 @@ bool dc_stream_adjust_vmin_vmax(struct d
 {
 	int i;
 
-	if (memcmp(adjust, &stream->adjust, sizeof(struct dc_crtc_timing_adjust)) == 0)
-		return true;
-
 	stream->adjust.v_total_max = adjust->v_total_max;
 	stream->adjust.v_total_mid = adjust->v_total_mid;
 	stream->adjust.v_total_mid_frame_num = adjust->v_total_mid_frame_num;


