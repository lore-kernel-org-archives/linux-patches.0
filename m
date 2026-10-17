Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C64233B1EC8;
	Sat, 17 Oct 2026 17:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257679; cv=none; b=GM8IRUkKs8zp9QnS23DLqkmJ7Vt+rNncMk9yIoIOM7vGbyDazw9zK3DyfcMmVeikX1CCl+jc4mc3TDlZh4VF5wZK0FZqzT4H6wd9NdBY9pR5baFI3TgLSVG+4S8xNvzW4uKoW4Lp/5+ROuxfZ+yWODNHiVhBQQLAHvjfZSYqvTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257679; c=relaxed/simple;
	bh=Tw2GD1ehIl/ZUp9rwEZCpBN4haqwitLZJbV38eBk334=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GMckdEQ4gIckcn+XjLQkAdm5XT2/lnljsr0MugK6VfkpVgvu6G0YnkDm6IxiSCCDouygl/IzFEoCTJl0oYJIB5RzNStPN+T0GyENFX54z2Rttc2PZkJRwOOM4E3Zz0ixluvfEhbLzF+/Et+1PA0uQPPsBSuia2h2zXofdvAp7qE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nzx6lItf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nzx6lItf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15E0E1F000C4;
	Sat, 17 Oct 2026 17:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257678;
	bh=1aG8YAu7A4k6CDNVxl+2D+KdhEa9S3Z6T43llAWTFac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nzx6lItfQKKNYWPyeS1KwUIQshnlvfihfJSpjzc7/Xee/LhO/GnKp5tCCNHoHail3
	 oma4CaKzCbWCUfJkAxQTQ7DXd54jkqbwPRRQLyRr8J2JPBD6qxFBalJjH0ppsNCBEL
	 fiNq2NKIvVceKs3yRaF/CtDNXYg2L3YTaHQbQNUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Lenko Donchev <lenko.donchev@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0636/1674] drm/amd/display: Use kcalloc() instead of kzalloc()
Date: Sat, 17 Oct 2026 17:48:28 +0200
Message-ID: <20261017160447.422136269@linuxfoundation.org>
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

From: Lenko Donchev <lenko.donchev@gmail.com>

[ Upstream commit f634ee1737e7b856bd4c3f040af867007d1cb7b8 ]

We are trying to get rid of all multiplications from allocation
functions to prevent integer overflows. Here the multiplication is
obviously safe, but using kcalloc() is more appropriate and improves
readability. This patch has no effect on runtime behavior.

Link: https://www.kernel.org/doc/html/next/process/deprecated.html#open-coded-arithmetic-in-allocator-arguments
Link: https://github.com/KSPP/linux/issues/162

Reviewed-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Lenko Donchev <lenko.donchev@gmail.com>
Signed-off-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 5524fa301ba6 ("drm/amd/display: Add missing NULL pointer check within dpcd_extend_address_range")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/link/protocols/link_dpcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dpcd.c b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dpcd.c
index fc50931c2aecb..c5de6ed5bf581 100644
--- a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dpcd.c
+++ b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dpcd.c
@@ -164,7 +164,7 @@ static void dpcd_extend_address_range(
 	if (new_addr_range.start != in_address || new_addr_range.end != end_address) {
 		*out_address = new_addr_range.start;
 		*out_size = ADDRESS_RANGE_SIZE(new_addr_range.start, new_addr_range.end);
-		*out_data = kzalloc(*out_size * sizeof(**out_data), GFP_KERNEL);
+		*out_data = kcalloc(*out_size, sizeof(**out_data), GFP_KERNEL);
 	}
 }
 
-- 
2.53.0



