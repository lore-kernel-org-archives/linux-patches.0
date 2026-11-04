Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829187;
	b=sj1JX7Im7OsQexYCzktI7kQ9vgLxfVbr8aabFRjuP6Rpo/7RZAA3rWSNuVk3/TAKh90H
	 TFBP/UIsEsqfRQ7VhdjfQQiTBnP8lL+lxxAGsbPRajv7/kDFQPHhHXZPfQ9xWga1E8913
	 AT8IYZrpIfjyMLmY0wj+2Xd2u+eso7bHNKGp+xnPhljp8XjyA/nI99B+251U1YX0k7jrJ
	 tylqtQRBYDFOYFDIiZiotHqEV+XoFne9XOanTZmgh++8xUmmFyRaOWwdHOPLf9fyV5zdK
	 xBYZKcyeGqXtaMmQHAOxEJp9gYAY7CtJu5pTgO8GVdv7gJHd4KGtWDwUQA6a1L2Aqnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829187;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vQM8T0pqXexMWe0lmVp+GwK2taq8senuKSwlPUFg2Kw=;
	b=y6VskzaObc9QVzOp6GDZVXZ//J/wj3JkKh1pjnuh/HOSLxFosSPpWHWyUV40jyciw26D
	 2nE9Md+x/E23EYWomFMpNiDBBO7sfxJ6roPVi8iYTMERAzty0fmZ0volOTl03ah/06kxC
	 ZZT3bz1MQCoD+UnckWLbvmpBX89ah6CbcTao6R0+0QIgoNMixo62YLRG9oE0m7YJxTEti
	 Z2MsUxxkor0HG6abnUQHM/rsYNtXFiSsvAzTLm0i/pq3RvXsctgTpHg/y+RdIrdUOAGkU
	 MRQ1IW24tV417MbMb3tPohyLr0Cugyo21m1Bo8dYXGV4r58LbfVb8eYCM6ZZEDcsxOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CIW7Yh8w;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36604606D806;
	Wed,  4 Nov 2026 21:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CIW7Yh8w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81B1A1F0093A;
	Wed,  4 Nov 2026 21:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829186;
	bh=vQM8T0pqXexMWe0lmVp+GwK2taq8senuKSwlPUFg2Kw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CIW7Yh8wPh9ItB2rx+X+rAbnhQseGvPguKGvxLVNpXm7igWCiZjAFeb+zpgaLnjXA
	 HcnQxKfiUqfaMgZG6RNCWUEJ7sP96cArXsMwM5Ph4gXpVMaMQpVWltVsOayLiIslOR
	 8CBsCIMkQA0WFbQvbAvycY0R0S2A4cFkz0vZRnk4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 7.3 501/547] HID: roccat: koneplus: reject short button reports
Date: Wed,  4 Nov 2026 16:11:25 -0500
Message-ID: <20261104211052.621622975@linuxfoundation.org>
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


