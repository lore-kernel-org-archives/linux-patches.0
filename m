Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BA6F70838;
	Mon, 23 Jun 2025 21:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750712839; cv=none; b=rcRR0SncmlHkvgO8S3BXpsMg4VMFD8ewxlEcawU5R5MGnS7EyjA+ddjTdeftKgleluaeTiqz1Bp5wIUXklufUjppVrA8X+oqxSjE46fCKvSv0De0xwZX7TUpp8b6pmNCrE0NGNecSx3UOj1wvd/LtzP/jutBArB9WKQUpJd+48Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750712839; c=relaxed/simple;
	bh=mYyAsl49KEAtnOcyEaKbIMqaDBw7Xj4Ivq9QmqK7WJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LaZCidt75noGUXCGLK3xUPT8jZ+dZcNxr3rnDzN6V44AySJDsjlC7y8jEuxjh1Iwu37DqD8/99yX8iUuCS8+RsP9M0gvSjDDhJ/9qXvoWzyF/8D4eGzSxgzuGag/LhNi1jSy+q7uzsvbYmiYuI7sl6BBbFNc3l1R/9xwzrWJb9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VYI3gjvd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VYI3gjvd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23547C4CEEA;
	Mon, 23 Jun 2025 21:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750712839;
	bh=mYyAsl49KEAtnOcyEaKbIMqaDBw7Xj4Ivq9QmqK7WJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VYI3gjvd6u4eG/GpvC+p1J4gMUpCDSQTb+iYgwMczZsq2F6c5x4U5DWwq8GEUXZS/
	 lfLVxe739Ok0laj91th/Q9fSbBqhIsxoS8oeZGikPYFtTqfXcDh3G1TH2L248w+CBz
	 1jY87py5YXd1yflTZnzcHzQzXfI7VzYz432ANHKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zeal Robot <zealci@zte.com.cn>,
	zhang songyi <zhang.songyi@zte.com.cn>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 108/355] Input: synaptics-rmi4 - convert to use sysfs_emit() APIs
Date: Mon, 23 Jun 2025 15:05:09 +0200
Message-ID: <20250623130630.018039539@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: zhang songyi <zhang.songyi@zte.com.cn>

[ Upstream commit 9dedc915937c33302df7fcab01c45e7936d6195a ]

Follow the advice of the Documentation/filesystems/sysfs.rst and show()
should only use sysfs_emit() or sysfs_emit_at() when formatting the value
to be returned to user space.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: zhang songyi <zhang.songyi@zte.com.cn>
Link: https://lore.kernel.org/r/20220927070936.258300-1-zhang.songyi@zte.com.cn
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Stable-dep-of: ca39500f6af9 ("Input: synaptics-rmi - fix crash with unsupported versions of F34")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/rmi4/rmi_f34.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/input/rmi4/rmi_f34.c b/drivers/input/rmi4/rmi_f34.c
index e5dca9868f87f..c26808f10827a 100644
--- a/drivers/input/rmi4/rmi_f34.c
+++ b/drivers/input/rmi4/rmi_f34.c
@@ -321,13 +321,13 @@ static ssize_t rmi_driver_bootloader_id_show(struct device *dev,
 		f34 = dev_get_drvdata(&fn->dev);
 
 		if (f34->bl_version == 5)
-			return scnprintf(buf, PAGE_SIZE, "%c%c\n",
-					 f34->bootloader_id[0],
-					 f34->bootloader_id[1]);
+			return sysfs_emit(buf, "%c%c\n",
+					  f34->bootloader_id[0],
+					  f34->bootloader_id[1]);
 		else
-			return scnprintf(buf, PAGE_SIZE, "V%d.%d\n",
-					 f34->bootloader_id[1],
-					 f34->bootloader_id[0]);
+			return sysfs_emit(buf, "V%d.%d\n",
+					  f34->bootloader_id[1],
+					  f34->bootloader_id[0]);
 	}
 
 	return 0;
@@ -346,7 +346,7 @@ static ssize_t rmi_driver_configuration_id_show(struct device *dev,
 	if (fn) {
 		f34 = dev_get_drvdata(&fn->dev);
 
-		return scnprintf(buf, PAGE_SIZE, "%s\n", f34->configuration_id);
+		return sysfs_emit(buf, "%s\n", f34->configuration_id);
 	}
 
 	return 0;
@@ -499,7 +499,7 @@ static ssize_t rmi_driver_update_fw_status_show(struct device *dev,
 	if (data->f34_container)
 		update_status = rmi_f34_status(data->f34_container);
 
-	return scnprintf(buf, PAGE_SIZE, "%d\n", update_status);
+	return sysfs_emit(buf, "%d\n", update_status);
 }
 
 static DEVICE_ATTR(update_fw_status, 0444,
-- 
2.39.5



