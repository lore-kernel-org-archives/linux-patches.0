Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E0A023ABA8;
	Sat, 16 Aug 2025 13:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755349800; cv=none; b=OuwoQrsw4V0yb85YBpDxkT9/qeEGa7b76mRRm88uV0sbn89DYLltmXS96f6kLH/MdCaPz4TtJEX7knFSAd3PERtQfCabQvA0+fdb4dCPsX3rbFy0fXLX2CugbPTyjQT0F405QDqV4FqMc//jpimCzkcSE2UtAs7HIWppk2h5ymQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755349800; c=relaxed/simple;
	bh=WCzugAa8NfIcrwg9w9x3VRT2U5Q71BphvrzagKgIwBE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b+jzrEtvQSyRCaNOFcmUaN/hJQ35U2R0oxSs042eTVvTW5Bi+cYGwp4n6nN2MGjYf7hFy9YgIIIpyrw63pn+HpCxihMFNcgdZ2aQlFS0n7/mTpi6kDScmaKjXnDnE39yTJONHg39SdCsJu2naH23mrMjRgdOWV24FFbAWjBwong=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=enapnd71; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="enapnd71"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1287C4CEEF;
	Sat, 16 Aug 2025 13:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755349800;
	bh=WCzugAa8NfIcrwg9w9x3VRT2U5Q71BphvrzagKgIwBE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=enapnd71gvn+2pALMJWMVgUu//0QvM2EQng1lsny9msCtdoZyWnBMOII9rkaFqp21
	 2PDskO4EYAn5TKhNaqYrD6lERwepTnjbZq7puCzup9gRKiGcEUCXKQMin+nesxZaZ3
	 b2849U9ky3DyKGDCewcMiKVS+VN5HpssxCrkkXHCq90KRctPD9ZPMe3SPqnwVN+r2g
	 yAE7ZQS27qexzlJmJoD/oI4S+Kq5ybUABTOxArq4dELHx7cknJ1+9cVVeyQOWVEePV
	 4sfQ6TmYLRnIzyd4gzQvhnskgY8Y/abo1buggcts3vHSP5QY1TNn9naqumTw7NWfaU
	 1XMGmP3jTzd1A==
Date: Sat, 16 Aug 2025 09:09:58 -0400
From: Sasha Levin <sashal@kernel.org>
To: Mark Brown <broonie@kernel.org>
Cc: patches@lists.linux.dev, stable@vger.kernel.org,
	Romain Gantois <romain.gantois@bootlin.com>, lgirdwood@gmail.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.16 09/85] regulator: core: repeat voltage
 setting request for stepped regulators
Message-ID: <aKCDJneZp4OXJRxJ@lappy>
References: <20250804002335.3613254-1-sashal@kernel.org>
 <20250804002335.3613254-9-sashal@kernel.org>
 <38852b6e-20b3-43fc-90d7-29d10fd90abe@sirena.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <38852b6e-20b3-43fc-90d7-29d10fd90abe@sirena.org.uk>

On Mon, Aug 04, 2025 at 12:36:08PM +0100, Mark Brown wrote:
>On Sun, Aug 03, 2025 at 08:22:18PM -0400, Sasha Levin wrote:
>> From: Romain Gantois <romain.gantois@bootlin.com>
>>
>> [ Upstream commit d511206dc7443120637efd9cfa3ab06a26da33dd ]
>>
>> The regulator_set_voltage() function may exhibit unexpected behavior if the
>> target regulator has a maximum voltage step constraint. With such a
>> constraint, the regulator core may clamp the requested voltage to a lesser
>> value, to ensure that the voltage delta stays under the specified limit.
>
>This needs a followup fix which isn't in mainline yet.

I'll drop it, thanks!

-- 
Thanks,
Sasha
