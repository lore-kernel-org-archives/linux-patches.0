Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 001D973466;
	Tue, 27 Aug 2024 15:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770815; cv=none; b=n180kiRY4lziz3aibe/B0DCKwgr938i9bYC6pdJYwt8IlbuTgO6/BuMLz2QdCg21Vfjsa+67UyyYcRQ7Squ5WZWiV7WWf45SEgY+n+vWmzJez4u1D5M3RG5gNSKCl8RVJJcHU3yOQe0geQ+IYW8kDBky96X/NM5lHXNfdyKYY+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770815; c=relaxed/simple;
	bh=4lfSmRx7sonzPYGF0lIBcR8QjKkV5jhWiFR1VHu/iGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LRP2XPJLXML+ysLrBPPZR+Lv5pgK4ZTL6GGQ0CFrWz/eLJLjBPqMXGLK2Z5O+RiuqWgI3/uS9NQvaJogTbMJhBdCr0QCzmlVjIALG/FFLytZ0Z8DJ8N+Pr2do59MEk2OQ9gXxiNP+p9y1SPhx6Zjw/Hz/RtyfRu+s+iuNfgdtN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BHcp/tjW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BHcp/tjW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6289AC4DDE2;
	Tue, 27 Aug 2024 15:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770814;
	bh=4lfSmRx7sonzPYGF0lIBcR8QjKkV5jhWiFR1VHu/iGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BHcp/tjWb0G2YiNyFhlk9hjPHZcDQbaDZST+ume33uRVho67+4BTYN3Y+bfOVwVWX
	 f+mJjYL7ff3hjuidterQBSumQHlwZb+pBn41v9VnG04IpQK3CbPpygtWUMTh9TjV6S
	 Nqr7KnMrwgU2GeT/NKV5T5nvLFl6sUPpnbVpmeK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 323/341] Revert "drm/amd/display: Validate hw_points_num before using it"
Date: Tue, 27 Aug 2024 16:39:14 +0200
Message-ID: <20240827143855.685141526@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Hung <alex.hung@amd.com>

commit 8f4bdbc8e99db6ec9cb0520748e49a2f2d7d1727 upstream.

This reverts commit 58c3b3341cea4f75dc8c003b89f8a6dd8ec55e50.

[WHY & HOW]
The writeback series cause a regression in thunderbolt display.

Signed-off-by: Alex Hung <alex.hung@amd.com>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_dwb_cm.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_dwb_cm.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_dwb_cm.c
@@ -243,9 +243,6 @@ static bool dwb3_program_ogam_lut(
 		return false;
 	}
 
-	if (params->hw_points_num == 0)
-		return false;
-
 	REG_SET(DWB_OGAM_CONTROL, 0, DWB_OGAM_MODE, 2);
 
 	current_mode = dwb3_get_ogam_current(dwbc30);


