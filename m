Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFFB84C7F;
	Mon, 23 Jun 2025 13:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685191; cv=none; b=nM2i5UuQJdp+NbQp+Qo+682yDajWLMLGoehzhWPTACMoKaAPXl1DGx7bjLXac8vJHetRnIEwlDTDf/xWlSoobgWacCdBkxMFSX60YOWJnRGx2tVr6L8NUemCXGWXBdpVrrGwi8JCEL3YKZsyeQE0VrvPUZaOsP/5isDolt2wMb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685191; c=relaxed/simple;
	bh=u86LW8kKY+/rmpySYVgzSAO3SZj3vAL5QBH3LkL+T8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IYKUiaoKz9xBJYCrrMgZ5TV3j4UEwC49DvAcJ5erzLUDG1MvUSk7eUmGHBz54x37vRIRXABDq+kCJw/3kQ0tUqPaMVQuTTM1PIbQogrjBzL+JLenohfN4efetmFK0SkB2T/AOKmX5wSnJM4cszpoF4c88c4py/QpjsEqlsyh/bY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U5poOuvY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U5poOuvY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84CA5C4CEEA;
	Mon, 23 Jun 2025 13:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685190;
	bh=u86LW8kKY+/rmpySYVgzSAO3SZj3vAL5QBH3LkL+T8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U5poOuvYlyRCceKcjzuT4MnBx0NMvDpgG2XesYHchHXv1E5jJoWk3+IjwwKzdWfof
	 bqQXwqQBq7ajoSuqF8Utb4ykREg2SaRtfkKuQZzOdJGDVQGfT4stDmY2mIy3R0hMJY
	 VyDbj9+LgH/4q4yArBr2xEGfrA21+19zjyWL4g4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zeal Robot <zealci@zte.com.cn>,
	zhang songyi <zhang.songyi@zte.com.cn>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 073/222] Input: synaptics-rmi4 - convert to use sysfs_emit() APIs
Date: Mon, 23 Jun 2025 15:06:48 +0200
Message-ID: <20250623130614.297836163@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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



