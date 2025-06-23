Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 592A824DCFD;
	Mon, 23 Jun 2025 13:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685774; cv=none; b=dxrwAgxVxZl9vQoCq4BUNp0p5vbKu0KuZYOWMl6q2tA1ZSQn8FzbaKz/EbVgez1SlrTtQzpQjIaulKoXDR3afos+YXEFBi4u1HyrYPpXi4H4bC02S4oLv/U3dc+95zvpXo2UgMrhm2p4GsZgySDuCcB6rfZjTGnLJmicRSYP0lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685774; c=relaxed/simple;
	bh=GcQWZm1ci0PTHbEYb09UlI2IvYsS3cE6XMLnNrsEWms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QKaBWW9pPrGT9lrjLkofQ38hABzXddznHqoBa2x6PkZZqZJg2aY5CcBEO3XPVbpb10a4tf5f4+kqxdYWCew7jcd/1W4OLY36rKUfkk3ceCcs0/h1oXCYafoyQ5J1EgSDlfmGRP4lTPG8VwLJPqNa6PyMfRvlO8neYhn10XW3v8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MT6or4Ox; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MT6or4Ox"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0A56C4CEEA;
	Mon, 23 Jun 2025 13:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685774;
	bh=GcQWZm1ci0PTHbEYb09UlI2IvYsS3cE6XMLnNrsEWms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MT6or4OxSQjE0ZjYtdfGwMVkipdkrythpxZeCCODSIzKu2xYw7F7MaDR0R+SLiNq3
	 aoY7hTwIkz9y1Y4NpRmHncoYljdsVJjR8Za6yMZ4+NZ2LMzFEJr/l5kwwgfQ8XZWyl
	 VO/TEss1Mx6ehUCTAdtvQGQIT7rDLtPFXkEHLpXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 284/592] media: cec: extron-da-hd-4k-plus: Fix Wformat-truncation
Date: Mon, 23 Jun 2025 15:04:02 +0200
Message-ID: <20250623130707.108256431@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Verkuil <hverkuil@xs4all.nl>

[ Upstream commit 5edc9b560f60c40e658af0b8e98ae2dfadc438d8 ]

Fix gcc8 warning:

drivers/media/cec/usb/extron-da-hd-4k-plus/extron-da-hd-4k-plus.c:1014:44: warning: 'DCEC' directive output may be truncated writing 4 bytes into a region of size between 0 and 53 [-Wformat-truncation=]

Resizing the 'buf' and 'cmd' arrays fixed the warning.

Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../media/cec/usb/extron-da-hd-4k-plus/extron-da-hd-4k-plus.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/cec/usb/extron-da-hd-4k-plus/extron-da-hd-4k-plus.c b/drivers/media/cec/usb/extron-da-hd-4k-plus/extron-da-hd-4k-plus.c
index cfbfc4c1b2e67..41d019b01ec09 100644
--- a/drivers/media/cec/usb/extron-da-hd-4k-plus/extron-da-hd-4k-plus.c
+++ b/drivers/media/cec/usb/extron-da-hd-4k-plus/extron-da-hd-4k-plus.c
@@ -1002,8 +1002,8 @@ static int extron_cec_adap_transmit(struct cec_adapter *adap, u8 attempts,
 				    u32 signal_free_time, struct cec_msg *msg)
 {
 	struct extron_port *port = cec_get_drvdata(adap);
-	char buf[CEC_MAX_MSG_SIZE * 3 + 1];
-	char cmd[CEC_MAX_MSG_SIZE * 3 + 13];
+	char buf[(CEC_MAX_MSG_SIZE - 1) * 3 + 1];
+	char cmd[sizeof(buf) + 14];
 	unsigned int i;
 
 	if (port->disconnected)
-- 
2.39.5



