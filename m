Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035502;
	b=XV57zkk26D7hki16LM5HaXkw5QqgkASPqPUMRfpZonIAn0Ta3JImzNwfrMmZ7QBh8PKs
	 CMqYypSIE6fqBrWv+rITQbvjypcpPDOrW0+RETE7gjR3r1Q5vEOpBUooASj/eu97nhUc7
	 ROOW3vwOVpLWDNhQOtRSuQkZfpBWfciiJB1Okdfdug/0inYhJdp5DIFSPwZbWc/UKybg4
	 Z7TianuYR69SwA3iz70t6xTGyJzdgoxRtRe6gV+dj/ZmK+ZWWfCMxYjNVmbPCdiU9sMlg
	 sZUxAXjiBRbn1PIQmL/6s2YI7cH8Y5E9uUaNO+jIniC2IrwiW/2gFNkVJWPyDL2cBCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035502;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0Uo8Ix2zjFhEvp3DFXm24SnCZUWufcEsSKOicCpuwyg=;
	b=hq6kw/fwA0R9/w0qxporpYxYX26pqyxw8FQzzkn+HFOKqgRipHMZf62bMwIvhmcmKFdE
	 DZC4QyGMP/ECrN+nmYrgC2oTTxudDbR67O95dN7RfMC6+v2MfpCe48e8oij1rK8+5iJ5S
	 lAKHLUAyHTcEZL3vZeZMKhWSkcUAIeYfrlShkeciGWuC6o/ObIzKulDoC8bJZMVsBH2eA
	 G3cIqhzmcB7fNGzHA86UaWgkk2wVX6sTgHe1r425rySV17wD3HyKAV5VHaet9bwI6nVG1
	 SEu6hqsD28MyuITVO/zvaYhwh+wYkqMr5nX/6xD950QHy+4xQBrr5UnDnhgp8ZOURXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dW5iVWRo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10F4F606A31C;
	Wed, 18 Nov 2026 20:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dW5iVWRo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 609C01F000C4;
	Wed, 18 Nov 2026 20:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035501;
	bh=0Uo8Ix2zjFhEvp3DFXm24SnCZUWufcEsSKOicCpuwyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dW5iVWRoI8AmkavHB3kIP/uI8sBh+dLrzNJ4ufcRHAgRaet4Ns4T22ZTwD1//okW2
	 8nTHVxYoT7Z2Xp5axIhRPOqInoA4b2NWtsG43qmQpxRrVmpRzc5wqgyLgeltPYNmA9
	 1A8zGVwvrl3xz1PqPNb+CCYJWuehuB5U0Vs8WYv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.6 0726/3318] HID: cougar: reject short special-key reports
Date: Wed, 18 Nov 2026 15:22:28 +0100
Message-ID: <20261118150340.293155517@linuxfoundation.org>
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


