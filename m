Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5C3C4F93C2;
	Thu, 17 Sep 2026 16:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664260; cv=none; b=FxPWWqIPYrdE78q2vk8fQpsar7xm4EL3sPvg6DB12YJt/dEWUubmlAu8Zz3PXiEDA8AW7nnW/bdM1nW20akgK9zmkdGVa5oOaZen/HM8jcFyFmLQaxbvRh00DG85j7Ctw3l/Yy9Uz7lG1Rz+ZsyX+91APN0sY5GyLemUkUYN+Bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664260; c=relaxed/simple;
	bh=R8POELAVaUsoHalIN6f8Dvpxh72vXGVXAMW3aNtMKKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DSNjWqK1QpKR0DubYLMRt6lLJ0keBt2cVdHG+lPk9Q3tNhG/Z3LiD2a9VuNwA0qw1CpAHnH4M5MP26U/lI4yfbcFOeBhfASg5N48MKUenHm5rv/5XrBL36MNO7hK7IFkBXDX6SDDASpfT44O04n2SWf5AZ7Ey/hi2ZRiV36WDd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FLRo4a87; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FLRo4a87"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37A631F000FF;
	Thu, 17 Sep 2026 16:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664258;
	bh=2yAJEFyOZoW3YgL5GKDqE1E5Svg0Z7P0k+XyTseoSSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FLRo4a87ycnuE7o0YzDbzTUZvAWrQGs1F+L5ZQ8895a8TnQmrbzAvrk/3tCW073Fj
	 /6x7qo3bFpwhKWqjETXLFCn3RlBr29520DFNCZctkvr1enjR3tniSovOB+fPkCnnVF
	 rIIw0EUoaO/rPLN3tdbaGW4quf12OcqTqiH56eh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alvin Lee <alvin.lee2@amd.com>,
	Ilya Bakoulin <Ilya.Bakoulin@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0312/1250] drm/amd/display: Avoid DPMS-on for phantom stream
Date: Thu, 17 Sep 2026 16:01:47 +0100
Message-ID: <20260917151600.559302695@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Bakoulin <Ilya.Bakoulin@amd.com>

[ Upstream commit 10f5f9c0ef32d08b228bfee3684b62f36f395852 ]

[Why & How]
Calling dc_update_planes_and_stream separately for stream and its
phantom stream causes a NULL pointer dereference, since the phantom is
destroyed on the first call.

Skip the call for phantom streams.

Reviewed-by: Alvin Lee <alvin.lee2@amd.com>
Signed-off-by: Ilya Bakoulin <Ilya.Bakoulin@amd.com>
Signed-off-by: Ray Wu <ray.wu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/link/accessories/link_dp_cts.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/link/accessories/link_dp_cts.c b/drivers/gpu/drm/amd/display/dc/link/accessories/link_dp_cts.c
index 2676ae9f6fe83..5f70793b8372e 100644
--- a/drivers/gpu/drm/amd/display/dc/link/accessories/link_dp_cts.c
+++ b/drivers/gpu/drm/amd/display/dc/link/accessories/link_dp_cts.c
@@ -143,6 +143,8 @@ static void dp_retrain_link_dp_test(struct dc_link *link,
 	// Set DPMS on with stream update
 	// Cache all streams on current link since dc_update_planes_and_stream might kill current_state
 	for (i = 0; i < MAX_PIPES; i++) {
+		if (state->streams[i] && state->streams[i]->is_phantom)
+			continue;
 		if (state->streams[i] && state->streams[i]->link && state->streams[i]->link == link)
 			streams_on_link[num_streams_on_link++] = state->streams[i];
 	}
-- 
2.53.0



