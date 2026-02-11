Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AECA6353ED7
	for <patches@lists.linux.dev>; Wed, 11 Feb 2026 04:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770783950; cv=none; b=UX1KVqgXnsgJtC2KOiHUZSkaPGplz8TlOjLG3NCMQKKsOI8vhxoXnxFPUCEZ3ntmGTjTkDc/cTFYMg2eqQGG75ozVhQJGioMez+C+z3aPNiC4QroAnDXw5F6d2TyMJTpxftU6clp/pe72zaXOJqtEg92Y31r+IkBhfOO/Ysc8jM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770783950; c=relaxed/simple;
	bh=JkYZnGYN+fOYzCkm7zRvBQ33rZs3x38+fabyBfvTu8A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VZu88UxdgDfEDFwTe+kJ4CB1oLYJP38y5MG1mX+qtoooibzov5gjAvJ0NA0CypEE11IQ5EaMWRDomhYvq438G6yX1qre7jJtH+L7GcTeB1dILvTgB+116Sttx4IMNhvIBaaCAS51gdlBotgbHzLfLsLlTPwoLptRSB6xfo/xvPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=cUhPU/UF; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="cUhPU/UF"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4806dffc64cso54971995e9.1
        for <patches@lists.linux.dev>; Tue, 10 Feb 2026 20:25:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1770783947; x=1771388747; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=adNnsUk/Ue+Ehcij4plZQHtF5jZOHNgjtF43mnMTFj4=;
        b=cUhPU/UFh0yRwpKNP+olBM/j+PeLFQtaCssxWWQ1MoCab0k3xsX5aSjvmytjNP0iFg
         DsDwGNoEJBbUlsHK0/ELJ0dX1iAkzDAk46BEh8WlCZwJcSkG8VL5spQ+Lv90HS/1dXDN
         mjd8ZN4Pxs8Mn6WI/aGV2N9T2MsKQWZ2v2SPp4JihNlqzJ0WfsU/+V43w5lYvb89Qs9i
         48wZRNO/Gc6KO1cvhRhgLSijDZoLWw5lM7ks8X778SBc9W70ZyUqwe1P8WAH2h7V/JnX
         yBOk/UsN+Uh6ar/8SnLk3gnBbLEbbdx7Z9kitmz6Dc6Hv/aBlpTAWVvBYwPnk9YG9p1Q
         aAQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770783947; x=1771388747;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=adNnsUk/Ue+Ehcij4plZQHtF5jZOHNgjtF43mnMTFj4=;
        b=OQ2Cmo0b+25gXbYUkNAp4ch3VlQoeBKVKLwAd6iNIomdv1f5Ct29K/1tPs//+oRpQl
         F/jjN94z+1sNjyS7nvVO1sIpIZsunWM0agPonoaycvQ0I86l/18Q3/31Cl+GiyWbJAna
         jTKRm9yuK6V9FQpBpvEyx6iSsARx881uSZiNCetmp9OG2u1mOrZuW028DaLLkHbtQSEG
         uGNv0c6O/JmZH+73UO5GFoTrDSQ78t0edbTFXt8YeLtbi/Tib7asWb3CHfDJPbZVHJdG
         BObozBpvS0w/4tA7TWYvHHpj1pwZw1/sTZyZYV8HgaFH8Yf3Cw3bpN+1JCIyv3FIAIp6
         0cCg==
X-Forwarded-Encrypted: i=1; AJvYcCU2Vye3od6S9iYyAvxUer+5ZJGDktxwuSbN9X9RHnRTnX8apmz5/ICGMc4T1P3eGPsVZYwNKXu6@lists.linux.dev
X-Gm-Message-State: AOJu0YyLcePNu/dfKOgyG4IBCa7vZr1PY89W8wdkAZP4mchDC0j2gQBb
	+sz08sNV5C4qs/+5Zx1ZfTzOFPMpL5oS5FTnjpASWE0e1t8uvbC842OeJqzw7WLxOqQ=
X-Gm-Gg: AZuq6aIRF62tVJg7dKs3Z/gtBQUy6h3Bhzu+CsLrPHUCx+aulN8byC2AhN0xZF0s83J
	LbkbEdLFBNLetYrnNYZZoZKHGN/H9WmAjRGU/AzfVUWclk4C02zzbx7e4Bi9G4JMyrAH1w6xB8W
	LKvRfidX9SH+Af8nVb1Fl/MznPxKvhk8WohWdfjzkMtNRV+NjTGRlhBR51m5PRjk/0abhNH1WsZ
	IeexWmzkWzekWNS8s6iFH6ReZR6sy4oHbXKe596b2lqp1remfXG2sAv9f81y+Cux9BgrUeRRevp
	m0r3bc/Ww9It1Wvmsyf+d2ANl9epI0bUPdTukkeUI0l9aOgKTI4qMitaCPe6oNOGppfmTuiAjgn
	3RercV3rY4L1E5WUFqjCYBCeoxEig7TxW2DdVBJheVM4P0x5vFKHoOAPzZXA2NFolrBXCAhCLyq
	pdmanBJlWbaDcAGIaxrh5gtiUDfwH6z23iQOsnSAI7M7Q=
X-Received: by 2002:a05:600c:a015:b0:47e:e9c9:23bc with SMTP id 5b1f17b1804b1-4835d54f8a3mr8337815e9.30.1770783946952;
        Tue, 10 Feb 2026 20:25:46 -0800 (PST)
Received: from u94a (110-28-16-35.adsl.fetnet.net. [110.28.16.35])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4834d82a1c2sm153656175e9.9.2026.02.10.20.25.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Feb 2026 20:25:46 -0800 (PST)
Date: Wed, 11 Feb 2026 12:25:30 +0800
From: Shung-Hsi Yu <shung-hsi.yu@suse.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.18 000/175] 6.18.10-rc1 review
Message-ID: <ac43ns3voofd4lgs6fi3zhuar7n2gy2jbn5icvio2bgytu2df4@auiowpkrgnwp>
References: <20260209142320.474120190@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>

On Mon, Feb 09, 2026 at 03:21:13PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.10 release.
> There are 175 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

test_progs, test_progs-no_alu32, test_progs-cpuv4, test_maps,
test_verifier in BPF selftests all passes[1] on x86_64.

Tested-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>

1: https://github.com/shunghsiyu/libbpf/actions/runs/21880634049/job/63161819185
