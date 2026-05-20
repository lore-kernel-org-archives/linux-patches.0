Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3754367F58;
	Wed, 20 May 2026 16:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295115; cv=none; b=aNp6ByX6RPvMnlUc3cvTqQMzEy1NbwrsG/thqVzxxSwVS5MHgLJwYAnEPXtOhouYQNJA8Z/Bkhs1icwclQc11Q/mPAdOXJ1mSo6MV3CDf1UvGLIMuIpyjig7YKIG9tuQZZjN4oPlEkF+cjkywNyCfvb3R7K2RF1CgOtZmUHVJcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295115; c=relaxed/simple;
	bh=BfS6RJMQA0+yBzq6q3KBZiwEoa1j3AUN56z5u1ygozc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ds87MeOGiynqxo3yZZ4ln9ropNmC74cG0X/ViBZrxQNFZU5/XCFhva/ozrVsrvbcjWV7a+jtY0Zd2C0p1oa8pQy9xZ92hoV/J2Jmd9EhkwUeMfJDgaonGhCSqoCClSu/4CFOSw7plUXNg4hCEPnHbn6UrkiLfhZar4UTPqxj4o0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sg0lNv/W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sg0lNv/W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C1D61F000E9;
	Wed, 20 May 2026 16:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295113;
	bh=5bonZrYHwJAF/UGeIrA4fRG9RSfL01I27VEMmGGMAFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sg0lNv/WE5bVWmB6247b72fb3JDY+GS/id69DFdzNHAHU4T3+omE9qlw3h2ZaHJNS
	 lvBHZT0dbM+0OB2+5K5Ajl1wnusMFz7PCUPTi9j+DAanp9atQMtcek2Nq5raOj2Iqb
	 dbee9NrFvG7+C1NSu4znpcM8reHFFe+6MvDDd/Wg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	YiPeng Chai <YiPeng.Chai@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0294/1146] drm/amd/ras: Fix NULL deref in ras_core_ras_interrupt_detected()
Date: Wed, 20 May 2026 18:09:04 +0200
Message-ID: <20260520162154.866978066@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

[ Upstream commit 6b606216e03fa2b53cc179d8383b683a140fe6e1 ]

Fixes a NULL pointer dereference when ras_core is NULL and ras_core->dev
is accessed in the error path.

Fixes: 13c91b5b4378 ("drm/amd/ras: Add rascore unified interface function")
Reported by: Dan Carpenter <dan.carpenter@linaro.org>
Cc: YiPeng Chai <YiPeng.Chai@amd.com>
Cc: Tao Zhou <tao.zhou1@amd.com>
Cc: Hawking Zhang <Hawking.Zhang@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reviewed-by: Tao Zhou <tao.zhou1@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/ras/rascore/ras_core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/ras/rascore/ras_core.c b/drivers/gpu/drm/amd/ras/rascore/ras_core.c
index 9df05b3963edb..b81741a339b1b 100644
--- a/drivers/gpu/drm/amd/ras/rascore/ras_core.c
+++ b/drivers/gpu/drm/amd/ras/rascore/ras_core.c
@@ -530,7 +530,9 @@ bool ras_core_ras_interrupt_detected(struct ras_core_context *ras_core)
 		ras_core->sys_fn->detect_ras_interrupt)
 		return ras_core->sys_fn->detect_ras_interrupt(ras_core);
 
-	RAS_DEV_ERR(ras_core->dev, "Failed to detect ras interrupt!\n");
+	if (ras_core && ras_core->dev)
+		RAS_DEV_ERR(ras_core->dev, "Failed to detect ras interrupt!\n");
+
 	return false;
 }
 
-- 
2.53.0



