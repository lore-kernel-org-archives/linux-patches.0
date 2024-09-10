Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC8E6149C61;
	Tue, 10 Sep 2024 06:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.96.220.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725950566; cv=none; b=d/XFbDxeZSfbaGucT5iq7hS5y/u/BWKd1B+sQrTogphrN203KkIZFPMxDOTrHaaqt5PdO2Q0IcrlQpX6VPiOw5qAB844Q528d4Jbg352kAv+9F5AjSCM3js/wLkfiZdeMFhSUqkUoMyl6E2MnkQawBNhdueSy0OiJGc9jVMtKTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725950566; c=relaxed/simple;
	bh=3hdYHGbHnGbQg+Pr7BAijZVjxBRDrGvUnInEP+LTUe4=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rafKVAIDS5mic4ChJyfupklBM+qtJZEi6XWFCBVU4SQhMHlwx9SBM6CLhcTqN9ZI/EWn3Hng51RXWr3SrgLmgPH2XMmvSMLG3oi5vmRmpxOlNDFc8yu6JocYWMCi+hBzYnHJO8pKKogPs0mZ2IIJ40pVhdBUqwUXTIm6XL5dH9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=secunet.com; spf=pass smtp.mailfrom=secunet.com; dkim=pass (2048-bit key) header.d=secunet.com header.i=@secunet.com header.b=KIj/zcWl; arc=none smtp.client-ip=62.96.220.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=secunet.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=secunet.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=secunet.com header.i=@secunet.com header.b="KIj/zcWl"
Received: from localhost (localhost [127.0.0.1])
	by a.mx.secunet.com (Postfix) with ESMTP id D50C220854;
	Tue, 10 Sep 2024 08:42:41 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Bz88uQcviNit; Tue, 10 Sep 2024 08:42:41 +0200 (CEST)
Received: from cas-essen-01.secunet.de (rl1.secunet.de [10.53.40.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by a.mx.secunet.com (Postfix) with ESMTPS id 6799C2074A;
	Tue, 10 Sep 2024 08:42:41 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 a.mx.secunet.com 6799C2074A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=secunet.com;
	s=202301; t=1725950561;
	bh=3hdYHGbHnGbQg+Pr7BAijZVjxBRDrGvUnInEP+LTUe4=;
	h=Date:From:To:CC:Subject:References:In-Reply-To:From;
	b=KIj/zcWlaqG0OrZYafcHqhk0Gl4aFDFeShImgwDYEsUduaiI7UNvw5rDAdbR/vbzV
	 vGQx0EZpPnBgZ8r9fufF2T3hs4GpnntuzsawkeqAoZPq+BFsu3FzJRThcXlRMO0t3y
	 +tcND9JYz+V+8rnmo/ff6AdPhMPy3KBuXPf1W8hDAAfQiFW/MRMXZS4UCw1bBH0wqw
	 hwpg/N8EItX655fMev/z2qTAe8aGRZGGSov7/BxTAM4B348//Bn2ppWL5V8fTb9jaQ
	 aDp1o3LIZqbCQDj2RnnYGmIbhfv/So2Pmu3oAt3wTeWJzoi722amzHV24aIljUZu6o
	 t+mV0ubettK0w==
Received: from mbx-essen-02.secunet.de (10.53.40.198) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 10 Sep 2024 08:42:41 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-02.secunet.de
 (10.53.40.198) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 10 Sep
 2024 08:42:40 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
	id 1D0C2318146C; Tue, 10 Sep 2024 08:42:40 +0200 (CEST)
Date: Tue, 10 Sep 2024 08:42:39 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Nathan Chancellor <nathan@kernel.org>
CC: Herbert Xu <herbert@gondor.apana.org.au>, Florian Westphal <fw@strlen.de>,
	<netdev@vger.kernel.org>, <llvm@lists.linux.dev>, <patches@lists.linux.dev>
Subject: Re: [PATCH ipsec-next v2] xfrm: policy: Restore dir assignments in
 xfrm_hash_rebuild()
Message-ID: <Zt/qX2RoOWSkTwOF@gauss3.secunet.de>
References: <20240829-xfrm-restore-dir-assign-xfrm_hash_rebuild-v2-1-1cf8958f6e8e@kernel.org>
 <20240909150934.GA1111756@thelio-3990X>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240909150934.GA1111756@thelio-3990X>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-02.secunet.de (10.53.40.198)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10

On Mon, Sep 09, 2024 at 08:09:34AM -0700, Nathan Chancellor wrote:
> Ping? This is still seen on next-20240909.

Sorry, there was some delay due to travelling on my side.

This is now applied to ipsec-next, thanks Nathan!
