Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41A15139579;
	Tue, 27 May 2025 17:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365802; cv=none; b=C7BA90sIt+aCJZFN4nWOEPfrNFxl2tcHJzszYva8ZpJTh4k2AUNywfJO13rjjqfhIvYYqVdpLwa/ViDL4lzX6Hph322sk7QU7mEHrgE5U+fMaO3lgMgQRiLUmk+9/NEvOo4KhFkBRAUZn1fhfvTBv2povBExXeegGOWiSJwjI6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365802; c=relaxed/simple;
	bh=2S5jRVjc/CKu+0euWlr9bugvaGj6GWfl+BMqwXcHIQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F1jV4VnBQwFpJK+Whjl1Q0uKWw6yE+TB66HK/mWEtJSJ02PXF3GtUcbWNZmRh+MHpYMAa7MdHe8U7BnHPsV+ZMoZAUdbhSlfShEQJDe5cuXxbB5SqY+naa+MQlB1QYPBQoc9yUtQldWgRrpOLKgfBWea+Jf7tD9GdeAIDUYFUV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Y95tTJv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Y95tTJv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAFF4C4CEE9;
	Tue, 27 May 2025 17:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365802;
	bh=2S5jRVjc/CKu+0euWlr9bugvaGj6GWfl+BMqwXcHIQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Y95tTJvhmDRufzvKtqv+bSTilWj8OBgEc3gNKIB+7akx80O+++LR0z152YEFjQ3H
	 aGUvuHenTLoVw3RXtBFYIMGZ8eK9Sp4XpKDuafRdUsGXI+Y+WYgCSbej2Buq8p77lp
	 WoE49IROJKE6a/FrM2UI7btc12fYV/rNB1mcig+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhi Wang <zhiw@nvidia.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 494/626] drm/nouveau: fix the broken marco GSP_MSG_MAX_SIZE
Date: Tue, 27 May 2025 18:26:27 +0200
Message-ID: <20250527162505.051504793@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

From: Zhi Wang <zhiw@nvidia.com>

[ Upstream commit bbae6680cfe38b033250b483722e60ccd865976f ]

The macro GSP_MSG_MAX_SIZE refers to another macro that doesn't exist.
It represents the max GSP message element size.

Fix the broken marco so it can be used to replace some magic numbers in
the code.

Signed-off-by: Zhi Wang <zhiw@nvidia.com>
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20250124182958.2040494-8-zhiw@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c b/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c
index 9c83bab0a5309..fc84ca214f247 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c
@@ -58,7 +58,7 @@
 #include <linux/parser.h>
 
 #define GSP_MSG_MIN_SIZE GSP_PAGE_SIZE
-#define GSP_MSG_MAX_SIZE GSP_PAGE_MIN_SIZE * 16
+#define GSP_MSG_MAX_SIZE (GSP_MSG_MIN_SIZE * 16)
 
 struct r535_gsp_msg {
 	u8 auth_tag_buffer[16];
-- 
2.39.5



