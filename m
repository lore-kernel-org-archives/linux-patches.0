Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6623C11C86
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 15:00:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF6BEC433C8;
	Thu, 24 Aug 2023 15:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692889253;
	bh=DFYMHAlB036MAS++I5Gow5f28V5bYH51Jc0vzwctZH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aNQ3/uru01m4/TlFRU4DBJIHlA9klysW+wMhKZYdx7cSIJDq8AAokUejNSI1T1VXx
	 EyE7R/foIJnEsgaMZy8uCKP9bB5EZVKW/q+VMWI1P76IbVR6L5umhGWyupSs36NFb8
	 c1HRQ607OgfwQtiI/LSjUwnG/9SK0wvkDkgQZLK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuanjun Gong <ruc_gongyuanjun@163.com>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.10 070/135] fbdev: mmp: fix value check in mmphw_probe()
Date: Thu, 24 Aug 2023 16:50:13 +0200
Message-ID: <20230824145029.884024271@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230824145027.008282920@linuxfoundation.org>
References: <20230824145027.008282920@linuxfoundation.org>
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
@@ -518,7 +518,9 @@ static int mmphw_probe(struct platform_d
 		ret = -ENOENT;
 		goto failed;
 	}
-	clk_prepare_enable(ctrl->clk);
+	ret = clk_prepare_enable(ctrl->clk);
+	if (ret)
+		goto failed;
 
 	/* init global regs */
 	ctrl_set_default(ctrl);


