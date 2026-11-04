Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829194;
	b=NoQVHymCK/pu152XUuxUr+dsDFJQhseGe6pi2K35I43hTd9Auk6/ZJDWTfTdP5HYLJW9
	 oxd/1ldDBin1eYZC2Yr/F/xZ37HN6QFbKHqEb8fsHK+x7B0k/pSrbeakjg9UP/Ktgtpo1
	 NHXMQjZjj4oMttzve75H95uJyaptqAKWhIPzJ3DZZVYpj9IJN+7CrJhQIvy/s/tZ206qc
	 GR/Y50MBoWd3lXiVz0zuV9pSh4zYv90dwtQu1QVGKdcDHe71lkLwHUJRB9GLXu0nla1M8
	 b+vu1c8HnsRuFlKmpU29PuBuo4Bs3ijsQFOGH3eMgzCBWSsVcqvtgvuKZXnfQxaTinw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829194;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tJujTUVKeUfE7e3zS42yQ+yYc/afwav15r+otsylnFY=;
	b=3MNyxTfEfL2g1XVil4Lvx8H5d97ikeenOtpZdj4W0IHe8E8MN+BxAetNLk+gBDmZlw5i
	 XQvNofi89qxwiWAz43pxvyFGXYc2T2VcQTniZp5OOIdFo4Zw4p2yvR3waf1cUAzXg3LVv
	 XNfBgwHfyCgvv3mr0MoTUYSlf3F5Rl81vFwS03dw/432IvI3jIIgOuCwhIX8XhZtGkoLm
	 ZG+90slZMON5iH4tiW41FyzWTdBTvlBdCL6mS76VIuJUbGLCfRVBGoQd3mLuEghKNeWQ5
	 tgmse1DuuD395RU1oA2H/Wtz6ohceFdktEgx80kzvzMrZ0baW+E1jmoN9godwx74Cgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VnUeUEbl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96895608F12E;
	Wed,  4 Nov 2026 21:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VnUeUEbl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B4BE1F0093A;
	Wed,  4 Nov 2026 21:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829194;
	bh=tJujTUVKeUfE7e3zS42yQ+yYc/afwav15r+otsylnFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VnUeUEblRvt80Wt7P+Q2rWxjsR6RLTZaofg/PXRPQf0M7YySbfIk+Xtz55UZ2rLdJ
	 NcA+C5KE24UT7cCbgQsRFJB7X0mRc/C7MteKJazFBNkGYyrT/RfMXM3XXCxo78Pe1e
	 yha1A0c4xtjUw87Ih5M6q9Pp9qHyqF1YyPsfOs2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 7.3 505/547] HID: roccat: ryos: reject short special reports
Date: Wed,  4 Nov 2026 16:11:29 -0500
Message-ID: <20261104211052.736881556@linuxfoundation.org>
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

commit 02f3607d0beb82e76481568bf631235e6a319b47 upstream.

The raw event callback runs before HID core validates and zero-pads the
report.  It reads the report number without checking the received length
and passes matching data to roccat_report_event(), which copies a complete
struct ryos_report_special.  A truncated report can therefore cause an
out-of-bounds read and expose adjacent data through the Roccat character
device.

Require a complete special report before inspecting or forwarding it.
Commit 47669bec44fe ("HID: asus: refactor the two workqueues and init
sequence") added the same kind of raw-event length validation to hid-asus.

Fixes: 6f3a19360545 ("HID: roccat: add support for Ryos MK keyboards")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-roccat-ryos.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/hid/hid-roccat-ryos.c
+++ b/drivers/hid/hid-roccat-ryos.c
@@ -189,6 +189,9 @@ static int ryos_raw_event(struct hid_dev
 			!= RYOS_USB_INTERFACE_PROTOCOL)
 		return 0;
 
+	if (size < sizeof(struct ryos_report_special))
+		return 0;
+
 	if (data[0] != RYOS_REPORT_NUMBER_SPECIAL)
 		return 0;
 


