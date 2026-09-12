Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AE572F617C;
	Sat, 12 Sep 2026 18:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238588; cv=none; b=X2f41fOQyE2CcrYTny1y80YeUvci7qIf9G2uet/flNsFdhy6Bh2KFmqjnXQo5/qPEF4JpTspLlK7lwY9XyA+738uuHozrsEip8EE6lmInRib2vWXtKy/YaFH/4Is++VByAmr2XES9af6fupkGyj6sjYT5xRYHGdkot63DNq/kpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238588; c=relaxed/simple;
	bh=iKRt8TNjon5fXPFgfKtw0pgFImkPtzV3XIlBAIVt6yM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FJbQfHZu3SYBQaXc4j5N/7beNBFRHGRqzLmoybmQAhQL4VZ72hhytpHNk3hVNsHknmD9WEI1fbuUXESZglW7rO3QInqwHoWieBGBQLGYaD/b0jmmg9B6J+X8VApJsdoZ5urTYb9Vs/R3YRH8EGHZhubxGdXoEUa3enjO3PhnvjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JwXV/2Dh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JwXV/2Dh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B21DD1F000FF;
	Sat, 12 Sep 2026 18:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238585;
	bh=pG5fSduuTgkcyD7SJB5kmB/ToK9QOAdrDfXvSCHV9/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JwXV/2DhAxkUIZ7Y4YuwrDiRjybnKq/F5/NiauGqkR4JXz8wxv5nviKxZExHKNccT
	 gfLv1KdnfyjwcehvKBWlQr8ujasOZR4BzamYQoGsZj88YXSmvy9BKMlD+ju17fDd8r
	 7W/nK6+c1rQA1fdJJ6VWsu1hEp83KLmZxr//zhz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Alexander A. Klimov" <grandmaster@al2klimov.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 449/935] staging: greybus: audio: correct sscanf() return value check
Date: Sat, 12 Sep 2026 08:57:59 +0200
Message-ID: <20260912065537.127850889@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



