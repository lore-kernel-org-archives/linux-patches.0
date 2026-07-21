Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42EB346D543;
	Tue, 21 Jul 2026 15:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649012; cv=none; b=iaT+L+VpziRzuuWE/HDOC6wE1istFe/ISibGVGioT+rqS/r1ZZPfoVot27kpg11JVvqVTCoTgolHgHjL17UOEca/c5AiZcKaRT1M4C1cBEhE3rv5FnGgtKTrWtfdilmsUhuQItiJR4qgrfunCz3yCuXoblIIBQm9Oj9VqA9EGc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649012; c=relaxed/simple;
	bh=9VkuVUlpUraMbkm4mPrspmFaiDRbB9G4QnwnHgFrU7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UWHmpY5SuLVarb7zYUSzWfEg/grHBCd2FDOSJ9m1xPVhQmBpKH6OnxbpT0UYSuM2Wnw3XrXt7GIoeEzjY9ngDcHTTc6TEou3sDWIrfreNmuIMBX/2sgGBZp4ulDnkBK7f+Tn6x9YXb5Ubb6hMc/0ltsawc7QDEjMIkWgFlvjZw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G3bKGcei; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G3bKGcei"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A35841F000E9;
	Tue, 21 Jul 2026 15:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649010;
	bh=OQi87BJMsOPN16Hd0hEw8tQZcw7xtmYbSrXC8tyeNJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G3bKGceiNmBsJzOYKMdqEOmTWH0WybNw0sI8pEXNbbL6WERAFtIylRcdmrGvUBSDB
	 Mf8FSuZG7joRrDptmtcRTgz+C5L03h1V9Q6+VIQGDtPUHehzv5hU8oSrkLpldZR3Kq
	 c3tJYLz81Nmmxo9TTG1vHycot9Vsg5uBp4lyo1eA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Rheinsberg <david@readahead.eu>,
	"=?UTF-8?q?J . =20Neusch=C3=A4fer?=" <j.ne@posteo.net>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0417/2077] HID: wiimote: Fix table layout and whitespace errors
Date: Tue, 21 Jul 2026 17:01:30 +0200
Message-ID: <20260721152602.570571830@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: J. Neuschäfer <j.ne@posteo.net>

[ Upstream commit 12b7731995ca577d86e02196e99ba9c126f47282 ]

Some tab characters snuck into the data layout table for turntable
extensions, which resulted in the table only looking right at a tabstop
of 4, which is uncommon in the kernel. Change them to the equivalent
amount of spaces, which should look correct in any editor.

While at it, also fix the other whitespace errors (trailing spaces at
end of line) introduced in the same commit.

Fixes: 05086f3db530b3 ("HID: wiimote: Add support for the DJ Hero turntable")
Reviewed-by: David Rheinsberg <david@readahead.eu>
Signed-off-by: J. Neuschäfer <j.ne@posteo.net>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-wiimote-modules.c | 58 +++++++++++++++----------------
 1 file changed, 29 insertions(+), 29 deletions(-)

diff --git a/drivers/hid/hid-wiimote-modules.c b/drivers/hid/hid-wiimote-modules.c
index dbccdfa6391672..dccb78bb3afd61 100644
--- a/drivers/hid/hid-wiimote-modules.c
+++ b/drivers/hid/hid-wiimote-modules.c
@@ -2403,7 +2403,7 @@ static const struct wiimod_ops wiimod_guitar = {
 	.in_ext = wiimod_guitar_in_ext,
 };
 
-/* 
+/*
  * Turntable
  * DJ Hero came with a Turntable Controller that was plugged in
  * as an extension.
@@ -2439,15 +2439,15 @@ static const __u16 wiimod_turntable_map[] = {
 static void wiimod_turntable_in_ext(struct wiimote_data *wdata, const __u8 *ext)
 {
 	__u8 be, cs, sx, sy, ed, rtt, rbg, rbr, rbb, ltt, lbg, lbr, lbb, bp, bm;
-	/* 
+	/*
 	 * Byte |  7   |  6  |  5  |  4  |  3  |  2   |  1   |  0     |
 	 *------+------+-----+-----+-----+-----+------+------+--------+
-	 *   0  | RTT<4:3>   | 		      	  SX <5:0> 			      |
-	 *   1  | RTT<2:1>   |				  SY <5:0>			      |
+	 *   0  | RTT<4:3>   |                SX <5:0>                |
+	 *   1  | RTT<2:1>   |                SY <5:0>                |
 	 *------+------+-----+-----+-----+-----+------+------+--------+
 	 *   2  |RTT<0>|  ED<4:3>  |          CS<3:0>        | RTT<5> |
 	 *------+------+-----+-----+-----+-----+------+------+--------+
-	 *   3  |     ED<2:0> 	   | 			 LTT<4:0>			  |
+	 *   3  |     ED<2:0>      |             LTT<4:0>             |
 	 *------+------+-----+-----+-----+-----+------+------+--------+
 	 *   4  |  0   |  0  | LBR |  B- |  0  |  B+  |  RBR | LTT<5> |
 	 *------+------+-----+-----+-----+-----+------+------+--------+
@@ -2458,20 +2458,20 @@ static void wiimod_turntable_in_ext(struct wiimote_data *wdata, const __u8 *ext)
 	 * With Motion+ enabled, it will look like this:
 	 * Byte |  8   |  7  |  6  |  5  |  4  |  3   |  2   |  1     |
 	 *------+------+-----+-----+-----+-----+------+------+--------+
-	 *   1  | RTT<4:3>   | 		      	  SX <5:1> 		 |	  0   |
-	 *   2  | RTT<2:1>   |				  SY <5:1>		 |	  0   |
+	 *   1  | RTT<4:3>   |                SX <5:1>       |    0   |
+	 *   2  | RTT<2:1>   |                SY <5:1>       |    0   |
 	 *------+------+-----+-----+-----+-----+------+------+--------+
 	 *   3  |RTT<0>|  ED<4:3>  |          CS<3:0>        | RTT<5> |
 	 *------+------+-----+-----+-----+-----+------+------+--------+
-	 *   4  |     ED<2:0> 	   | 			 LTT<4:0>			  |
+	 *   4  |     ED<2:0>      |             LTT<4:0>             |
 	 *------+------+-----+-----+-----+-----+------+------+--------+
 	 *   5  |  0   |  0  | LBR |  B- |  0  |  B+  | RBR  |  XXXX  |
 	 *------+------+-----+-----+-----+-----+------+------+--------+
 	 *   6  | LBB  |  0  | RBG |  BE | LBG | RBB  | XXXX |  XXXX  |
 	 *------+------+-----+-----+-----+-----+------+------+--------+
 	 */
