Received: from dvalin.narfation.org (dvalin.narfation.org [213.160.73.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDB253B38B4
	for <patches@lists.linux.dev>; Fri, 19 Jun 2026 17:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.160.73.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781888486; cv=none; b=HXVwXpXoGb/nYbfJGJVK12gWabgVj0fu2rjl7ujABuHtpZOivkpms9zoWxvR83Ro1wDkjJbfILjMG/GPOpGxv6196dpQ5Fq+QxLhy2JWvPyZbW01EMcDK5GxeZbXcInhI9K2+IABK8TJAIJ4eJpop0x7OrX7yCm65Ys5VWbaHRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781888486; c=relaxed/simple;
	bh=blk0sLmKG/9G+0vVOQ1FwFXKH6K8YceXzpsNctNXO/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NAYeRFgvJu1Eu0ChxYRVRnZtKx2cj02gFS9zAS/XMicxn0VWGXY8QTMCGfMbCeXVBhLjTg94qt7venwfxTExVRTJSQXnwE3JeYCEtNQNSVo5j+xp6ILcQ49IHORELHd6WomwSAvJKhOlWI7d9JQQ+E4038V6ifZb2V85lk4DsdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=narfation.org; spf=pass smtp.mailfrom=narfation.org; dkim=pass (1024-bit key) header.d=narfation.org header.i=@narfation.org header.b=Zrdc2G/b; arc=none smtp.client-ip=213.160.73.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=narfation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=narfation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=narfation.org header.i=@narfation.org header.b="Zrdc2G/b"
Received: by dvalin.narfation.org (Postfix) id 521581FEF7;
	Fri, 19 Jun 2026 16:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
	s=20121; t=1781888077;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zAsEXsjcjCFDxWh6TsARyUFmjzp9lkxD2mv/Y4WeXk8=;
	b=Zrdc2G/bOiJT7aa+ByVEZmR18s/JFORgHAxJxNqJydKferSGxtwChuuYGoQ/0C3G7ucCPC
	PIUH75PxUBKo4sYjz/PzSFF7Driu0rOban8vvZmcuRTZTQNcQ7QsiiiRgB6lFvUmYOihb5
	rfuGEc+fRglABTqcM5murZrtEQy9ySI=
From: Sven Eckelmann <sven@narfation.org>
To: stable@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, patches@lists.linux.dev,
 stable@kernel.org, Sasha Levin <sashal@kernel.org>
Subject:
 Re: [PATCH 6.12 125/307] batman-adv: tt: prevent TVLV entry number overflow
Date: Fri, 19 Jun 2026 18:54:33 +0200
Message-ID: <8696716.T7Z3S40VBb@sven-desktop>
In-Reply-To: <20260607095732.348045111@linuxfoundation.org>
References:
 <20260607095727.647295505@linuxfoundation.org>
 <20260607095732.348045111@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart10869751.nUPlyArG6x";
 micalg="pgp-sha512"; protocol="application/pgp-signature"

--nextPart10869751.nUPlyArG6x
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"; protected-headers="v1"
From: Sven Eckelmann <sven@narfation.org>
Date: Fri, 19 Jun 2026 18:54:33 +0200
Message-ID: <8696716.T7Z3S40VBb@sven-desktop>
In-Reply-To: <20260607095732.348045111@linuxfoundation.org>
MIME-Version: 1.0

On Sunday, 7 June 2026 11:58:42 CEST Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.

No real objection for 6.12. But it was missed in

* 6.6: https://lore.kernel.org/all/20260529181639.417037-1-sven@narfation.org/

  - applied when using the correct order - no actual change in the patch

* 6.1: https://lore.kernel.org/all/20260529194529.471742-1-sven@narfation.org/

  - applied when using the correct order - no actual change in the patch

* 5.15:

  - it depends on the also missed patch (with context conflicts):
    https://lore.kernel.org/all/20260529200201.476164-1-sven@narfation.org/
  - applied when using the correct order - no actual change in the patch:
    https://lore.kernel.org/all/20260529200323.476654-1-sven@narfation.org/

* 5.10:

  - it depends on the also missed patch (with context conflicts):
    https://lore.kernel.org/all/20260529201109.479022-1-sven@narfation.org/
  - applied when using the correct order - no actual change in the patch:
    https://lore.kernel.org/all/20260529201235.479508-1-sven@narfation.org/



In case of questions regarding the order of patches, you can refer to:

* https://git.open-mesh.org/batadv.git/log/?h=batadv/lts/7.1
* https://git.open-mesh.org/batadv.git/log/?h=batadv/lts/7.0
* https://git.open-mesh.org/batadv.git/log/?h=batadv/lts/6.18
* https://git.open-mesh.org/batadv.git/log/?h=batadv/lts/6.12
* https://git.open-mesh.org/batadv.git/log/?h=batadv/lts/6.6
* https://git.open-mesh.org/batadv.git/log/?h=batadv/lts/6.1
* https://git.open-mesh.org/batadv.git/log/?h=batadv/lts/5.15
* https://git.open-mesh.org/batadv.git/log/?h=batadv/lts/5.10

Regards,
	Sven
--nextPart10869751.nUPlyArG6x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQS81G/PswftH/OW8cVND3cr0xT1ywUCajV0SQAKCRBND3cr0xT1
yz4iAP4vZStcHduf48GIm3WEX3lbGoavCrwDG4MGgormdy1dfgD/V7oe7QkbcoRF
Nf1Mn834c1kUbkN0XQ8L3fH0KkkTBgI=
=BZrv
-----END PGP SIGNATURE-----

--nextPart10869751.nUPlyArG6x--



