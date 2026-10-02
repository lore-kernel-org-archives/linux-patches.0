Received: from mail-qv2-f41.google.com (mail-qv2-f41.google.com [74.125.230.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D447D4B7A53
	for <patches@lists.linux.dev>; Fri,  2 Oct 2026 13:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790949039; cv=none; b=rpQKnLWYToOZ+PWQdDA5rWeOIGE58LG2USMq+HVnzDJ4A/E40kNtZoKPqjbdBngxqjnL7JbnUbnMt/O6EFrRve96CzLRWg2YDFhcn+7x0IM1qtVlX1dg/7epmTZPvLWu5xzwpnqw1P7VRw9J8hCK9LjjPjoGjawE+lLQW3k4uCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790949039; c=relaxed/simple;
	bh=YAbhCEsj1Xow+kprODecviF0SnZgAch7eBzBEf5i7yk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LSOGhHAEQdkle8aMZTr8ZoIPoAmRRE9QBA82AduLHNqo8U4GSUz7Qj1yxUCRRFmAHQruwnXrnEHkTVeQslpK7ytBB4YoaJUq0W25nqlxzAc6329o5HQ2DA8BJJLi/IUxw0lv9Px+DAJFHXM8aaOKiUa7os+pj1k1yaK9DtpUc0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=HTl+F8td; arc=none smtp.client-ip=74.125.230.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="HTl+F8td"
Received: by mail-qv2-f41.google.com with SMTP id 6a1803df08f44-91786d375bbso683576d6.0
        for <patches@lists.linux.dev>; Fri, 02 Oct 2026 06:50:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1790949036; x=1791553836; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:sender:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=lS1VVahwxyy3uHWOK8ukiwzRDiQgwlDYS5Uok3wV7Vc=;
        b=HTl+F8tdD71bUt67yg9IaOuAtZ0DGJhxeqFqHx1E1GENLVAKMtqNCxnWTDCju/29ul
         aE3c3PmH6ykYJ/PkUW3rlRDoHvxn84BMffLI9FpGMM9iZ/7DZ/4frE9XpgjbX5AI5Ohj
         r+v1pCHtmSDXiegNI+v0IeiooDZRAP2tfpQxo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790949036; x=1791553836;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lS1VVahwxyy3uHWOK8ukiwzRDiQgwlDYS5Uok3wV7Vc=;
        b=NinPLX2uv6p7RiY6GXZBjVE7bWHo+a5RWVHxEnoBbB3fb0ZlyN6H/405Dt1RcZaFn0
         g+4D56AaWgm9A50pGvQx5FRnM4k4CLM3bZNSbHGTeHb/cM1GcdeIzgJQLgOc4yU1lTUS
         zU+GP3+CEf4JZ6yBp+5MTWphQqXHmat16OIr8VgPOEFZxDscYxlB4fNUYcJZ9w/HhoI2
         /W+NMo3AjUCdfSjao9YcT0LJznMYxLWEU3o+3vBK+dC/RRdw5RGZmlCUMjbjpHnWqED2
         X4eD2z2LfBBEBx1V1B3haOhigl7RKRBlwSamtKuZAfrUXPDtHFZ7KpnLn+QWxA+N4LEz
         PT4g==
X-Forwarded-Encrypted: i=1; AKwUvByXFwkFIKccWn0hSsyUDOWmccgI/UbQwmFkyF+oAuwlx0SUd0ZpicV+FO9WD4aKhxcZcBa+p5K3@lists.linux.dev
X-Gm-Message-State: AFuF++l0qCBidh47D7lXJ1t4VGvLeVx3lGz1zzkZcnpuvpw7EYAP4KNX
	WxyxaUZcBHFLmzbZcoYOolQn/IsQlFq3875uRRUlUkA7z4z1P3p4V7Rw6BStjvF74Q==
X-Gm-Gg: AYBFou0nE4nDdsV8WpSl5igNmX+IRxZuu9tZl8QU89quc27Q2qN9XoaRwVMI5n1tCsm
	EpmAQvz87+CBjb90G/9Kwkm5N0xvhefJHxs8AGzhBANb3YOEddv9zRq1jUMHaAuiv9EvzlUfAeD
	Mzus1j8GIOwLKxcUUOjX2itU3Zen1RTp2b0dMBmyn/U7UH2wWFfUhFql3NnBv0cDBwLLSKPlbVY
	bNbrVeIqOe1tQyuzpPBFh1AuPq33ziFW6cdDsHi4XznMCcuBHGEWyrCjEM6v4sfxPrjPpG5woHC
	JllgbQNmLDBuSV1Eyrrs0nr/4NZ9yFzXwuhRQyvonpCRx4NbZNaLJMF83x579KV3Y9seOmtiU+Y
	i10KXhsBY0uKLArNlrKwc4IpJetkfDqZG2mAz2kmcrezGJydAffQuvqtgATG+G1oyWsc6FYdhIV
	FwqNaR/mt3AlVTtmy4/T9+fIHNnmF28y9vPEAKqS/4JFAwwT/zvOsi9Uc7Ss9iq2VaEAIKXevYp
	mQwglwbbmYYLG9tyw==
X-Received: by 2002:ad4:5dc8:0:b0:917:8ea8:cf48 with SMTP id 6a1803df08f44-917c0023954mr55938026d6.11.1790949035586;
        Fri, 02 Oct 2026 06:50:35 -0700 (PDT)
Received: from fedora64.linuxtx.org ([98.97.107.167])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-917e0c17b8esm19945606d6.43.2026.10.02.06.50.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2026 06:50:35 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Fri, 2 Oct 2026 07:50:32 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 7.2 000/457] 7.2.9-rc1 review
Message-ID: <ar-2qLGYAeke2TUl@fedora64.linuxtx.org>
References: <20260930152346.024115587@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>

On Wed, Sep 30, 2026 at 05:21:45PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.2.9 release.
> There are 457 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 02 Oct 2026 15:23:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.2.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.2.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
