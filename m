Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19BDB18801A;
	Tue, 30 Jul 2024 16:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358404; cv=none; b=I5wO3Vc9GJ/uOu3rzdy4wDw/M4kLcVGzclTXDpRXBoF2/+YBJ6dIHhWAs6wQ5an56R3VzU+Y8o88qJo5oRGPcxsSfgP4qQvgMeNMU8pyZTrh8ntqZwPwzGFiE+eReNh3Dz3NiXTa9Xgh35JafPAYOpgmtUvv3kr5qZE1FsR9oVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358404; c=relaxed/simple;
	bh=fvdIlybOZp/9DafUqHNiY0Lu50IDFte2Z8vv2z06JCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Huv1ke0ma0Ys98W7HhsCRqDLAqzRmH8CgECQ63w00TNkLkO2iW6Gad1p20QQfxeeBG/6zx4XVlBRDIC0xzhrahTsA69OiFKjGr+DYCQ1uvn+b7WHm/NwloFkj47872VqKapKpbWytGfk6SBxk2WohIoETE0bqUkOeSMbRGdmEe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z7mJ1U47; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z7mJ1U47"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D599C4AF0C;
	Tue, 30 Jul 2024 16:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358404;
	bh=fvdIlybOZp/9DafUqHNiY0Lu50IDFte2Z8vv2z06JCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z7mJ1U47x/O2HG6EqGs7u7ZEZLFN9cVXTPJ+CQ5ppVArRV+ND/3Hsx1uxa90BkQfQ
	 /joOT1DYNRNOuvmqDrNW58ubMhTRtGnT/Ja8zXS2TiZr3ak8JVeX3sFrf6V4FLbvTO
	 h12b7W/lUiqr1FPxCoe81VAnJSJ+BeS2H3ahJug4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 356/809] drm/amd/display: Add null check before access structs
Date: Tue, 30 Jul 2024 17:43:52 +0200
Message-ID: <20240730151738.704897255@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make24@iscas.ac.cn>

[ Upstream commit c96140000915b610d86f941450e15ca552de154a ]

In enable_phantom_plane, we should better check null pointer before
accessing various structs.

Fixes: 09a4ec5da92c ("drm/amd/display: Refactor dc_state interface")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Reviewed-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dml2/dml2_mall_phantom.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dml2/dml2_mall_phantom.c b/drivers/gpu/drm/amd/display/dc/dml2/dml2_mall_phantom.c
index 282d70e2b18ab..3d29169dd6bbf 100644
--- a/drivers/gpu/drm/amd/display/dc/dml2/dml2_mall_phantom.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml2_mall_phantom.c
@@ -750,6 +750,8 @@ static void enable_phantom_plane(struct dml2_context *ctx,
 					ctx->config.svp_pstate.callbacks.dc,
 					state,
 					curr_pipe->plane_state);
+			if (!phantom_plane)
+				return;
 		}
 
 		memcpy(&phantom_plane->address, &curr_pipe->plane_state->address, sizeof(phantom_plane->address));
-- 
2.43.0



