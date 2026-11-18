Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044650;
	b=lNKffqTvIhkPGMA/m7mCW6fMkcYTETy+EHnWIw3Y3gM5VxUkimuGolX36UyK3UKaNcwb
	 6GEYt4jn2TzchMm6sA2/wXyRjOePFCYYC4NbsgUW/L0YV9LF9EYqOzHDmn2wmgWBzUTek
	 qbKQknaVaU8QrM9xbKwy0Rj0k1y1wSxOgpiM3xsC/nevWWRmshWThz+q56N3uBJlRbtKn
	 xG+arXPnmfYYDUAAR62oiGFI/N346NJ140wstRGjaPC0/YD+2lQqOVkYOO1FbnPX2xVE8
	 Lzo11p4ACMVF+CZ+NoqTjCu3NklF0wM/IHyKQ30uLu4XbUsA96+cvxMJxbj+ijJViRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044650;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XiSi9sOelFPDflOz7CpUCv15pAy3ZqEG+MD+93Reo+c=;
	b=hXWUazdS1aJTBWfMFptY0xz+JsmNYGDzEipowJROe0kWENl8dpo3ZG0CTkIBpmrIo7A9
	 Z28SlyGk9VCdZrhzkDMQagDBkeBFj3zujLXayA4YsJm+zdVqr3CUBSi0NNrQ8Tmyp/YK3
	 4sRdGBUbhjufn4fPx3iIwRj8XuhhwEyOcZorIUtQe8GE03VC1YYmdnZWyYNcIHsF78zy8
	 VFDIRtGb0RFtemXyHvgfN9JBW/B7G3n60th6D60PXmdJ4mchhI4Vy3Hs/0X5etVT780hG
	 QE06FbD4wMnOL/p2liHUZOmdRqLl+9ipawi84razl46B/Xg6BqLu07tEETm0Tu1KPAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AJ2HRTXb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C075C606A325;
	Wed, 18 Nov 2026 23:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AJ2HRTXb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AD6F1F000C4;
	Wed, 18 Nov 2026 23:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044650;
	bh=XiSi9sOelFPDflOz7CpUCv15pAy3ZqEG+MD+93Reo+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AJ2HRTXbyxo14lBcugLTM2ND0shLt5o7u3wsJ9POXL4ysXq6E+v1R6YmaMhDRTspN
	 7ElYqhkQ0LqjQcLbiKw0dt0lvK5gFiVyma+15rf286f/dayZ59k9ZB9i1I01f+SHkB
	 n1U6yEqWg+C0lBIcrmGVbSYfPsnXBF3h+DiS2uuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 6.1 0643/2857] HID: roccat: koneplus: reject short button reports
Date: Wed, 18 Nov 2026 15:27:57 +0100
Message-ID: <20261118150224.678227813@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


