Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051933;
	b=ZSkVIbu3mCal80Kbc1KWp483JUKBEHV29CzUj09Y57Rth9cMovjG4FQ/MYJsbJMlP73n
	 /LNGlVA2Mm3NXLWHyJrowdsUqsoRnqD0aNtZWtYJXdne8aygYLXEPrEmqraXWGoZ4IPeB
	 ay9EAvZbhzLXUjVEcoHoN8yz3oyLKYQ4xGL75NG8XEGswTcZoeARqRXHujzw7iW4GLucx
	 pRGoHIIxtATz9PnV6UTy1cu5fF3T31BBGiPzNd6DffUldRa8TTvx5HeBOTQcgzbao1taf
	 51XQRH1hGVg30mbxfJRcBbUZz9LG5lK/wXyBqqJ6LN5jpDinO/r2N99W/qm9/kPsvEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051933;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zGNfJ0lSt/LSrbAJWs6yu/NuF01siyQG6RcXTrQRRQw=;
	b=R3wbjulBKy+7tguWt+zNygiUn2z7AM7JOMhTq5QJlw6SxUNKnZLi4KlvQC/9cG7Kcwkc
	 U8GxDkvFkKflOfv/wRvOI9k+sZleaqsP3OBXKvaZZzyL4S/iEBURb3O/igxOHBEA5AHwN
	 fJYSDhQ9k2gOg+XHXUerdrXsTAqLoQe7WWvPdc7iHVL4nvN5yrvfHmVsRh5l+/LRwoEdk
	 DL00iX3X0wUhcqiQ/QOsdBWDMy0obi/AxBCHaSQ5duQCfjX7vxyKV3lxhoY7KByHwfiLF
	 Tb1HLf/+uB55dOccuYDBP5M6LAG5ORcFgHazyKJXfLYtF9IHGVHIGfG2oOGANAu5wlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PrpF9c8p;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8392606A338;
	Thu, 19 Nov 2026 01:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PrpF9c8p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 064441F000C4;
	Thu, 19 Nov 2026 01:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051932;
	bh=zGNfJ0lSt/LSrbAJWs6yu/NuF01siyQG6RcXTrQRRQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PrpF9c8pDOyHMgEHfzCaGkWrm8/HUeqtCxIF04VO55tChxYIaHPHEjilMhBcyPq1w
	 KX83cUS8MAKfqXd9N4O3X5ua/tAGjFGHB86KcEsO8vKHSVsIsKem9GBKP6KpL7+LxN
	 KNv7miXf1KD/6bj+5OAnxGzQW9KrmtqjEpHq15FY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 5.15 0384/2214] HID: roccat: pyra: reject short button reports
Date: Wed, 18 Nov 2026 15:34:20 +0100
Message-ID: <20261118150026.049539379@linuxfoundation.org>
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

commit 493268f459bb6aeeecbc77f2204c11ad74d05213 upstream.

The raw event callback runs before HID core validates and zero-pads the
report.  It passes the buffer to helpers which inspect data[0] and read a
complete struct pyra_mouse_event_button for button reports.  A truncated
report can therefore cause an out-of-bounds read.

Require enough data for the button report before calling either helper.
Commit 47669bec44fe ("HID: asus: refactor the two workqueues and init
sequence") added the same kind of raw-event length validation to hid-asus.

Fixes: cb7cf3da0daa ("HID: roccat: add driver for Roccat Pyra mouse")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-roccat-pyra.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/hid/hid-roccat-pyra.c
+++ b/drivers/hid/hid-roccat-pyra.c
@@ -554,6 +554,9 @@ static int pyra_raw_event(struct hid_dev
 	if (pyra == NULL)
 		return 0;
 
+	if (size < sizeof(struct pyra_mouse_event_button))
+		return 0;
+
 	pyra_keep_values_up_to_date(pyra, data);
 
 	if (pyra->roccat_claimed)


