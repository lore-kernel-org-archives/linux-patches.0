Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035488;
	b=a9MFmrql6wZEB672W8RFBgiq5s4llyM/4GqdaqEJjv6tTEEB5dvVBkm4eUOcmEKW7+jS
	 idfojIGGBPR03damK89rytGdsnaWBmTka/p69q1phozQcXJTVhucq31Qqoo5K44juMYw5
	 eK4637zJ6phLMDnCpgd6WZL5ibSV7+AvZDME1jbk3TuFujO7QKKLW5eRTfzWr2V2hC7Yj
	 8w9Q0871P3+BJMFs+NRf1llzck33IFY2kRAu28xu+CBPlmgDK1jIYWj0F6X9h+5fIDex/
	 vZ316VNELXgknZ2HBv3e6BOL1TPAmWCR8POCfYLLBbqS0n/BOGnEdY9MR+WROWuOM6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035488;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CtmzqMbJ2A69szRhpb5Rxt0r5thxsIw6t/LMvqbgUOg=;
	b=1XdfohGkObXQGf+aWRap1IJMeTID5pDFQZvbwB1Ncbbn7Ic8PT+5QRvzHLdDU47xJqZN
	 6Zc0rMjURvJYhDpZPFwyklmeWeCMTFVsYdxKelwQML3/zFCc7yfhj7Exv0u5ioy0U5uMB
	 SgHsvJErGR/Id5Zf0PLFOCL6jJ4xMN/l+7Gqd4LYURuGdhTFsrSCskI5mcSPBli1bYT2S
	 ItrCySXshb2uUTaIUr44Z+PT3JgCwDVHSDuaTluWv0PGjgKdEyvneooRi1rOSARzuO7V8
	 t66bS+RwThDORDAL50jQpWqwn3wz3EhQ/wdjChU+8qY0thIIFrtHtfNTun43I886Z4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kKO+3zjp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11E41606A31C;
	Wed, 18 Nov 2026 20:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kKO+3zjp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64CE91F000C4;
	Wed, 18 Nov 2026 20:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035487;
	bh=CtmzqMbJ2A69szRhpb5Rxt0r5thxsIw6t/LMvqbgUOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kKO+3zjp0q1yu6F5ey+tR0GIGEZ/5TupFcx3pxDfTq769HT9vsw/Ig/8RYRgBwjuF
	 68tqBDviS4OKtT5lTAuf4ejrTye0IGhKkz5/PzTseDJR5GkVBLRsM/BKtraoQ+fJcc
	 BYFIwbZZpO1Wlzw/pqdSksppCp/B5rrgH92/E9CI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.6 0722/3318] HID: zydacron: validate key report length
Date: Wed, 18 Nov 2026 15:22:24 +0100
Message-ID: <20261118150340.157467071@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


