Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831855;
	b=m7XEebCSot8OG8fnOwDLfp+0MEqFDPX2JYTMi/lsvo+b6e5Ydu+s0QDI3hglRVaz7efO
	 qrG0O3qWIB3B8pS04uBCcxNi0jxyazp8HIjypGRQ6ztxUxEP3vWQBlY5VVjqyujD0kHlJ
	 56HfdO9Npkh56wMDHQonnnLgeMbybVZERCNTyzD3cRsbQU11FXMErJyvIPNvyZbnvJe/P
	 Xy2UOSbbKIVvyQoz8jE9oJoasG+7u450WbvfrZDp70exXhPIUIxk4CwxfLA7BKFoFCpmk
	 88CIAJ9pFhACBQ6JxJ1sVBqzmdVEfS5oOMVOvjSPSq+prjxdtPUA7TBbMP06yQeKH5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831855;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fbk373F4+f/n/8pSe/9aWktGmVjDAS6LMKu/wK+aPjg=;
	b=B6rbNIQ1g30AAxgP+3XEzvG0Yocy+Q0XsmLP1DcbMAbtcjbgJzPcFSVsZENL9YIjJ3r7
	 REsu7owBQVn0XuTNuq9KMiz9fJPsMZXe95KLonVKDdX7l+6bKbbZGGYhkoB6a6oIFJhVb
	 wfFg/6LCCKAvrlkShKygrpXLiA3VHhNwp9DQ5x8oWzZoEeN3DfV1zmCdauuLuGb5RRr3B
	 7FnE0JeidmbrgjdRWEa5vIwhqh7T9iUiMYX3TW+os+9Qh9KQmzolkALGK2xnGiMvzvxs4
	 TRuWE9R6aFZhVFySAt4GBxEQ9SwQ0fRCp0Ba1t2gm9lfPXyIRmVfGJ3dgBApPYrTENQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bTDkB1rx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EA59606A328;
	Wed,  4 Nov 2026 22:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bTDkB1rx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 218931F000C1;
	Wed,  4 Nov 2026 22:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831855;
	bh=fbk373F4+f/n/8pSe/9aWktGmVjDAS6LMKu/wK+aPjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bTDkB1rxCvpHGpS6ZoX2TAJBEAQmn7wkpy2Ryukr9nezIsfjdWxx17RpSjTgTcmQN
	 Ar3mQEKoblDHvIRsb7kwwwMMdy6pVunpofSx6NxaCTa6uQ1Q3Zwzk4z35YCtxd4uDa
	 qYJJK+ExNX8tIN7pPuKSItXRmaB+oFUkGWHV41dc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.18 0957/1005] HID: pxrc: reject short input reports
Date: Wed,  4 Nov 2026 16:11:30 -0500
Message-ID: <20261104211109.895285745@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiale Yao <yaojiale02@163.com>

commit 0deb22da5a8c6663c3e071f55fd7d7e3189f5517 upstream.

The HID core invokes raw_event callbacks before validating the report
length.  pxrc_raw_event() reads byte seven and writes bytes one and seven
without checking that the report contains those bytes.

A one-byte input report reproduced the first invalid access under KASAN:

  BUG: KASAN: slab-out-of-bounds in pxrc_raw_event+0x161/0x260
  Read of size 1 by task hidtrigger/90
  Call Trace:
   pxrc_raw_event+0x161/0x260
   kasan_report+0x139/0x170

Require all eight bytes before reading or rewriting the report.

Commit 47669bec44fe ("HID: asus: refactor the two workqueues and init
sequence") added the same kind of raw_event length validation to hid-asus.

Fixes: acc3e34613da ("HID: Add driver for PhoenixRC Flight Controller")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-pxrc.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/hid/hid-pxrc.c
+++ b/drivers/hid/hid-pxrc.c
@@ -55,6 +55,9 @@ static int pxrc_raw_event(struct hid_dev
 {
 	struct pxrc_priv *priv = hid_get_drvdata(hdev);
 
+	if (size < 8)
+		return 0;
+
 	if (priv->alternate)
 		priv->slider = data[7];
 	else


