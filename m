Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A50C4FD27B;
	Wed, 30 Sep 2026 19:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790797141; cv=none; b=iu1d2xLLtKkC6g5hTbyA3UCw10lVJZug4HGdBoJotJIJNFzuvmmWlnqGd8/mBAWoqqySDMhQ93a7GXYkxyA1cB+E1M/c1/+sykXHwuZU09svSr6tUMkUK+ZJevL76m9keBIyLg33A1Xx6LPkTmFyzHv1PYdAyT3GJ7BvBu0WhAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790797141; c=relaxed/simple;
	bh=90MSyW55OpB9PNxp8cPwDKgYNPeypPrwRKqH301IsoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ml2+rPqH0GZC5hpBJXR93GRhQtXPXGaTSe6PFuOyo87+Sxuc5FdK+LqJPeiCu0RW4nB2kbMQ4yDOAl+JgEvFJoNj9ESkVQVvfhZ6QT0GN5FHYCR1rulukYivgXhSHGx+ay2hmcoR0A7qhH0bi9v/2/uFNdnqafyhnAOiv7xaUCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iCDtQ8cu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iCDtQ8cu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FCE51F000FF;
	Wed, 30 Sep 2026 19:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790797139;
	bh=OUbDWzvhK9zV39xK16fHX7IEsNaJe9yRNA5CqJ9+2cc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iCDtQ8cuMBDfsqtmKDNy0a2lR4TD+IHKDY7XJDnk9GclHODo4p2kDehD9gdR6FLcw
	 ApBk3t9pJXjmZVvtjssdXYlAzpvbVA33sZ8ml4hPa2ttF0t6yVhPMlkk4y799/wuZj
	 n8q0Ni1laYGv9myzm3Eqg0k/HKZgf2YxPb2O1Rgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Charlene Liu <charlene.liu@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Allen Pan <allen.pan@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Artem Dinaburg <artem@trailofbits.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1161/1193] drm/amd/display: Add a dc_state NULL check in dc_state_release
Date: Wed, 30 Sep 2026 17:30:45 +0200
Message-ID: <20260930152500.040206249@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Allen Pan <allen.pan@amd.com>

[ Upstream commit 334b56cea5d9df5989be6cf1a5898114fa70ad98 ]

[How]
Check wheather state is NULL before releasing it.

[ Backport to 6.6.y: implemented the same guard in older
  dc_release_state() in dc.c rather than dc_state_release() in
  dc_state.c. ]

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Charlene Liu <charlene.liu@amd.com>
Acked-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Allen Pan <allen.pan@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Assisted-by: LLM
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index 50b860c07ae01..50df677d509dc 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -2302,7 +2302,8 @@ static void dc_state_free(struct kref *kref)
 
 void dc_release_state(struct dc_state *context)
 {
-	kref_put(&context->refcount, dc_state_free);
+	if (context != NULL)
+		kref_put(&context->refcount, dc_state_free);
 }
 
 bool dc_set_generic_gpio_for_stereo(bool enable,
-- 
2.53.0



