Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831860;
	b=Tv3YLVQg61QZZst7jMeQ2Cqn7xPFpJ2Hs0/oa8YZe04dvh71z3UzBHAArj39I3ek0gaA
	 q+QqgOG1SnKDrcvShicEEWf3P75CjgKzJ7A5sYD9KN51eTlPy0mpGrurqY75usJk/1bNK
	 JgHWuS9gVKXTYHXXnljljo/dXxkancTJvu3FhZxnFpIFo3FWdmscVBipV1AlG/60sT3/j
	 28XCWwgiX9gdy6YSTiPPdRHWDMsWitzNQ0YtFvbxR2bARHppuuV6pPXKchLOWqnUX9oBb
	 AKx8ngf51Kvs5JTwgl/aelWQsEsX7+MYosimQWHt0gtCbit4vtisC71Bw+DA0WuCodQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831860;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VU4syppw6T9pnkFe10WByG4V1kvedR9y1lvQ8uWmfOo=;
	b=hkfmidTHl2FsL8HXBkQWGBqeTS1Zkvayhq6VM48a5KPc4RP06X7Wz0xEf1S5lcJcWhO6
	 N40V+otzkoPOM3Cpvcosm2AyGiOmuMEZoWkP53JVbPclLL0svsKzlwdYtx/C78VhBPxPX
	 ooEQuLIbLiQ56rrCA8+HQ5XgLBA4eB6EAGB6Mr+vo3MR+0bmc47plM+CQZWNZLCltUjNi
	 kNkok3TuGfJ8wJtSGu3IV7UIx1Fu/rhtl72SY/xlx7TAb3ghr7rO9rtOGqpgTQFUSRLzI
	 QMnxeEzRUWDmsXwmR9VRbJim+Evw97ZX3Jv3sj6789edNbdIy/kRySOZlW/vRzFbtTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EpPR3H+j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BD9C606A328;
	Wed,  4 Nov 2026 22:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EpPR3H+j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBDA31F000C1;
	Wed,  4 Nov 2026 22:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831860;
	bh=VU4syppw6T9pnkFe10WByG4V1kvedR9y1lvQ8uWmfOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EpPR3H+jpQ/Cx75hTipEogr+P2suz7u56qDRfIEJyHU5eKk6lUqyuTrJJtSaTSrEL
	 AKvDExCOXrCu0fZGZ7hWKtU3+KP/NDMexvVBNskhu9UWaJ9yo2hpBxidPEyx03lTv1
	 Z8VBS/gIMgREcu0s1JyjxVIUvGkgD/KvDUX4PzU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 6.18 0959/1005] HID: roccat: isku: reject short button reports
Date: Wed,  4 Nov 2026 16:11:32 -0500
Message-ID: <20261104211109.946493944@linuxfoundation.org>
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


