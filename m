Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E1EA4E50D7;
	Fri,  9 Oct 2026 14:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556552; cv=none; b=TGJrcSLBiuTsBMCA6hFPJdxcUweEiN2I8gGPpT4k2lya2rF5W+WpI0TAcERMYaKxU3iu5aqlfM1LpDywBbV1zN+TRq0A5K2mAYx6K4bkqBSaV2nCvmvYSP1Dse3Mb6HgANGiEw8/imhZIITqZRTX4bwZTuswAd/cjoMwpSoz0Fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556552; c=relaxed/simple;
	bh=t9f/rzJv1pxlUH4mgYVnH1o1ibIXOf66jX5Ug7GM0+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H5jkI5zHP9WlxmNRlvR1YGMz/HHVQS7TOGFB3KlO1xf+sjyhV0o/bk3dRAt+qxPmU1dOJpleghb9D9Gxi6KKhTKF+XahroyB7ncDLXoWOpDfB5XiFIRsBeXBKxjLE52rRLNTjHnnO6S13SveJsMEQQeHXuSGUkpzL2SeGn25heE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g2wq1fxf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g2wq1fxf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF55A1F000FF;
	Fri,  9 Oct 2026 14:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556550;
	bh=y+rRI1wYHB+0vnDN3wmeSLIiR1cpnld8Mx6zoYlp3rw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g2wq1fxfjQLynQSpdI8ty9sfRnoYnGa6SHA3csR5P7n5I/bK7j6ezHVnPcjnnMO5b
	 4jYO0ohgZo/KvCd65D++Q0qdLHh71d1P7LpZoWu/2w4sdllpjMnUqIaDUEEegpE6v9
	 9Qh9rV9ItpzH4QT4CLSsdzgCYSIHIXG9Ojmr4Ll4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Rosencutter <rosencutter@gmail.com>,
	Lovekesh Solanki <lovekeshsolanki00@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 7.2 199/428] Input: synaptics - add LEN205b entry to smbus_pnp_ids for ThinkPad T490
Date: Fri,  9 Oct 2026 16:08:56 +0200
Message-ID: <20261009140950.507642971@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lovekesh Solanki <lovekeshsolanki00@gmail.com>

commit a961417c5ae77bbb728a23d9577ecd8f4d8a4b5a upstream.

Lenovo ThinkPad T490 has a Synaptics Touchpad that supports SMBus/RMI4
mode, but is not listed in smbus_pnp_ids table.

Add LEN205b to smbus_pnp_ids[] passlist.

Reported-by: John Rosencutter <rosencutter@gmail.com>
Closes: https://lore.kernel.org/all/CAOGuaRh025eKcBf9P8UrvtXNp68vQ0HVF2EbNMp-kpdaC1HNpA@mail.gmail.com/
Signed-off-by: Lovekesh Solanki <lovekeshsolanki00@gmail.com>
Link: https://patch.msgid.link/20260920200730.1836756-1-lovekeshsolanki00@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/mouse/synaptics.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -191,6 +191,7 @@ static const char * const smbus_pnp_ids[
 	"LEN2054", /* E480 */
 	"LEN2055", /* E580 */
 	"LEN2058", /* E490 */
+	"LEN205b", /* T490 */
 	"LEN2068", /* T14 Gen 1 */
 	"SYN1221", /* TUXEDO InfinityBook Pro 14 v5 */
 	"SYN3003", /* HP EliteBook 850 G1 */


