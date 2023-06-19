Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D6571FB7
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:30:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65CF7C433C8;
	Mon, 19 Jun 2023 10:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687170602;
	bh=amL2Nhm8cwIr7U0FiUt7GFoC1TGrk53k6QFJTZXMgDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0QT4PYGee0kXMRh4pOzzfIMXNpljSzusKmtg15ogrk29DH1nTsvdWsWAvG3UsIlCA
	 5sCgbzqJG3p1dyRTPzZjLlIjb9TevfM8WTWxW3Cl0wwugBTMAhag+vKWdKjkCO4y4f
	 AgWz5pIGVYI977MLMCDzMDwVEm9QslLmzFjHzD8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 05/32] regulator: Fix error checking for debugfs_create_dir
Date: Mon, 19 Jun 2023 12:28:53 +0200
Message-ID: <20230619102127.781246764@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102127.461443957@linuxfoundation.org>
References: <20230619102127.461443957@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Osama Muhammad <osmtendev@gmail.com>

[ Upstream commit 2bf1c45be3b8f3a3f898d0756c1282f09719debd ]

This patch fixes the error checking in core.c in debugfs_create_dir.
The correct way to check if an error occurred is 'IS_ERR' inline function.

Signed-off-by: Osama Muhammad <osmtendev@gmail.com
Suggested-by: Ivan Orlov <ivan.orlov0322@gmail.com
Link: https://lore.kernel.org/r/20230515172938.13338-1-osmtendev@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 871d657a161f0..7898a54a324c4 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -3955,7 +3955,7 @@ static void rdev_init_debugfs(struct regulator_dev *rdev)
 	}
 
 	rdev->debugfs = debugfs_create_dir(rname, debugfs_root);
-	if (!rdev->debugfs) {
+	if (IS_ERR(rdev->debugfs)) {
 		rdev_warn(rdev, "Failed to create debugfs directory\n");
 		return;
 	}
@@ -4513,7 +4513,7 @@ static int __init regulator_init(void)
 	ret = class_register(&regulator_class);
 
 	debugfs_root = debugfs_create_dir("regulator", NULL);
-	if (!debugfs_root)
+	if (IS_ERR(debugfs_root))
 		pr_warn("regulator: Failed to create debugfs directory\n");
 
 	debugfs_create_file("supply_map", 0444, debugfs_root, NULL,
-- 
2.39.2



