Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24BE8328B58;
	Fri,  9 Jan 2026 12:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960675; cv=none; b=HeMRUQpKQpDKZH7cR7yjYHWHb2red7o/nEmJrazsqRxdt/KopAWKJThdKfpv2xYuDYZSfxnIP/VAKj+ncUIGs/POUJDkSnJltGYJfTChpmf+sY3toOpx9zfqD0fe9md2fZWKzWmXXiwa6uF2A+loFLdsWm/cA7by7mkHp0vhNH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960675; c=relaxed/simple;
	bh=tDy25k0Geii++Bw0j5yKaMwx8CFeKcWjqU1sHAXZdOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X0efumxc22EdFUXTRqVDPJOsx8Pdj09LP8tmIDn1H8IcqIPfmfb3VT2Odzv6G3OdhergnfQsUH/9El04Tw3K26xnY9X/LhHW/NNhQXbM81q7a549012CV9uQ+iWNYdxxpeJYiEW89Ni96tdDpPvhQ+KxXNM8dLERRlVs6clYvvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Br6SEZgF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Br6SEZgF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74E08C4CEF1;
	Fri,  9 Jan 2026 12:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960674;
	bh=tDy25k0Geii++Bw0j5yKaMwx8CFeKcWjqU1sHAXZdOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Br6SEZgFzguNWc/8gVXN5BwMwoHpCcgac6uUMtK/cuX15qr700y/nuDllj4rI2eZV
	 dM1bxM/PJNEe10kV/ntrbfJPw1/tVL9nUMArv6/UvZEjp9zw9HlBydV9fdvRlxuGib
	 MsGQBCt3AQpYCeCZYFc959K8r+fld6U3MEqjp4Cw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 485/737] drm/amd/display: Use GFP_ATOMIC in dc_create_plane_state()
Date: Fri,  9 Jan 2026 12:40:24 +0100
Message-ID: <20260109112152.231025728@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Alex Deucher <alexander.deucher@amd.com>

commit 3c41114dcdabb7b25f5bc33273c6db9c7af7f4a7 upstream.

This can get called from an atomic context.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4470
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 8acdad9344cc7b4e7bc01f0dfea80093eb3768db)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_surface.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/core/dc_surface.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_surface.c
@@ -104,7 +104,7 @@ void enable_surface_flip_reporting(struc
 struct dc_plane_state *dc_create_plane_state(struct dc *dc)
 {
 	struct dc_plane_state *plane_state = kvzalloc(sizeof(*plane_state),
-							GFP_KERNEL);
+							GFP_ATOMIC);
 
 	if (NULL == plane_state)
 		return NULL;


