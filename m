Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C9443A8E4;
	Fri, 24 Nov 2023 18:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KxftGKWp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 119D1C433C8;
	Fri, 24 Nov 2023 18:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850659;
	bh=G3zPcHvMHTMm7CW7QbXgrgs4WW+pJeKYWCKpAQssFUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KxftGKWpS+DrfsDZ7l/+ekhe9eDv4n8TRGrkxUcpKZYnhdFQd0eAW8r+Ft84+qQmq
	 QoLtBUThbQwOQ2uqypS7rrbyAspHu0sgP7q2WNdxpSlng0x+CePN4i1/qEfRS4NlW/
	 jtPzdCVGumKVz8YF35nvYBZSSsSCAoqJFYvyfFYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 113/491] thunderbolt: Apply USB 3.x bandwidth quirk only in software connection manager
Date: Fri, 24 Nov 2023 17:45:49 +0000
Message-ID: <20231124172027.935994578@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mika Westerberg <mika.westerberg@linux.intel.com>

[ Upstream commit 0c35ac18256942e66d8dab6ca049185812e60c69 ]

This is not needed when firmware connection manager is run so limit this
to software connection manager.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thunderbolt/quirks.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/thunderbolt/quirks.c b/drivers/thunderbolt/quirks.c
index 488138a28ae13..e6bfa63b40aee 100644
--- a/drivers/thunderbolt/quirks.c
+++ b/drivers/thunderbolt/quirks.c
@@ -31,6 +31,9 @@ static void quirk_usb3_maximum_bandwidth(struct tb_switch *sw)
 {
 	struct tb_port *port;
 
+	if (tb_switch_is_icm(sw))
+		return;
+
 	tb_switch_for_each_port(sw, port) {
 		if (!tb_port_is_usb3_down(port))
 			continue;
-- 
2.42.0



