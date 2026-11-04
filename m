Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829185;
	b=EwbroGepGCcW3/1GiMWrFHoHkr0xnzO5dxV6TSCEKB0oJ1/diSLRHNOB4D4ZDaiPmS5m
	 l8hydrTXarn92FKCtTyexDuoxjBqaaNZY1eDdVmIzvce6XP/31AvG1bGwR0YS4zOHOsym
	 6xDImH94mGsHSMmJOeLYwvKQvv+QG22TV5ltsz9eY/0bN5wSRsxMjXDhWUn8Xo6o51Aep
	 zWg3F5PVyk//moEpcUGaB5bRfitlIRrv51TR7unOtsdj6zObKRRzxN2tOAPDstM+lSY1z
	 OgOsBH03McHCLDMdXVTCZSqyeChOonjy4GudqYhIqf3/Kge0qq1DUYz/0fkugPcnJ0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829185;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IJIIp9v82xlqSTZlT0nkGV4/eWiJYPS6QClxdrkFg8s=;
	b=nVFdYW7lwFvIFiNHvpH9IT9+viSNifBEKCtEfCW+Ajr0gXX1YYHZCWur9DqXTrKexjm4
	 LuSed7VhlcOTACOzJ2rbZ7AHuWQQ4mIsHPgHEbH1MMqQ9d4f6pFGpVVXXtIwzFHmVGQQ6
	 Zi+cJcZDDGwREYK/ib/M56o8YfBAw9OxDUGo5CkQMnb+AKJPzJ8xP2CUj1pquV33bQaCd
	 yF2jF8ElLm33GmthkFknv+0cCZLFgd6x/iuBpHexTeR2lzzMkn53xqDH2qNITYCKTJE5y
	 9oCcKSG396eiRvctR5/WLywiYpZHNp93DOEuJFc/8kAaNaIKClmKUTsI5kxVdDO4RTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xyk2sQzu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79DF0606D817;
	Wed,  4 Nov 2026 21:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xyk2sQzu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ACF71F000C1;
	Wed,  4 Nov 2026 21:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829185;
	bh=IJIIp9v82xlqSTZlT0nkGV4/eWiJYPS6QClxdrkFg8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xyk2sQzuBBjM7DQWrubj+1VnpBrNfzCX/KZb1vHmssPxF0PZBi7PCr9AFG6BIyWJh
	 +4NVp5sGuFIBfFP0gGhf2iVfCWxY89IaaFdiLJrHp2gHu09X8tZHK2XIkJA1Msn/it
	 BnBXkw/EC+jBbxhXsi/9TSxSKfQUymxCSVOCFzw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 7.3 500/547] HID: roccat: isku: reject short button reports
Date: Wed,  4 Nov 2026 16:11:24 -0500
Message-ID: <20261104211052.589540336@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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


