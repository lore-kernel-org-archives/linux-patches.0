Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0E683788D;
	Mon, 18 Dec 2023 14:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qunNC42J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63CC3C433C7;
	Mon, 18 Dec 2023 14:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908253;
	bh=bBB25PGlzC5IPITkr5Ohk6oC8nC8P7k+X9NyIIYBrT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qunNC42JJAdebSGpiefsK0tgVd/G0IxmqKZuoW1w4T8swiwNAY0nfOjmJH+YAbHe3
	 uxaQZpCs4IExlbXx4ayFJXZUiedEYWtcnw2aSiKNlmDX31o94NwJszvz1HGz9vWmKT
	 Rji236u+eM6bf1fhmOTkxK7bRnCNVSzVasgF3hLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yihong Cao <caoyihong4@outlook.com>,
	Jiri Kosina <jkosina@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 109/166] HID: apple: add Jamesdonkey and A3R to non-apple keyboards list
Date: Mon, 18 Dec 2023 14:51:15 +0100
Message-ID: <20231218135109.907334828@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135104.927894164@linuxfoundation.org>
References: <20231218135104.927894164@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yihong Cao <caoyihong4@outlook.com>

[ Upstream commit 113f736655e4f20633e107d731dd5bd097d5938c ]

Jamesdonkey A3R keyboard is identified as "Jamesdonkey A3R" in wired
mode, "A3R-U" in wireless mode and "A3R" in bluetooth mode. Adding them
to non-apple keyboards fixes function key.

Signed-off-by: Yihong Cao <caoyihong4@outlook.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-apple.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hid/hid-apple.c b/drivers/hid/hid-apple.c
index 3ca45975c686e..d9e9829b22001 100644
--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -345,6 +345,8 @@ static const struct apple_non_apple_keyboard non_apple_keyboards[] = {
 	{ "AONE" },
 	{ "GANSS" },
 	{ "Hailuck" },
+	{ "Jamesdonkey" },
+	{ "A3R" },
 };
 
 static bool apple_is_non_apple_keyboard(struct hid_device *hdev)
-- 
2.43.0



