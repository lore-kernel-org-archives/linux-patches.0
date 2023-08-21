Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97CAF11703
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 20:04:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19326C433C7;
	Mon, 21 Aug 2023 20:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692648298;
	bh=BnfRMvWGj+yOLG3+t50I5FPVEgAalNskJrrEnB1BRGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wnijTsEuBo2y3r5x5j50w1ks2xPMU7V6y9gTP97gqizoiZrekd3x+5s7wfby/T2fT
	 FK1CsUu264BKeSk1Xko8s442cxRAu13YQRbVui4/jQY90o9+xnyFmqDYEUGGZw9qh3
	 6H0B6Na/OWHvyXCv0J/ERWdPfJsHTwM4wj/J+4vc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuanjun Gong <ruc_gongyuanjun@163.com>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.4 097/234] fbdev: mmp: fix value check in mmphw_probe()
Date: Mon, 21 Aug 2023 21:41:00 +0200
Message-ID: <20230821194133.099234877@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
References: <20230821194128.754601642@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yuanjun Gong <ruc_gongyuanjun@163.com>

commit 0872b2c0abc0e84ac82472959c8e14e35277549c upstream.

in mmphw_probe(), check the return value of clk_prepare_enable()
and return the error code if clk_prepare_enable() returns an
unexpected value.

Fixes: d63028c38905 ("video: mmp display controller support")
Signed-off-by: Yuanjun Gong <ruc_gongyuanjun@163.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/mmp/hw/mmp_ctrl.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/video/fbdev/mmp/hw/mmp_ctrl.c
+++ b/drivers/video/fbdev/mmp/hw/mmp_ctrl.c
@@ -519,7 +519,9 @@ static int mmphw_probe(struct platform_d
 			      "unable to get clk %s\n", mi->clk_name);
 		goto failed;
 	}
-	clk_prepare_enable(ctrl->clk);
+	ret = clk_prepare_enable(ctrl->clk);
+	if (ret)
+		goto failed;
 
 	/* init global regs */
 	ctrl_set_default(ctrl);


