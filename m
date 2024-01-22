Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D3D11292EC;
	Tue, 23 Jan 2024 00:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971008; cv=none; b=CVqSF5xSkawFXwutnm1cD76UJuGAHDrYYa0u/pAHoosdp8NFQnAdPRpmeZq5B1adbJYWRa3XAu+iHnOTMgOMXb/gVbiEokGdNwK2PU+tf2pfccyVlgNlNQtHou+2tqDYg47y1g6DvjjNosugTXld2VLoSYbchM6oO1mQxyikAj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971008; c=relaxed/simple;
	bh=pAKDOqL5C+UheVRuqSbZsmg1bPmKaD832RDNv30Lztc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UVxe0oYBsX8uNjRoUVP0z6T04IlC6ljX2x/6Qn2PI5JPWx8BD67nNQEdinauA2GblwjTBkutlWCiZuIZhcAgyaKFDbuaxsZreilv3pOcL4psowfJCw1gx9G+6uuYoXuGTduqeSYCZeErzpjitzEKYNPpt/ibJ7KqEYA1/YhZzCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LkTev5zz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LkTev5zz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22879C43390;
	Tue, 23 Jan 2024 00:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971008;
	bh=pAKDOqL5C+UheVRuqSbZsmg1bPmKaD832RDNv30Lztc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LkTev5zzMEh+89zLcp0QyxBYuKjX6t5g2jbmUiIzeoIRmgXS0+8PLG7qDH/qBCznx
	 zqBkG6VKG6mqL57E6546IELJ+XAHJGgT7ek3p93wPNV3AeGctvfgEcsLGbQFWGTKPD
	 UAdNkB+mIkMawOSWFsnXN5DO6I9ph2TF3eoIUHxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	Paul Moore <paul@paul-moore.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 069/286] net: netlabel: Fix kerneldoc warnings
Date: Mon, 22 Jan 2024 15:56:15 -0800
Message-ID: <20240122235734.677309898@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 4e62f2ad3575..f28c8947c730 100644
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



