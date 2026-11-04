Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831862;
	b=vuCFzMmgCYFA2Qf8i8tL/y02MTeBKnV0VObDkZnEUh3pIQtBAfyXR9pqaFLBnCdyrOwY
	 J+nukBHCcZJnJpcEPlmfN9n7OJPLn9/mD0Vl0q+V01xoxpOVv3+VBuC9S8lOWudrWZdw4
	 qtsmjA9Q2r6RsEpBrzSaKcMznCy7c2cU9reB+nqPhL8NMPtNxHI246IbNOa3TxSn3K7g8
	 zjy7VZYCwABfLB5oAUndNrIWnWtosbrZ2HH0IlwnECSa7HMMHAahLSDErH5Zy4wq3hMOw
	 zLSsdPa0kkCFcdOjtcpWt6boPnjbPfVmu+YkELGLaS/vAPVVVY6V7nS/OHu/y71+4Vw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831862;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ve/GddpRtb2b8+KKXW9sWPKpCS+2jE+3xDN2ymZVDvE=;
	b=GrMYvxpTJsAptCMwrxUtl3FLhqsLRiGDlGZI8TuT2u2xoch3EMn5N2OZiGx+px6aG/WL
	 shzFS+3AY8Kykdrtt+4bTGYpaCerFUa8TRQt7E+wJR4VGTkcP3I+40gcDKBSWadah2nqj
	 5cOV7DUPWb3RkSifPneSiYGRGh0Kq0t0OQpfGqhRvZ+4l3JZ1NV7oAaH7RugRAmfIpnMx
	 MiZ7vgSWWJytxHIWaJixaNQKuLazDJ3E9N9dkyAQjEA7CaBtJKJF/6yWPqAxOLerk/pmq
	 01hUbFqrXLFozn+3obxwJSq5+OLW2A+ZH/1G8mRNMyJ/cQj80dGaoM4oYBwMrRuqeug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BCTkZqZc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABE10606AB29;
	Wed,  4 Nov 2026 22:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BCTkZqZc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A9D01F00919;
	Wed,  4 Nov 2026 22:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831861;
	bh=Ve/GddpRtb2b8+KKXW9sWPKpCS+2jE+3xDN2ymZVDvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BCTkZqZckZi4C3WnKn59TgOpSL/FUxmiLdcrPdfG0P2UlPH14sThOKuS2bPtqD1my
	 +UggJw13rchw9WAYShGsYYSnbWBD2vk8SEJz9H5F1B+LofRLLEnBc1wqKzseKm3QE1
	 jKlpmNC2PGYx5R7neZ4o6jbTFdFY0VVyAaMceae4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 6.18 0960/1005] HID: roccat: koneplus: reject short button reports
Date: Wed,  4 Nov 2026 16:11:33 -0500
Message-ID: <20261104211109.971541216@linuxfoundation.org>
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
@@ -523,6 +523,9 @@ static int koneplus_raw_event(struct hid
 	if (koneplus == NULL)
 		return 0;
 
+	if (size < sizeof(struct koneplus_mouse_report_button))
+		return 0;
+
 	koneplus_keep_values_up_to_date(koneplus, data);
 
 	if (koneplus->roccat_claimed)


