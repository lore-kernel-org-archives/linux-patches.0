Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EE7122F14C;
	Mon, 18 Aug 2025 13:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523833; cv=none; b=lIAU0HY8FhvSc3MQa5lRifBAeruBib5nM6EKBX3KAQ3ekBWamshyjpY8UTqzdVvLA5v7COauy4herHv97V7VLApf88e4lk7XBzG3JfOulz+GRGkR2ddn+7Yai0HlKsvaz1rFuw1MFDrj/EJU3IkKykRYnziGFs4okrhFq1M1JtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523833; c=relaxed/simple;
	bh=XWz9/jIEBRmInHQ2j6fSZP1Mhq/Cph8ortxfzY3vXEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eRquuAL6dNbHugcOeIGrJOOZhmK+U9TV2Do1n3lQ7oFtv5wS96AZsQlaeUZO6Dqvc/RI6yPJ9NY8mW9IIWVvSKOVZhPJ68D7FQe3dkTz8Mw5uCVdn/lCYIZSlMbbFICKO3GsHGIPmiulJigRXpom+0PRQ+TTgUR9SD/x2SMFVrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DLg3/GAR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DLg3/GAR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ABDDC4CEEB;
	Mon, 18 Aug 2025 13:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523833;
	bh=XWz9/jIEBRmInHQ2j6fSZP1Mhq/Cph8ortxfzY3vXEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DLg3/GARTWzD0Q8NuGpIIr2wdpC6zFpm/kvVjT7Gb/bU2LZE2OnxPe85I6jAKsBU1
	 7QlOmgFdcEs1EPnvKsObTTtONXVK5gWo5BZSFUOwzdqLihxbSApCp5s/joarFEIBBv
	 FnptiKhHrAWk45ou4bQOuDVk1Z+I1AeInj2A1Bko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Fangzhi Zuo <jerry.zuo@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 285/515] drm/amd/display: Initialize mode_select to 0
Date: Mon, 18 Aug 2025 14:44:31 +0200
Message-ID: <20250818124509.390115618@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit 592ddac93f8c02e13f19175745465f8c4d0f56cd ]

[WHAT]
mode_select was supposed to be initialized in mpc_read_gamut_remap but
is not set in default case. This can cause indeterminate
behaviors.

This is reported as an UNINIT error by Coverity.

Reviewed-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Fangzhi Zuo <jerry.zuo@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/mpc/dcn401/dcn401_mpc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/mpc/dcn401/dcn401_mpc.c b/drivers/gpu/drm/amd/display/dc/mpc/dcn401/dcn401_mpc.c
index ad67197557ca..63fb6777c1fd 100644
--- a/drivers/gpu/drm/amd/display/dc/mpc/dcn401/dcn401_mpc.c
+++ b/drivers/gpu/drm/amd/display/dc/mpc/dcn401/dcn401_mpc.c
@@ -571,7 +571,7 @@ void mpc401_get_gamut_remap(struct mpc *mpc,
 	struct mpc_grph_gamut_adjustment *adjust)
 {
 	uint16_t arr_reg_val[12] = {0};
-	uint32_t mode_select;
+	uint32_t mode_select = MPCC_GAMUT_REMAP_MODE_SELECT_0;
 
 	read_gamut_remap(mpc, mpcc_id, arr_reg_val, adjust->mpcc_gamut_remap_block_id, &mode_select);
 
-- 
2.39.5



