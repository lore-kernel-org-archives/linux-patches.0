Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C77A22DFBC;
	Thu, 17 Apr 2025 10:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.60.130.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744884885; cv=none; b=HSS1l3GPuQ7bMejcvvXw2C1DMbCVkwT0D2bWxlez0xFKXt2aWd2NDhuE3JPqAWaOn81kJWYo1C5Zz3f3YzaLvSOjPowemi1vTG+DrJ4FqI/E1UHv1xnBlrrGw+9Q45XF6WuikAhtxcukLXZgRTj7iNLSrYIIci9JStqQXMTppPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744884885; c=relaxed/simple;
	bh=+urKNUkM3t2RlrAPTSwC9MS3NCtCtypvl5ACUzDcw/8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pzShXuDUhRkI89h55awJfyicjCxmNZah8ELj4+Sv8t4jqL3dw129eD7EqlI6cO8ji/nTKYoO/2T9+1iRG5XTeMIWHtkm1F/VCCF4bnUUVly6ilzJoisoJ9CC8a1rfTniI4zTr26FTLfWEyi29gwJWdyXSXboSJBg8fp1Iw95LwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com; spf=pass smtp.mailfrom=igalia.com; dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b=JST9YclK; arc=none smtp.client-ip=178.60.130.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b="JST9YclK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=TYrZHwXvVeYQH2JRTv8n+wK2dCMJNjDZ2+cJBh164J4=; b=JST9YclKQRfWcVlPcEJIHIFe7Q
	z+p/HY9UgJGXoed6d/Mojnko6qqqbFxwPbUX5wiLQDUcIcsamYoQynzOwX+qe6d9HOJ2EA1EOeMS7
	6Bqmz6wQ4zVpsnO/r9LoKRj//gNK3kaPicG09xbbsB2yvBDNQQTEGGMHrx2QPTbbmsy0FVKhN2kEI
	KWD+3I+fqKBb9J5wEs1MiIczy0oQ3tPho/KIoSt6GS4Yl1gOWjIDOL77m5Kz5QgA2rNAy8H8Wil20
	a6K6FoEuzMUcsesuQkhsdarRwst3e8bBnGPGppgjTKUmDh+GhnysEDm2rNdeCihVxcELBBeb+E42O
	D7yMUECA==;
Received: from 179-125-92-204-dinamico.pombonet.net.br ([179.125.92.204] helo=quatroqueijos)
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1u5MGR-000lOr-1N; Thu, 17 Apr 2025 12:14:35 +0200
Date: Thu, 17 Apr 2025 07:14:28 -0300
From: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
To: jianqi.ren.cn@windriver.com
Cc: gregkh@linuxfoundation.org, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	davem@davemloft.net, kuba@kernel.org, sashal@kernel.org,
	pabeni@redhat.com, edumazet@google.com, yajun.deng@linux.dev,
	yuehaibing@huawei.com, dan.streetman@canonical.com,
	steffen.klassert@secunet.com, netdev@vger.kernel.org,
	i.maximets@ovn.org, kuniyu@amazon.com
Subject: Re: [PATCH 5.10.y] net: defer final 'struct net' free in netns
 dismantle
Message-ID: <aADUhH5-ee0Rc_Ap@quatroqueijos>
References: <20250417075740.1747626-1-jianqi.ren.cn@windriver.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250417075740.1747626-1-jianqi.ren.cn@windriver.com>

On Thu, Apr 17, 2025 at 03:57:40PM +0800, jianqi.ren.cn@windriver.com wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> [ Upstream commit 0f6ede9fbc747e2553612271bce108f7517e7a45 ]
> 

I don't see it in 5.15.y. Can you prepare a patch for that branch too?

Thanks.
Cascardo.
