Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058078;
	b=uGNF82+aKCxhDJ+dFsOB2l1wc4L1EVNEdP/BOW5zVMGspedU21KapTQkutUvSvNCcTX7
	 ToNSNrBTDGrbtjK1eGaVqO23RmuS5O5iAl7hGpjEuH8DcfvIS8mcDK20YEaeh5f3E2VLB
	 P0HBwbiChJjHjIHELfBSON7lB/NMmWH65YjbV9KHDzOF6FlQ1tpGLthnUR5lUAwn4U4xG
	 t9xHaifMfoaXICSk4IcUwOEx9QJBEFCXv+MVt2ugtMLTg8pjfMve/1QDBb1TOkoRncN2G
	 8o67k5B+OyV/D0s6Lh8kwk9vvojK/iSmoG1+Lk1MQ8oRRC26xe+ea0SdhCZR6vrrD8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058078;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WAgKQl0Hm3adsfo6aCDN009322ZDtEJj8gm9Wzv1mr4=;
	b=A3Nz2hVN0I2CniGtpCaoYNaXtxXAg0FmXOQOzIsbtB8UXUqcLyL24EA6weuLgq8iMIgX
	 0SLiAs6DRw2G1k5vkikZHCbZ1ZdOkzQ9uoyL6HXE92eb93yyWYe2CWxEp35ubRRbnBtBh
	 kwSeVskoaMD4WmjvTV0abpfMTivv/cA9tV/CVoVkTLeiAxNhvB31SZKyKTuCO1j2rgbuF
	 Ke2oQfaap7ValU9G6jaku6/aqUGpj7rTosRln9/X9oe0h+Yla8jsomJz+f1som1GDcgHQ
	 kn6KcafvZfEuvK0o5TXTX8tqCqDMtm6YF9bQYlLWoc5qMt6vpcZkMIC80YEoK1izvSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ok5T3vt5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20F53606A331;
	Thu, 19 Nov 2026 03:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ok5T3vt5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 234F61F000C5;
	Thu, 19 Nov 2026 03:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058077;
	bh=WAgKQl0Hm3adsfo6aCDN009322ZDtEJj8gm9Wzv1mr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ok5T3vt5ZUC9TFZL26H34CBH1E3k3bKZSOHys2AAZ0GAzyvhqiopRKGyaKnJIZjlz
	 ADWDULzCYFOcVbtVL4RGy04cLhEenf3W4z3Zw/KuApgeehBwZRv4MWBa3G9qny3NED
	 rg6+FEUFaiYEvnhkjIU9X3hb+OETBH/5VStWF78Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 5.10 0306/1848] HID: zydacron: validate key report length
Date: Wed, 18 Nov 2026 15:39:04 +0100
Message-ID: <20261118145924.978843707@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


