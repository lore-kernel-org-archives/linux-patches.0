Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D707178C9C;
	Sat, 12 Sep 2026 19:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241166; cv=none; b=AF3fQwc3DHfBi4Xl7NvV/cNL8X80AHPBqgIft1rzTinxh/iKElEHiCjOS9PE+VIRnmzXTylMf7PnnwS3J0MkM7PY4F+JmLRulkEJahO/R2dE7EW/aDWp+N44z1gAE7cZcN+A51Yk3i5/2zzz+9UkkojIu5KgFPfQIMMB2xrS710=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241166; c=relaxed/simple;
	bh=FMNdyb9tUcs2QPQWLEnc/uyx/Du+HfLWbDrvlba+Y34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=io17PFM/v1MTYMrt7rrldxz0djbPOu/F06dDaMnFfvodHni6Ots+dr9RrlgiVGw6PaBtbpDVtG9WdtjggC/68cO/Fa3wJHMD6CSmenSLFfyzoJ+/AHiaLYvpYtqcPwPUGZPxK9n2Sy7k+OlyKpJdL2+KlExvse50pJTNXcEMa08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YTFTQzcS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YTFTQzcS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D1401F000FF;
	Sat, 12 Sep 2026 19:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241164;
	bh=j3ykg7bdA6fEmCAryYOcL/Y7sUPgPQijpr4TCocluMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YTFTQzcS2DkFNAndDOjLb9QcUeZ0SpHCXQ4jP+9tykNwLtUDbfx8T+PJemtkOmHfE
	 vi4eMsOHYg4JiEXGbAcbSxGdtoSLAWGJTjv3oyCaK8D+laIe8pKQvQ6dWbFYwOo1RW
	 0wHxotJCCFfYjsREAAduki0ut9cdu6+lGMloWqbQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Krutskih <devsec@tpz.ru>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.10 080/798] dm raid1: reserve space for NUL-terminator in build_constructor_string()
Date: Sat, 12 Sep 2026 08:55:08 +0200
Message-ID: <20260912065518.797362417@linuxfoundation.org>
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


