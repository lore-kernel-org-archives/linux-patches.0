Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E291297112;
	Mon, 12 May 2025 18:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073378; cv=none; b=FDolJA0ZqKMAwUH0d9B3UmxyVVWerJTI281yNzm2di+0Uyi6GGC8KnQAtFt5kR0w55NlI2bsG0PkimZf9hO80CKPf6HF9Mv0B7D1NYzfqYhMhYtEvLhrRAsghgxas0j3Dll3PnpnZq8CKqQ9bGMB90Mmguvy0uHsLaY5Wb2w1as=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073378; c=relaxed/simple;
	bh=EsKfOkhVFzChqnjNgclpzQ00E4/ZEYEg6NwK05aJz6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U6n4i2tDl6/RG1C+gf+NYJhlTO22hSO9pt/3LZHalAa3J4jATlcqbIb78/le/amhzK9uFZjqdTMU9oxCH82Cc3nkFLcsqnCsLr02VuZYFuM0DoJWFBDG9Q8HTQhuYmRHVfX0zlwMg0/4Fv23pomfApmJFHJ8EypgXXa+PZb0pY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rpkBA9mG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rpkBA9mG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B537C4CEE7;
	Mon, 12 May 2025 18:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073377;
	bh=EsKfOkhVFzChqnjNgclpzQ00E4/ZEYEg6NwK05aJz6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rpkBA9mGexQ3b3axB6ds+4u0Xf5iJtmNLiYpW7+lEOorKyGBH4lnU+L8HDxQ8WmCp
	 D2rBTjtBEvY3t/zNplVUvTkMN5A+vy6rZcfrK26TtsQTT4wXPmv+OUVzjTyqap24Pn
	 NvLPU03R59sEQY7v+yl8MFMoZPHO5QFa3EMHMuys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ray Wu <ray.wu@amd.com>,
	Wayne Lin <Wayne.Lin@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 049/113] drm/amd/display: Fix the checking condition in dmub aux handling
Date: Mon, 12 May 2025 19:45:38 +0200
Message-ID: <20250512172029.672052302@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172027.691520737@linuxfoundation.org>
References: <20250512172027.691520737@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wayne Lin <Wayne.Lin@amd.com>

commit bc70e11b550d37fbd9eaed0f113ba560894f1609 upstream.

[Why & How]
Fix the checking condition for detecting AUX_RET_ERROR_PROTOCOL_ERROR.
It was wrongly checking by "not equals to"

Reviewed-by: Ray Wu <ray.wu@amd.com>
Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
Signed-off-by: Ray Wu <ray.wu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 1db6c9e9b62e1a8912f0a281c941099fca678da3)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -11055,7 +11055,7 @@ int amdgpu_dm_process_dmub_aux_transfer_
 		 * Transient states before tunneling is enabled could
 		 * lead to this error. We can ignore this for now.
 		 */
-		if (p_notify->result != AUX_RET_ERROR_PROTOCOL_ERROR) {
+		if (p_notify->result == AUX_RET_ERROR_PROTOCOL_ERROR) {
 			DRM_WARN("DPIA AUX failed on 0x%x(%d), error %d\n",
 					payload->address, payload->length,
 					p_notify->result);


