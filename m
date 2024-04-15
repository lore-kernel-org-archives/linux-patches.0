Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16BC87A705;
	Mon, 15 Apr 2024 14:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191510; cv=none; b=qm01bUKWe6I0Jsuss8eA3ZI0DWPpOZ3X3MP5IlZHm01bfryqXElsd29dWPw44ki4cLwkj98O5Zu/tQH9Q+yahDIhukAuSRgFP8zjirY2LjNWjNW5tOTiwXuxSQJ7kAJiZHyO2roVAcyLWyMsuNxXmitt+btgrbV7j1ST7R8dooA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191510; c=relaxed/simple;
	bh=dtzMa4MJs11/6RH6lheuBCFJVkV7AZ26EyyvvVrtuiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lfaMeykVRf53XToHnGHR5QfZyLFPB4jPVFLXQ6OHEHUNScVgdniRpzKJV0tREcXNMHfuIa4v6XPmSKS7XR9EwB2f4izYoKu8O6LEw3NQrdZyWJFrfXMTk+5gjTQn6RKzU0xsru0nJLlPnTGi4PifC7YFnQZjC67NSQfrPmvHSDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EySTYizE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EySTYizE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9206DC113CC;
	Mon, 15 Apr 2024 14:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191510;
	bh=dtzMa4MJs11/6RH6lheuBCFJVkV7AZ26EyyvvVrtuiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EySTYizE+m6655hOqNHT0Wz6glxMNiHFoxI9cSUoGWsazbW8kI1BLK3RQ60FxDmbN
	 JhYlmvnNFIm0NK3zzYaIA21dRygSLIZwaZntpy7krtJH8mjj8NEqE2z0TGjTaw7rAW
	 gI32kb4NMs2C5Y/JkzmFupS6MUuAdnv8PnBkLb0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Huang <Tim.Huang@amd.com>,
	Yifan Zhang <yifan1.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.8 165/172] drm/amdgpu: fix incorrect number of active RBs for gfx11
Date: Mon, 15 Apr 2024 16:21:04 +0200
Message-ID: <20240415142005.362031511@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tim Huang <Tim.Huang@amd.com>

commit bbca7f414ae9a12ea231cdbafd79c607e3337ea8 upstream.

The RB bitmap should be global active RB bitmap &
active RB bitmap based on active SA.

Signed-off-by: Tim Huang <Tim.Huang@amd.com>
Reviewed-by: Yifan Zhang <yifan1.zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
@@ -1630,7 +1630,7 @@ static void gfx_v11_0_setup_rb(struct am
 			active_rb_bitmap |= (0x3 << (i * rb_bitmap_width_per_sa));
 	}
 
-	active_rb_bitmap |= global_active_rb_bitmap;
+	active_rb_bitmap &= global_active_rb_bitmap;
 	adev->gfx.config.backend_enable_mask = active_rb_bitmap;
 	adev->gfx.config.num_rbs = hweight32(active_rb_bitmap);
 }


