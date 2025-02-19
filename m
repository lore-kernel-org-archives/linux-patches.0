Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8655823DE;
	Wed, 19 Feb 2025 08:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739953856; cv=none; b=EM5hC9nepchy4yPBXUVlJmSBDBr5JDqu6pq3fTURhsQJucf6AbUxWNgFVakFPwKKjQEX+5v3VCYQYZeLg5PHJZlGwmMZhBFGL4UwBvNAETa7chr3Ijf4vsXwm4tP3dH3AAA/Xqahnclf9nNIKnUlBpE8FJRYBCK5k41iLmMNAw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739953856; c=relaxed/simple;
	bh=+pLQcnAmemZqUeWSZtMHwB3V7hvNPpEWz1FCDq8Rk30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MNgPKSXE8LdBn5iXULcc3jeEhcxd7vPHanSZZKNLmKdztsedB3Dt4h+jnkdX4P6BkPlJ9IwdDjrUb03PmiuuF43yWfVeN/noNKyNn3ig2kXTRndiMRmJ8/1sfNBimaxlxcSeQJaojybe9hXUukrpc2ORFXYKxjtit5hhSSQWniw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1lNeOXp0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1lNeOXp0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B21FC4CED1;
	Wed, 19 Feb 2025 08:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739953856;
	bh=+pLQcnAmemZqUeWSZtMHwB3V7hvNPpEWz1FCDq8Rk30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1lNeOXp0g39O0VOIWTNDCGXoSnqUbUG1a6WTeqGeXmizDcMRihtzZ1s8yPDUJq+R+
	 3WgaVd3YmjuMQY09Cp3f4koAtPC/zIPoipwsYCRcFJfLf3cgEe1BDaZM1Dz2GPyzBZ
	 tQl87XCMbE473EeYKMYrWU9xFuZiCRDwF2RWogng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	yan kang <kangyan91@outlook.com>,
	yue sun <samsun1006219@gmail.com>,
	Stuart Hayhurst <stuart.a.hayhurst@gmail.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.13 002/274] HID: corsair-void: Add missing delayed work cancel for headset status
Date: Wed, 19 Feb 2025 09:24:16 +0100
Message-ID: <20250219082609.633680272@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stuart Hayhurst <stuart.a.hayhurst@gmail.com>

commit 48e487b002891eb0aeaec704c9bed51f028deff1 upstream.

The cancel_delayed_work_sync() call was missed, causing a use-after-free
in corsair_void_remove().

Reported-by: yan kang <kangyan91@outlook.com>
Reported-by: yue sun <samsun1006219@gmail.com>
Closes: https://lore.kernel.org/all/SY8P300MB042106286A2536707D2FB736A1E42@SY8P300MB0421.AUSP300.PROD.OUTLOOK.COM/
Closes: https://lore.kernel.org/all/SY8P300MB0421872E0AE934C9616FA61EA1E42@SY8P300MB0421.AUSP300.PROD.OUTLOOK.COM/

Fixes: 6ea2a6fd3872 ("HID: corsair-void: Add Corsair Void headset family driver")
Cc: stable@vger.kernel.org
Signed-off-by: Stuart Hayhurst <stuart.a.hayhurst@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-corsair-void.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hid/hid-corsair-void.c b/drivers/hid/hid-corsair-void.c
index 6ece56b850fc..bd8f3d849b58 100644
--- a/drivers/hid/hid-corsair-void.c
+++ b/drivers/hid/hid-corsair-void.c
@@ -726,6 +726,7 @@ static void corsair_void_remove(struct hid_device *hid_dev)
 	if (drvdata->battery)
 		power_supply_unregister(drvdata->battery);
 
+	cancel_delayed_work_sync(&drvdata->delayed_status_work);
 	cancel_delayed_work_sync(&drvdata->delayed_firmware_work);
 	sysfs_remove_group(&hid_dev->dev.kobj, &corsair_void_attr_group);
 }
-- 
2.48.1



