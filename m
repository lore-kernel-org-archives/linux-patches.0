Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051903;
	b=2FEAtxrYZrDOib3Vr38Q4zuz6NJFNVodDm0Df5fFgJ1PIsqjPNEEZqQ2+OLLAN3kpXry
	 laoscBvpINHzm+0EY9aVRD22reegRrmL/jXvtsZynSkj2hwsgyRmTKeIUbKsIQjPOccYy
	 eNVUsTexf/JC0iio2xVdU7GjGVUwplbeKIOZqVnnpvX48G1k7SvqpJ+QyNrhr+shPvzpy
	 TTvzBbLAdK9paxLAkApbhAqSmDr3AlUMkaygAX6Zpxn32eMxsUnmvJ+AirAqh+J4ssfif
	 Q+PNGsYOKMSNKw/fU16I2RJyte6aZkZHOErPaCxQ+dmCzUMLvc4hVfrufYVSHUmWR+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051903;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lIpKU3FcKu+DAfQMt1N/HFocAt/L5QHvpYDqach/goQ=;
	b=4yW85GxhJYl8nAwmk+d6K+87kcCq9qYA+ocCQTvQC7zCJ3QbRIGZdmCU0IzW/5hpF65l
	 9cVeXQZ7uq10fhfHyzmzZCTHe3Mie/TmMCWoARZQYzPY7UAJO1IhW5SlxhtQZWojOTOym
	 LxWymHpJl/ZsdyuWaUL3EVWcZsVnW+liHYMaT7qK6r+XkFeUch8RpafPMaEr71yr5hwbR
	 IwVh+cOI12ayfZb5sqnqIER8eeZ/5A/OSKv/pUy8LI00ur5ffVeI1FkIhIGvOMTPT9gRX
	 g1amLwOy96CG0jWZRuJPkOG0mzxd5fbAeVhMuGUXx18cIqAnYS6utXaesVBInWFrBAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VvO5s8wh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF9F1606D68A;
	Thu, 19 Nov 2026 01:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VvO5s8wh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF36D1F000C9;
	Thu, 19 Nov 2026 01:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051903;
	bh=lIpKU3FcKu+DAfQMt1N/HFocAt/L5QHvpYDqach/goQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VvO5s8wh9IogkbkXm47JJ/kSmUcKuzbmrrrAPAtcjXA2ImeS8DfVr/mmk+58wICat
	 M/JUdzl0jbOuvlh4c140G6mRqnxksGIF8KChrFPxdLWd+Ilq26MucxuQvdsNug85z6
	 1z1AcjsJMBnK7k0i4IcCVUt9MrLVVxOPuvmVxkJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 5.15 0375/2214] HID: elo: reject short touchscreen reports
Date: Wed, 18 Nov 2026 15:34:11 +0100
Message-ID: <20261118150025.716952345@linuxfoundation.org>
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


