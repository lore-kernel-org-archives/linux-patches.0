Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EBCC193086
	for <patches@lists.linux.dev>; Fri, 14 Jun 2024 10:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.149.199.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718360362; cv=none; b=mOeu6WEssMNXxftIEgSqwF9vnW7JEx5ODUTX3NVf6JtcoFKNVQ+SnB+m/b6q8Ma7K+kcY/GLGHIl+uJhUCJnsO+b+il5qrQaq1Yj40Ng8zvgaQrVmMvt6bT3EbQvs/aPPFUSVF82Fqd0GEWKfwyXmtySBZgJfkjYYjbY8qMPG50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718360362; c=relaxed/simple;
	bh=vPui0HMuypqfFk1YqQTMYprp1+TouQfcH0F3cHLqzyQ=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=cjQ+fLZf0aKdmN6WA43aSjumG2yBIn/T6ftTZQlY8I1XBWg5Hmf1RFm/9HyLFqVxSAe9n6dIkwJR+FroiSf8XvJk8+opfkxPFSX9cQWt5XkGSOeircU1weglDWWXjwlLpuwsqJSGhoBxCiOA/4oenftWOpTuCPxki96/JlSKsYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru; spf=pass smtp.mailfrom=ispras.ru; dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b=sfSeSs4k; arc=none smtp.client-ip=83.149.199.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ispras.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b="sfSeSs4k"
Received: from [10.10.2.52] (unknown [10.10.2.52])
	by mail.ispras.ru (Postfix) with ESMTPSA id 88E654076739;
	Fri, 14 Jun 2024 10:19:18 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 88E654076739
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1718360358;
	bh=2JKLFIjl8ixArdgVrJ5DBpdunmYy3E2bCd6ZiZ1wUbI=;
	h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
	b=sfSeSs4knkQcnJ6PItgIlxeugi9O0iu4i+i+3GUs59wqUQAfcBj3tMtCduhc2hoYG
	 wZ30sgkyW9HdviNVa9VH9f1nw8B4X6o2uNouPGnrIUybYY9cP0tDLCa3Csd1akNZZx
	 /NiWL9pn0gZ9e5Ndj4Laytj310iIrUFk76Eldluc=
Subject: Re: [PATCH 6.6 267/301] Revert "drm/nouveau/firmware: Fix SG_DEBUG
 error with nvkm_firmware_ctor()"
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 Dan Moulding <dan@danm.net>, Dave Airlie <airlied@redhat.com>,
 "lvc-project@linuxtesting.org" <lvc-project@linuxtesting.org>
References: <20240514101032.219857983@linuxfoundation.org>
 <20240514101042.344516025@linuxfoundation.org>
 <1fc2fb82-aad2-8587-cc5a-2076d1f63862@ispras.ru>
 <2024061447-clamp-pretender-bac9@gregkh>
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
Message-ID: <3bb5ed3c-8797-2cf8-c684-0b1553080c94@ispras.ru>
Date: Fri, 14 Jun 2024 13:19:18 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <2024061447-clamp-pretender-bac9@gregkh>
Content-Type: text/plain; charset=utf-8
Content-Language: ru-RU
Content-Transfer-Encoding: 7bit

On 14.06.2024 12:42, Greg Kroah-Hartman wrote:
> On Fri, Jun 14, 2024 at 12:34:02PM +0300, Alexey Khoroshilov wrote:
>> On 14.05.2024 13:18, Greg Kroah-Hartman wrote:
>>> 6.6-stable review patch.  If anyone has any objections, please let me know.
>>
>> A little bit strange situation to add and revert commit in the same
>> stable release.
>>
>> Is it intentional? Or some scripts should be updated to avoid that?
> 
> Totally intentional, otherwise we would notice that the original commit
> was not applied later on and try to apply it there again.

Thank you for the clarification!

--
Alexey
