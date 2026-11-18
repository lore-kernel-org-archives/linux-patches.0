Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058050;
	b=mDzXXlrEz+eVSo7ip7xLRcJ1BUotsVcvi/uqVb2maKZWRvfagyppTMwkwg4lf6ysuxng
	 pkna/Lz0KklYMQLtZTf444EOlqqCaN/J7CeVawEo3ypPUiYOW619XVPS5X4/VCGTPZOiW
	 +nOhbkloYp8+XBPp/KOOKrVXxyXzH5ZdXJgPUT7U7dOIbPzTBaHuMboWGI+jrBVLVx45v
	 53cHpTSmMYRmUodctt+yYsKdt4F7lzjFEKfkD5tXKIIA5Bj2aGk3dJxQbZxaD7mphRpIi
	 +ByHUApCxG1EkxFNX81MhF8ARooiZ9QmCqMH3BbZscXi+9Bqw8BSdicPC8c7tbCMimw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058050;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PbSvlFJRD5r8Ppj660LYWU3PakgCcg8Eljb+vh/h3nw=;
	b=moZ8kVThlWAgzhOUTB3s93eAiTuyRQEEXSdbP8yqU5QPa9Q2c5YsBmMYSz4w9duD38pb
	 EuGVJx7/2sv7yj9/PYf3bRmaqhLQrFM8kisVQpEMHmZULrSWCgzcY1HccZfOynsJIwR4c
	 8EZrsmGNkgAL5Dfye6BMptjM5rhN7wwMhDiLUBTsppdj7lDfVf8YEZ9vjQ5ppUHDnigiN
	 jYK5/hQvPBvhLLylJdV1LS73LAwCJILVh2VGO4AC5wxC41RoxnzPPWLL3iX8nOhEGMGHw
	 XaUSoRn6YxWKqQ3S27vnWutcH67q8l0TSQ5DUDM0QoUlhZAkL1lrXuHYL+Ikh8g+vCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="jkd//hRT";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21352606A320;
	Thu, 19 Nov 2026 03:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jkd//hRT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7342E1F000C4;
	Thu, 19 Nov 2026 03:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058050;
	bh=PbSvlFJRD5r8Ppj660LYWU3PakgCcg8Eljb+vh/h3nw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jkd//hRTa9CTSwc85YlxBz5YM0kCeDgLN8URhOUww1c9XUfrTS2yL0IuiwTtgqWzN
	 7SidFDrIMYpfsDD2FmOrn9Lp09sweT4M64oIwGkaJFgqo/7zyRZ9VIDyT+eMSx2Rw0
	 XTMQVL1cMahs/n/kNcvdZXSQH19CwsSJkWTt7jVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 5.10 0310/1848] HID: elo: reject short touchscreen reports
Date: Wed, 18 Nov 2026 15:39:08 +0100
Message-ID: <20261118145925.226255180@linuxfoundation.org>
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

commit 1cb92fcb2ac344d78737e3c5cb7b061dfb2850b1 upstream.

The HID core invokes raw_event callbacks before validating the report
length.  elo_raw_event() only checks the first-byte packet marker before
elo_process_data() reads coordinates, flags, and pressure through offset
seven.  A truncated packet beginning with the expected marker can therefore
cause an out-of-bounds read.

Require the complete eight-byte SmartSet packet before parsing it.

Commit 47669bec44fe ("HID: asus: refactor the two workqueues and init
sequence") added the same kind of raw_event length validation to hid-asus.

Fixes: d23efc19478a ("HID: add driver for ELO 4000/4500")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-elo.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/hid/hid-elo.c
+++ b/drivers/hid/hid-elo.c
@@ -85,6 +85,9 @@ static int elo_raw_event(struct hid_devi
 	if (!(hdev->claimed & HID_CLAIMED_INPUT) || list_empty(&hdev->inputs))
 		return 0;
 
+	if (size < ELO_SMARTSET_PACKET_SIZE)
+		return 0;
+
 	hidinput = list_first_entry(&hdev->inputs, struct hid_input, list);
 
 	switch (report->id) {


