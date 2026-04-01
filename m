Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8899D3002DF
	for <patches@lists.linux.dev>; Wed,  1 Apr 2026 06:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775025950; cv=none; b=QEW+mFbzIFLB1O5eAx1g3u8kNimPjYukCSMP80DJkVL9sENvWt0MEJzYOO3IWupN7IRlmtbWQQGNPBPSCM0dzPX+DqTWV5TZiScJmokkchUNd3vAiC1GchCZya6bsjWFT6mfFU9QJSff7O9vgdN/2tbPgpfCLOcdnMhjF4NZ6Ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775025950; c=relaxed/simple;
	bh=Y9PsSAeF2VVTlv0gxp4NaYm6ElhgGVAYI2NCjV83v3U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rm1+wCIDAjhdZNuX6r4BLqNUNvAWhCgHxFf9yweu+BMOMSxV9edq+5wsvSQOR1cljpT/J7Ldx3SIgEWmuacFMBYNn/EizqYb8YY7VBo+oO494KZ8zpnfp/ZSGGO/kT2ZGeWmM3xeotUPJNL0ixXikxMJp2y7Vt+vp9jfXj+ugwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=O15c/hcn; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="O15c/hcn"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4888244e9f9so8097565e9.0
        for <patches@lists.linux.dev>; Tue, 31 Mar 2026 23:45:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1775025948; x=1775630748; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8eXLAnhmwdFqoYouk9YANXlnI2O5gIXzF7yJsegLE3E=;
        b=O15c/hcnVJPf1s5DMxmxIGRB2nICUk+vMVOvJtIZrgynwR1NaVvyYnthrPZe8vLgBw
         cAc1vd5xGXD9lAiW7lSl1PiFFutdlDUk5LG7WVMB0Oe7lL86J/uOJqufbXySTf0k5fn9
         oIgGA5x+x21EL6PEQSrYI7D84MrZha++P5TpZnTMLRYzIMIGoWTUzg5IZxnzNAVoHcBm
         +sCa32BvZZTMfzCMT7hpsb3IJqoS/vpC69zsDBEkGmsYH2+5nJizCMJZdUKexdGv1H/g
         PakKjdKHQmsRObtVfh/bJTkblsUK07vW62PdEMFuXBTN2S/pj6VHzDlJVfCY/qp2AX0F
         1ZZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775025948; x=1775630748;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8eXLAnhmwdFqoYouk9YANXlnI2O5gIXzF7yJsegLE3E=;
        b=alG/fhNJhsdJT0aQSKb2wwva+54DGzPpgoyAU7Zni3hEFSTKB5b3/nFtwUZg6lBN06
         M9iv46r/3SUpi+LX9pYzyJLfT8gqTX6qkKzRUksqoQJs/swQ0hh/rB+SAmNOqfRsLFVK
         8UFgnTSiCQoTthgOWW5kuJh9jw/icmqyKB6nU3ocR6dJae3mqnFPAzc119mR3xiU9Tqr
         bC2aT3FFIO+/DryyNIM2mrDXi2nRqsR46W4++SiY5u3hgeXHajHAyue4BSBXIkuuZ45P
         TLXf7qKlfewFrg2cL9ndpl+c9EwP0vEF8MvIYRxu+4/IR6Afs0pYbwkZHp8wKiZAWQrc
         iavA==
X-Forwarded-Encrypted: i=1; AJvYcCUKEoRT1tvQ7aud9qhkjVEF2fW2iMof899UCauV+UcyBqNIoOFLaAplJnKNDXdiOXExYrDmzhia@lists.linux.dev
X-Gm-Message-State: AOJu0YzHcOnhkA/3rUdvqnTMgngEm+V08l/EBmJjX73Dl4bgeG21UUJs
	fFZmpW/9kCJlLaMlfNoJz3IH1KwoALI7iRuzuIYXwrSf8fOamONh8y1lXJ22h/K84y0=
X-Gm-Gg: ATEYQzyBitu1xPQr63FN+uRlpzkxuwdEOX3oPl3RCgClD3uUZNaY9UTSkuNE8sCpTo7
	roQguyHBA69cq6z0L/FKFdZC1Y4yF8XUqZ7ZFTnqg3vHuseJInfKulnhMKuDuQH1GXZ2SrqNld5
	NZRK3Fe0Y+HKA+pdLFEESrlikvcmm1jI7EOzcDRBN9DTeakoCQ56qt1b0kLQmsjIGsAKsLt+goy
	vPcoC4pcA7R30JOJHWQt7nqBG7e9OqehLMdSznmHWl/eUkwKPLCzFHmreyox0l+yzBm18JncVTn
	bBE5RMhmzkZDtAvoYCXiQhKYXgGom0JL0JcwMjSNh5tQx8Z6zJpwtW7vQGBRGbrj05K+6523pio
	MS2ILR2Y5bSX7BhECGPHBoG8eHyj7HZCmB3YSctwbPT1E/j/OL2maqPCQ0DHovVJ8O/hKP00AW9
	BUTNb0qDO5HPqwqPQTiSLHxfrC293BmpkDpKOKwJUQUrzjmHQ7
X-Received: by 2002:a05:600c:4e0d:b0:486:fbd1:9dc0 with SMTP id 5b1f17b1804b1-488835b76a0mr36100545e9.22.1775025947841;
        Tue, 31 Mar 2026 23:45:47 -0700 (PDT)
Received: from u94a (114-140-80-217.adsl.fetnet.net. [114.140.80.217])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35dbe5e1b9esm3873321a91.3.2026.03.31.23.45.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 23:45:46 -0700 (PDT)
Date: Wed, 1 Apr 2026 14:45:38 +0800
From: Shung-Hsi Yu <shung-hsi.yu@suse.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.19 000/342] 6.19.11-rc1 review
Message-ID: <pejzbrndilvhthlxa676kwrf4ftlxxvebb5sz3mod3caa7j5m7@v5n5wx7ic2c4>
References: <20260331161758.909578033@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>

On Tue, Mar 31, 2026 at 06:17:13PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.19.11 release.
> There are 342 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

test_progs, test_progs-no_alu32, test_progs-cpuv4, test_maps,
test_verifier in BPF selftests all passes[1] on x86_64.

Tested-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>

1: https://github.com/shunghsiyu/libbpf/actions/runs/23814574909/job/69410511598

[...]
