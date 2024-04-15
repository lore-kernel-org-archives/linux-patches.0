Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DCF07A705;
	Mon, 15 Apr 2024 14:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191891; cv=none; b=HNQ7mlyZtCuuN8Y1iAX1l3BfpXQ2RrQV7Ep6kCsY0Z/DX+yTTijm2SMRxlQ0XJSBG1TYyj88G8juagDkm3nY0zQbbQQ2PgG+Bx+8H/r+LIIjxUmX2bISghPnmEgUtCO37q7M6tceL9a8qYyC1FDH9S30D3RBLTG0IvoaZWv/YqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191891; c=relaxed/simple;
	bh=1eiGAwvXGsEe8YL/J1mL4TQEiq+/lGC5aDGJxdpVPwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=falE+5NMX4qyvDJielxw3qA655GThAvuKT9ZMpJuyN1e6PGzK5VUX4d2t7jWipuF3O2R5l7pDeujKcA+yTOe27BsnPqrkpCKD2ZHojOzZXK7axLyW2ygB2QAQ81w0HMmsYsIpdDvetU/GOsz0nYMYUZfzcHm6ZQk+jyVIoWaNsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R54L6jIx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R54L6jIx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 870A7C113CC;
	Mon, 15 Apr 2024 14:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191890;
	bh=1eiGAwvXGsEe8YL/J1mL4TQEiq+/lGC5aDGJxdpVPwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R54L6jIx99tOk4Yha0samr7T/TU0wH2p5u2icVmlFgO32uk9+VYUEXsTryYqm/i8+
	 MMFgughyPacBfzhLBfsRR35MTJq7JgE1qYwHMUpbOF8ejHBF4TcZZPzR9pILbnCGG9
	 kcSIlVKIbD7jYPW4JkwmPOisp/5bbD0bW13rJSRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Huang <Tim.Huang@amd.com>,
	Yifan Zhang <yifan1.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 119/122] drm/amdgpu: fix incorrect number of active RBs for gfx11
Date: Mon, 15 Apr 2024 16:21:24 +0200
Message-ID: <20240415141956.940231208@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141953.365222063@linuxfoundation.org>
References: <20240415141953.365222063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1616,7 +1616,7 @@ static void gfx_v11_0_setup_rb(struct am
 			active_rb_bitmap |= (0x3 << (i * rb_bitmap_width_per_sa));
 	}
 
-	active_rb_bitmap |= global_active_rb_bitmap;
+	active_rb_bitmap &= global_active_rb_bitmap;
 	adev->gfx.config.backend_enable_mask = active_rb_bitmap;
 	adev->gfx.config.num_rbs = hweight32(active_rb_bitmap);
 }


