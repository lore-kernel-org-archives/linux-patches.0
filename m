Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF301DF24A;
	Wed,  6 Nov 2024 12:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895558; cv=none; b=U797O03bl2RI4W8WCC4PRfXZnUTybVDWOevKT+cdA4Wkoh/SAkUAlspDhahJb61ND7ZXUx6CCu+BqNT4s8YqnEha+g+otCvEZvUQNw8czm2jSn4xPeMvnfNlAL5zxad/D4FY+xRsWgMxpl1Oy7NKKY6z3mVV/7Lfx+XNfIz7I7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895558; c=relaxed/simple;
	bh=6Yp+WD0j4NhzUO3v4AQu0cRz9E0GdYPoXKP1L+IRck4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AXA1JkLxd9LLZFBVyAQkdPWtmrOIlvpcLT4nTVax6QNsK+NI5qrPQwlpg4vmMvZq09m4/DhS5dUsCQpIB6znU9NePqvjwrUP5QFGPoFSAP3kRPiH+A9qGNao2SRus39pYNHWVUBLkH2+NI2zC6AAmmPmuvhTLeuFMgWY1/3lyxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rgnYialL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rgnYialL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29A25C4CECD;
	Wed,  6 Nov 2024 12:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895558;
	bh=6Yp+WD0j4NhzUO3v4AQu0cRz9E0GdYPoXKP1L+IRck4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rgnYialLrrYRwu/Jg6Eyvp0exW/4sOJjM0bN2K7mQrtk3hYN+bk0JTGPLqg8QMDFc
	 6eVbWjDzX55Os9amAHUxLgo5miA2OxiTS2E8FvzYOvzWotv0l3LQ2DGNmvwqGXMcSZ
	 aNY6AaTsLNZf9WCjlY8WgiPc9Ahk1Fq9URJL+QA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 259/350] net: ibm: emac: mal: fix wrong goto
Date: Wed,  6 Nov 2024 13:03:07 +0100
Message-ID: <20241106120327.305503460@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 08c8acc9d8f3f70d62dd928571368d5018206490 ]

dcr_map is called in the previous if and therefore needs to be unmapped.

Fixes: 1ff0fcfcb1a6 ("ibm_newemac: Fix new MAL feature handling")
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Link: https://patch.msgid.link/20241007235711.5714-1-rosenp@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/emac/mal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/emac/mal.c b/drivers/net/ethernet/ibm/emac/mal.c
index fff09dcf9e346..9b3ba4db3222f 100644
--- a/drivers/net/ethernet/ibm/emac/mal.c
+++ b/drivers/net/ethernet/ibm/emac/mal.c
@@ -581,7 +581,7 @@ static int mal_probe(struct platform_device *ofdev)
 		printk(KERN_ERR "%pOF: Support for 405EZ not enabled!\n",
 				ofdev->dev.of_node);
 		err = -ENODEV;
-		goto fail;
+		goto fail_unmap;
 #endif
 	}
 
-- 
2.43.0



