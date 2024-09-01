Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17AA8537FF;
	Sun,  1 Sep 2024 16:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208337; cv=none; b=HLfVqbqwtemAqWdHTvLjKTSVCKxG/ZFp6HpGX9a1PfhCFQ5SszirUHhGUoheuWQ7g4ayZh10FnOlm39r4bXPssr30aD1RSQOEV1ZgalbZU+3syWGqhmm+D1eHgvmiJJEr0Cy6MrNYCdlrQo72H+vzrmM1fEfQWKuBdrLUC/yRoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208337; c=relaxed/simple;
	bh=XS7DUdNTiKI5W3u3+tg8AhqG/nPnuIcvSBPTBf2y8X8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sR9vHeHoqWcli1JUjI2PnOzHV+z0XhxzsaEBysxxTpP3KsuqM9b44JBz1PO8WRvoUipTHgCIoqrRItjAw72D+M0Wk5yfyMOCkEWk1K3iIUvDyObF0xJd5/0VXXFMcm0Vc+zDBhxmZwNrgjKjW0QiscMFQZ4Ay51Hg6xQSOs0kKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fP+GFs7M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fP+GFs7M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A32DC4CEC3;
	Sun,  1 Sep 2024 16:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208337;
	bh=XS7DUdNTiKI5W3u3+tg8AhqG/nPnuIcvSBPTBf2y8X8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fP+GFs7Mj2kWPPS+iKnWC6Ih1ktzejGiBJGjVjxSZrYnzi+Lgf+tkTTOVtrsYeB0p
	 KR2O/Tv7kwFXz6VX8erE8/oaxdTl/Kmsvq1qsdZ9BW365I+0N3WpKhAsbYMyKmEAPT
	 ZO8xXGMQGXK0lsOPnLes4fSCA37U2Rf4+h+r+caA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Ma Jun <Jun.Ma2@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 050/149] drm/amdgpu: fix eGPU hotplug regression
Date: Sun,  1 Sep 2024 18:16:01 +0200
Message-ID: <20240901160819.349667766@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
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

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 9cead81eff635e3b3cbce51b40228f3bdc6f2b8c ]

The driver needs to wait for the on board firmware
to finish its initialization before probing the card.
Commit 959056982a9b ("drm/amdgpu: Fix discovery initialization failure during pci rescan")
switched from using msleep() to using usleep_range() which
seems to have caused init failures on some navi1x boards. Switch
back to msleep().

Fixes: 959056982a9b ("drm/amdgpu: Fix discovery initialization failure during pci rescan")
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3559
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3500
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Ma Jun <Jun.Ma2@amd.com>
(cherry picked from commit c69b07f7bbc905022491c45097923d3487479529)
Cc: stable@vger.kernel.org # 6.10.x
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
index ea5223388cff2..f1b08893765cf 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
@@ -269,7 +269,7 @@ static int amdgpu_discovery_read_binary_from_mem(struct amdgpu_device *adev,
 			msg = RREG32(mmMP0_SMN_C2PMSG_33);
 			if (msg & 0x80000000)
 				break;
-			usleep_range(1000, 1100);
+			msleep(1);
 		}
 	}
 
-- 
2.43.0



