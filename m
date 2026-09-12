Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68376349CE2;
	Sat, 12 Sep 2026 19:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242481; cv=none; b=eeEgpX9pNpEFoictFjkxuWzG0QCE1y/lnhQRVPyHDWMpN62rIvDnU/7Ib2l1Cf+J1UCXkmNHVeVv2gv1OwrNXwzsmuERx2CFdlk64sGx/h+IbKdZVVA33DL2F8LhikCtybA9gWOQSdt7EA5PeXEO0Yoh0UYNG9FlW5VuhRqJ7Ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242481; c=relaxed/simple;
	bh=sQhJ9mVpaW8fzdw/WaPoAq3awZo3DYjU0Tfiy8G5iH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ec2MoY0a4y9cJfwAMCOy7Z9JJOaQ6cvGHgEg9JNOcs99Lodx+BkHS0T1P5/rbWaESgeWK3e5jzBqv8mxQ9se9eRQQLRKC9nkCDdAp2HT32d4ACSF7lfZr/J51a1e6Ep4w3LGe0sYsib4BYc048NicG/fQI9WEk5Fn1AomM+zSc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TDvGJ0XY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TDvGJ0XY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F6D11F000FF;
	Sat, 12 Sep 2026 19:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242478;
	bh=rqqzpQXqLRFHiN0DMFw3IJXku4uNmzjhi7GIYYqHz0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TDvGJ0XYwymvoFwdVNQBbgsbnBi7Rrwb6lkxufkAg8aumokhTiCIcevvW85OWVHGq
	 U5fQcvfcRTzIjqOlJOoh6eZlJtVVpswdqOyoBMGbZHIVCvycnC/32sNttWr3Lg/R39
	 vLWOPLB/yYFYvD1yhXJymmndl9l3RfqaK8CNCGY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Alexander A. Klimov" <grandmaster@al2klimov.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 381/798] staging: greybus: audio: correct sscanf() return value check
Date: Sat, 12 Sep 2026 09:00:09 +0200
Message-ID: <20260912065525.887023332@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index ab882cc49b411..22afaf8dd1100 100644
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



