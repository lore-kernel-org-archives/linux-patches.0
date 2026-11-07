Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061773;
	b=ayJZEHDaG22TMh9Vqs5CHW+rGTkcE+H9ZHmhV4Q4XYmU+V/IVlgVvF8JgxF1BZFn4MPv
	 JidgTzAFW9RPGRZWTovSvtBhefdc6H0RESEwVqfgvGaJ3nxVm/hCcLNkRSmrLjcIn+6YK
	 0+Gd5vEWbfHDAe1/u5LvRltV6lU4oAU/NUfuoBJn+ODRKhk0cPUirviX17aXnv0CIW28C
	 O1K7O0TwQjqlxNcj+GGLyVs2790HQ9RcA1UM2LNNpIhE/ttLZBRy7VZPeUImliR5T9SDV
	 Bfs9hqFmwizCD9RuRS0eNbeDuTnqw5d27Ig6dzUAabX7dQllprAG8uCnJGtKs9wcr3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061773;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sT6qUTQr7WB3MQu69kX2BEumO2/1zJ2q5HEEDU8hWAo=;
	b=xPjpHCecLjufMyeE1fKx53zrVQuz+Um2hASs4TCrlpjiRn947e/QMr+5Wbtx/bec4U8t
	 JzE2Feh5AZWd+NM/m/pVFuHy+y5ce2Fsz31iJDRalzGC+FJPDmM4XpBEhyCj5Td/+OIsC
	 HSJwMado3vLCLRTA/bkPPErH/l8EqVj0yT5r1TN4nBtuM8YnejqbYNoBIjDCjJGWHCF1R
	 r6uwaek1DksLJ9XDGTq7TyIuBQQZKgjdTFidWX+RYqqIYmwJDJFUaB/tR1j87Vk1f7Ew5
	 5Y4pLPfEf6GD7Wnpx79LcbvaHPXzyyZMf7iUs9ygqMLDDNxMUYQJZRb0PaXYDENbpZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SSU4AUPv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AFF6606A32F;
	Sat,  7 Nov 2026 14:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SSU4AUPv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABA1E1F0089F;
	Sat,  7 Nov 2026 14:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061772;
	bh=sT6qUTQr7WB3MQu69kX2BEumO2/1zJ2q5HEEDU8hWAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SSU4AUPvPejoIRfBsxwA1C7JKLiOrwEzT0BfmUVTSuENs5pVKA8jMMYkj7GzEr58h
	 6XCu6s82fDyWF1/IBS5o0BhODhHkoKJLKXof9fcVvKhBM4OM2Z5WWNthe67V66TYQK
	 FKJMzZ3RIG+TvpsEMgECQMiMdO9VrtV7wihqSAcA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.12 0806/1536] HID: zydacron: validate key report length
Date: Sat,  7 Nov 2026 08:47:02 -0500
Message-ID: <20261107135020.184334584@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


