Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051900;
	b=RPsGmJrGAdb/pcQtffv356h53JecET36vkpgwKOdIjCEjt1MBWdUQiZTHi6fzvJmFGYL
	 0hBaLfOEd5n26k7Xuc0YsEBR1LLEpO0oepnHqGY8+buexq++yjxZxU991iiQ+NZH+/0lt
	 E2vB0rk6YhYCFqHE0LniXP3Keh3liGCHfDof4rrfMcRpAHS9UmaE9YzH6j6kJ/0dUhxZ9
	 S8Ohbs3lFlaThWeiZrh+pkXL2GLds+VGeu1RSm/gqbJQm5VAR3YKv3ka0XZ2HTgUvOgbh
	 vp4Dqj+fEip4E9pzGtXQsGoNzrXWRndUta5bPYFPtdrH0P3rjqKahNzGHo93iNdbS8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051900;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GInW0zELXAvXCCN00yefUD66sWRaRMKajSWIdHHt+lw=;
	b=VkRdmWrzayPXDPTAjT3cOyB66adK151cdn2ApAq78QO6tryHVR7uoJKxZ6evdc/OkYnw
	 0JN/qSRG51qloA+XMvgPcB8nPJ+/M/NC29Lun2dhekXhT+SYo1y3Od2vWN/mK0ViSa8mK
	 rzEdc3E4snixf7jd10LuqFM11CVJY+q7sEPv1B+U9JIEK1P/sJJXAzdwFjllrmX4/XIRD
	 +qqJk+AGjNADMpUAj3cU+XFkGAY+6uBay+rB3W+dHm78dmiG7HD/1ktUyU7M/kmSqIhvY
	 yEh2f0V8J5PjjL/Q0uKkZulrI7qUXoQ9SUImq2AYBX9wqxMVBwUuLXUnFwKAyqFob7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="nBb/3YhA";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6074260A6F53;
	Thu, 19 Nov 2026 01:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nBb/3YhA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B34211F000C7;
	Thu, 19 Nov 2026 01:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051900;
	bh=GInW0zELXAvXCCN00yefUD66sWRaRMKajSWIdHHt+lw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nBb/3YhAkFq7c+Jy+GOTy777Nq8bLjXzpRbw9az+0efUTra5VovNjz5YmLp1NNWe0
	 UNdYc1XN6S3ju/tZY4WyE0VsyfBRdLUieKkE1EM5eRhiC8qysWt7yYtTOrolH+Th6H
	 uLRIn01ivzagfaHIz7itp1KVqmIJg233n8vJ+/MQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 5.15 0374/2214] HID: cp2112: validate response report lengths
Date: Wed, 18 Nov 2026 15:34:10 +0100
Message-ID: <20261118150025.678132227@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiale Yao <yaojiale02@163.com>

commit fc54e71a063c0dcc4bceba6d0f71805a9b84082d upstream.

The HID core invokes raw_event callbacks before validating the report
length.  cp2112_raw_event() reads every field of a transfer status response
without checking size.  For a data response, it reads the length at offset
two and copies that many bytes from offset three, again without ensuring
that the input report contains them.

Require a complete transfer status structure.  For data responses, first
require the header and then ensure the clamped payload length fits in the
received report before copying it.

Commit 47669bec44fe ("HID: asus: refactor the two workqueues and init
sequence") added the same kind of raw_event length validation to hid-asus.

Fixes: e932d8178667 ("HID: add hid-cp2112 driver")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-cp2112.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/hid/hid-cp2112.c
+++ b/drivers/hid/hid-cp2112.c
@@ -1424,6 +1424,9 @@ static int cp2112_raw_event(struct hid_d
 
 	switch (data[0]) {
 	case CP2112_TRANSFER_STATUS_RESPONSE:
+		if (size < sizeof(*xfer))
+			return 0;
+
 		hid_dbg(hdev, "xfer status: %02x %02x %04x %04x\n",
 			xfer->status0, xfer->status1,
 			be16_to_cpu(xfer->retries), be16_to_cpu(xfer->length));
@@ -1457,11 +1460,16 @@ static int cp2112_raw_event(struct hid_d
 		atomic_set(&dev->xfer_avail, 1);
 		break;
 	case CP2112_DATA_READ_RESPONSE:
+		if (size < 3)
+			return 0;
+
 		hid_dbg(hdev, "read response: %02x %02x\n", data[1], data[2]);
 
 		dev->read_length = data[2];
 		if (dev->read_length > sizeof(dev->read_data))
 			dev->read_length = sizeof(dev->read_data);
+		if (dev->read_length > size - 3)
+			return 0;
 
 		memcpy(dev->read_data, &data[3], dev->read_length);
 		atomic_set(&dev->read_avail, 1);
@@ -1488,4 +1496,3 @@ module_hid_driver(cp2112_driver);
 MODULE_DESCRIPTION("Silicon Labs HID USB to SMBus master bridge");
 MODULE_AUTHOR("David Barksdale <dbarksdale@uplogix.com>");
 MODULE_LICENSE("GPL");
-


