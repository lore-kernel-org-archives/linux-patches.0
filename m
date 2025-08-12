Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01B03305E08;
	Tue, 12 Aug 2025 18:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022239; cv=none; b=A6tj3P/C2stv2hqFMqgqbnuRaMLcA6Y25IPKQa955S5yNzzA5l4u83mYGl64MQe171GXqPzsVh7L2S6p4n0KMyieIzaOkN0zBio7oElPvuLfK3+Qi658GnSq3TgtaavREDfw4WXMHuUjIeCQ/wludx2UBD+vtDQX6Wr1v91rehE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022239; c=relaxed/simple;
	bh=6NmMwzl3y5jFUklY0tfWeV93qMJIZN10hmzqQ4i8IZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OnaMO6lw1aO6AOBBAUpN4y/Zyoam4+de8BsTyLPsg8Dd88AIRoD6h+KvGbdB0e68wf05wLLBPXcuFRQBQCLIfgMaw610mCtJsJ48LHxr6uuL8xzz8dCHjkPaX6ynY5kGXYEif9FuVKa0WnnwQm4s5PK6viU3ap/SMsgVvjXRSoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dCKOWL4c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dCKOWL4c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AA02C4CEF0;
	Tue, 12 Aug 2025 18:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022238;
	bh=6NmMwzl3y5jFUklY0tfWeV93qMJIZN10hmzqQ4i8IZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dCKOWL4ciawqLbJonwh+wWZB+bD9aJBJ33P3Xxe5Whk3woGoXy8Tt01m6zFY6hTNp
	 mjI2IqB++cJBSy5MBuQmHGR3Jx0ZYnOGKuAl0VOStH7OFk6/3dEWuU/xpc4Xfyxj71
	 J9WWcIadjkqeaEwdPcFCNx6kOuC+rUVpZC1M81hA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 095/369] drm/amd/pm/powerplay/hwmgr/smu_helper: fix order of mask and value
Date: Tue, 12 Aug 2025 19:26:32 +0200
Message-ID: <20250812173018.357011220@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fedor Pchelkin <pchelkin@ispras.ru>

[ Upstream commit a54e4639c4ef37a0241bac7d2a77f2e6ffb57099 ]

There is a small typo in phm_wait_on_indirect_register().

Swap mask and value arguments provided to phm_wait_on_register() so that
they satisfy the function signature and actual usage scheme.

Found by Linux Verification Center (linuxtesting.org) with Svace static
analysis tool.

In practice this doesn't fix any issues because the only place this
function is used uses the same value for the value and mask.

Fixes: 3bace3591493 ("drm/amd/powerplay: add hardware manager sub-component")
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu_helper.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu_helper.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu_helper.c
index 79a566f3564a..c305ea4ec17d 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu_helper.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu_helper.c
@@ -149,7 +149,7 @@ int phm_wait_on_indirect_register(struct pp_hwmgr *hwmgr,
 	}
 
 	cgs_write_register(hwmgr->device, indirect_port, index);
-	return phm_wait_on_register(hwmgr, indirect_port + 1, mask, value);
+	return phm_wait_on_register(hwmgr, indirect_port + 1, value, mask);
 }
 
 int phm_wait_for_register_unequal(struct pp_hwmgr *hwmgr,
-- 
2.39.5



