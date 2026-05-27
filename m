Received: from smtpbgeu1.qq.com (smtpbgeu1.qq.com [52.59.177.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D38533C2BA8
	for <patches@lists.linux.dev>; Wed, 27 May 2026 09:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.59.177.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779875208; cv=none; b=qo+8kukN7Lg6HvVuDlFe6R6LKjtcLOTn+lIdlO+Zj+i+gvHIecK5K+TLaV+KrarlacK/fN+nGPwR+iw03n/gvLTP/GgtyxnwPmwN8PLLmKw/U6+UIMJ1d129G0yT9uWWvdj8gcvxW/bNGjaSt3w2xsEvDxWAMQxZ+8Q+JMZQgME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779875208; c=relaxed/simple;
	bh=Ia0yIbhdqpKtebMPGbigWhsK4eOsrKkpZkvYwRjp0Kc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RSJghD1o1EUqAwGhYyxjSSnNGdcdoZ7Y3UV9MFBhW5DBQKhvaYEn3MFvMTUs/AvS4u567nnshEA8W2ulnKDDF53SVzQmgmHIIYSySaxUQEDA4W7d6NoHU6p5iP6mZZcOBnQVTOD6tVVQb6izN0+O9f9F3hXflI4hfaQcuonbX/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=HnQokIjF; arc=none smtp.client-ip=52.59.177.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="HnQokIjF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1779875151;
	bh=Ia0yIbhdqpKtebMPGbigWhsK4eOsrKkpZkvYwRjp0Kc=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=HnQokIjFrXf2VKOSROZ0wkZ1oGNS/xaKQfgWWO+NFiWq3PvVXJVw7/tNQ0/VfcP6v
	 0PAedFdexlqKqRo8BsZjdJX6+R72r6c6S0PuFe+SCZQzvlG9scAcjaZ7vd7pULPiAH
	 LFXdDcyiYgRXqLEBztsKL1tBYl3R394DHLAoY2bQ=
X-QQ-mid: esmtpgz13t1779875147t35b1c9e9
X-QQ-Originating-IP: ePvmYdHkFpHo6PoZ1NIT/fGc+g26VcbfqO/F6xSTWGo=
Received: from localhost.localdomain ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 27 May 2026 17:45:45 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 2997212932578719407
From: Wentao Guan <guanwentao@uniontech.com>
To: gregkh@linuxfoundation.org,
	sashal@kernel.org
Cc: bird@lzu.edu.cn,
	kuba@kernel.org,
	kuniyu@google.com,
	n05ec@lzu.edu.cn,
	patches@lists.linux.dev,
	stable@kernel.org,
	stable@vger.kernel.org,
	tomapufckgml@gmail.com,
	wangjiexun2025@gmail.com,
	yifanwucs@gmail.com,
	yuantan098@gmail.com
Subject: Re: [PATCH 6.6 229/474] af_unix: Reject SIOCATMARK on non-stream sockets
Date: Wed, 27 May 2026 17:45:44 +0800
Message-Id: <20260527094544.2344825-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260515154719.961677988@linuxfoundation.org>
References: <20260515154719.961677988@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpgz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: OAHLEV5KK0oz0airRhP1wr1TIEzPMPktfHlBrUgP8QrevoQhlnh4OBMx
	PQPQOPoup/669Ve1lK2iMXsKMrZN/bJ+dT65nxPGWKehr2gT6twTRS/wm4c8hCEujRDBJqM
	WQi++CTssFgv6WTlNj+SZH6Vak/VSSosA3iHP2ZCtDkrL3gUrqYI0yRpW67pQq/+02AdpPt
	Tg8FYZG03spipB//RVZQy+v3Z+0ZPW7TWx3ctS0015qtduG9U0MmJJ/cfckgF9pzVVslH6B
	MhfcCwEndVpVDTLVLazXHxouc30043gMWHgngf2lFhKvdDQwwE7XjhoGkdyltRQXWuhQEJV
	5qdGOl71sUWpxubfLL5TAKaz2xuyXsTjIOmsaz6aMg54nltV/Hlb5mA2+jnaibICl3xtBVW
	z8OPARY0LYGXR84OctpUcz6xLBAiikP9Wkb3NRRV3JA7ykHJ6V6LI24gZw6SYk1O3tn5t1O
	8X9nj6irBLnKmtILpm+Jw0o2i/NL0V8vZ8AhfhuzvloRRxTCGSl+h5fPyviPlkzRV1hmDy/
	ObAvOKoJIOJnpa1uWtoeQ/oHDX8ZGFvnem/kUfizwCRD7ZOm61MAfEGNQcAc0iontekoI/W
	8gID/WDYBIGvisoM1qkzPFZuKF8cNCcnCIITcKijL3vum6+siyL0n2LfXOJBWMZ7Pn+QH3a
	yWJAs5T2icmPv9mrBcXD1wxYn5ArawiA0nG6Y7GaR8DV+LdH93gtvpcSHz7lHtHKGwGrGa5
	5IgnJE5bHGc6112FdKir/hQuwE8wNbxHgtG/owGrYslsD8wZSNJJTKR3pAu23FFLl6H97Do
	morSKAO5GI8NZ1yNV2tAUAjqE5LSSGYnqUHYuEOLX5ve2k5xyWaMRgnOZ57ElhnGAESzRov
	MfIQDjnfxutjn+t84+w4PVlfGdMTscyuW8qfVXlxxQuEgFgR/5AOkauX6bndxDN3vgx+Uck
	VHY89eBOanbdG6OOQIV+pokHhdw1gadk4Qd034H9qR8aD1H17S7tnRZ5CeqFIDcB+cw5JnD
	u3ursfcWTNzneArELxMHuCMNPYYTX+0Xg9FEkKzeJbwBJmv/KL
X-QQ-XMRINFO: OWPUhxQsoeAVwkVaQIEGSKwwgKCxK/fD5g==
X-QQ-RECHKSPAM: 0

Hello Greg and Sasha,

On patch review, found this patch which backport to 6.6 context seems such
different than orginal patch, I think this should be revert:
commit 0d7e7235bc543c6ed7b873e3015db814d8e8c414
("af_unix: Reject SIOCATMARK on non-stream sockets").
pls review.

[DIFFERENT]:
original patch patched in unix_ioctl(),
this patch in 6.6 patched in unix_stream_read_generic().

BRs
Wentao Guan
