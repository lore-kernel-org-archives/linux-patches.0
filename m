Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035530;
	b=TZBCIYqDo60gJb9V2yN0LVVPbOhPMaU3vn3snqad5bKUVbZplqt/7S222u4QbOu57XWh
	 N5fK+WS1d4++1a9qv447Dz7lqFyBgK0D1wW5+cvzvXlxtxQscw38vQQJiLLF8JsEvdwmY
	 PofDuJZlPhcZP4Tc/JJzXCoZemqHICEMSPMRnij19RNYdcCTl3jUkp3GTjaNf18ugfGcN
	 S0sFUW9M9T7KpyEkg487GpuPvRjzV9T45uXG5s8U1yG4ajAz38XlOneHnOK4aKwuuiH6h
	 wFHYqfSS4/D6WZ9ye4BXlidE1H0mgeZGnRv4KY5F8qFFrhf0pAe+5aw8OiTHIPD/ptg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035530;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aH43a+4b7UyXz6jmPAb/pdaotPozbhzL/zRKOrXi4LY=;
	b=AOv9Kcq3A4ymhLi9D7ZiqbSrHcXavZBXQN3XMJdjs7+22zixOL8ewmIsizuUKdhZcEZf
	 yoOxaIxxeZ1yrC2JMhnhH184cRr1n4VJEyCnmTYpaaMUlZ3y2rKT1Wm3FjGoBGB9XdC9s
	 KWpHXADoacWG/iReWbhFBVZpcxUQXo377tB67ENddlC+/ZEByOl4BV5TvauLGuht4ntPr
	 /2GRs1zaf97nrgoViLkhE+eT+mJgz5LqhUrd1RO8oIGdbEoXuCqOKxxPILYZJRB5r7t31
	 Uvi7pnVnW/1WrDabRouFyz5jGjkS5pbcEaBfVazD9cpSEUjdpaADwYrrR4u7IyS1MGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="f+8teA3/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20A80606A31C;
	Wed, 18 Nov 2026 20:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f+8teA3/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F69E1F000C4;
	Wed, 18 Nov 2026 20:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035530;
	bh=aH43a+4b7UyXz6jmPAb/pdaotPozbhzL/zRKOrXi4LY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f+8teA3/94sZzQJHEKte42QHQyrB54f08DcMBsRBGCQSEiKTEjOlwUcCHJXa8w2XL
	 g81MdvspxjSGlLQJQEWaSBCx2I7/zwQJ5KeuUsboTEF+1IuGyjKDSkvzsXARGarDec
	 XsB43k/yjGYXS2dySgcQhvFHbSuDuHnrqimshE90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 6.6 0735/3318] HID: roccat: isku: reject short button reports
Date: Wed, 18 Nov 2026 15:22:37 +0100
Message-ID: <20261118150340.611025285@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -411,6 +411,9 @@ static int isku_raw_event(struct hid_dev
 	if (isku == NULL)
 		return 0;
 
+	if (size < sizeof(struct isku_report_button))
+		return 0;
+
 	isku_keep_values_up_to_date(isku, data);
 
 	if (isku->roccat_claimed)


