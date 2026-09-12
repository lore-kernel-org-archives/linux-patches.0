Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E9404746BC;
	Sat, 12 Sep 2026 13:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220385; cv=none; b=bBE45/nM7BhfYO7rmZ6i+lp8q73yhQXVWiAGxz3u1qggOe87NAl8CKW4Gmz144uJG9BC1BrRKKcoiQJWlJT3rtPmU7mJzetquNYdvaq8bwRN0GY8nlcwZ/KIH/i1f02mjkwdjR4gPBlA/OSStE1bECMn62WDTfFxGv5t7yitG5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220385; c=relaxed/simple;
	bh=kUgrYCGLHZZGB/dRoewU0KReLj7uSy/R9RzYtESkTL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jk7AtyEMNM2ypr06y4Ta6CNaEafQWmVeKye4c/l94nbZusmcLBQ6o+0ePan0FfhWxZ/l8dvQun7JQtk/gSfSjdMD6+HPprYDa3a4sRebAfN1AMneRhjsd4qzbaxB8XtogBlXfG9749NzjEnmjrAbZWILSA8Kgl3J7ViF7bBg93I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Te/LBXSy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Te/LBXSy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 062761F000FF;
	Sat, 12 Sep 2026 13:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220384;
	bh=j3HZyUWMtX/5aRxuY5mrSquyFrQe8BlyecZzvceNKkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Te/LBXSyhdfnEOTmzV2HSbiXu7Q6tdhJX7XMJp06S/w8kVafxrnMpoOJ2Q7h+qsGX
	 s71/LhFMYwBsugSY5xEqfVoDv0FlyXWROCXD5kEgF4I9tmuotMkEXG6/PWofuWtJ4k
	 1s4KEOrhd+OLuE/5DJ2PgJG7H/lWyQewQR0qcmao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Krutskih <devsec@tpz.ru>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.6 0124/1424] dm raid1: reserve space for NUL-terminator in build_constructor_string()
Date: Sat, 12 Sep 2026 08:42:36 +0200
Message-ID: <20260912065610.078355593@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


