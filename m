Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E7BE3AC05
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:31:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 180D2C433C9;
	Wed, 20 Sep 2023 12:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695213105;
	bh=WhakkxabZuI1iVuqyCX3Q6we6eDTNVAl4NSObtxJKhc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VSSD2Xnm5EtqcCqLrwb+a56bJmEsCBPJnhFTxW/yZUvArGQGOrNtNWD6IbwudpPSU
	 mh98dK+GSdDILRj66SaBSAIV9SJP5eNIC588AP2JlmjhuMubjfNMtxMMTtAm22dGmY
	 l2BfipmPqR62/liPvhpXXmkXIEbgm0z6O/MRrJaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baolin Wang <baolin.wang7@gmail.com>,
	Chunyan Zhang <chunyan.zhang@unisoc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 163/367] serial: sprd: remove redundant sprd_port cleanup
Date: Wed, 20 Sep 2023 13:29:00 +0200
Message-ID: <20230920112902.869025583@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112858.471730572@linuxfoundation.org>
References: <20230920112858.471730572@linuxfoundation.org>
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

From: Chunyan Zhang <chunyan.zhang@unisoc.com>

[ Upstream commit 72534077475fc489f8358c0e214cc1a4d658c8c2 ]

We don't need to cleanup sprd_port anymore, since we've dropped the way
of using the sprd_port[] array to get port index.

Reviewed-by: Baolin Wang <baolin.wang7@gmail.com>
Signed-off-by: Chunyan Zhang <chunyan.zhang@unisoc.com>
Link: https://lore.kernel.org/r/20200318105049.19623-3-zhang.lyra@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: f9608f188756 ("serial: sprd: Assign sprd_port after initialized to avoid wrong access")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/sprd_serial.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/tty/serial/sprd_serial.c b/drivers/tty/serial/sprd_serial.c
index e6acf2c848f39..9cf771a9cff62 100644
--- a/drivers/tty/serial/sprd_serial.c
+++ b/drivers/tty/serial/sprd_serial.c
@@ -1205,10 +1205,8 @@ static int sprd_probe(struct platform_device *pdev)
 	sprd_ports_num++;
 
 	ret = uart_add_one_port(&sprd_uart_driver, up);
-	if (ret) {
-		sprd_port[index] = NULL;
+	if (ret)
 		sprd_remove(pdev);
-	}
 
 	platform_set_drvdata(pdev, up);
 
-- 
2.40.1



