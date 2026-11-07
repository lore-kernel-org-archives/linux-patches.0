Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061778;
	b=URfaLlbayao1JPpymksQQDlbWo5iKt15xur+ayAikzdD9vu8IKdSeIBbj9DeghvlUEwM
	 WzFFh99VZVhIbgb/rUvbVuiVWe24SvkzTX5DqZNMdAgTf2DIWYjBAbGDZpl1ZZd6yqYio
	 gPHRpAvm3WdfYZjQ/Z/NkW3C0ouRClapesRr/IpKaMb92mrx2Q6PbDTL2JT0gPzKbBifr
	 pQSV35qsHftIKVTVPTaxqdM8hJf7etJC5DyMCwijI159pPLl41UR+El5luxWJbquZz1A3
	 v1G0guKW/6/hKrPsRe2SS44dAkCE8zrFFpfRiqFP5BPcs+5Rgsda4eOaaWA6cW7d0mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061778;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5LRFrLrYqMi4suPDDSKVYlhtfxLNAhoZ/NbL3//FfVY=;
	b=HB8nUXqcA7HsOMRVsepp/urixx9M8SIE3Wl8wdJgcxM2qTagKjNI6cyJJ9qOz5l+KRwX
	 YV/RBmAXjAiBv+x5y363ahyjFRh2r/3F+BV7xzRSPpCgxnNV3pOliMZaAEyGlVrwNgi7b
	 VG62I/HlZar4IP3mjub4ZFwKhjEBA661Ml+5CXhThPp3z8fGR1QnyD8dfvKJ9MmK94E/t
	 8H5+dQAi3uBn7IWDUE1pH2CT5IfwJ58PrqQZSkMwesc37OndeY52HOuE0NEjSSb2OE9wV
	 1MU6i9TeII3HsbXDBWnclhampagSt4DbTUQOpvKCFqlrxv7ZcxmruO9mHR9Jc5ynp5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wlwmbcpp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDC90606A32C;
	Sat,  7 Nov 2026 14:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wlwmbcpp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B8661F0089F;
	Sat,  7 Nov 2026 14:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061777;
	bh=5LRFrLrYqMi4suPDDSKVYlhtfxLNAhoZ/NbL3//FfVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wlwmbcppoNrdE81GBeW4Rf1rc6NfMtdHKYxXoKOvldPxPHCgaqZl160yLy6niNoT+
	 ddJ1J3P5bjXL1d3/PJax2f4ZpS2Ib05vbmVgnWv/NlLfzA3n7wWah91LFDXJp9QJdQ
	 S44RXxWf91Tk1JevsvD/0F20m8nKp4jaJBEqjlZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.12 0810/1536] HID: cougar: reject short special-key reports
Date: Sat,  7 Nov 2026 08:47:06 -0500
Message-ID: <20261107135020.295709716@linuxfoundation.org>
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

commit c6c0df8a4b73a0d563c5e64de640ef5ff525fc82 upstream.

The HID core invokes raw_event callbacks before validating the report
length.  cougar_raw_event() reads the key code and action from offsets one
and two without checking that those bytes are present.  A short report on
the special interface can therefore cause an out-of-bounds read.

Consume reports that do not contain the action field before accessing the
fixed offsets, consistent with the callback's handling of other reports on
the special interface.

Commit 47669bec44fe ("HID: asus: refactor the two workqueues and init
sequence") added the same kind of raw_event length validation to hid-asus.

Fixes: b8e759b8f6da ("HID: cougar: Add support for the Cougar 500k Gaming Keyboard")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-cougar.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/hid/hid-cougar.c
+++ b/drivers/hid/hid-cougar.c
@@ -270,6 +270,9 @@ static int cougar_raw_event(struct hid_d
 	if (!shared->enabled || !shared->input)
 		return -EPERM;
 
+	if (size <= COUGAR_FIELD_ACTION)
+		return -EPERM;
+
 	code = data[COUGAR_FIELD_CODE];
 	action = data[COUGAR_FIELD_ACTION];
 	for (i = 0; cougar_mapping[i][0]; i++) {


