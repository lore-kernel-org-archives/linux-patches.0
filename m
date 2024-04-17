Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F3401487C0
	for <patches@lists.linux.dev>; Wed, 17 Apr 2024 16:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713370123; cv=none; b=pVJ93I9PhJ2NhIBOHWbX4sIJRAHq2nOZiYonmBQDDPV+XcESDRCDpTNxqX+iuz0P2l9QdU2lu43MHE6bZ9qEcFtJmW8lJWo9lz+01clu9jDpWwRd1r5bClWeXjNGLlQsetJTyMUrQi0CvO6tsFdSJqDfPtPIvAa4GNLiq1VVas0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713370123; c=relaxed/simple;
	bh=26a4q1b+qSqumSamso89ZepY6YnikGWu88avFTTGmt8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i2osY9AWNt3OEYs5niKsr3aqjJ4TTeclY6cXdXn6QGlEYH7cwMJc86Wh+lQm5PBN2QG9ndKrdCDsJ/5hwKusG4E8t8oRJWYWLcBhL9CvNnTILoJaXOEncP3K+1fu3araFAfi1dBEh/IOhnv9FgawLOt2ouk5RIsXti/gkZiVWds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [172.18.169.210] (ip-185-104-138-26.ptr.icomera.net [185.104.138.26])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 4500961E5FE05;
	Wed, 17 Apr 2024 18:07:50 +0200 (CEST)
Message-ID: <23faa727-4b1e-4eb2-9e43-c10b8fadaa23@molgen.mpg.de>
Date: Wed, 17 Apr 2024 18:07:46 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 42/74] x86/cpu/vfm: Update tpm files
To: Tony Luck <tony.luck@intel.com>, Peter Huewe <peterhuewe@gmx.de>,
 Jarkko Sakkinen <jarkko@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, linux-integrity@vger.kernel.org,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <20240416211941.9369-1-tony.luck@intel.com>
 <20240416212202.9452-1-tony.luck@intel.com>
Content-Language: en-US
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20240416212202.9452-1-tony.luck@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Dear Tony,


Thank you for your patch. It’d be great if you changed the commit 
message summary/title to be more specific. Currently, the short log, 
`git log --oneline`, is not very meaningful. Maybe:

tpm: Use new VFM macro INTEL_ATOM_AIRMONT

or

x86/cpu/vfm: Use macro INTEL_ATOM_AIRMONT in tpm


Kind regards,

Paul
