Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044628;
	b=o5BGFOPgwkODyKpTH0YSJdyK7ahKoelRP9cyuVIvs6ze04a5ePze1fRP9i528slX4fpu
	 xK7G+OmCq5ZNsHYTPS2NHpJ1RkWRxF4ZRI/qCNjSNPs8kwkp1A/ig6teeL369fND7Prtp
	 FJC93BAB8oTUQ7je73dFQLYxt+FL3vJmZ8IhLYkkYKlW37L1LcvI0rPtzz7r3eVhxrcyX
	 yxEliQx7knEAbUZAZlG74xIPX6VIxT9FmvX9k9p7FZr5DUH4z1L/964liLHnxzMd3RYDJ
	 cie2f9ebJzcReyRKqWUTHAqfKJME6PnA4F40LW6WTa7H1g5C8Qc2imNgyKgpATCMexg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044628;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=X6K4yPi5E7sCxGz7xfqKW/18xkr4hcdaRwjepqaROVM=;
	b=pZPQMRETHaNF2+U5p3kTrGf/+Yq74DevnaF3pIDcFMWb7sFQvrVUULEtbK85VmEJ/wP/
	 mZot7Fkatrv7tDbiXo+nggw39KylLIl+EKoahry/XqsWUMVFJPluT9CGh5qCwNMsIOhWO
	 mOU78r3VPG4td1ShkairLWNNzuIOzp30/0S1MgFpRGmMyqHPfHaUArP9bWvIMp34t9vID
	 0kzFKFOG8aeTJK67LhT8i/3ugmJrUtAcpywamxVJmxI57+JNVRORE2JFf4QsCEPYh4Vht
	 oSbAeVdzYFE1/Joll8lCw6Fn23cQ2dPuu82j7zQYfmlJPXsWQQ1oZ68DiWIhK6JPkmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tyOx+db1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 459A9606A337;
	Wed, 18 Nov 2026 23:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tyOx+db1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BD001F000CA;
	Wed, 18 Nov 2026 23:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044628;
	bh=X6K4yPi5E7sCxGz7xfqKW/18xkr4hcdaRwjepqaROVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tyOx+db1+2qRQ2+g4ebgsqiQ3Lktqw5gY4KwCaTgOClM28TjwhLg9YUFD5H1QWiVt
	 8eVMp4cTefBO0DPQb/GbqGLgpHe/8LOFfvYRiifRaOjQRp+sHyg47Ox/GPoiae2F78
	 3u72y3bIIuo54Tx0k0iZVbzetrJ97tkR6sbUP5Ic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.1 0636/2857] HID: elo: reject short touchscreen reports
Date: Wed, 18 Nov 2026 15:27:50 +0100
Message-ID: <20261118150224.410216725@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


