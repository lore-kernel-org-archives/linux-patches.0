Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058075;
	b=W1+f0LbZbvFYfvLwtCKha+AI1ZkFo3UDC4FUWE1pyBpbLZQ7J3fomkH1ap+7Q0xVnYGo
	 shFiZ6dcbAsLQbXvcb5t9Td1fGPiumODPzMjBwH4Ug0GSTJtzsl5AZvUVud3gre5venQP
	 53pgtNvlySN0S0Mr7ytcrX+QQQgeSWDQ8O0YW8ZZXy5dT1HOmBKYlrtU45fWXPw8E4xvd
	 g1+zffGI8w79scBOY078qnYIhaWQ9xMdzKeoWbNqF1FmL4zQcxwqRlVt0ZO/1WaGxWVFB
	 0MgMK2cH5Wrp0b3pm6sIjPjW3ho20emhW7MmVFcWqlFH5NdHvJrPFdgCQQtXHO1hXpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058075;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pdCMC2IcvMI/KGZYXh2FCKP1jQLnwJPn2rWfHcAQ0LU=;
	b=5hS1bpP7Q7ZOXludn0bAmefJgnUXtocAS6HfM6z8vnfMJ3GmOTotx4jN75rX5sBaDgox
	 aZJyR3nOYV2pFStVBzAhA+ZUi6BFIIKmvOjAAWOby6sSa4yqgRe/ErtnzkhAq/6SJD1Sn
	 x6JVuXU9B/FeWOLIV/RZ7s+3SYKEvQtnHGDbnbVTHYBmEzJhSaETT+qp4cVX/zqAXsJWn
	 qPl0s5WM4nru6qo6iprAoWPVmlL96Sxx4ILcKlBATibP4aF8ADF1R94MJrz9CURZ3/46a
	 BVSN2yD+FEl7rZOKZCWAuhNcNLIPZWCnLaIhIHPm3/Oo6oOluS15FeiOr6TtpCTv69w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y9XUFBq2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D831606A32A;
	Thu, 19 Nov 2026 03:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y9XUFBq2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E3D11F000C4;
	Thu, 19 Nov 2026 03:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058074;
	bh=pdCMC2IcvMI/KGZYXh2FCKP1jQLnwJPn2rWfHcAQ0LU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y9XUFBq2Qu/J93ODjx7fP7uyC9/2hJnJNfriWULllv6CXJlalD7rkCcgyWvp3Wi2J
	 DwX5MKUDRnoCF6PoY0uzpMMP4X4pWTEYKjqcvYxDUYVF8Iq9lpOyjPjefva7V9xIO0
	 aZYoWbZGRIaNsn49BdgAXIeFWdjkJgJMjBgmx1DE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 5.10 0315/1848] HID: roccat: koneplus: reject short button reports
Date: Wed, 18 Nov 2026 15:39:13 +0100
Message-ID: <20261118145925.407688650@linuxfoundation.org>
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

commit d879e17a8b4c572c0b53b4e42a36849484e8f00c upstream.

The raw event callback runs before HID core validates and zero-pads the
report.  It passes the buffer to helpers which inspect data[0] and, for a
button report, read the complete struct koneplus_mouse_report_button.  A
truncated report can therefore cause an out-of-bounds read.

Require enough data for the button report before calling either helper.
Commit 47669bec44fe ("HID: asus: refactor the two workqueues and init
sequence") added the same kind of raw-event length validation to hid-asus.

Fixes: 47dbdbffe15b ("HID: roccat: Add support for Roccat Kone[+] v2")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-roccat-koneplus.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/hid/hid-roccat-koneplus.c
+++ b/drivers/hid/hid-roccat-koneplus.c
@@ -520,6 +520,9 @@ static int koneplus_raw_event(struct hid
 	if (koneplus == NULL)
 		return 0;
 
+	if (size < sizeof(struct koneplus_mouse_report_button))
+		return 0;
+
 	koneplus_keep_values_up_to_date(koneplus, data);
 
 	if (koneplus->roccat_claimed)


