Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04CBE258F
	for <patches@lists.linux.dev>; Thu, 23 Feb 2023 13:12:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 575EBC433EF;
	Thu, 23 Feb 2023 13:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1677157961;
	bh=LEV9EJzGjWl5bqmd8gKvZW97vEYWcui7Qi40BCVlsK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pvOmHnGYPUJOXYC2WD53Icp48smSoed6o7C7D+pVMNqZvGLiCoiY5aAXRr9B0D0ej
	 K2asGlD6CYtjYj1kzk8cWFRwQiCwqgZ8oBWloM91ttfg68xBn66RazZ4a4n9Ixgeev
	 LF79DLYvc8ZOmNffcKxNEU0z6bbxL0EuRAO1Kj7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	Matt Ranostay <mranostay@ti.com>,
	Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 5.15 29/36] wifi: mwifiex: Add missing compatible string for SD8787
Date: Thu, 23 Feb 2023 14:07:05 +0100
Message-Id: <20230223130430.418308163@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130429.072633724@linuxfoundation.org>
References: <20230223130429.072633724@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lukas Wunner <lukas@wunner.de>

commit 36dd7a4c6226133b0b7aa92b8e604e688d958d0c upstream.

Commit e3fffc1f0b47 ("devicetree: document new marvell-8xxx and
pwrseq-sd8787 options") documented a compatible string for SD8787 in
the devicetree bindings, but neglected to add it to the mwifiex driver.

Fixes: e3fffc1f0b47 ("devicetree: document new marvell-8xxx and pwrseq-sd8787 options")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: stable@vger.kernel.org # v4.11+
Cc: Matt Ranostay <mranostay@ti.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/320de5005ff3b8fd76be2d2b859fd021689c3681.1674827105.git.lukas@wunner.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/marvell/mwifiex/sdio.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -485,6 +485,7 @@ static struct memory_type_mapping mem_ty
 };
 
 static const struct of_device_id mwifiex_sdio_of_match_table[] = {
+	{ .compatible = "marvell,sd8787" },
 	{ .compatible = "marvell,sd8897" },
 	{ .compatible = "marvell,sd8997" },
 	{ }


