Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795318760;
	b=XnMCyit+ZIq3jEz/EMUJwSoY6/R7zuWUqQ5jGtLpLuR7bgCXBLCUuoVbRqr1tWnnSTNT
	 mQWaBJUbWCwCqLaJQNOBDHR+U6nrBZoQfR2kh1a3Xof8xZ5h3i0Ez2KWmOBXarHkxYBWH
	 wHF69CaJ3cOR1vbfZrRx3Czf8XyczwDIuhe/NP7Xor+dOvV7ohu9vjWURsBHakQUEEon7
	 LT9BkSqCjEQ7HfwQvoKb4724y7o2UTzyWluJlQR7Oh8zejlCHJ5oXQEPQ1a1eNip4MO5q
	 eejPFJY8h8HeZUfQ4BgPQP//wH1tPWEo0FTAcl1+8asXhdjF1XlKDV6xLA2re+xUjLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795318760;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=fY1+WU2+/r6ZYT/glN6MM6ZC9upNxp7IZVpAbdSOEOk=;
	b=uvVQmexUo3VVopBlp2p2IHAl0heck8OwjCqb76y2RNMdW0TRDbNKlg5uDtgLxwTkYhe5
	 0xD+Cm1rmn2EORZgcxwBnQZ2T7sI/QgvuD2wXLKYaiGLiD8bX9unR/JA+wDsnAfPcXlcU
	 tuEfGxT1upK+sbkRsX1ST8a/iAH3fT2VrlQyMkiW0mtuVYg+wLftJ+vwOkALCadmMDFSk
	 S/Q6GZKUULToPS93QAcpX7mfuhheM3Tw/VbGAu2CxDH1D5cwfPWxFUxVnwJmCur+5fXCk
	 ugconfNZ3de+/kCI+Ki3RIMJL2MZ+ZO9aZgdfiI4C7DOi/70Tb64WNfj7TWnHUTCRkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="ne+v/RYR";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8B88606A32A;
	Sun, 22 Nov 2026 03:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ne+v/RYR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CCD11F000CF;
	Sun, 22 Nov 2026 03:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795318760;
	bh=fY1+WU2+/r6ZYT/glN6MM6ZC9upNxp7IZVpAbdSOEOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ne+v/RYRVct6Qd+KIJC9QFdJiE+VVLGeISbrdxaqEkRYxA+4J4XhjInG3v8Sk9I+j
	 +wpQlZfuj0zAMRE6ngZgOF/SrmfsRyG1LVMAIbbilFI4zXpan/8+7JhLPtLsDnz/bR
	 0YegxgZ+jKEpLM2XDgvVngX7BWox8hJCRCAUmi4x4/6repxbX0tk0fy8HxBQM6dP0z
	 3U3GazStEAEs4ad+edKHumqrMfE5xYNr2FAu8S3jYKmJa7qr5fUHVs09MDaiIhEAbV
	 qbzGn87DHHrvMqt6IZhWzbadNDnhqjZ08PEHOCpzupW25BXnv8HOuSe6MtdHaxBlS7
	 WHGTMheuWEBpw==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Janne Grunau <j@jannau.net>,
	Neal Gompa <neal@gompa.dev>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 5.15 1081/2214] wifi: brcmfmac: cfg80211: Report port_authorized for 4-way HS offload
Date: Sat, 21 Nov 2026 22:38:47 -0500
Message-ID: <2026-11-21-2-daily-reply-0004@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <a57865f9-15ff-4fa3-ace4-0b384f53cee3@oracle.com>
References: <a57865f9-15ff-4fa3-ace4-0b384f53cee3@oracle.com>
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

> I suggest: Include 8d70f33ed720 ("wifi: cfg80211: Allow P2P client
> interface to indicate port authorization") before adding this callback.

Queued it ahead of the brcmfmac patch for 5.15 and 5.10, thanks.

-- 
Thanks,
Sasha
