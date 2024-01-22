Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA75212A17F;
	Tue, 23 Jan 2024 00:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968798; cv=none; b=UJq7KAKj7msm0fC3IvsGqaUaURkRJ9q5G+CxIxHDBMSC1uXtWlvBDh0b1skILXwFrG7DFo/Aee2wArI3o5qSrhLOstPxkR38sYprVpFe8YZ/oHy5GSht8xGvqTHZa2bSGYCclDNvb/hyEF7Sypl0+sd8P+9X3reBecbjmaeW8+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968798; c=relaxed/simple;
	bh=Xzpiy7mMEN0UQXCXiymoUWcuzDOLyJCuaeG7XvzD7wk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GHoe22RTOmrWg+HN8m0XWa6M3LztBiRsCs2qII395xkmKg6OAI6IbsUwE150TkfvQ1/TkVL6/jGxt2R5ZAS5eB9JxC1iNrAiPXkC1ZYOsLTdoRzdzCSWfRc7bDgz5l+DuuuhcVD3oP9zKrwFPKLkCQcXzq+AKXuu3FuJsl+LnaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1/WgXfZh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1/WgXfZh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D0B8C43390;
	Tue, 23 Jan 2024 00:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968798;
	bh=Xzpiy7mMEN0UQXCXiymoUWcuzDOLyJCuaeG7XvzD7wk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1/WgXfZhsvPYh0CC28y5WwWgairBiLtB1QNK4O+s+pVxb4n5GpB6TO6ZdhT257Wa5
	 KwrSMbmWlBnkMFkOokC1X47B+Olbx49/cM7YVdO4DnkpOCBUz6iDMyzeSia8vqd+XJ
	 +1fK9EWmHpNgE1bCiv5wZcSnsQlvIANxQszMP8c4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	Paul Moore <paul@paul-moore.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 054/194] net: netlabel: Fix kerneldoc warnings
Date: Mon, 22 Jan 2024 15:56:24 -0800
Message-ID: <20240122235721.518576296@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Lunn <andrew@lunn.ch>

[ Upstream commit 294ea29113104487a905d0f81c00dfd64121b3d9 ]

net/netlabel/netlabel_calipso.c:376: warning: Function parameter or member 'ops' not described in 'netlbl_calipso_ops_register'

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Acked-by: Paul Moore <paul@paul-moore.com>
Link: https://lore.kernel.org/r/20201028005350.930299-1-andrew@lunn.ch
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: ec4e9d630a64 ("calipso: fix memory leak in netlbl_calipso_add_pass()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netlabel/netlabel_calipso.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netlabel/netlabel_calipso.c b/net/netlabel/netlabel_calipso.c
index 249da67d50a2..7068b4be4091 100644
--- a/net/netlabel/netlabel_calipso.c
+++ b/net/netlabel/netlabel_calipso.c
@@ -366,6 +366,7 @@ static const struct netlbl_calipso_ops *calipso_ops;
 
 /**
  * netlbl_calipso_ops_register - Register the CALIPSO operations
+ * @ops: ops to register
  *
  * Description:
  * Register the CALIPSO packet engine operations.
-- 
2.43.0



