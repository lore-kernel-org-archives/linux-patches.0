Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D36D7356A12;
	Sat, 17 Oct 2026 17:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257682; cv=none; b=KYtPNucK1ixZVXcXdWzGEtKFBIsTBSKI7PHsbFBu7iGuDaObF0XhaFVRqYUDGAuapoWkuQ/DZWkf3La7zj4IocCB/ec2GA7TwD7ak51Z/lnm/wSKPGcf52XLFFYe0c6CJhRC5ucvH9pecvCf+7vFCeT9K8P5ftgpx3ujyfX6tx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257682; c=relaxed/simple;
	bh=weZqGLD7vRhWPsMu+6Ufm5EcMuHP8zLgkqIltnXcdmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f2Le+Di2KMCP1TMTM0iuDGzoxypVy965EOs2kJAHdspqroVuCcFLdnyqSUcY+ShuAHCFq5jEz2xDVaY/GbAjHIBJQL7b+O6QigsJvJI+3thBogQrUqnihgASg4RT4udkZwzYTzroHNIlsMsqxGmcK2lzhFIIBtas73FDIaNG2hE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=On/PGCze; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="On/PGCze"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3486C1F000C4;
	Sat, 17 Oct 2026 17:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257681;
	bh=NmWqzRCsAtf1D//YCaPPYbavUNhNQ7BDf9l43lG7P0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=On/PGCzehOUPtqLPnCaKAyNoBHo4H2mArfGC8/BFK2TOMCMT9Sn6/CH56N3oMDKsQ
	 Sti9JXMtMMZ2QNxVINQCyxLieYEP0iMf5Qr1FODn3Mek+OMhOl1HGEL5u1/8VtB0Zl
	 B8DTV55LRXV3ZwhZDwuAQjY8idYzQereu4ZarS9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Hersen Wu <hersenxs.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0637/1674] drm/amd/display: Add missing NULL pointer check within dpcd_extend_address_range
Date: Sat, 17 Oct 2026 17:48:29 +0200
Message-ID: <20261017160447.448408753@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Hersen Wu <hersenxs.wu@amd.com>

[ Upstream commit 5524fa301ba649f8cf00848f91468e0ba7e4f24c ]

[Why & How]
ASSERT if return NULL from kcalloc.

Reviewed-by: Alex Hung <alex.hung@amd.com>
Reviewed-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Hersen Wu <hersenxs.wu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/link/protocols/link_dpcd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dpcd.c b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dpcd.c
index c5de6ed5bf581..1fdbc6aa03683 100644
--- a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dpcd.c
+++ b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dpcd.c
@@ -165,6 +165,7 @@ static void dpcd_extend_address_range(
 		*out_address = new_addr_range.start;
 		*out_size = ADDRESS_RANGE_SIZE(new_addr_range.start, new_addr_range.end);
 		*out_data = kcalloc(*out_size, sizeof(**out_data), GFP_KERNEL);
+		ASSERT(*out_data);
 	}
 }
 
-- 
2.53.0



