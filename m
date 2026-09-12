Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B82BA345EA2;
	Sat, 12 Sep 2026 17:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232825; cv=none; b=lUepOOOTfmBMnvjx3YEKxN2Ryh6x2AGnkPt37+MbKgmuFzkAjbR2yQUtiEgs+HSood7sp7677pICF2fd4FxXuAQGIco2n2yArwsjpsQs7ERzBrKUH0vRegHhOHzmFGevO2DWfyjbXKxQ7DwY+Jld6HOvE7nKahkK9qb9lO9X7ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232825; c=relaxed/simple;
	bh=degXE2tOe8hp+u18No7aG1Uso9Kgh8Q3WAqHLwj68ms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TbMqzSRAWPsFmC/e45uRmULTz/RSbEywhATrU0N55Lf9m/UIELYGVvlmGCgXXj0Tlid0CqAe6w+yw3ETu69vqFk4hqmyYdc2ALJfJE7gZEuPQuE8YgjlT3sCAiVkrJ4iSq7DAy1AmJtHVXxHAMpz/VcYXJQFh2ocq1Yq1oLKgoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dB74P/Ck; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dB74P/Ck"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03E731F000FF;
	Sat, 12 Sep 2026 17:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232824;
	bh=HDfrxaJ2kNnPm90vqJP+Px4L3Ym+SipP1a9i+rwbRys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dB74P/CkMwMW+WFnVCqpH4w1I7K/f07ln32lNfElxhRhKy/gzmsxTesJXbWwNEosD
	 QH9YEJvZziz05uJuGtA17+m6UpF8DDRX5HXWOiccDLZCInx0YH67vYhI5Ad5vKIBtq
	 YSuNqeKJZyE8q8+9VuvehwROQjGxJ05T37gqZd0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Krutskih <devsec@tpz.ru>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.15 090/935] dm raid1: reserve space for NUL-terminator in build_constructor_string()
Date: Sat, 12 Sep 2026 08:52:00 +0200
Message-ID: <20260912065528.888847234@linuxfoundation.org>
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

From: Ilya Krutskih <devsec@tpz.ru>

commit 73c37fe54cd056d07461b142ab0b8b81e1ef6ad8 upstream.

Reserve space for the termination NUL after the maximum 20 decimal
digits of a long long value to avoid buffer overflow in sprintf().

Fixes: f5db4af466e2 ("dm raid1: add userspace log")
Cc: stable@vger.kernel.org
Signed-off-by: Ilya Krutskih <devsec@tpz.ru>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-log-userspace-base.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/md/dm-log-userspace-base.c
+++ b/drivers/md/dm-log-userspace-base.c
@@ -138,6 +138,7 @@ static int build_constructor_string(stru
 		str_size += strlen(argv[i]) + 1; /* +1 for space between args */
 
 	str_size += 20; /* Max number of chars in a printed u64 number */
+	str_size++; /* For NUL-terminator */
 
 	str = kzalloc(str_size, GFP_KERNEL);
 	if (!str) {


