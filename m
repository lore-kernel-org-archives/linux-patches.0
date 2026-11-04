Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829170;
	b=kC9xUFMueI+QEZhlbv9hWvZVyr+CJ/5jFeSRZMQOTCovMkjgfTAbtQRC72TKSmPrfYkj
	 MoHu1pafyqqAv5s8bj0cA6eZUaub/8vTf3FfetHXySw/LgeAnVecoZD9O9UKBA7obRsWL
	 clxBEqAMo3VVsOQyolhvhGckvTSoYtfLylDfD/9e4YrQyaB0w7P/k/wrFgSSAXq/oBNe6
	 BAipwJnC5uUHlNFIpaaz0etnOuUDSYW0F1Kulg0cHW7pm2PHAhesbTqYpIBu7huv8KUuo
	 EjdwupWzPZIkTJYD+Fe/bfd0u2kObVJ0a8q1BNIBoKt5VDk6g6bH5QQ2keh+6RKctAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829170;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Oq4kzinJF476Uzd6jW7kdGXJOlJnZnCv6CJGOB/uC70=;
	b=3aKEDLG+nk797W2bT8fuSJn6GcpzuTeMgFq0K3xiudoitf854OKe+JJowS6TqaJB3Of1
	 PuMpQzXCgVeRIT9M2sZlDXd5zVR5NecXGPo7xyx4WWLXXmeqJ+UIRjHTmvy0gv5WPcgh0
	 OKgDN7+xljqAd0EyDfOy0cBqWzlNe/W85kd2244WI7YaqYwD/X5/8wCU0n8moj5w26VlY
	 s1Kw4Ik6wOJn0tCBW4Acmho+7cm/yv49fU3vv4rlStJgdJhpOO+IUeXA+7CQ5Aek478JO
	 HrA2LfJmMI7l//VV1ax2ekPtt7c5AywB0v57nvGcH2z/OJR2hR8Y0Fp0uNi2Mu3hdJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B1K35SdE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89DA660709A3;
	Wed,  4 Nov 2026 21:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B1K35SdE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20DE71F0093A;
	Wed,  4 Nov 2026 21:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829170;
	bh=Oq4kzinJF476Uzd6jW7kdGXJOlJnZnCv6CJGOB/uC70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B1K35SdE429NRJJz4tQn9YsUULp33Gj0Y7RUfvoq9coG7wwKcfjo1PGicpy8GYCtu
	 aOapqDjmi4OX33XmqNb1Oz2rz9izDm87mmRgnba58ki+NmmEjrPu58jSfwzf25d+gi
	 iZ7GhjyyZw8XiAZ0DnHQ8XoC9cbfQ1vK8SIOqqfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 7.3 491/547] HID: elo: reject short touchscreen reports
Date: Wed,  4 Nov 2026 16:11:15 -0500
Message-ID: <20261104211052.324451917@linuxfoundation.org>
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


