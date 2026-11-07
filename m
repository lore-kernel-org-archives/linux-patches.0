Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061789;
	b=xWdF98J1CpknF7PFFeQ0cbnpUd9FzIO059SQVfd6oqkwwl8xiQ3tj8R/z+U5VIpyRTF1
	 AfPUFThu5Sd/MYpkIsLzflfgPJpL8psr+m7rb/IfrmBH+AGHuRt4KxV7zo1gAdIOqC97V
	 /T9zgXMKeDiX7QGo71eAq1HSLUeMwNStwouvlffN2gBiVOg0yx65P8Mw8k65M1A8bi09O
	 wRFUgxFWRnDdeGEr8VPhrzyq6+2g172eSr+NuzPLkwt6QfFvy0hj1Ye/8ddgWEJW39/sY
	 aQBydoSkgvtqNSQHaq/EQKYhk0xtmV1No5mbluHcTq9PlhWdpFycO93rc5G7/A20TTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061789;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vpiL0H4GPmUaYGdZsASs1fLhExFosfLIYmPuRZ5B/fE=;
	b=F/Kve8CAY8ezur76+lBI+lniSvgft54Uk5rectGW2hbFz2AtlUDqUJjHbCNvB1Wb1WGA
	 1h4yDawJFOdG9CTr/HmCokmXPn0xabNNequ9eNjDsm+GrL5ypNixPqO7+L7S6Ic5XL+O3
	 UlONKjcALYXNm1kzzCaqURnAbqH/WyYgoueAGKyoArIw9nCbxUn9VNDcqzSeI41kv1Y2D
	 GIqk2XOSlfZGNqBWvW3dkTZaHYwywCb9xj9jqCtQZNRpmd5Ui78dSVKV3e8snVYDcrzUp
	 PDIp6+9GEDJ9X5TU9GYJhmTYHKAYGnxA395zE0INbxmG1gWL65fHPEKol2pt4fhzMdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OfJnICAs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FFAA606A32F;
	Sat,  7 Nov 2026 14:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OfJnICAs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B38941F0089F;
	Sat,  7 Nov 2026 14:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061788;
	bh=vpiL0H4GPmUaYGdZsASs1fLhExFosfLIYmPuRZ5B/fE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OfJnICAs/KLeOjWuWjzAS90ukmiMLzfwfVD7eDl/VBwPeIytTQj+oQJ86rN8uzkOh
	 6n3gOquBNFhw9Zf456Q8NgFeaCt4ZMPPhQCX7IH6vlWXqPp4qzv1cRD+fhDcAXS1kI
	 0TV2z7HRJk+9PBn2gmgcIZwXglcmstzq6Yb/t4qA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.12 0818/1536] HID: pxrc: reject short input reports
Date: Sat,  7 Nov 2026 08:47:14 -0500
Message-ID: <20261107135020.518656340@linuxfoundation.org>
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


