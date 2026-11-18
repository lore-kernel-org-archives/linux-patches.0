Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037886;
	b=gdhSwt46aaLrpUDW2fWjd4uoYyVoEGnGtc8ABN3nyt2G0nZdyXuajAJ1u9rO8Sr9mrR/
	 RnPHSnQRAp9BOJ/68bJzBaV7S6n+3OSQ0ajVcIciqmA31JLGM2tOehe8GR0gNYe+248OG
	 jCTjLIrkBxlqVAWHJCT4qZh9+Q/yLXJpYGD0U+xVcH3O2oTIQGs1m1fFhPTaDVyiqYqdw
	 agy2bzH2sOHEfceAUeBFgay+SQ+wI9IpqICOWEYvjBAKOutGa37HVS+IBlhEAIrgGzD3Q
	 0vxVL+u7Mgiey6uJXmK+GUpO+ew7bWSa8FHr+RnmwuyteV1eA3BhmVFYM9Mkv+MY1jg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037886;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=fqkI9K3a4ugVu1UeH8UQPptBcy2jT5Jjfrhh3zV/j/I=;
	b=ukrrCwf94TC8/szGEdhMUHjW6b6tDhsrYh6cNFTbVg+FVU6t/JhL8qyiQhN00+fM0k8G
	 IDc8JDhJNTmbSLHQ+JRxfU1baQUfAAenzdPkZLjhdyiwmq9Hvz7XVK92wudL0fz9bRlGg
	 PacVt58Sz3zgWFhMpLRXaWhVmhFdy5mnf0HC+NuvPlVSp9V7jQ6P95X7KxREsQ6SkOH7P
	 pZkk/5dr5O2RmayvANzO5fa5wVf+lWWOngXtQuuGILyF+iZr05otPoiuV0vSSNxMaDZDs
	 A79CMbOpZ0zVxOfNqxbP9APPW5ajPbN14nyujeTA8zdqupoiSGA5mPzg9eEm7OMtfwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tHMi8xrC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 829CB606A32F;
	Wed, 18 Nov 2026 21:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tHMi8xrC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A65AA1F000C6;
	Wed, 18 Nov 2026 21:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037886;
	bh=fqkI9K3a4ugVu1UeH8UQPptBcy2jT5Jjfrhh3zV/j/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tHMi8xrCqRgueM9vLhraNtdxfzHkDM3mnGxATN8yacQT052H+gaF6uhxKbhslL+27
	 8/OexxUpjiUtx9CVWSViD9yFpqfQ1ZFLBNZ+quNiANsmgKGChVBB5v8T7knxAQ39iy
	 hvjI+1mEQ/06s+zgZg5+DAFkaY4ygBvDoZccBlEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Changjie <liucj1228@outlook.com>,
	=?UTF-8?q?St=C3=A9phane=20Grosjean?= <s.grosjean@peak-system.fr>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1515/3318] can: peak_usb: pcan_usb_fd_decode_buf(): accept short uCAN end-of-list records
Date: Wed, 18 Nov 2026 15:35:37 +0100
Message-ID: <20261118150406.399308048@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liu Changjie <liucj1228@outlook.com>

[ Upstream commit 2d4c272e816a5b784f1fc7899256f8826df34edb ]

A PCAN-USB FD v2 running firmware 3.2.0 sends a 16-byte status record
followed by a four-byte zero-size end marker.

Since commit 93fcab2c6968 ("can: peak_usb: validate uCAN receive record
lengths") these transfers cause repeated receive-buffer dumps while the
interface is up.

This has been observed on Linux 7.2.11-arch1-1 with matching kernel
headers:
- Classic CAN, 500 kbit/s: 25 decoder errors in 5 s before the fix; none in
  15 s after.
- CAN FD, 500 kbit/s nominal and 2 Mbit/s data: 26 decoder errors in 5 s
  before the fix; none in 60 s after.
- Three additional down/up cycles: no decoder errors.

pcan_usb_fd_decode_buf() requires a complete 12-byte struct pucan_msg
before checking the size field, so it rejects the end marker with -EBADMSG.

Check that the size field is present before testing for an end marker.
Require the full header for nonzero-size records and keep the remaining
record and payload length checks.

This patch was created with LLM assistance.

Fixes: 93fcab2c6968 ("can: peak_usb: validate uCAN receive record lengths")
Signed-off-by: Liu Changjie <liucj1228@outlook.com>
Reviewed-by: Stéphane Grosjean <s.grosjean@peak-system.fr>
Link: https://patch.msgid.link/CH5PR19MB997156AB3BE253C3BE445223B0AC992@CH5PR19MB997156.namprd19.prod.outlook.com
Cc: stable@vger.kernel.org
[mkl: copy additional info to commit message]
[mkl: convert Assisted-by: tag to prose]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
Built and tested the original and patched peak_usb modules on Arch
Linux 7.2.11-arch1-1 with matching kernel headers.

  - Classic CAN, 500 kbit/s: 25 decoder errors in 5 s before the fix;
    none in 15 s after.
  - CAN FD, 500 kbit/s nominal and 2 Mbit/s data: 26 decoder errors
    in 5 s before the fix; none in 60 s after.
  - Three additional down/up cycles: no decoder errors.

USB captures during the patched tests contained 406 packets with
short end markers. Neither receive-buffer dump recurred.

The CAN bus was disconnected; external TX/RX was not tested.
One startup "can_change_state: oops, state did not change" message and
an RX dropped count reaching 2 were observed during the patched tests.
Their causes remain undetermined.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c b/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
index 6ebfbc0753d97..7954937e828b8 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
@@ -754,7 +754,7 @@ static int pcan_usb_fd_decode_buf(struct peak_usb_device *dev, struct urb *urb)
 		u16 rx_msg_type, rx_msg_size;
 		size_t rx_msg_min_size;
 
-		if (msg_end - msg_ptr < sizeof(*rx_msg)) {
+		if (msg_end - msg_ptr < sizeof(rx_msg->size)) {
 			err = -EBADMSG;
 			break;
 		}
@@ -765,6 +765,11 @@ static int pcan_usb_fd_decode_buf(struct peak_usb_device *dev, struct urb *urb)
 			break;
 		}
 
+		if (msg_end - msg_ptr < sizeof(*rx_msg)) {
+			err = -EBADMSG;
+			break;
+		}
+
 		rx_msg_size = le16_to_cpu(rx_msg->size);
 		rx_msg_type = le16_to_cpu(rx_msg->type);
 
-- 
2.53.0



