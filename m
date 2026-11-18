Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044662;
	b=PcStSFk5fQho44WHJeLCrmvjdkhLQ7jAMOKl4TvV0vRvGMXJbPXSGcyGbaG5IuzedAwW
	 9L/A4TkUP04ozCE2ft38c1pAfxh9eC/zzhlZ3EucEa5IUi1r4JmPZ5cMBMyvSrmL5syCj
	 8JYDW4DFTQQsFuPfENwlG+OMa+Ohki6QAJHgwDsDHMQxtzPXvGJLoRAxOuYORC6Iss456
	 I6dflws6Gn2LFeYbkkh7xJwlLAGskRGqsPVxmqpdOs7luBLgP+S/RdP5+m4iZRBNxDIc4
	 g7uqg4Xbein74tNWHAQpKi+NyZ+D7oeQ32nVAOs+PDkqlDNssRSq78l158EtUM6YNgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044662;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BMQ/+1MHi0UJsQv7svfl293lU8OAv8JKTpZc4vNtxHA=;
	b=RtbwVeyncknQxdfP1XKS4GF1jYACk+yn9CjS4YdcMdgI/LQ6K3NNib4Z+ZSdtqNjN9lp
	 tdBY4oSK+ZzPRy3oDhzGi2LjOi3FMWUN3IrfJET1jCDGEBMrL77JV+w/lnXIfmzj4eT6+
	 B5j5PO8KOdbNEVAsMOuwIlv8c2aILSEbSZrFr9SvKtQ29q9quRkuF+FqrfykMDN+3eHuO
	 6OJjHDtryQQeQ/LbuDLdjiLjDAh8qCg38BmESnzNsxxw6HTF5SZvCCV2nqu6D2ksiocNc
	 3w0Z1QcWLs0WbIA+gVOOzszlyNCCbmq8bQoJUIIn3oj0xCG5ZNeM6MlsWgVubD7IXDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=goZJEeHq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11418606A32C;
	Wed, 18 Nov 2026 23:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=goZJEeHq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F2E21F000C4;
	Wed, 18 Nov 2026 23:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044661;
	bh=BMQ/+1MHi0UJsQv7svfl293lU8OAv8JKTpZc4vNtxHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=goZJEeHqRRfQVBUW63GlTZ/UTe2DJ2MILp/EXYwbqpg65xjR58ZqFxV+sR9mhbbVB
	 ER7/T3FMQVOMGHE7hg6JBUZXr6wWA6GePmrzwDbS5QRoYqR3LlkExn9uCUXrhq8Q93
	 85gUtemvPkyfeSBdL8WOTXvEiMLCsG3O8ted/YSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 6.1 0647/2857] HID: roccat: ryos: reject short special reports
Date: Wed, 18 Nov 2026 15:28:01 +0100
Message-ID: <20261118150224.842793951@linuxfoundation.org>
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
 


