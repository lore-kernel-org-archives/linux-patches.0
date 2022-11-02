Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEF597E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 02:44:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B43BCC433D6;
	Wed,  2 Nov 2022 02:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667357046;
	bh=lPS8vLaNnJqXQrGNry+P5n6+3nBFg4dYnjUVxCySAks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ogF42dDf638QSnOSOnQ7DF0GbP6yuLfb2RN7kQV4IF4uX6BjBp6HyOVtzNagxH55r
	 pCSmmNXLqxdDH2XHUNjdMmJLtBAwBUbnjyAjo94Zx/s2+ociH+zppo3+d47JowhVNF
	 yOQYBvHkXnoJaNCHZmeX7JCI+yypAjhp0l3fou3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.0 104/240] ethtool: eeprom: fix null-deref on genl_info in dump
Date: Wed,  2 Nov 2022 03:31:19 +0100
Message-Id: <20221102022113.743945249@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xin Long <lucien.xin@gmail.com>

commit 9d9effca9d7d7cf6341182a7c5cabcbd6fa28063 upstream.

The similar fix as commit 46cdedf2a0fa ("ethtool: pse-pd: fix null-deref on
genl_info in dump") is also needed for ethtool eeprom.

Fixes: c781ff12a2f3 ("ethtool: Allow network drivers to dump arbitrary EEPROM data")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Link: https://lore.kernel.org/r/5575919a2efc74cd9ad64021880afc3805c54166.1666362167.git.lucien.xin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ethtool/eeprom.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ethtool/eeprom.c
+++ b/net/ethtool/eeprom.c
@@ -124,7 +124,7 @@ static int eeprom_prepare_data(const str
 	if (ret)
 		goto err_free;
 
-	ret = get_module_eeprom_by_page(dev, &page_data, info->extack);
+	ret = get_module_eeprom_by_page(dev, &page_data, info ? info->extack : NULL);
 	if (ret < 0)
 		goto err_ops;
 


