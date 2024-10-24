Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [96.44.175.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 742051EF955
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 15:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=96.44.175.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729784357; cv=none; b=jnU9t+HTC3FsUqtQQ+qVSqUkxuDr4dIfJ/GU7bAt+JwcXAc4jGwl+qeripHQNfS4dhTGPHPhxxpjX7VYEdX/cBPU3Gogo4f4UCcJAXYm/bb8k82px5yg+8ugPt4HcYeuzvbajTHr9MkPEe3Wpt3qCyg4rMuNdyCuzOiNsIVkL3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729784357; c=relaxed/simple;
	bh=Ko5wG55xDHelASXjan0ot///NzLfDIdQQc92FPfKpno=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:Content-Type:
	 MIME-Version; b=jwrKzWzSV30l5FV7DEYUd69AL7g2W1f7Anbr5tB8XKTI2ANSOO/pnyPKfPkrlqrhZHf3rtDejXTKs1ZVlVc3lqrbbiIRGstxQo+YcBnOtyonBMQ9waNYpq2udZzN8Hi6A1ozJXNI09y+yu0j+YE2ddz8A55fWtf5RjD1OMMIPtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=rr13seJ1; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=rr13seJ1; arc=none smtp.client-ip=96.44.175.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="rr13seJ1";
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="rr13seJ1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1729784354;
	bh=Ko5wG55xDHelASXjan0ot///NzLfDIdQQc92FPfKpno=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:From;
	b=rr13seJ10RBXwD1zY0BmxemgHOVWWJXsHABLSDjp8dmYRpQvfYhby0pS7MJz/cCWv
	 W3Q6RaAqy+mJeSumLEjGfEiI/Zl7e593MzzZCO0I6k8YxS9YmGtRiAqNq46AQF0h1t
	 QXYjrOkNZI4Os4do+EQCjjuCOFnGOSfjI1z8iIUE=
Received: from localhost (localhost [127.0.0.1])
	by bedivere.hansenpartnership.com (Postfix) with ESMTP id C87E51280E5D;
	Thu, 24 Oct 2024 11:39:14 -0400 (EDT)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
 by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavis, port 10024)
 with ESMTP id x2KAlgYTN2fP; Thu, 24 Oct 2024 11:39:14 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1729784354;
	bh=Ko5wG55xDHelASXjan0ot///NzLfDIdQQc92FPfKpno=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:From;
	b=rr13seJ10RBXwD1zY0BmxemgHOVWWJXsHABLSDjp8dmYRpQvfYhby0pS7MJz/cCWv
	 W3Q6RaAqy+mJeSumLEjGfEiI/Zl7e593MzzZCO0I6k8YxS9YmGtRiAqNq46AQF0h1t
	 QXYjrOkNZI4Os4do+EQCjjuCOFnGOSfjI1z8iIUE=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4302:c21::a774])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(Client did not present a certificate)
	by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 188A41280E13;
	Thu, 24 Oct 2024 11:39:14 -0400 (EDT)
Message-ID: <7ee74c1b5b589619a13c6318c9fbd0d6ac7c334a.camel@HansenPartnership.com>
Subject: Re: [PATCH] MAINTAINERS: Remove some entries due to various
 compliance requirements.
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: geert@linux-m68k.org
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Date: Thu, 24 Oct 2024 11:39:11 -0400
In-Reply-To: <a520d1f5-8273-d67e-97fe-67f73edce9f1@linux-m68k.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> On Fri, 18 Oct 2024, Greg Kroah-Hartman wrote:
> > Remove some entries due to various compliance requirements. They
> > can come back in the future if sufficient documentation is
> > provided.
> 
> This is very vague...

We finally got clearance to publish the actual advice:

   If your company is on the U.S. OFAC SDN lists, subject to an OFAC
   sanctions program, or owned/controlled by a company on the list, our
   ability to collaborate with you will be subject to restrictions, and
   you cannot be in the MAINTAINERS file.

> What are "various compliance requirements"?
> What does "sufficient documentation" mean?

The documentation Greg is looking for (which a group of Lawyers at the
LF will verify) is that someone in the removed list doesn't actually
work for an OFAC SDN sanctioned entity.

> I can guess, but I think it's better to spell out the rules, as Linux
> kernel development is done "in the open". I am also afraid this is
> opening the door for further (ab)use...

I agree we should have been more transparent about this but I think it
would be hard for someone other than Greg to get a Maintainer removed
on the "compliance issue" grounds so it's probably not that open to
abuse.

Regards,

James


