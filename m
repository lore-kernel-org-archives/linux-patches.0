Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1AB5305062;
	Tue,  2 Sep 2025 13:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820809; cv=none; b=J6gGvDluoS8kBy7YXdDKAmu62VxpvFqLhRMz5Lxj0gwhalFrdMnRHB/UcbtZGGgVlVBGO6EA1I/tcp5/JykvT4XvN3w3RxVamQr1azQGyGdZBU4zDki/lXQ9mesWc/ov7LOh7kqhuOT5yBb1DeGJjiS53Nw16rob8n5XOeKKjUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820809; c=relaxed/simple;
	bh=ZYeOnej8dkkaASfkct6p8yDbNawTcSlIHPWuzDJfqbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QXeyuffCltuuISYwdfT3hSOglkCK9KKtm0dvDa4DUjtz9Pgb+5K+XJ72giR8COoVcA9/BsA72s6/gZ8pK4jeeFhmyMp/Xxe3usJD8+xbOdDKtMYNAKpvbt9kd4yYWAhw53eBPcQrxR9od9uNbAJaaraXGhext6uTbw0fg/uUgqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UayD6r8C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UayD6r8C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F7C5C4CEF4;
	Tue,  2 Sep 2025 13:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820809;
	bh=ZYeOnej8dkkaASfkct6p8yDbNawTcSlIHPWuzDJfqbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UayD6r8C/H6rzT+VILuNtFq0yXzF0JCCm2ta4jQzZG0Hrrp+8Dz5TAlJyGyivBtix
	 8MGiLqzWbDMIodnf8K9zpeW6RK2IB7xeJiR6EW04KlP0MCSXUaQt2GznS5pEMLtw2P
	 7YsVV/ZmUgGY+AEXXoiGy9IPZhXa0mvOD9/F0AGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.g.garry@oracle.com>,
	Johannes Thumshin <johannes.thumshirn@wdc.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 03/23] scsi: core: sysfs: Correct sysfs attributes access rights
Date: Tue,  2 Sep 2025 15:21:49 +0200
Message-ID: <20250902131924.860061707@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131924.720400762@linuxfoundation.org>
References: <20250902131924.720400762@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

[ Upstream commit a2f54ff15c3bdc0132e20aae041607e2320dbd73 ]

The SCSI sysfs attributes "supported_mode" and "active_mode" do not
define a store method and thus cannot be modified.  Correct the
DEVICE_ATTR() call for these two attributes to not include S_IWUSR to
allow write access as they are read-only.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/r/20250728041700.76660-1-dlemoal@kernel.org
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Johannes Thumshin <johannes.thumshirn@wdc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_sysfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 530b14685fd71..8949848fe6a74 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -264,7 +264,7 @@ show_shost_supported_mode(struct device *dev, struct device_attribute *attr,
 	return show_shost_mode(supported_mode, buf);
 }
 
-static DEVICE_ATTR(supported_mode, S_IRUGO | S_IWUSR, show_shost_supported_mode, NULL);
+static DEVICE_ATTR(supported_mode, S_IRUGO, show_shost_supported_mode, NULL);
 
 static ssize_t
 show_shost_active_mode(struct device *dev,
@@ -278,7 +278,7 @@ show_shost_active_mode(struct device *dev,
 		return show_shost_mode(shost->active_mode, buf);
 }
 
-static DEVICE_ATTR(active_mode, S_IRUGO | S_IWUSR, show_shost_active_mode, NULL);
+static DEVICE_ATTR(active_mode, S_IRUGO, show_shost_active_mode, NULL);
 
 static int check_reset_type(const char *str)
 {
-- 
2.50.1