-	
-	be = !(ext[5] & 0x10); 
+
+	be = !(ext[5] & 0x10);
 	cs = ((ext[2] & 0x1e));
 	sx = ext[0] & 0x3f;
 	sy = ext[1] & 0x3f;
@@ -2499,32 +2499,32 @@ static void wiimod_turntable_in_ext(struct wiimote_data *wdata, const __u8 *ext)
 	input_report_abs(wdata->extension.input, ABS_HAT1X, ltt);
 	input_report_abs(wdata->extension.input, ABS_HAT2X, cs);
 	input_report_abs(wdata->extension.input, ABS_HAT3X, ed);
-	input_report_key(wdata->extension.input, 
-					wiimod_turntable_map[WIIMOD_TURNTABLE_KEY_G_RIGHT], 
+	input_report_key(wdata->extension.input,
+					wiimod_turntable_map[WIIMOD_TURNTABLE_KEY_G_RIGHT],
 					rbg);
 	input_report_key(wdata->extension.input,
 					wiimod_turntable_map[WIIMOD_TURNTABLE_KEY_R_RIGHT],
 					rbr);
-	input_report_key(wdata->extension.input, 
-					wiimod_turntable_map[WIIMOD_TURNTABLE_KEY_B_RIGHT], 
+	input_report_key(wdata->extension.input,
+					wiimod_turntable_map[WIIMOD_TURNTABLE_KEY_B_RIGHT],
 					rbb);
-	input_report_key(wdata->extension.input, 
-					wiimod_turntable_map[WIIMOD_TURNTABLE_KEY_G_LEFT], 
+	input_report_key(wdata->extension.input,
+					wiimod_turntable_map[WIIMOD_TURNTABLE_KEY_G_LEFT],
 					lbg);
-	input_report_key(wdata->extension.input, 
-					wiimod_turntable_map[WIIMOD_TURNTABLE_KEY_R_LEFT], 
+	input_report_key(wdata->extension.input,
+					wiimod_turntable_map[WIIMOD_TURNTABLE_KEY_R_LEFT],
 					lbr);
-	input_report_key(wdata->extension.input, 
-					wiimod_turntable_map[WIIMOD_TURNTABLE_KEY_B_LEFT], 
+	input_report_key(wdata->extension.input,
+					wiimod_turntable_map[WIIMOD_TURNTABLE_KEY_B_LEFT],
 					lbb);
-	input_report_key(wdata->extension.input, 
-					wiimod_turntable_map[WIIMOD_TURNTABLE_KEY_EUPHORIA], 
+	input_report_key(wdata->extension.input,
+					wiimod_turntable_map[WIIMOD_TURNTABLE_KEY_EUPHORIA],
 					be);
-	input_report_key(wdata->extension.input, 
-					wiimod_turntable_map[WIIMOD_TURNTABLE_KEY_PLUS], 
+	input_report_key(wdata->extension.input,
+					wiimod_turntable_map[WIIMOD_TURNTABLE_KEY_PLUS],
 					bp);
-	input_report_key(wdata->extension.input, 
-					wiimod_turntable_map[WIIMOD_TURNTABLE_KEY_MINUS], 
+	input_report_key(wdata->extension.input,
+					wiimod_turntable_map[WIIMOD_TURNTABLE_KEY_MINUS],
 					bm);
 
 	input_sync(wdata->extension.input);
@@ -2557,7 +2557,7 @@ static void wiimod_turntable_close(struct input_dev *dev)
 static int wiimod_turntable_probe(const struct wiimod_ops *ops,
 			       struct wiimote_data *wdata)
 {
- 	int ret, i;
+	int ret, i;
 
 	wdata->extension.input = input_allocate_device();
 	if (!wdata->extension.input)
@@ -2594,9 +2594,9 @@ static int wiimod_turntable_probe(const struct wiimod_ops *ops,
 	input_set_abs_params(wdata->extension.input,
 			     ABS_HAT1X, -8, 8, 0, 0);
 	input_set_abs_params(wdata->extension.input,
-			     ABS_HAT2X, 0, 31, 1, 1);	
+			     ABS_HAT2X, 0, 31, 1, 1);
 	input_set_abs_params(wdata->extension.input,
-			     ABS_HAT3X, 0, 7, 0, 0);	 
+			     ABS_HAT3X, 0, 7, 0, 0);
 	ret = input_register_device(wdata->extension.input);
 	if (ret)
 		goto err_free;
-- 
2.53.0



