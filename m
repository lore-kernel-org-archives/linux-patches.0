Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829167;
	b=o0KVr9Wc4wIfACFPyW2r77lsLJZNCtu08+xboyXWh4r1aRclLCVHZTHmmsc5eFesTtaj
	 BfknJbkImDPMeI5PBabLpC8Yf4hCmdcHOXk1lIKpwIG5x60GsgUFo75j93JqmdXVcISNP
	 ZO3fA0dJjwWWrNb4U4qYNFzu5cSQi/IThBAf/ie7kiFadkMQ/nAlQXgsd0dwE9MO4cvnY
	 64Rxtz4w8PoC9yMfN4YKcb86ExAa7ZOHoGDZqci00YlUaa2WFlRRgzUso03cpYgh+xZo3
	 3XdAFBYfwbInytMcYZpzD1MlYH9wuPkVAL6BI454DMP7X1+goZc5nnqqBdfuI4MKR1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829167;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xF7oTEDdzHffhPbsRRC56Ab81BU9p5piMi8dJnRJwCU=;
	b=qxPtEpaWKpYBkKSf8439Q9wCzon89DC1NuYBdl6LFdK+H9Hv5fEmBe3ZUN+bRuVm84PG
	 cBvGKwFGqsntePjP5sHdspsVJZjkupqlFyZGYFRnDb+KNroB4giFH3v0lXWBkV/H7cyB5
	 an2Perp3Ze81rqup2tbQR655lUlS5Jrg4G5FsnIqAs/3EZwv3Mr0dVJVkqFUzZsySRbjx
	 H2uEDZ3061NlAEfiaCWiLMm1ov4Wmt4/9yzEaizZULP5wf2KuPgTSvd5VbAb/5xE0/hfG
	 1qY6hn9MbgTKyG050e2EgAraNEyOZrOhXsSZjwm+6T4Z39C2ep1Y+3nNccUAIQIIuYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Y/5/ZLfn";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F0B16070989;
	Wed,  4 Nov 2026 21:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y/5/ZLfn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 318841F00A1D;
	Wed,  4 Nov 2026 21:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829167;
	bh=xF7oTEDdzHffhPbsRRC56Ab81BU9p5piMi8dJnRJwCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y/5/ZLfnH2wxSqAzimZhkhaXzJa3WqCbNgXAiKyHiFzMQ7zi00Io0WcoOOk5NfMn0
	 M25GD96LHyJMKIJEbb2COP8jl8rPV7fN+0s9k8t/0833JCmDY0VbHNTGkCxsnKn6vk
	 Q0dNSvmEaQfWImvs5cBz1VUALc9R53ALwYFwCHe0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 7.3 489/547] HID: cougar: reject short special-key reports
Date: Wed,  4 Nov 2026 16:11:13 -0500
Message-ID: <20261104211052.268484253@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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


