Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CBBE3B42F7;
	Fri,  4 Sep 2026 06:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502332; cv=none; b=Qb9IAvQB4oMi+ft3nCTlGsus3rXJn8nqg/RanJbxqv8hK9OxtlRpvZWra8jBA9UQJRzAI8mkz/CPFlcQf/z1Jlc5FDnFJY1xYuWYKIp2UGQywViKRzJMlGzs3HY/psYJ2Izti16EADq38xtL9v0F1O9HhHYS8QOTsvH5VHFrWGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502332; c=relaxed/simple;
	bh=ianDZBY93KUWFh8tpDfFLQbAwM/cqOrwUhIo4No+vCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ir8R9XGh32deDqjZ872UMBq5pb+SRgiU6I/Uotv/XpAquv5I8YXeaP7R4p8kEBxs5VC9ewXjQBVimkz+eLM9iGfjAbhJM4LDpYrNoIbSslTmK5ON1gi8eWHnXFPgasry65elFfJjqLxFp7iW06FXzv6ioqqaJzyMDqIkIEmuU/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=grBHSZT+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="grBHSZT+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C2A31F00A3E;
	Fri,  4 Sep 2026 06:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502330;
	bh=IxGLje0pdtiWuYkVAJcQLdyd7dZpif1wvS+g0grwpAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=grBHSZT+WVlHRPaoMGA7ZE/Muixtn4me9zeBnfUB+JsHqjxjYLAlwQl8DeBGYI9nB
	 YCqW8MQKKrbZMYfxFWYYWyIDVaWuUb2dPY4vS7o/KK8VWYghMhVDlXyWLWZwSD+n/k
	 V/kJxLu11rryj+YN5hvMeIbVLUaLIx0XkdsMmLj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Krutskih <devsec@tpz.ru>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.12 169/403] dm raid1: reserve space for NUL-terminator in build_constructor_string()
Date: Fri,  4 Sep 2026 06:59:32 +0200
Message-ID: <20260904045738.705045545@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -139,6 +139,7 @@ static int build_constructor_string(stru
 		str_size += strlen(argv[i]) + 1; /* +1 for space between args */
 
 	str_size += 20; /* Max number of chars in a printed u64 number */
+	str_size++; /* For NUL-terminator */
 
 	str = kzalloc(str_size, GFP_KERNEL);
 	if (!str) {


