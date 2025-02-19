Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B4A41E5B97;
	Wed, 19 Feb 2025 08:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954730; cv=none; b=UimmL43ZjpCBqWbn950L4HFSrjSJ5Y+m6Z9e1rQWy7x+wb6eG0MAFPwxDrzSo9drqmLy8+7BUHiJOEdOz8d/zJV6FV35NQon1VnS7/SPbxdzO3DcJrvGIiVEjGhyZX6v/9GV2has9N7c9hqyAhxCRVNNOXY90GIMncN0qALzYXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954730; c=relaxed/simple;
	bh=ZvrJrIqdQu96y+Ao3h3CrYTWUTY7VM3LZdjJwNv1xiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hva7VUlBJ7qZpuAgqT2wJIC/eqCzT2aW0n1auyte9eXQr+S4bnuZqKCazc8pkPkzrD4iZ6JiMWJEROB4aZ0ZJiI0Z/v5ujVJ6N4ClwXiK1CI2llo+4nxd4s0U0YLpL7lEhtLK7/RCOK5JYCD3wFeWmmSgRwjAFAOlCIgbe9Mc0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fJpAve9K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fJpAve9K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60DFAC4CED1;
	Wed, 19 Feb 2025 08:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954729;
	bh=ZvrJrIqdQu96y+Ao3h3CrYTWUTY7VM3LZdjJwNv1xiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fJpAve9KqJSfsIp79V4xqEXaNFW1r3iT1czgxdj+eTzmXfXJZetD0ff1GSUUs19At
	 C3cjkgY6PIqSJA5UeZuZTKmA8RBMT/hoftJ6a+tp08QFIPdn/3AFRtoznqIVVlhu1N
	 03AIllWPct+wZ+Dbg+Sj1kDpAIN4E15yz3ZI+u6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Reyders Morales <reyders1@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 018/230] Documentation/networking: fix basic node example document ISO 15765-2
Date: Wed, 19 Feb 2025 09:25:35 +0100
Message-ID: <20250219082602.415555786@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Reyders Morales <reyders1@gmail.com>

[ Upstream commit d0b197b6505fe3788860fc2a81b3ce53cbecc69c ]

In the current struct sockaddr_can tp is member of can_addr. tp is not
member of struct sockaddr_can.

Signed-off-by: Reyders Morales <reyders1@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
Link: https://patch.msgid.link/20250203224720.42530-1-reyders1@gmail.com
Fixes: 67711e04254c ("Documentation: networking: document ISO 15765-2")
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/networking/iso15765-2.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/iso15765-2.rst b/Documentation/networking/iso15765-2.rst
index 0e9d960741783..37ebb2c417cb4 100644
--- a/Documentation/networking/iso15765-2.rst
+++ b/Documentation/networking/iso15765-2.rst
@@ -369,8 +369,8 @@ to their default.
 
   addr.can_family = AF_CAN;
   addr.can_ifindex = if_nametoindex("can0");
-  addr.tp.tx_id = 0x18DA42F1 | CAN_EFF_FLAG;
-  addr.tp.rx_id = 0x18DAF142 | CAN_EFF_FLAG;
+  addr.can_addr.tp.tx_id = 0x18DA42F1 | CAN_EFF_FLAG;
+  addr.can_addr.tp.rx_id = 0x18DAF142 | CAN_EFF_FLAG;
 
   ret = bind(s, (struct sockaddr *)&addr, sizeof(addr));
   if (ret < 0)
-- 
2.39.5



