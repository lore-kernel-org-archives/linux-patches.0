Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B35D31A57F;
	Tue,  2 Sep 2025 13:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820451; cv=none; b=NzL7jBo40clvJGqNdZEaRQdR0v0oIaV6cXdjkHjTcnWv7qnv4Gycreo/Rf1fKy+HpR2lz+dV5+AXAlImfLc6mL0mCFuCz/MjXdwalTmsZQmlPlVyuFPQ5IRoPFMG9rGGhiRyeHbTv7j5z5BGodo6JWl7yevSctj6AFV9CXPheOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820451; c=relaxed/simple;
	bh=mWZ3bvGvTQs5myfmU+x0+teLJJNotvDmlN8pCZ4Z13U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uR8Qz94HyTicr0JGv07lE5C1YK/tRVb6On/ksUtuOqjX9kroJr1RaXL3kkQNUDACicWy5zSXzTKpAFlktiQHVswNQam3PIu6fpXBZiAAaTYY1XZrawbl/4adMv9YhVoShGqubf8KWJ7PnBqOXUmgQ9qpG17pcnsdeJnE5VfeUpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LNpm78rn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LNpm78rn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98FC3C4CEED;
	Tue,  2 Sep 2025 13:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820451;
	bh=mWZ3bvGvTQs5myfmU+x0+teLJJNotvDmlN8pCZ4Z13U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LNpm78rnS1a4/AR0QTHBYBVQZ6Tc/zVYWRQD+PVJKb6OfCHGdDuiWyxvzF0gYI6fO
	 v+xtV6FaT6p2xz2qz8QlntQbsf1g+gntRcZH3yt4sPoccsP/DbU1QDhF8YabH8m2Uy
	 wOyK8KtZxGcv85iaFaiufImv8j9jI862PDfSonic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.g.garry@oracle.com>,
	Johannes Thumshin <johannes.thumshirn@wdc.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 05/50] scsi: core: sysfs: Correct sysfs attributes access rights
Date: Tue,  2 Sep 2025 15:20:56 +0200
Message-ID: <20250902131930.725563724@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131930.509077918@linuxfoundation.org>
References: <20250902131930.509077918@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 1f531063d6331..456b92c3a7811 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -265,7 +265,7 @@ show_shost_supported_mode(struct device *dev, struct device_attribute *attr,
 	return show_shost_mode(supported_mode, buf);
 }
 
-static DEVICE_ATTR(supported_mode, S_IRUGO | S_IWUSR, show_shost_supported_mode, NULL);
+static DEVICE_ATTR(supported_mode, S_IRUGO, show_shost_supported_mode, NULL);
 
 static ssize_t
 show_shost_active_mode(struct device *dev,
@@ -279,7 +279,7 @@ show_shost_active_mode(struct device *dev,
 		return show_shost_mode(shost->active_mode, buf);
 }
 
-static DEVICE_ATTR(active_mode, S_IRUGO | S_IWUSR, show_shost_active_mode, NULL);
+static DEVICE_ATTR(active_mode, S_IRUGO, show_shost_active_mode, NULL);
 
 static int check_reset_type(const char *str)
 {
-- 
2.50.1



