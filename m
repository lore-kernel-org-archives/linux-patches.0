Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044648;
	b=galBmkQZxO+qkKMWdhGhQHhR5mBUDUS/ZzekqKeKnma0jyPr3DA935nh8amIhHYh8esQ
	 XWDNugk2TQ+RKKOlm8HE1QWRT5+O5B9rLT/XgHP0pyyB+J3DEvm/QK2x5w/OyHtCIFY/5
	 6Ja52PBBmXRVeyVdQ+HCxoGow5iUWza/jF04CnfXei8+aZccfG64QzxEs0HjqWdFl19Q9
	 fjHlHWWiNikeuw0wMIp/Hxtwe1UvjdiMKD8/aoYvjE4TWjaE+VOxibNd6w8cVVIJyA0H2
	 BxyHA5WVoDV0O1lGThzeqhuw924lqovc8UdTAkX4okjTVOGBEgevype6zdP8Z3N1/Tg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044648;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cjPQjRj6sStZtWpf4DK1LqaGc/yCCKUJoBN4wXV/RUY=;
	b=dYkFNEr5Ty6Q7+ZUdilQk+MWG5dkH/u1GZvJ0i/+cA7nBRXAY+EA6JdpM78IURSzaEr5
	 wJ7wuCx8+bIUYaU/0wQAg03IvjkXUWmC+1hW5q1giIFmd1fDnMHIdBrvBdLIaFSR0GhGU
	 zQECO2CWHqNSt8M4TUh/uCD/DPVZTJcEPIGw+NFoGw8pe/gVlwGPzj42kgWOxu/OnXOJX
	 CVqfaevTXdk3IRjiIg9iyuLDBr6C+tKnZnjqj/R5MJBiqkSEHXBI1MXu4MQY7XQrznFi6
	 nXRvEeK031xFk6sevZNCv6Kdg1b57+I89g2+nBqPW0gpAah/YFsVQDw+DZKc8eCEDQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YMUQemZl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3F43606A325;
	Wed, 18 Nov 2026 23:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YMUQemZl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4679D1F000C4;
	Wed, 18 Nov 2026 23:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044647;
	bh=cjPQjRj6sStZtWpf4DK1LqaGc/yCCKUJoBN4wXV/RUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YMUQemZla68JI7HVSkXD1fX+ZKDRnjC5oa2cmNp7yPMydl0fOop3b01SryJCibSUs
	 AhgYSMjM4wqdXDoUZJFp095/wyN1IHTSnbESZlRqOEFfRo1cUGYT0DUyVTKEEnrcZa
	 jFP+3ovXjM0itKx/t6FgN6rZ50WEJbDXR+wvVl5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 6.1 0642/2857] HID: roccat: isku: reject short button reports
Date: Wed, 18 Nov 2026 15:27:56 +0100
Message-ID: <20261118150224.639895525@linuxfoundation.org>
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

commit 93e5f7f6189af76a2b2e2dfe647838a7b9f99d21 upstream.

The raw event callback runs before HID core validates and zero-pads the
report.  It passes the buffer to helpers which inspect data[0] and, for a
button report, read the complete struct isku_report_button.  A truncated
report can therefore cause an out-of-bounds read.

Require enough data for the button report before calling either helper.
Commit 47669bec44fe ("HID: asus: refactor the two workqueues and init
sequence") added the same kind of raw-event length validation to hid-asus.

Fixes: d41c2a7011df ("HID: roccat: Add support for Isku keyboard")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-roccat-isku.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/hid/hid-roccat-isku.c
+++ b/drivers/hid/hid-roccat-isku.c
@@ -408,6 +408,9 @@ static int isku_raw_event(struct hid_dev
 	if (isku == NULL)
 		return 0;
 
+	if (size < sizeof(struct isku_report_button))
+		return 0;
+
 	isku_keep_values_up_to_date(isku, data);
 
 	if (isku->roccat_claimed)


