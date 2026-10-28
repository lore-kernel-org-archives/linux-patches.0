Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216512;
	b=BE9xoVVPDkkA8AM/gL8khaGa1p7nLQR437zerrSl8Qwyt3pD9aCF19UiNuq5Yl37kQ/I
	 ninh/8hZXE1r6H5FfYwGFHYQPa0ro1zMeYl+yEJsrUE2u1A4MYZanKYkKpKq/DaEE622q
	 RNzL7HwZDvm7mVmacTfoXhObiQiOQUX+hqQip72OLDAesfpyCIoI7Z40gACyqyoOuBX7+
	 GVlUoM9AnRPDRwiBcna74xLfunh4+qBJpDJYdSG/it37zJVxxEwKnLvhkX+kf0K+Zc1PD
	 Zuy4O2NJQYJTTrTUVvtLBUQhjdPVP39Vo3ZYzbPbIhYYK4OO4phzLmFhoPPfzL8CwTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216512;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FH5Ijipe0V0b7R4zjUL5SwN1joSXPPJdLK9TIyKwldg=;
	b=ixEQxcuJBppegOeRVIAy73e4bfpCL5T9tflrTaezZaByQzZJ8sBWWcse/YVq6+6NdPgE
	 shWqFPfhpmwkoyJVzAykH0eRx+Kd2wNMmfSSPun9YjAOZ2iso3HT/VAvA58vN0sx+ju1m
	 2v9Mq5B7JPKKU1/8ImI1uRuAXERVwLr3wT1ZAVZ6LNRJdQ+rLVoJgnCynMt3S/aeCUpbC
	 9RGDjhJ//Q0jabXNHiSdziCPife6CB5qcWVCSqR8Z8O5SwDz4udRZCRXH/NM9IBXa3wrv
	 2arbgF/v7PgM/HfgWzUxAZo/yvjeG3MuT5uTvSXu6gR+rBuuuBz/Ko1K4DnqS1FCTig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LahjNJuT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6E17606A31A;
	Wed, 28 Oct 2026 19:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LahjNJuT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 305F91F01828;
	Wed, 28 Oct 2026 19:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216511;
	bh=FH5Ijipe0V0b7R4zjUL5SwN1joSXPPJdLK9TIyKwldg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LahjNJuTR7a7UBSXzpoXqW3/Hkh1HqjFYAWnvCDjiMlO1pxc9BqjidHIhvRM1xO1A
	 L75cQaA7A+M2Rky9gxuumcCc9UeDGiqOXWV8ECymf5d6UwaULuCXtdjBR35BYFKpvA
	 xBYi6uVf6lc3bZO7SFRrB+6Yr4JxL+BVcv8sxPAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+75f3f9bff8c510602d36@syzkaller.appspotmail.com,
	Vicki Pfau <vi@endrift.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1581/1887] HID: steam: Reject short reads
Date: Wed, 28 Oct 2026 18:01:17 +0100
Message-ID: <20261028170535.444680499@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Vicki Pfau <vi@endrift.com>

[ Upstream commit 33ff7b49c38b39b1f3d27db508ac0720fb25c08a ]

Steam Controller FEATURE reports encode the size of the message in the
message itself. Previously we were trusting that the size reported matched
the size we actually read, leading to a potential issue with short reads.
Instead, we should actually verify the length of the read.

Fixes: c164d6abf384 ("HID: add driver for Valve Steam Controller")
Reported-by: syzbot+75f3f9bff8c510602d36@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=75f3f9bff8c510602d36

Signed-off-by: Vicki Pfau <vi@endrift.com>
Link: https://syzkaller.appspot.com/bug?extid=75f3f9bff8c510602d36
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-steam.c | 34 +++++++++++++++++++++++++++++++---
 1 file changed, 31 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/hid-steam.c b/drivers/hid/hid-steam.c
index bbc150167a7f1..a54bf625ae47f 100644
--- a/drivers/hid/hid-steam.c
+++ b/drivers/hid/hid-steam.c
@@ -135,6 +135,13 @@ static int steam_recv_report(struct steam_device *steam,
 	u8 *buf;
 	int ret;
 
+	/*
+	 * All reports start with a two byte header.
+	 * We must read at least two bytes to get a sensible output.
+	 */
+	if (size < 2)
+		return -EINVAL;
+
 	r = steam->hdev->report_enum[HID_FEATURE_REPORT].report_id_hash[0];
 	if (!r) {
 		hid_err(steam->hdev, "No HID_FEATURE_REPORT submitted -  nothing to read\n");
@@ -157,10 +164,31 @@ static int steam_recv_report(struct steam_device *steam,
 	ret = hid_hw_raw_request(steam->hdev, 0x00,
 			buf, hid_report_len(r) + 1,
 			HID_FEATURE_REPORT, HID_REQ_GET_REPORT);
-	if (ret > 0)
-		memcpy(data, buf + 1, min(size, ret - 1));
+	if (ret > 0) {
+		/* Remove the report ID from the return buffer */
+		ret--;
+		size = min(size, ret);
+		memcpy(data, buf + 1, size);
+	}
 	kfree(buf);
-	return ret;
+
+	if (ret < 0)
+		hid_err(steam->hdev, "%s: error %d\n", __func__, ret);
+	else
+		hid_dbg(steam->hdev, "Received report %*ph\n", size, data);
+	if (ret < 0)
+		return ret;
+
+	if (ret < 2) {
+		hid_err(steam->hdev, "%s: reply too short\n", __func__);
+		return -EPROTO;
+	}
+	if (ret < data[1] + 2) {
+		hid_err(steam->hdev, "%s: expected %u bytes, read %i\n",
+				__func__, data[1] + 2, ret);
+		return -EPROTO;
+	}
+	return size;
 }
 
 static int steam_send_report(struct steam_device *steam,
-- 
2.53.0



