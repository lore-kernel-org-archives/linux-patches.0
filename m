Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035507;
	b=5dKtbe1p218AMSp0tBCpCSgcM8Kx2KU5SgFn2Ll1RUDsST5UpbOa/TDagV7by9hBWSVZ
	 7r8EulMZKNz389TBBGOp2P/UoLviZCWt+L6J7EdtuM2Pc2FS1vQe6vPWWcNTjtwdXOPts
	 ucq+C0CNxHdR02+nq9N/P5fm0goXgcgnXdnLjDbJwxO1197yrxAUR7UkkoYDob4h2OfME
	 iXP/ghXU7+jeMjsR7rNEBTIqDRxyPyMMEwioLPt2RG0HXsbZ4Dv8TAI2qCAuKNZvF8Mn6
	 gR4xYRPCW+7PmUg7FFwynuowoCcFF95Fm9Jdg3ZPRcUxUzNFHTNLjQQBgsYp3rNk+Mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035507;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uXrmWwwB8gv+9ZriwGHLKWtHI2MwqkWK0lYGoc2Rt/E=;
	b=MtgNpsBm9mziaITP00T6HBWmov2gHf2S1E4a9ziZMOhwIC/n3Vc9aaA6lydOFBHLuiqD
	 1RLF70u/o0b+e+TRdlWFxZri/qNJyUjtPBxrtQDXGfIP2PEjod1Aw0mUBwQj+6rK6Np9b
	 JTWJz+txubZSDs++OI4CcXW1bwZWHAGn5bRE8JbzMC0PAyU+NPiyRUw16UYMTpBNTGBnv
	 j7qPpQ2fXiuMWuutfS8nachVY/3qsH5sei8gD0yjBtAkl4yCYGbm1LD2cJ9vOFW4IJebR
	 K72dp7l5Lg24rujtT/3dM5FOnlxYYpcGdpwPikW6X1jHJmENx7h7jEAcFZ7WIcZN3vA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gBhiIMnY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6EF5606A31C;
	Wed, 18 Nov 2026 20:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gBhiIMnY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18AD61F000C4;
	Wed, 18 Nov 2026 20:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035507;
	bh=uXrmWwwB8gv+9ZriwGHLKWtHI2MwqkWK0lYGoc2Rt/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gBhiIMnYAOFV1IOQwxJ+JfV1jA66LfbJMEsDq4vDdpXMPKJJ3+QgDRYyohmkuKd/y
	 3BpvlqG8OMC6DjqS9mELNecVF9pt5/GH225C5ESG2x7J4HUKZ4zOcHclRBN7L/rnYn
	 5yYMqq/CEnn/WcALxw10p+P/WEirtbo54KH1jM+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.6 0728/3318] HID: elo: reject short touchscreen reports
Date: Wed, 18 Nov 2026 15:22:30 +0100
Message-ID: <20261118150340.364881245@linuxfoundation.org>
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


