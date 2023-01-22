Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB0912590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:24:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4340BC433EF;
	Sun, 22 Jan 2023 15:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674401054;
	bh=/YyYo0fyOydi99bqr+l/KZxlzSDBGV1LFRkX/WC8Phw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jzaBNZiHfryKtP6RtrB9Lv0HtUQkOKuu6uqPToMDg8BjefFQ9LGdCZAjbxhqHXuNj
	 XxJYM584Bhsyj4dEmnnZCqnTF+Uo4EPfvkrJDYuPPdzh/s430z3ATrkhOeTR7TBz7i
	 +4Vof1WxKPFGXqjtmRr2REN+OajAVqkk1bMV4Ca0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yehezkel Bernat <YehezkelShB@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.1 092/193] thunderbolt: Use correct function to calculate maximum USB3 link rate
Date: Sun, 22 Jan 2023 16:03:41 +0100
Message-Id: <20230122150250.569512945@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mika Westerberg <mika.westerberg@linux.intel.com>

commit e8ff07fb33026c5c1bb5b81293496faba5d68059 upstream.

We need to take minimum of both sides of the USB3 link into consideration,
not just the downstream port. Fix this by calling tb_usb3_max_link_rate()
instead.

Fixes: 0bd680cd900c ("thunderbolt: Add USB3 bandwidth management")
Cc: stable@vger.kernel.org
Acked-by: Yehezkel Bernat <YehezkelShB@gmail.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/tunnel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/thunderbolt/tunnel.c
+++ b/drivers/thunderbolt/tunnel.c
@@ -1275,7 +1275,7 @@ static void tb_usb3_reclaim_available_ba
 		return;
 	} else if (!ret) {
 		/* Use maximum link rate if the link valid is not set */
-		ret = usb4_usb3_port_max_link_rate(tunnel->src_port);
+		ret = tb_usb3_max_link_rate(tunnel->dst_port, tunnel->src_port);
 		if (ret < 0) {
 			tb_tunnel_warn(tunnel, "failed to read maximum link rate\n");
 			return;


