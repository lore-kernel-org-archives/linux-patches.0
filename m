Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01F571F8ACD;
	Tue,  3 Dec 2024 15:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241543; cv=none; b=TCRX2ddso/+uMorZqG/rhVrtkVZrFC2MiKSKnUnoDb5lXXb1lbJC6Yt/YYjncouPJ2MHEknz3ODsCmr2Eozt6pvkohkhU7FGPuF+djZeVsm+7eSUj7z0SQX2ow7qSS0A3GfRu4c1iAj8uuVvWPrE8XVVlvq8OkzYuTgI5fhFh6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241543; c=relaxed/simple;
	bh=A5Z+y5HZjofbeUhAz83I+lmWGqu7AuodNG/I+QZncZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jHq2FziwLa8gz5XHa9xQF0++HXO7t/UIOKT0pHskg09RUc9/ck30q/eNy1LsKKuxrBkgvo8sj41KrinCjUoWcbV/fegF7n6syAkfxgkIzWMCQRTMUDl/CigmMr8JdqlwwmoOolANwrov5lcY9kFLs2RVgS4e0kBjrESkK9/VFLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dgstWbFE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dgstWbFE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67D07C4CED6;
	Tue,  3 Dec 2024 15:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241542;
	bh=A5Z+y5HZjofbeUhAz83I+lmWGqu7AuodNG/I+QZncZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dgstWbFEzmRe5DSZYL1nSiMQu8QS37X7SFHK6p7O/HPQWEs7rZlvM7be9CeTDjipO
	 3MI3QHumARJxqRFtFUry2terC6yrZkZUG8scvOfEG3jrvlQ9YS6LLERkWCcP0glw3k
	 cjN1i2aEKiJrzCZG7qnqsGWkXdszuFxX7T4iIp+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baolin Liu <liubaolin@kylinos.cn>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 417/826] scsi: target: Fix incorrect function name in pscsi_create_type_disk()
Date: Tue,  3 Dec 2024 15:42:24 +0100
Message-ID: <20241203144800.026236455@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 440e07b1d5cdb..287ac5b0495f9 100644
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



