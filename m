Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B60653093A8;
	Wed, 28 Jan 2026 16:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769616815; cv=none; b=gm7+XPjWmNPM2/y1vLsfKE4c+Jz3RvEj2kuAiIreUkt+TUcN2EyIn58ThulrWCkc5tFvao9iOWicDzfWnFYdurMPSWo0z9c4q9GNdQGlD+Cuy1CkxsfFZ/euc9myK9pshYMkLtcTxyNhnBGuTxexIgqyXdnkFfslBp+rWIsJrnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769616815; c=relaxed/simple;
	bh=YUMH9wHFkWa24wUo5erI81UQEsMCysAce2pmi8ZWsTA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FPziNdIWG0sLFJhqDKVT015WHTYI3TqlJB25fCmFQKagd6aT8J/kGYjFM/luuRCcNY6gtCP9tcxLbQFQ2EnAYxbLHce3nq/emRDBcp4ToMaYNwRXUOxN6gjvVgkaQO3pf9Wc2tDeatOoHIEwPzRpVVWEKJtlXIGJde50xKLpPfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h5lcDjZa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h5lcDjZa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E274FC4CEF1;
	Wed, 28 Jan 2026 16:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769616815;
	bh=YUMH9wHFkWa24wUo5erI81UQEsMCysAce2pmi8ZWsTA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=h5lcDjZaolFwH1wlFeKasRK1ys+NE5zN/v76D15WJ00e1szTf+SnxdSPPEN5dx05W
	 csLIXkwMjnkv0xzWcy5tlNNDSN8AJ/auNIygLLSqgl4RAe/sK7fkYqYR7jolr8jLUG
	 rhN46eDv3RlflbTretMJm16moS9ToUO+OuAwwfNLrgBJVQ+xxX7aghl4JEtu8BAMTt
	 Ug/nJ3L66uCpSAqCLNJjectAplVCYIPKFWkdeMDFXsPDUhUDPgQGZ5K5VjjXOVTGw0
	 MxwWe8lPOUKSYIU1G03+XSJ5Y1wXRzG77Ne7WowYy8blV2rmXPhQnL+Q39jyn/Jjvk
	 swlV8l6fgp4Gg==
Date: Wed, 28 Jan 2026 13:13:31 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Leo Yan <leo.yan@arm.com>
Cc: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>,
	gregkh@linuxfoundation.org, irogers@google.com,
	james.clark@linaro.org, namhyung@kernel.org,
	patches@lists.linux.dev, sashal@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 6.6 176/737] perf arm-spe: Extend branch operations
Message-ID: <aXo1qx1b3HW_HQS3@x1>
References: <20260109112140.649989422@linuxfoundation.org>
 <20260127183832.458213-1-hamzamahfooz@linux.microsoft.com>
 <20260128090223.GD1339236@e132581.arm.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260128090223.GD1339236@e132581.arm.com>

On Wed, Jan 28, 2026 at 09:02:23AM +0000, Leo Yan wrote:
> Hi,
 
> [ + Arnaldo ]
 
> On Tue, Jan 27, 2026 at 10:38:30AM -0800, Hamza Mahfooz wrote:
> 
> > It appears that this patch broke the build, see:
> > 
> > In file included from util/arm-spe-decoder/arm-spe-pkt-decoder.h:10,
> >                  from util/arm-spe-decoder/arm-spe-pkt-decoder.c:14:
> > linux/tools/include/linux/bitfield.h: In function ‘le16_encode_bits’:
> > linux/tools/include/linux/bitfield.h:166:38: error: implicit declaration of function ‘cpu_to_le16’ [-Wimplicit-function-declaration]
> >   166 |         ____MAKE_OP(le##size,u##size,cpu_to_le##size,le##size##_to_cpu) \
> >       |                                      ^~~~~~~~~
> > linux/tools/include/linux/bitfield.h:149:16: note: in definition of macro ‘____MAKE_OP’
> >   149 |         return to((v & field_mask(field)) * field_multiplier(field));   \
> >       |                ^~
> > linux/tools/include/linux/bitfield.h:170:1: note: in expansion of macro ‘__MAKE_OP’
> >   170 | __MAKE_OP(16)
> >       | ^~~~~~~~~
 
> FYI, the fix has been sent out:
> https://lore.kernel.org/linux-perf-users/20260123-perf_fix_bitfield-h-v2-1-cc8f8752607c@arm.com/

Thanks, applied to perf-tools-next, I also added a Reported-by: Hamza,

- Arnaldo
