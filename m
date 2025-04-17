Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F5D41DB148;
	Thu, 17 Apr 2025 18:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915622; cv=none; b=JTHYHv2HXkqHtn74wzTWQ1rqVKDog52xgdrHL6MTZOgwHBtLlQOHtOpW9NJUyYXiLt1zZi6Wf68fHjtbVfvqUbx36Xvr+RQANKTAxg/vjZMwS+TvRryo7P+MfURmt9Q6rFCEFN6Cx3eGDdeMUuou9xJlPNKRftE7LzfFn0+kw2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915622; c=relaxed/simple;
	bh=9vC/NYAPYJ4ZZV1WpETnhWhPQ+7awIpdcYKMDgFJoQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N7Ivw7TBhQe5MfNS3layk7OniGFniXLSzoin9MwYG8sgYK/G5UaPYg6JXWnZ4vIdDo7anEdu4bxtXw+bte/27UkwF5zofk6Y57bFP4SGRMmmMZlRymG0hdKvtMQ2lMYijyhsk7rKp76bSuZCdOSKzBInF10LqbmoD7DOYZWTwxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QdMRqbQ/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QdMRqbQ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B999DC4CEE4;
	Thu, 17 Apr 2025 18:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915622;
	bh=9vC/NYAPYJ4ZZV1WpETnhWhPQ+7awIpdcYKMDgFJoQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QdMRqbQ/9I5z3Vj26MX5uQSvkqNQkKRJmLCkoNyfssuYMOQjJcK3q5NdzNOiOLrlF
	 gHKoOKxTd6F5e1Gv8UuIeNzHDlpIpte7JQwJR6wY/VKnnnsjyEf1mS4M8aKREENjRQ
	 YLlTtBtsRYZNY6mdPXuzbeoWibAcu1wHZtT0bhsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 185/393] HID: pidff: Fix 90 degrees direction name North -> East
Date: Thu, 17 Apr 2025 19:49:54 +0200
Message-ID: <20250417175115.034509181@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>

[ Upstream commit f98ecedbeca34a8df1460c3a03cce32639c99a9d ]

Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/usbhid/hid-pidff.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/usbhid/hid-pidff.c b/drivers/hid/usbhid/hid-pidff.c
index a614438e43bd8..6eb7934c8f53b 100644
--- a/drivers/hid/usbhid/hid-pidff.c
+++ b/drivers/hid/usbhid/hid-pidff.c
@@ -145,7 +145,7 @@ static const u8 pidff_block_load_status[] = { 0x8c, 0x8d, 0x8e};
 #define PID_EFFECT_STOP		1
 static const u8 pidff_effect_operation_status[] = { 0x79, 0x7b };
 
-/* Polar direction 90 degrees (North) */
+/* Polar direction 90 degrees (East) */
 #define PIDFF_FIXED_WHEEL_DIRECTION	0x4000
 
 struct pidff_usage {
-- 
2.39.5



