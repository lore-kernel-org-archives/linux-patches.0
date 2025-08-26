Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 504784086A;
	Tue, 26 Aug 2025 13:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215739; cv=none; b=EUHN13kgYHt+cKbUwpZdg1/YcQgt21TXdtlVrj8onJZ3JH6l3JDWYawQWf73fUTKMQBMlnt3VXyy7eFFB39QDSAaiDUVpsDEBJlUH16UsPEuXT1TrU26otDLzn2XUkcSfLZbg7yOuNhaod+k/yuwCxXsVUer/Qlr9TIa1ZPavZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215739; c=relaxed/simple;
	bh=LyOD9YJqmn/7jpb9rLNdM+SIOM1jUmaxrmq/B1dpO68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=urfHP0ypA7msMF+iScBLeKWrCfKNszcK4VCO1r+tnLHLZJ6VSuFj0CbOvmpzDUr6OwnFZ9Z2YNYOJdlc5HjnrS2HT/GKAmF4WlHFdvGzrGsC/Yox26bkcuf5JFHCF2L0xExS2n63uddQYJurD8E+S7kwPn2MR4OHFbjnPal394M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SWHHL0qi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SWHHL0qi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDD89C113CF;
	Tue, 26 Aug 2025 13:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215739;
	bh=LyOD9YJqmn/7jpb9rLNdM+SIOM1jUmaxrmq/B1dpO68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SWHHL0qiRfE8qcXHIPdI64XflvxKXA9m18AKX1Wt4A5xlasag904vQNdh2P4ZbyMi
	 CgukrPR/Rrqo2VhXD1SS9UcASDXp2CLAo/776D2zyKSwUeupE+24fYIDB1W4C7ZvkO
	 PrYvza5DpThPzlwref09VbntkaMBTEbFXhb1uug4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 147/644] drm/amd/pm/powerplay/hwmgr/smu_helper: fix order of mask and value
Date: Tue, 26 Aug 2025 13:03:58 +0200
Message-ID: <20250826110950.130003638@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index bfe80ac0ad8c..fa2a91d16615 100644
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



