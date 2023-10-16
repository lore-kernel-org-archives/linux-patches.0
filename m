Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 361411A599
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 08:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fnVP/Wxm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C619C433C7;
	Mon, 16 Oct 2023 08:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697445879;
	bh=dbk6ZXGqlyANqcwXI1Q26u8eZIvdyVI78DTRkfI0Ais=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fnVP/WxmP6T2sM9BMO9KeZJjgwu/fZS9tKEMG7qOR22XHr7PioAZNFlQAtvtQ/P3B
	 PZtRGsSR22EMhiSUz1O4VsjdpBs2FsnH+wPxmsRQZ2Hzh7psnf9pM5pTlOT4EEe2Zq
	 qBPIVl0VRzfN0oZgZRiuHcw6XDN7ubYP02dRoJzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Meskhidze <konstantin.meskhidze@huawei.com>,
	Zack Rusin <zackr@vmware.com>,
	Sasha Levin <sashal@kernel.org>,
	Ivanov Mikhail <ivanov.mikhail1@huawei-partners.com>
Subject: [PATCH 5.15 030/102] drm/vmwgfx: fix typo of sizeof argument
Date: Mon, 16 Oct 2023 10:40:29 +0200
Message-ID: <20231016083954.504728182@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016083953.689300946@linuxfoundation.org>
References: <20231016083953.689300946@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>

[ Upstream commit 39465cac283702a7d4a507a558db81898029c6d3 ]

Since size of 'header' pointer and '*header' structure is equal on 64-bit
machines issue probably didn't cause any wrong behavior. But anyway,
fixing typo is required.

Fixes: 7a73ba7469cb ("drm/vmwgfx: Use TTM handles instead of SIDs as user-space surface handles.")
Co-developed-by: Ivanov Mikhail <ivanov.mikhail1@huawei-partners.com>
Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Reviewed-by: Zack Rusin <zackr@vmware.com>
Signed-off-by: Zack Rusin <zackr@vmware.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230905100203.1716731-1-konstantin.meskhidze@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
index ed75622bf7082..b91f8d17404d6 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
@@ -1632,7 +1632,7 @@ static int vmw_cmd_tex_state(struct vmw_private *dev_priv,
 {
 	VMW_DECLARE_CMD_VAR(*cmd, SVGA3dCmdSetTextureState);
 	SVGA3dTextureState *last_state = (SVGA3dTextureState *)
-	  ((unsigned long) header + header->size + sizeof(header));
+	  ((unsigned long) header + header->size + sizeof(*header));
 	SVGA3dTextureState *cur_state = (SVGA3dTextureState *)
 		((unsigned long) header + sizeof(*cmd));
 	struct vmw_resource *ctx;
-- 
2.40.1



