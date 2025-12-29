Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A147C334C05;
	Mon, 29 Dec 2025 16:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025930; cv=none; b=gJ1Mf9FqaVjay9XVQaoZZLD0ICPn6yO+AhF54sBNZgza3WI3L4w17Civ0cqjcINiz2h7ujBTZFOp87CdeQQ6PuHIfJR43fyCkeU4F00oMOhB5dkG4xpAUnWAyYbB8cYEcT/PM5YC+BC4j06u9Eq3qKHou6R0mJIwQU4m0rtTuEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025930; c=relaxed/simple;
	bh=9jZgm4iGB5vfosgl2o6EkgENqy0vQmqTKzD9rgieH5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u+iZmv86/dL5pEDvE4curQqcZtOchKKPNfTca2ercnNaXz3H+uxVLRNaWydkJwLwOgcebLZM6OgUp8CyIMwg5YO0sUzJF+B1bVBuwsoHOk7vDHdZJdwMZqPiEE/ONxA2UysByvHba5dMKXH45inIRZnaW9V4FIg5JKowYGBWVNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A+BlwFrk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A+BlwFrk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BA0FC4CEF7;
	Mon, 29 Dec 2025 16:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025930;
	bh=9jZgm4iGB5vfosgl2o6EkgENqy0vQmqTKzD9rgieH5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A+BlwFrkjh7cIPbR86l+u50EmYz7O3I9DavVixmFtJv9D6VaZ1D4anLSeFpjClCrK
	 ddBHeB9+KViz90yCy1pR4sU43hyvbBc9HT3p3FOmnn5JuLdstbsg2jXdK6RYqXQKap
	 +tkuEnR6uzlTVewMboYuUjKQbWsc2wE7w5SZGsw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Chenyu Chen <chen-yu.chen@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.18 388/430] drm/amd/display: Fix scratch registers offsets for DCN351
Date: Mon, 29 Dec 2025 17:13:10 +0100
Message-ID: <20251229160738.598531158@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Ray Wu <ray.wu@amd.com>

commit fd62aa13d3ee0f21c756a40a7c2f900f98992d6a upstream.

[Why]
Different platforms use different NBIO header files,
causing display code to use differnt offset and read
wrong accelerated status.

[How]
- Unified NBIO offset header file across platform.
- Correct scratch registers offsets to proper locations.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4667
Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Ray Wu <ray.wu@amd.com>
Signed-off-by: Chenyu Chen <chen-yu.chen@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 576e032e909c8a6bb3d907b4ef5f6abe0f644199)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/resource/dcn351/dcn351_resource.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/resource/dcn351/dcn351_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn351/dcn351_resource.c
@@ -183,12 +183,12 @@ enum dcn351_clk_src_array_id {
 	NBIO_BASE_INNER(seg)
 
 #define NBIO_SR(reg_name)\
-	REG_STRUCT.reg_name = NBIO_BASE(regBIF_BX2_ ## reg_name ## _BASE_IDX) + \
-				regBIF_BX2_ ## reg_name
+	REG_STRUCT.reg_name = NBIO_BASE(regBIF_BX1_ ## reg_name ## _BASE_IDX) + \
+				regBIF_BX1_ ## reg_name
 
 #define NBIO_SR_ARR(reg_name, id)\
-	REG_STRUCT[id].reg_name = NBIO_BASE(regBIF_BX2_ ## reg_name ## _BASE_IDX) + \
-		regBIF_BX2_ ## reg_name
+	REG_STRUCT[id].reg_name = NBIO_BASE(regBIF_BX1_ ## reg_name ## _BASE_IDX) + \
+		regBIF_BX1_ ## reg_name
 
 #define bios_regs_init() \
 		( \


