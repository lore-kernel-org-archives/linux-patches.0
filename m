Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831903;
	b=WXo24aduSr0VBdTJdOycR2EGryhpvN9JLtcilAIZNrZRC05ZGoF3LZ5qZxrJkFA5RZZa
	 XlDZxT05/tjEScbWXTD/hatxrkmWg126mii6CNJ8hJb7xM1hs8AoKYRwYFOKYC+AJ6myX
	 4/z0wkpQEiln2mYhDD59H3/GtsWi0qdNFphQP55XSMHEK60Pmo/c/dN8z1nEY8iVPlHPl
	 t9qHcaU1JyHpJTKn6PMhcK0rRsycVgkuIqUo9LxA3WasswcYWz9YA4bjzTVfimcCMlph5
	 n/O1laGGLu8cdyWqtgkwfZdFwBULwJE8c/hmprC68QB5Op4KatO/fUefxWoD5BpjFwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831903;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mgCDQpC6BqLCIX7bCd0t1kUCrbfpEEKubfCbNX+sUvk=;
	b=znOavEqzz9FAWx7Dp81xfAQfcDdnUfyYSbtiYFtOHbhTw8O9SUNa6Yj1bGLkzrL5PmP0
	 ug1Ixr2okXZo7jAKfJYxgaAHkEaQjbsqtPr1jM5jD49OmO1eq3tdOUA10Lp6PX9kxwhqa
	 sRHWnHc+Am/5brKJ2aHzROSJDNvLikuDS1SWu8++szNlgnyrkkMpWP2c29InG1RBjMCaR
	 yis1psX2gNLu5SrnW13DnjMRk/DsNCxuMDuECPN3wc+f0s5ZtLNzU/KWavC/GLUINDeA3
	 TfthRl6RhVj4dGNRTFiWC37ptcM5r+G/Vhjh4IJUoQKYmQwDU+KOrR7zUqoMZwU0y6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="epVN/LHp";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29C06606A33D;
	Wed,  4 Nov 2026 22:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=epVN/LHp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8FF91F000C1;
	Wed,  4 Nov 2026 22:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831903;
	bh=mgCDQpC6BqLCIX7bCd0t1kUCrbfpEEKubfCbNX+sUvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=epVN/LHpL3/IgGuGqYfkxRdBna8yykeYioxPDCzc/WaCvyyLKTRtqxwVkR0eGWARO
	 YHB6WHtInGYBRlFncUMi4K6rJmrXqLCML+Ldtqse/PrlQE0armDJ5YD31k2UraVGdl
	 jS9biglLF1mpf+NJ0cmDIlWKUJ85bIS4ukMXITDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.18 0945/1005] HID: zydacron: validate key report length
Date: Wed,  4 Nov 2026 16:11:18 -0500
Message-ID: <20261104211109.586764052@linuxfoundation.org>
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

commit 9932c9af185f8586e883d44ca562c12f4487c762 upstream.

The HID core invokes raw_event callbacks before validating the report
length.  zc_raw_event() verifies the report ID in byte zero and then reads
the key code from byte one for report IDs 0x02 and 0x03 without checking
that the second byte is present.

A one-byte report reproduced the issue under KASAN:

  BUG: KASAN: slab-out-of-bounds in zc_raw_event+0x54c/0x580
  Read of size 1 by task hidtrigger/93
  Call Trace:
   zc_raw_event+0x54c/0x580
   __hid_input_report+0x2ef/0x3a0
   inject_store+0x479/0x490 [faketrans]

Require both the report ID and key code before processing the report.

Commit 47669bec44fe ("HID: asus: refactor the two workqueues and init
sequence") added the same kind of raw_event length validation to hid-asus.

Fixes: d0742abaa1c3 ("HID: add omitted hid-zydacron.c file")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-zydacron.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/hid/hid-zydacron.c
+++ b/drivers/hid/hid-zydacron.c
@@ -114,6 +114,9 @@ static int zc_raw_event(struct hid_devic
 	unsigned key;
 	unsigned short index;
 
+	if (size < 2)
+		return 0;
+
 	if (report->id == data[0] && (hdev->claimed & HID_CLAIMED_INPUT)) {
 
 		/* break keys */


