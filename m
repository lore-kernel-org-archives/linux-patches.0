Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061796;
	b=hj4sZ4D5/uL1e81o6g4+HZNQtUi1zglvVSBdPavRngQBjruj35RYe6k8tJQNl3NLRJwM
	 8QESek3YqV70XdwQ5uxVa0KBXQGgPt62IcgJjSneHskRqIeGgVXAhVgBrsPJHvJF+hoTO
	 Fux8BHeqrviEmQV4b/3b3VzM2lEG+kziZ1wjQhVkL2y/GB8XIFCz58I2mAumklOd8o2yz
	 cVaojLosi5sWtRoJbfr4gFbzZVpqp4nO1Dq7UT+Edimrc2cMHmW7Bru6O+Inbqn6nUmmh
	 ACdVwBKcVQijVJUAnsWT5bOHfijTvn1U4Ys4u/gxWnbH8YWpeXwtjQHL5Ye1Y0ahX0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061796;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zuh5mVYj/DJfefZyiVyJEqUYipi2WUxxqOZ0Y3HfPFs=;
	b=oR8r9kGURxhKk/+gWhc6VNFn2jpcDzjqyRS16xfXXZ7asJGbmS0Xs4S18LjmbchybVg6
	 Wcj2x6q/b5tB0Uv5Y7qbYahCihQNXMd5OjGlCYVj1ZcK46oRxpiDHpLGchSeQpz8BjvM/
	 ugD1gdja/qSi9xDXEYbtqQDDNmhPkSlH7tkTywZCUgILVVRUWtJl7leWNMAp5cRKWM6Ay
	 aM7PxFUqd9wben7miGZ3xchJpTWlQe9PcI7B8OLml1xQGB8OMHO7J1mJsKwEe928Axx9O
	 XP/EKDFRGt4ArXYGm4NhJCISc/qLqaj/eTOxQ3nKnlpaJ/4DxQQP2NtNWEA4mbgDlPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1V7DYmwC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 540AD606A32C;
	Sat,  7 Nov 2026 14:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1V7DYmwC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 026101F0089F;
	Sat,  7 Nov 2026 14:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061796;
	bh=zuh5mVYj/DJfefZyiVyJEqUYipi2WUxxqOZ0Y3HfPFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1V7DYmwC8lKYU9hs8yGK9cVuLptqyJmWxX1WZf2cpIUMcKmNH6Tbt+UPnfnABdAop
	 /pOqCeWXS5knWlmd1ZCC0qHxMz6GpyKQ3hPLjJKQ/B8Lit3EU818AiCbOvD2JZtcr0
	 f9nzGfI72BpoT7P07vlIHrvBXF4QK6ixTjdAtWOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 6.12 0823/1536] HID: roccat: kovaplus: reject short button reports
Date: Sat,  7 Nov 2026 08:47:19 -0500
Message-ID: <20261107135020.658268899@linuxfoundation.org>
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

commit e95917a606f486e46f5136fc1b72190742a091d6 upstream.

The raw event callback runs before HID core validates and zero-pads the
report.  It passes the buffer to helpers which inspect data[0] and read a
complete struct kovaplus_mouse_report_button for button reports.  A
truncated report can therefore cause an out-of-bounds read.

Require enough data for the button report before calling either helper.
Commit 47669bec44fe ("HID: asus: refactor the two workqueues and init
sequence") added the same kind of raw-event length validation to hid-asus.

Fixes: 0e70f97f257e ("HID: roccat: Add support for Kova[+] mouse")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-roccat-kovaplus.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/hid/hid-roccat-kovaplus.c
+++ b/drivers/hid/hid-roccat-kovaplus.c
@@ -614,6 +614,9 @@ static int kovaplus_raw_event(struct hid
 	if (kovaplus == NULL)
 		return 0;
 
+	if (size < sizeof(struct kovaplus_mouse_report_button))
+		return 0;
+
 	kovaplus_keep_values_up_to_date(kovaplus, data);
 
 	if (kovaplus->roccat_claimed)


