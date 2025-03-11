Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 793D9264631;
	Tue, 11 Mar 2025 20:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741724281; cv=none; b=HcU/8e34wHH3SzcEDN/C98Tfg+5QtfPf9A1Y+yMtamVYn/XLARMHGG/3wM8U30PtNHb0fqhbmvOx0bBF8PAkLkc1E4mtAdFsmc2PGDUGYz9fGbNqhxrrIjjvS4E+gkZAKcTU/UNzpeplp4h4sgj1UJgVhEOGwoyjd00o/Drk/Ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741724281; c=relaxed/simple;
	bh=ipU6W44x2RVuiuHI0LDaAlYJGW0Y2jnfnY8F1O7k+ho=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pdd/tb/USEzMQGJfP+Xf8HYQETsdYQ1yPDnIRQdeiX81Fr8DQxZ8JkCC0OPZb0jaald8zaW0frmSWhAOrnxFZwcim/8uz8hqfwuhrllp9F9d8lv3yBBaaXPLXknnWfK0wZ5X/7vXGuE6Ntl+YruAkAnGbDySaMHkA//P6id7Vzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=oc+y8f3V; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="oc+y8f3V"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=ipU6W44x2RVuiuHI0LDaAlYJGW0Y2jnfnY8F1O7k+ho=;
	t=1741724279; x=1742933879; b=oc+y8f3VATKvBK8KQO9NhS9JK/f3GY9LoA0HeGu4GjR2Mnl
	cLqEemi0OdrtmgNsBAkKQW55rRxKk8pQ2BEiQv9JSSP2Y69ykowsPJzbJYfTMjwb1CYrVR/J07B8i
	/mXZEA4+eNcx+H1q22dh0Rh+o8G427rajqC36z94dfH4INe0aHCCmsiWSuBD51qXIk3g8JRwSyPWE
	JxOHYGv7iEpRwJSV/ig8o8agqi7FRvoB4PjzXpev1e6j3RFmAWiZSYaXBivGgq1LPbHvtIMvBFsrB
	d5htyopLO8gKXPzEGBpbZk8hJ56kVsqdNGgoZ4ConFnM5gK7J3+bKLbLFu8jcQKw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98)
	(envelope-from <benjamin@sipsolutions.net>)
	id 1ts62w-000000085Mf-2Idb;
	Tue, 11 Mar 2025 21:17:50 +0100
Message-ID: <523cf45116bab7a653994d5eaf17496ed57f8351.camel@sipsolutions.net>
Subject: Re: [PATCH 6.13 000/197] 6.13.7-rc2 review
From: Benjamin Berg <benjamin@sipsolutions.net>
To: Holger =?ISO-8859-1?Q?Hoffst=E4tte?= <holger@applied-asynchrony.com>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, 	shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, 	pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, 	sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, 	hargar@microsoft.com, broonie@kernel.org
Date: Tue, 11 Mar 2025 21:17:49 +0100
In-Reply-To: <00f382c4-1347-bc6d-b3ec-427de5658cf5@applied-asynchrony.com>
References: <20250311144241.070217339@linuxfoundation.org>
	 <00f382c4-1347-bc6d-b3ec-427de5658cf5@applied-asynchrony.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.3 (3.54.3-1.fc41) 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

Hi,

On Tue, 2025-03-11 at 18:45 +0100, Holger Hoffst=C3=A4tte wrote:
> On 2025-03-11 15:48, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.13.7
> > release.
> > There are 197 patches in this series, all will be posted as a
> > response
> > to this one.=C2=A0 If anyone has any issues with these being applied,
> > please
> > let me know.
>=20
> Still missing a followup for iwlwifi as mentioned on rc1:
> https://lore.kernel.org/stable/5d129bda966b7a55b444f4d48f225038361e9253.c=
amel@sipsolutions.net/
>=20
> Not sure if that refers to the whole series or only the first patch,
> maybe Benjamin can clarify.

I meant that particular patch as it fixes a regression that was
introduced in "wifi: iwlwifi: Fix A-MSDU TSO preparation".

The other two seem like reasonable bugfixes, but I am sure they will be
picked up independently anyway.

Benjamin
