Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057967;
	b=pO1zfOmFluFoGqv+ywYL2LqrBoQSWMsknSlwDNHhivhbriPh4CpsaoYT40xEb/8xsmnW
	 b72nlkLWpXeo7GjOaWaT/yLvxE83l9JbQLrOjPdoc0hTGG7Zo72nqykczj1MDneUsLtZ9
	 qoylXCJd0TEhx4DlHZeiyhV+6ZXk1JhiEatLCbujcioBEQLV48Bi0WRlsC0+lORpIr1vf
	 JQwtg5987ysSMkrSJZJr5cL9eZV9VXAu+IjpWdzvlSFvuPqIplHV7DYrvjotTOcu+ZwO5
	 A6MvXJmvcPkd6RWSFOKYpanijxbcATx02otWpoVLf9dssaCZzPVB81e8pzpIHCfG3oA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057967;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=t5eN8agXJLrGfRU1PPlUPwRvuP9pIY7hFLdd3P4+aVM=;
	b=XMKoCQ7VI4JWxK/1cJ2JG408/7DS+BeVDAdzWKmVBKXuToW8YSwC59gsjmSNyGB2cI5r
	 6bFRfyXeAzX8GB00putJee1spYJuxjch+Qf7ikcDhAA22Bd09wEiDLB7rWFM5lWp8SaXh
	 crI5ujlMVxNGLapXKyHbtqeKF6AIdaX8/nEA7xUUxFyzp4drJO4TJiuyzihqCCnUeAxxv
	 22Rv8kLgQr6qWwcv80OYqe1femZAmgZ/+R804j5jlSPJw8d691JwttpWjOL4ryGmsKbBY
	 Je2MflPjv3tR13EkD5Hr7eWJ0SawvwVitz2Qudoqoohw8J2Kow6XItcpiMv7USXb6AA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rFcP2p8R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60C1F606A320;
	Thu, 19 Nov 2026 03:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rFcP2p8R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 647841F000C4;
	Thu, 19 Nov 2026 03:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057966;
	bh=t5eN8agXJLrGfRU1PPlUPwRvuP9pIY7hFLdd3P4+aVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rFcP2p8RTDAGrA045VU//BLvf0zerK2ZroW14vy9l1pYDE9o83kuqcDzc5IEI59j6
	 7JqSPMG16BBUYHRobWGofeYDhv2+iZsy9MFHkFKKJJ+DEOyDZpAlshu12N1GcJ4YjI
	 tqvMuZXaMNB20v2psNJEgSopo4Ea4XZCAovNrpUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 5.10 0319/1848] HID: roccat: ryos: reject short special reports
Date: Wed, 18 Nov 2026 15:39:17 +0100
Message-ID: <20261118145925.546497877@linuxfoundation.org>
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

commit 02f3607d0beb82e76481568bf631235e6a319b47 upstream.

The raw event callback runs before HID core validates and zero-pads the
report.  It reads the report number without checking the received length
and passes matching data to roccat_report_event(), which copies a complete
struct ryos_report_special.  A truncated report can therefore cause an
out-of-bounds read and expose adjacent data through the Roccat character
device.

Require a complete special report before inspecting or forwarding it.
Commit 47669bec44fe ("HID: asus: refactor the two workqueues and init
sequence") added the same kind of raw-event length validation to hid-asus.

Fixes: 6f3a19360545 ("HID: roccat: add support for Ryos MK keyboards")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-roccat-ryos.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/hid/hid-roccat-ryos.c
+++ b/drivers/hid/hid-roccat-ryos.c
@@ -186,6 +186,9 @@ static int ryos_raw_event(struct hid_dev
 			!= RYOS_USB_INTERFACE_PROTOCOL)
 		return 0;
 
+	if (size < sizeof(struct ryos_report_special))
+		return 0;
+
 	if (data[0] != RYOS_REPORT_NUMBER_SPECIAL)
 		return 0;
 


