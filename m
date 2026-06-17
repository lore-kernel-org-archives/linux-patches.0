Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC7E838B149;
	Wed, 17 Jun 2026 14:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781704875; cv=none; b=ZHYH/eQwinYXl5Zqd0JXPPgrEAcsoVoNi73YiwCLPB+QUMUJr5J5QWmsemp6oK/fJ7QnNNGrpLuUDMaBI6UwzTaU3DPTPHScyZPYYKlcO/aRr7fiIocMUKA+vPsBCkqoJmAEv8/3h0wWaQ77IhmAZtUmFWR1wCOyTDbwAz1knDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781704875; c=relaxed/simple;
	bh=TIusgAdoSDza+x4r7JCqo0en5rY2AGlu+NtIOjX2TyM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JJHufcSoMXcMfTdNrfgbwbC10+J2+VmnLDa3lHtEyXjdMmsYuWlCfXhy2LTjLKITlfQFRsAV98YZ5pHTHJbT5ApGTEahjwAmJCRdEIOJ5Nj+rfqVpf2pNtZOUIQ6o0qv/29PCUnykLnlYkQ1RfjRSIu7CbmTx+NSB5Fe38Sdkpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HVJN9GtG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HVJN9GtG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 884891F000E9;
	Wed, 17 Jun 2026 14:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781704874;
	bh=dixPDattbyK6aGZAeEkXBvNOuSSv7cgGd6Gw3GLt8J8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HVJN9GtGuti537H1wpbwqt3fB9eVSP4YcQxe3QaTEeFrrBPWVpHWS+3Tv6OXTl6lO
	 12S5DIZg7RveuVPyx3FATpDbyTZzVVg4DjgOq+Wuzc/m5Yr43UxhV5QD4tnNuaS1ta
	 69RTcT38ujPt9nPRrBwPzFH/gB8tTFYDUrsw82zg=
Date: Wed, 17 Jun 2026 19:30:06 +0530
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 035/342] batman-adv: tp_meter: fix race condition in
 send error reporting
Message-ID: <2026061757-proximity-donator-6940@gregkh>
References: <20260616145048.348037099@linuxfoundation.org>
 <20260616145049.888286838@linuxfoundation.org>
 <f0be2ecfe2c27c1920a44b6f41d8db87611267f1.camel@decadent.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f0be2ecfe2c27c1920a44b6f41d8db87611267f1.camel@decadent.org.uk>

On Wed, Jun 17, 2026 at 11:01:11AM +0200, Ben Hutchings wrote:
> On Tue, 2026-06-16 at 20:25 +0530, Greg Kroah-Hartman wrote:
> > 5.10-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Sven Eckelmann <sven@narfation.org>
> > 
> > commit 71dce47f0758537fff78fddb5fb0d4632d29b29f upstream.
> [...]
> 
> No objection, but this is missing from the 5.15 and 6.1 queues.  (It was
> already applied to 6.6 and later.)

Good catch, I've queued both of these up now.

greg k-h
