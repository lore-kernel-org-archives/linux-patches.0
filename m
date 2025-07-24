Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AFA65D8F0;
	Thu, 24 Jul 2025 23:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753398703; cv=none; b=L2gPMDR2ovm2o+ElQdrSAvy5cqTx1jQV8Z1jDuP7YjiSGjQDPGU3SNBNf7+5DNA4XwKJf7QmGO8oeWZrhQPpLR6N6mF3VwRkpl+d2LgKTUTGrC0cvrU83S3BJgkSjNtKigmh1hUalZFDoI2CAGvjbDbGYZz+RJliKqR4BGXXbro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753398703; c=relaxed/simple;
	bh=d8TxaSu4kxZ/sIHDsC99YRNlTS6fUD2FC+qEt1/EWbQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jbz8B7+myUdrZUFr8aR3OMNUO9a5tFPOXYPtdxMJolL+/h1JFold9olJcR/VnyuceaVZZgJCgDeX11EcfbPfrHr54hL67d6cJgDy1kx1HiFZzOwT7AXgA1RQpp7b6b0nZdFJbrSWh1YbNmOasvwC2HEGol3iMoGXzIlMw8CMXQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KZ8su6R2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KZ8su6R2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB2B9C4CEED;
	Thu, 24 Jul 2025 23:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753398703;
	bh=d8TxaSu4kxZ/sIHDsC99YRNlTS6fUD2FC+qEt1/EWbQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KZ8su6R2yWEsZ7Ud+LAtyl8cvvgx8UeUWv4PZVdX0nRWLEJCD8A0AB1Mqc8nl/kYD
	 An4GbMOIbvuuVFRaQ38unWjHkJX69/krkz35dnljn8A/j3xya210r2+mmOKV6lTb8m
	 KDzCYo8TmsuhI0AF2JED17xaesP0UjhAhqXf7DW1v4+YSHKQZ7s2AwvlKJ+RmcNgzo
	 TWE37wrV3cUg486AVe6Fjl8KUsMw9PfuzGEpMECYuWBfvi4VxfIjRPYWfULBZZPRoR
	 rhkNVjUMwPSw4RUmj7uzoZtcwLb9XjoNTJM1qopX+lSCWO0xVWzmdmzhTn5sXcFykk
	 M4k3fH09ig9Qw==
Date: Thu, 24 Jul 2025 16:11:39 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, llvm@lists.linux.dev,
	patches@lists.linux.dev, stable@vger.kernel.org
Subject: Re: [PATCH v2] usb: atm: cxacru: Merge cxacru_upload_firmware() into
 cxacru_heavy_init()
Message-ID: <20250724231139.GB3620641@ax162>
References: <20250722-usb-cxacru-fix-clang-21-uninit-warning-v2-1-6708a18decd2@kernel.org>
 <2025072433-professed-breeding-152a@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2025072433-professed-breeding-152a@gregkh>

On Thu, Jul 24, 2025 at 11:33:51AM +0200, Greg Kroah-Hartman wrote:
> On Tue, Jul 22, 2025 at 12:11:18PM -0700, Nathan Chancellor wrote:
...
> >  drivers/usb/atm/cxacru.c | 106 ++++++++++++++++++++++-------------------------
> >  1 file changed, 49 insertions(+), 57 deletions(-)
> 
> Sorry for the churn, but hey, it's less code now!
> 
> Nice work :)

Agreed, thanks for forcing me to address it in a more robust way :)

Cheers,
Nathan
