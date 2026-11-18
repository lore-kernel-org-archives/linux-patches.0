Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051929;
	b=R/8ouc9Mi8/Mo5HfcfMPHzDxXs5lwIQ5PFTcKW73+XJ8d4jp5muXPqT+eZKGvCocRF0D
	 GYt3VH9z471dRY9qA/1Qfrl8tyIsKYp7SzLf0UA189L4nZ8S4kppSpNE2+69Fli45xayU
	 r187DZd7wA69hgZW1KHxgV+NfAQMOijCCf6sjuFYC8APLyMwFcCEGOOeZlAvVE2FQW20t
	 Awws7j8k37v9hYoQtbL8VW4R+qqBRYMloURCb9uPyqQJrKlO+2qXzN3Tn+QXdkBw+Z0ve
	 qM0c0hhR4bSprhg9jaSvl2hp1vueIZDDUF9htRETJr7zK1iabjt7/H8wA/VIqKDAiBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051929;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=u2XMyQ5ZXfvx/WC5ymPBqMiljDbjAvmG+ZWII3ZmgZc=;
	b=MPoaCVZGtKj7SVxSlmn2BcRw6yX1ejoKAKNKAph1BVLHtJgm3r6gtsurqC/O1AXmnh57
	 oHx3VQsfZFe86fufB3hHScfs5xoNAC5HTqIgiwK9WUgqKlr/Pbw52VNBvKz9beMDoaL6X
	 f3nS/b301J/wVmFmpL4HeNv3pkQdnRoo2m391JzDKEA/QEHhJbPYulr6Ge/Gd96RMk71e
	 cA7Nga6oF7Qu+z5RQO29WWfwDUGgHajojQoslL90/Qnl3JGnxGmS/gmw4XcHSXW1bBxUn
	 Fl26oIZnrgBIBXFNjX3C9bnH7XULLKOAsWQuXvd5UI0Zx4rvP1uhktQ2/uqVrmYG4Aw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z+ien58W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D48F4606A32A;
	Thu, 19 Nov 2026 01:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z+ien58W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3796E1F000C4;
	Thu, 19 Nov 2026 01:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051929;
	bh=u2XMyQ5ZXfvx/WC5ymPBqMiljDbjAvmG+ZWII3ZmgZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z+ien58WFEpPLu4vgtlv2lUbxgVrNKjyPTrOfUoYx4vhu+1m25AqSeEq2EpAd9hvK
	 CXE6K0XIvH07QtW0YwpLOXzl4DiP0/bl5on1MSAH1xCUyPq+I+mFouO7NVY+2EZDR5
	 o/3i8EtUxF195WDqin9w3To50SKb1qdsulnw1i8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 5.15 0383/2214] HID: roccat: kovaplus: reject short button reports
Date: Wed, 18 Nov 2026 15:34:19 +0100
Message-ID: <20261118150026.012578187@linuxfoundation.org>
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

commit e95917a606f486e46f5136fc1b72190742a091d6 upstream.

The raw event callback runs before HID core validates and zero-pads the
report.  It passes the buffer to helpers which inspect data[0] and read a
complete struct kovaplus_mouse_report_button for button reports.  A
truncated report can therefore cause an out-of-bounds read.

Require enough data for the button report before calling either helper.
Commit 47669bec44fe ("HID: asus: refactor the two workqueues and init
sequence") added the same kind of raw-event length validation to hid-asus.

Fixes: 0e70f97f257e ("HID: roccat: Add support for Kova[+] mouse")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-roccat-kovaplus.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/hid/hid-roccat-kovaplus.c
+++ b/drivers/hid/hid-roccat-kovaplus.c
@@ -611,6 +611,9 @@ static int kovaplus_raw_event(struct hid
 	if (kovaplus == NULL)
 		return 0;
 
+	if (size < sizeof(struct kovaplus_mouse_report_button))
+		return 0;
+
 	kovaplus_keep_values_up_to_date(kovaplus, data);
 
 	if (kovaplus->roccat_claimed)


