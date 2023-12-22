Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [80.241.56.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDFE81D52F
	for <patches@lists.linux.dev>; Fri, 22 Dec 2023 14:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailbox.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="QjI2X+Gf"
Received: from smtp102.mailbox.org (smtp102.mailbox.org [10.196.197.102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4SxTpx11X2z9scS;
	Fri, 22 Dec 2023 15:15:37 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1703254537;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=V/mhqXMoHRu6vLBVYURJ4olCDceAwxhHCNFVZpWTyNI=;
	b=QjI2X+GfW9GGiufbG8I/qhCl/H3ZwXKKI8ww40RQkIHIHlLZmtcyMxmlzAm9hlTiZKywCB
	RncCoEAOqCHIGpXcKJ9r0Ncb75WA2cAFOPwkHohOHRFMHS46Hv9SLUxXFjHbDTe5r76F56
	mxmK8KlgFjzml6S3ByvLJ3v0YanF/ganT0irn0/5suHZExYUSgRHVp6ykagcmHes9bmpR2
	EsZCl0GVQznGbm5RfTd6ZaEimqXGLwitQITUAw6kuU1ZFddtJfoDjwGgQT8LdoLj+LnUMk
	hIveBa+q1t156W8yp2lEJm8qqHzOL8KeYVReofKzVgZrb6t+b9VI79Og0BAIGg==
Message-ID: <2feecc09-3310-4733-a65e-50b9f5dc7325@mailbox.org>
Date: Fri, 22 Dec 2023 15:15:34 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
To: gregkh@linuxfoundation.org
Cc: jkosina@suse.cz, me@khvoinitsky.org, patches@lists.linux.dev,
 sashal@kernel.org, stable@vger.kernel.org
References: <20231124172031.066468399@linuxfoundation.org>
Content-Language: en-US
From: "Uli v. d. Ohe" <u-v@mailbox.org>
Autocrypt: addr=u-v@mailbox.org; keydata=
 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
Subject: Re: [PATCH 6.6 097/530] HID: lenovo: Detect quirk-free fw on cptkbd
 and stop applying workaround
In-Reply-To: <20231124172031.066468399@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-MBO-RS-ID: a55d55361e97dd8e8d6
X-MBO-RS-META: eihhesz4zywc85quamkfpgx1ed78tx8d

I have one of the affected keyboards with original, unmodified firmware, 
so it should use the old "workaround" to function properly.

However, it seems that this keyboard does sometimes send REL_X events 
when the middle button is pressed (contradicting the comment contained 
in the patch).

Thus, with the patch the necessary workaround gets disabled. Once this 
has happened, the middle button scrolling exhibits the known buggy behavior.

Explicitly, I can confirm the following values occur, leading to 
disabling of the workaround:

cptkbd_data->middlebutton_state == 1
usage->type == 2 [i.e., EV_REL]
usage->code == 0 [i.e., REL_X]

This was tested with kernel 6.1.67 which contains this patch backported 
(commit 6e2076cad8873cc2a9f96e4becab35425c3656dc).

The USB keyboard has been working fine for years with earlier kernels 
and is identified by lsusb as:
ID 17ef:6047 Lenovo ThinkPad Compact Keyboard with TrackPoint

Best regards,
Uli
