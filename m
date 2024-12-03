Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D99081DA3D;
	Tue,  3 Dec 2024 15:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238908; cv=none; b=nTJzfNgBMpDgY/UXu4AD+5rBiuZjQzG5lUYLjNLXe40PXYIliOB8+GWmKYogMUYitrOVwr6MFZzfv6Kng6jNdPMS3uENnZZdI2KwpL6b0gvKydQFP8n90Tn4p6VDNzqLxaQ/y8FYbE29u6n9RhXGeS9l7ahCDYwczYt6mSOim1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238908; c=relaxed/simple;
	bh=LuOCEpcK4w5DMVZq0yg1fAsF0wKL8my4uoqPSpAXWPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a98/iAx2K2mNKL0liFzJZgP66SzxZlK4Jqo//IMBYWWjZsou6EXQi+qXN/aCLBI0vwi2xvXp1VPq7G4NAl8nWksVeOdNFsj1o4NuhXTlomY+oHjqZyDHXjy0HCJ5z1zbgJzSK7zBpPl0J9ahG7FftF0hlZOYTsGGhFolY593OKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uRiNJbXk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uRiNJbXk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61CB0C4CECF;
	Tue,  3 Dec 2024 15:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238908;
	bh=LuOCEpcK4w5DMVZq0yg1fAsF0wKL8my4uoqPSpAXWPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uRiNJbXksjMKIVmaYpEjpmn8I19OF934x9Rg1wB8BQpmcovDuaBHnBKWA3O/A9uJK
	 GPHBXRY0CDKPPFid51nduZANPnaTrG8gu5tRoTz+N7Y8SpiUwEmi60HqwuWk2Xi4LZ
	 FdsyKwN8EIVFc4io0Prk648SzzS02e6qud7inQZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baolin Liu <liubaolin@kylinos.cn>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 437/817] scsi: target: Fix incorrect function name in pscsi_create_type_disk()
Date: Tue,  3 Dec 2024 15:40:09 +0100
Message-ID: <20241203144012.939135554@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baolin Liu <liubaolin@kylinos.cn>

[ Upstream commit da5aeca99dd0b6c7bf6679382756ea6bda195f72 ]

In pr_err(), bdev_open_by_path() should be renamed to
bdev_file_open_by_path()

Fixes: 034f0cf8fdf9 ("target: port block device access to file")
Signed-off-by: Baolin Liu <liubaolin@kylinos.cn>
Link: https://lore.kernel.org/r/20241030021800.234980-1-liubaolin12138@163.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_pscsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index f98ebb18666bf..da7017113f92a 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -369,7 +369,7 @@ static int pscsi_create_type_disk(struct se_device *dev, struct scsi_device *sd)
 	bdev_file = bdev_file_open_by_path(dev->udev_path,
 				BLK_OPEN_WRITE | BLK_OPEN_READ, pdv, NULL);
 	if (IS_ERR(bdev_file)) {
-		pr_err("pSCSI: bdev_open_by_path() failed\n");
+		pr_err("pSCSI: bdev_file_open_by_path() failed\n");
 		scsi_device_put(sd);
 		return PTR_ERR(bdev_file);
 	}
-- 
2.43.0



