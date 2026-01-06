Received: from angie.orcam.me.uk (angie.orcam.me.uk [78.133.224.34])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49D301514E4
	for <patches@lists.linux.dev>; Tue,  6 Jan 2026 13:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=78.133.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767705487; cv=none; b=fq8cRGZcYNF/Y6rRQyZou/oI50Tye1d3Ct4MrFCCM7z2xLSfOqaQqJSdL30jWnLl/nVopvcihhqlHvC1tmyQAetFbimt7rXcv9sEgN8K5chbRyIwvGSfkiYim3qYXNR3r8fuQIHP2SBdLuBpZZweq1y1p8yZB0h8lOVpsKdvxso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767705487; c=relaxed/simple;
	bh=FvgYQCSMaEmREp2BIkvfdZGmDkPftaOHaA5gRT1oBcE=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=d3shtHc38yy8McdatnKHa5CxYCLXI9O4ExZlz7lASscSfo7vAia+eTkch7rxLYU1PJX1Dg0hUfCQdU9Oe+Aui6gfEurVN5/QMV8zOhJEPgNCg/s2C4AW7I21O5BlIxwmlAFGFmSxNqvPLy7i2qpXM5FI3R2dPTAo8eYTWjKZo8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=orcam.me.uk; spf=none smtp.mailfrom=orcam.me.uk; arc=none smtp.client-ip=78.133.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=orcam.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=orcam.me.uk
Received: by angie.orcam.me.uk (Postfix, from userid 500)
	id 84D7192009D; Tue,  6 Jan 2026 14:17:57 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by angie.orcam.me.uk (Postfix) with ESMTP id 8234992009C;
	Tue,  6 Jan 2026 13:17:57 +0000 (GMT)
Date: Tue, 6 Jan 2026 13:17:57 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@orcam.me.uk>
To: Magnus Lindholm <linmag7@gmail.com>
cc: Askar Safin <safinaskar@gmail.com>, 
    Richard Henderson <richard.henderson@linaro.org>, 
    Matt Turner <mattst88@gmail.com>, linux-alpha@vger.kernel.org, 
    kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org, 
    patches@lists.linux.dev
Subject: Re: [PATCH 1/1] alpha: trivial: remove ^L chars
In-Reply-To: <CA+=Fv5Ra7fFTd2wA77iM_6X7NooApfoMJX5z1j60cXex_uxm7w@mail.gmail.com>
Message-ID: <alpine.DEB.2.21.2601061310110.45251@angie.orcam.me.uk>
References: <20251228063440.2623595-1-safinaskar@gmail.com> <20251228063440.2623595-2-safinaskar@gmail.com> <CA+=Fv5Ra7fFTd2wA77iM_6X7NooApfoMJX5z1j60cXex_uxm7w@mail.gmail.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Mon, 5 Jan 2026, Magnus Lindholm wrote:

> For a v2, please consider adjusting the commit message rationale away from
> personal tooling and towards general readability and editor/tool compatibility.

 As a matter of interest, why would the presence of ^L characters cause 
any issues?  That is just another instance of white space and it has been 
commonly used across some source code to separate functional parts, e.g. 
in the GNU toolchain.  It can be ignored unless you actually send the code 
to a printer (which I suppose hardly anyone does nowadays).

  Maciej
