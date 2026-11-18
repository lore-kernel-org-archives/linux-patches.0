Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058072;
	b=nJcd7bQWwGlrFKAvNSFr+balOljm/jYXKICwPkYWMPlBc49Kwv0hyufe+FJvGglNSZ3Y
	 mKhgFfYGOJ9TDctoVKgtVXs4+agD1qcT+++nP09+1gJABy+hKbXsXxzbea6mqt1D6KN44
	 ZI6HFWGJLrDVkNB96RxZCL1Cc/hxzE4KnlfRDyxSbUShIoDXouMCQtaE/WhckDLxipZXd
	 ys2azVqSB3yrX9Tk9ZX3YnMW7D9GZBFkMgtaXr8GF+D/01BT2kaTTrYtpfCOCw8SnGiGy
	 xabvC7s6kCGN8XfgnhHuIuyk0mGqomfUMt2PzS9rxEEQqE4nYDBtx6TzyVEqHFR7pdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058072;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Bw0LspVN1IWkz6shBFLHaMf/jC8HS8F022nPtzFokSA=;
	b=30yV5R5SmquclgEWhyGtdNVXm460ndNsk602eV0pH8GlxdvsKEUrr5NvIdUmOXMxSo/G
	 UzVll36MILJzTntbg0N4tAtEF/wbIDHA5nKI/84b0JliczSm41Aq/cyStfav7Yyj7tcma
	 eYg1b2CzpPEZooiIPjewaZOfxY15gI5mzIGifg+spT1ZbSNDeYryKzOoRs2JateMyi/bj
	 mbeIbv742HvK4EoSPUTwCUsQNORSK1iCHaCJhGn+Y7nSv1Vkly/fi5vp1HkYdKbr/SfPT
	 8rA1HkwRd1qTFGlBpd/k2QpVXocg2skFbx1/MToeBRGi8G8dblq6sasgGiaSKps1L4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=umPhURym;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A2C7606A32C;
	Thu, 19 Nov 2026 03:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=umPhURym
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9457F1F000C4;
	Thu, 19 Nov 2026 03:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058072;
	bh=Bw0LspVN1IWkz6shBFLHaMf/jC8HS8F022nPtzFokSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=umPhURymD1dHKfbYU/55aywguFl2jtrmUEiOXfUemVvxdxeuT6T9u0+7l6baHRlS5
	 rKzVmhLjSxq4wF/SAAiLrW/BQ3GA50p+kUTM4VMB7uqf0CwzBN+52fuL4ztC22lnlR
	 juild0el2LsKn3fQUoEa17G0mMstJBlPASXrzvOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 5.10 0314/1848] HID: roccat: isku: reject short button reports
Date: Wed, 18 Nov 2026 15:39:12 +0100
Message-ID: <20261118145925.373909352@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -408,6 +408,9 @@ static int isku_raw_event(struct hid_dev
 	if (isku == NULL)
 		return 0;
 
+	if (size < sizeof(struct isku_report_button))
+		return 0;
+
 	isku_keep_values_up_to_date(isku, data);
 
 	if (isku->roccat_claimed)


