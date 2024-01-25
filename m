Received: from madrid.collaboradmins.com (madrid.collaboradmins.com [46.235.227.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8287517BB9
	for <patches@lists.linux.dev>; Thu, 25 Jan 2024 08:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.227.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706171075; cv=none; b=lMKNykjsQNHqsUvaPJrZdQr/0tzMAW8Y/L7RAiF9WLbMLWAY14awMrWcEHI+/xkwR57kOyua3ez/yD+gOMwk+YUGCalDZFamv+84GysVjVmU4Y+9wZRtxXGhoCcQVbvdYDzkkOtxqPKGqxYf4Bvcde8btpjn/zvUvtGL6bZgheg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706171075; c=relaxed/simple;
	bh=gbrB9NLIlYC5NTig3kJYB7G3uvykx2Hby2/m3ZKMIl0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GFTm2ACz3XwKTGM9bGJ9wZL4NTph4hE3EIM5lWK5RLN55UbrCzv9v5to9w4+0abLkUGHLkj8TnA7I5xWmBqfsjMdUuKYB/QKHExxzwolYcaTrJ32Or3LU2p3NZbHz4WQ/SkVZrHRTIiCdqZq8eL4/qIpHcQlKlFhTW3FtyFdJzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=JzxGzMM9; arc=none smtp.client-ip=46.235.227.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="JzxGzMM9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1706171071;
	bh=gbrB9NLIlYC5NTig3kJYB7G3uvykx2Hby2/m3ZKMIl0=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=JzxGzMM9+n63kEOSgtEZk9qEnHHJE6pBOEO4viPJpTfscJCimVlcbqtRrFh7EFqcs
	 PETbJoY+BRIum/geSL9u/VmtIFWttEvkem3bcoi2wxXYfR+/WbzST9/M4D2a0XBJ9j
	 YZrMqA41TdKpw1PdFc0pjzW30d/AkiZmJUH/e1qCTTwBkCmUfNXkvA8mMa09QxTJbZ
	 zS37vweEa870FXLF5USYGAmaB2r0tmvBFwLjRxA/2WKpmDGQewzCUHn6XZmqt+Ovao
	 zGdz8ezNh1ZUWnB4MxkkcrITERWwr3JCL/XOhDoou1alu5ZnRkCeugXukWpW8r1jqH
	 0F5nSHwrcGbMg==
Received: from beast.luon.net (cola.collaboradmins.com [IPv6:2a01:4f8:1c1c:5717::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: sjoerd)
	by madrid.collaboradmins.com (Postfix) with ESMTPSA id CC37A37820BC;
	Thu, 25 Jan 2024 08:24:31 +0000 (UTC)
Received: by beast.luon.net (Postfix, from userid 1000)
	id 819BDAAFD424; Thu, 25 Jan 2024 09:24:31 +0100 (CET)
Message-ID: <d0e3c99793d981c5ee90aa7457e480d83fe9e8de.camel@collabora.com>
Subject: Re: [PATCH 6.6 132/150] bus: moxtet: Mark the irq as shared
From: Sjoerd Simons <sjoerd@collabora.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Marek =?ISO-8859-1?Q?Beh=FAn?=
 <kabel@kernel.org>,  Gregory CLEMENT <gregory.clement@bootlin.com>
Date: Thu, 25 Jan 2024 09:24:31 +0100
In-Reply-To: <20240118104326.164425257@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
	 <20240118104326.164425257@linuxfoundation.org>
Organization: Collabora Ltd.
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.3-1 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

Hey,

On Thu, 2024-01-18 at 11:49 +0100, Greg Kroah-Hartman wrote:
> 6.6-stable review patch.=C2=A0 If anyone has any objections, please let m=
e
> know.

Thanks for picking this up! To complete this fix the following is also
needed:

fca8a117c1c9 ("arm64: dts: armada-3720-turris-mox: set irq type for
RTC")

Not sure if i missed something causing this one to not be picked up,
while the others in the series were.


>=20
> ------------------
>=20
> From: Sjoerd Simons <sjoerd@collabora.com>
>=20
> commit e7830f5a83e96d8cb8efc0412902a03008f8fbe3 upstream.
>=20
> The Turris Mox shares the moxtet IRQ with various devices on the
> board,
> so mark the IRQ as shared in the driver as well.
>=20
> Without this loading the module will fail with:
> =C2=A0 genirq: Flags mismatch irq 40. 00002002 (moxtet) vs. 00002080
> (mcp7940x)
>=20
> Signed-off-by: Sjoerd Simons <sjoerd@collabora.com>
> Cc:=C2=A0 <stable@vger.kernel.org> # v6.2+
> Reviewed-by: Marek Beh=C3=BAn <kabel@kernel.org>
> Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
> =C2=A0drivers/bus/moxtet.c |=C2=A0=C2=A0=C2=A0 2 +-
> =C2=A01 file changed, 1 insertion(+), 1 deletion(-)
>=20
> --- a/drivers/bus/moxtet.c
> +++ b/drivers/bus/moxtet.c
> @@ -755,7 +755,7 @@ static int moxtet_irq_setup(struct moxte
> =C2=A0	moxtet->irq.masked =3D ~0;
> =C2=A0
> =C2=A0	ret =3D request_threaded_irq(moxtet->dev_irq, NULL,
> moxtet_irq_thread_fn,
> -				=C2=A0=C2=A0 IRQF_ONESHOT, "moxtet", moxtet);
> +				=C2=A0=C2=A0 IRQF_SHARED | IRQF_ONESHOT,
> "moxtet", moxtet);
> =C2=A0	if (ret < 0)
> =C2=A0		goto err_free;
> =C2=A0
>=20
>=20

--=20
Sjoerd Simons
Collabora Ltd.
