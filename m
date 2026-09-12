Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80F91309EEB;
	Sat, 12 Sep 2026 16:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229164; cv=none; b=ZqqKB6E+jVsd6+1YUr7i3v4nKLUmnyNtNIKcC8N+MFCCv5GZmf3T0hKe4wI5nS7+3uRjHWDv7tQGcsVjToqGCq+PqHfJMVHi9fZTAfSpZlczCKVgQkW4q9zOHeCqpckcqaVS+VYf52m6UCWm+c5X0NtatIKT9fxl/zeeqeFheXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229164; c=relaxed/simple;
	bh=N1b9i2nQUfx01EXvmZ6jIZTlBW0yw9gb/DdHYzfpiDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I2ivJZDJG5JZ+5yC4mGXmzLhokahPV5EnurUbI/SfMWoFOIfjQf0TJcHgHnYg+nIEawWCnWZR+/6UedolalPcwSTH7D5HlrspBZSDT8ETE+47ifhUibKXDVWCOSb0DTuWuwlHHKJViUhdx9tGW58lqsu6l3vDeGj7GvCTtFqxw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ze81iBKa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ze81iBKa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0E501F000FF;
	Sat, 12 Sep 2026 16:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229163;
	bh=7Ol6JmqYQuReMJ11uzQGjrD9XlMYMipg4nflnWgHy5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ze81iBKa0858hTJHvCUHnUIFamYjhWGaJzlXKdqRE6Ms07nQhdymu4GFoWm4phLGh
	 1eolGWfRJjS8bng0zWqJmV/+1Z1MG4dSyNUiefpUUo1MhiABZ9650FcjYigKv0ThHy
	 G4HnZ6adU5OLDAKLbVB7cIWiL4wzXaPoma5bDapo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Alexander A. Klimov" <grandmaster@al2klimov.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0534/1191] staging: greybus: audio: correct sscanf() return value check
Date: Sat, 12 Sep 2026 08:54:22 +0200
Message-ID: <20260912065600.245465500@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Alexander A. Klimov <grandmaster@al2klimov.de>

[ Upstream commit f883fa1a0a0212f63acb18c50e5f900301f3bb1e ]

manager_sysfs_add_store() passes 6 pointers to sscanf(),
but required latter to return 7 which always failed the operation.
I corrected it to 6.

Fixes: 49b9137a6002 ("staging: greybus: audio: remove redundant slot field")
Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>
Link: https://patch.msgid.link/20260521182331.22685-1-grandmaster@al2klimov.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/greybus/audio_manager_sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/greybus/audio_manager_sysfs.c b/drivers/staging/greybus/audio_manager_sysfs.c
index fcd518f9540cd..ff323ca8154f3 100644
--- a/drivers/staging/greybus/audio_manager_sysfs.c
+++ b/drivers/staging/greybus/audio_manager_sysfs.c
@@ -23,7 +23,7 @@ static ssize_t manager_sysfs_add_store(struct kobject *kobj,
 			desc.name, &desc.vid, &desc.pid, &desc.intf_id,
 			&desc.ip_devices, &desc.op_devices);
 
-	if (num != 7)
+	if (num != 6)
 		return -EINVAL;
 
 	num = gb_audio_manager_add(&desc);
-- 
2.53.0



