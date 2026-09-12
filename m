Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72D17275AEB;
	Sat, 12 Sep 2026 15:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227280; cv=none; b=SHbNacEO6/r5IRB6/jXDThLGwayck5DS9SutRmBhrwqM5F8V1xJlvupIz0bBewGmcVzXD3AdvneZM/Vpf6XrJgPGRCQnCD6nzm2dcm8pe7UFeTw06OY9xKTQ8jCUcAYME4LuQKI601LJFkDgZtFE4tsanQ79oK+ekHpB7XlAv04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227280; c=relaxed/simple;
	bh=88j5UyKqcN5MjHFL3t6B99qL3kZfJplXJ8Fy99bJxNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AmqRl4YR/uzM8KB/f5V7iLI/KQBLVtZw9Rq8cQP0gzJs8rTpk54uaEpp9gpiD82xqeB/zaUUL3B7gvAQbU5RIh9NTH0JtMA87YXLYnlPLULft9RMmwycksovdbJgjR/aGzDt6m5CNs0a9/2YOtL7mIXPvH41WG7Sx3es7Kq63QU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MlXWidue; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MlXWidue"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D38221F000FF;
	Sat, 12 Sep 2026 15:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227279;
	bh=aXxyAa1F1wCok2huXWViEIx4j6wYDo3KbhELsduTo7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MlXWidue+lzQVgkcrI0cZfVpeNGCltzYUOu3m6pO7+0MNSGOG1RWq4m4h2GJw5YeW
	 RcJjpHMQrxtpQv7bQuXZTNQX4KMp1XCPaBbxA1oz1nDYWy6WyGf3eYynl5bMBHUdM3
	 G3105/UzuE9XaQyfUuq6MLbrc0AbiEfWirNN/5I8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Krutskih <devsec@tpz.ru>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.1 0106/1191] dm raid1: reserve space for NUL-terminator in build_constructor_string()
Date: Sat, 12 Sep 2026 08:47:14 +0200
Message-ID: <20260912065550.566592976@linuxfoundation.org>
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


