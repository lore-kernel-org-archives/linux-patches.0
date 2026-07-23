Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 727C141B355;
	Thu, 23 Jul 2026 20:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784838815; cv=none; b=G0oUKYCsPFuknqLH9DWf1lYUPHLbbhU0BfHXIZvMXh7eH7fECWmuSdKc6CMTvHExS3e4lh5vYa4w+DKHQi2g7dMsmCeRimo1V32XU3vTr+tIR5n/OCf1MmxWqUwGJe3kaFmStLcXA1+qm1XF8Fj6he8fHqF5EaG3AA3hqehlIes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784838815; c=relaxed/simple;
	bh=DO/gJqdawW9CmZ4EJe+UiBo1+9edT2zPkjP1BwpP49o=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:Cc:To:From:
	 References:In-Reply-To; b=Bi2nlTGEuVDOOjTKXl1Z/ZASLex342/8knfiOESV3xiKggjVeKvzRb1nE8ajK2BzsEeouOOTJ2qes2uZfyhK3uQmiAOY05mcN/Vh09v4oHsujnpX+YCqz5RdbYaDgIck1kyGY7KXoDtykAjrcbpPB+YouRlwwtzxI5451mc7EPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WyQO0eHk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WyQO0eHk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6450D1F000E9;
	Thu, 23 Jul 2026 20:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784838803;
	bh=qKMBkfA4Fscc9gb2Mwxxm/SG+O1Cf4fPyQiewhN8Y88=;
	h=Date:Subject:Cc:To:From:References:In-Reply-To;
	b=WyQO0eHk6YYNhnOQuGfvCK+4OXDBlKSRtLW2n42OKeh+sdzsP4j+ATDn/yv3MXCuc
	 qIbtqjSeZ2bzRTL1G5pBiJsfWbK5TsR1OI8I38sJ08+0OkaU/yv0f7RFokmF4EAr9y
	 7vkku2frWqcCajVSImHbP0ptjJWOM1pu9W9R/IMe3l++jearHhB72v82hRjCRVs48e
	 mF4N9QL5vHzIRBMktag3UFz1fQGdrRmPzI7k9DbnWEhiDY0uR/vQ+b9Rj/oWngAKb/
	 zPpYmJNQqM5axXZFgefC3lN2fzg/EuCGmG1mMoDaewVP3BstCva8lQfn29BHlo0i+p
	 bqYwfHljPIJog==
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 23 Jul 2026 22:33:16 +0200
Message-Id: <DK68JRVCSLFU.3MCXVFEF3EE5T@kernel.org>
Subject: Re: [PATCH 6.18 0000/1624] 6.18.40-rc2 review
Cc: <gregkh@linuxfoundation.org>, <achill@achill.org>,
 <akpm@linux-foundation.org>, <broonie@kernel.org>, <conor@kernel.org>,
 <f.fainelli@gmail.com>, <hargar@microsoft.com>, <jonathanh@nvidia.com>,
 <linux-kernel@vger.kernel.org>, <linux@roeck-us.net>,
 <lkft-triage@lists.linaro.org>, <patches@kernelci.org>,
 <patches@lists.linux.dev>, <pavel@nabladev.com>, <rwarsow@gmx.de>,
 <shuah@kernel.org>, <sr@sladewatkins.com>, <stable@vger.kernel.org>,
 <sudipm.mukherjee@gmail.com>, <torvalds@linux-foundation.org>, "Eliot
 Courtney" <ecourtney@nvidia.com>, "John Hubbard" <jhubbard@nvidia.com>,
 "Alexandre Courbot" <acourbot@nvidia.com>, "Alice Ryhl"
 <aliceryhl@google.com>, <nova-gpu@lists.linux.dev>
To: "Miguel Ojeda" <ojeda@kernel.org>
From: "Danilo Krummrich" <dakr@kernel.org>
References: <20260722142910.893804136@linuxfoundation.org>
 <20260723154303.11008-1-ojeda@kernel.org>
In-Reply-To: <20260723154303.11008-1-ojeda@kernel.org>

On Thu Jul 23, 2026 at 5:43 PM CEST, Miguel Ojeda wrote:
> I suggest dropping commit
>
>   d8fa174e21c8 ("gpu: nova-core: vbios: read BitToken using FromBytes")
>
> for now -- it was not marked for stable, and as far as I know, there are
> no production users of Nova, especially in stable kernels.

Yes, we can just drop the commit. In general, for now we should only backpo=
rt
nova patches that could get into the way of testing stable releases in one =
or
the other way.

> If we want to fix the bug, then we may want a custom minimal patch.

Yeah, I don't think there's much value; in the best case it fixes something=
 that
isn't used in production anyways, and in the worst case it causes noise if =
it
breaks the build.

> I hope that helps!

Thanks!
