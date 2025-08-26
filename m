Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 768B834F463;
	Tue, 26 Aug 2025 14:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217420; cv=none; b=HqqhBVHqd1KLpW7I556nDLHc92EMwk82/Vsdr5gSFOjoCDj0x0v3GesGy/24o011eIcTj37AWqEhRnJp/zTRGPKFZehjnU37n3TRLFP4KdzHUj7T/bEBfzqKAohVZ6EpaR++rBFgE3vqWyxP0eADZYYEYAykhLIidvoGBoHW5nE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217420; c=relaxed/simple;
	bh=2fn6tzhCZJauubxkdGvLgQSf8ImH/Mxn5a6YR0h8AWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VOkL5P0Nd/MrdL01TSqO1fWByRXP2JUv3joMLvgYmBsfOA+3LrppoXcCx4EK0kxWy2YIFbg/oDFSwctiWEh/I/yyak2aBgyXuXCia7OM3EtO6eFCLY7LJwIERxJgDFO/ukV/1MxXYxKYgOre+NUMuGml/u+wZze5hHCyl+J6JaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JBHeQiY1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JBHeQiY1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3056C113CF;
	Tue, 26 Aug 2025 14:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217417;
	bh=2fn6tzhCZJauubxkdGvLgQSf8ImH/Mxn5a6YR0h8AWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JBHeQiY1TCfsa5I56vhUXZQTlpb/OW/4dtGtxSSoHDtIp9KnGuRrWk5HQ7FVux94w
	 ngzXLW3TKi1zNrunwPCySL5Ew9+cEMwahpflH7jJAtitqRMZTSjnDkGYO+6tG9Uf2v
	 3A0LbcWIhnyjlOKLKSiJlPbUQ1fXZGhNlywWsK1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 104/523] drm/amd/pm/powerplay/hwmgr/smu_helper: fix order of mask and value
Date: Tue, 26 Aug 2025 13:05:14 +0200
Message-ID: <20250826110927.102617308@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 60b5ca974356..80d5fb388003 100644
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



