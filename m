Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831846;
	b=4qKEUthAxFQ2USbiL5rCIPqhAN6zYxY9jT47r4qIaAXFsE293S60hVJoL8a1d1O1dNNP
	 2scEu/pjZk1wNwWEds2vbaLWvn5n7aW+fSGxnD5aFOa29ndvf0nZ1tW6aQtzFYbHVgLiC
	 rS/EcutiZgc3oS8QEn1cgrjclNlttz8dg95B+8Ub9RKhssUy8z5ui4IWwaWw78jdEq889
	 FWisNAb5OVN9VdZqWgS3rFqyYT5BuRPcpKR7lDNntJMFfzPdcc+UJxjjfbfYwIoLMAM9B
	 So4QhBG9OrfU/rqWYBXffUWe9O9T09FB9V1n+PWY+3snK3/TetPhbAhD/IOk1h+YCcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831846;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hPXiwiLejnJGYVuplLhGHY33saAr9MpqspSq0jxqg2E=;
	b=K0Crme+vaGQ/SdfqK4G2VpcLpNkJr0KQArcj4JICx30wB1E61qyh+ETW1N734I9Bjx8x
	 jh7Du8b9tW/0LGSCH0cycDUYX2asw6VWtRYoUsJ32x/OTtOpA8sHMT0oJvVpldNovJE2u
	 KkOJRGFA3OeFfXaugFoOCw2I41yHtFanYPTp69Hz5ooDvwuUkS/a7iaL7PeBpa10BZQ5m
	 6AsDNYhyXCRpMdb/w7pZuWuvRrsrULe7Uq5986C0WO3fXThjSoEWhcY8hbfirssUmJafw
	 LQE/HGeTxxiESN3dQmsynZyb2XOPCYubrb09ukb9ewn6/LtecECgMZ9zCuNG5YaZ0Ow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cBwwjgM7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D170606A329;
	Wed,  4 Nov 2026 22:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cBwwjgM7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0EE61F000C1;
	Wed,  4 Nov 2026 22:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831846;
	bh=hPXiwiLejnJGYVuplLhGHY33saAr9MpqspSq0jxqg2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cBwwjgM720TqZN22uVyyjhWFRkFnkdtHd7U9099DHioUJQ2pISuiRWvrNFqspOBPm
	 bdi7gZ9xsBRTzlDKzcROe/dJdrPycj8cQO/KWOph2IHw4wY+Wb5w91qe0aHt6IrhXr
	 ponPsSEfBa7Jx2dZrA6OwrqSBbHPQbhYW31QppBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.18 0951/1005] HID: elo: reject short touchscreen reports
Date: Wed,  4 Nov 2026 16:11:24 -0500
Message-ID: <20261104211109.742651432@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


