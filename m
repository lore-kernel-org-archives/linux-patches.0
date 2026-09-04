Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA8BA377EDC;
	Fri,  4 Sep 2026 05:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500951; cv=none; b=T1IdxIz8ZjOpBD0db3a9YujbWFQas3eiIuRuPRAQKmqBvZjPrM4+0QpNWeW9CPDabwaqQ4EMyOjt2rPSMNU3qRVb2CM3CKz+xbe5wmBPBjb3qj3z8gzV0ZvD3py/c3qW6w6bIbkZncYSYVG/KdMXJu+7Pkx8U1EA4GJ/PEXz+ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500951; c=relaxed/simple;
	bh=44xeC1BCkaphD9hgpnQolfBIiRqwJ4LMlLPq3/Li5xE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GQS60510U7z5y78Sq3vaOGrljeww0DOmdkr/9P0gbgF/pLXVAduNtmyRoIRTVjLjNGcqjSRPtfDt8KvZIfxLQznbFRpXE6V66w/zXGAlhIrAcvEvXI9zqSxg9wRtVGhxOjhkCdrhcvt4lw4C+Nmr2BoAdfiTIu0pG+EwRasXSVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U8/gRvG0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U8/gRvG0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFFD21F00A3D;
	Fri,  4 Sep 2026 05:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500949;
	bh=nHWTLFcVZYUKbMd9PuXA9pmwwcp4FOEz2JpWlfaKDl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U8/gRvG08tScSwinWs0utLSmbfWDqycOFEYImOyISP09KNFfJshzjJ+4sFW/63WUS
	 gcSkvKQ4ly+AIPY52Gm4oz8ivas3C+F05RSGOtsnqoGBwLwsElJCsfH7teTTjOA/H4
	 HJp62TVXoT7M1itzgl383Ks+SklGFpHDgkdBJ5YE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Krutskih <devsec@tpz.ru>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.18 237/552] dm raid1: reserve space for NUL-terminator in build_constructor_string()
Date: Fri,  4 Sep 2026 06:56:34 +0200
Message-ID: <20260904045754.853720348@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


