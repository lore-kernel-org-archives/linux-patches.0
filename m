Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795784080;
	b=Cm6YNAi7NyVm2Ac4QDcOxluujYlTanKcT+J+IQfCZ14s7cwTkBawL6y1ciMHfhwYvmlQ
	 kYIqYfHNorPk2vOCOBHbEZVelYGRecSOr1DwLJ6iccMdti7ozMSWxxUhm6H7f+pH8KO5O
	 Cn2tnJ3R5QWnHBF9UZ2zrbHuH+lf6aV5EaLeLencUM48WNHOnWnyzeyXcqBQM9CTtc2Ln
	 HtpoxTYWLH+SAgOUmkVXm8JU2IOTquJAekcH8dnji6Ji5vx8ZftGF3Zs2f4VBYJuE1wA4
	 YieMptXzOrJ/MCn6VcSnyv5RbZ0NdH1rUcXsx5I6Awg+mjUT+O3hs8w/meiv70t9IKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795784080;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:From:To:Cc:References:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=TQkVH1jjDAMiibOHHeNRFPOznvXK/0Z03BJFc8UEQVY=;
	b=O4F4mZ5+XgrKNekzvwQYvi+fpMG2iscf6F63VNhuy8pWoBLc0oDsm1y9MssLiJ/sVIXB
	 wWt8udYrhRwI2+Szhcmub1N/tsoU6VifoCtzEb9aMPa0cH/8HX0dNpR+rwqhkeNsaQbwk
	 oF+ewrOxmWgAX9zJeKGdGW6mcBj2xtxSE/50cJm1z7QR4VY+wENn8KW2XVY9nLX415VMM
	 whMrU7TrjBs4fAertdZ9HtrEDLZ8YbCqn8/wEI/+ITAccnkS5aPEP9sZ02YGMwd0zTaZu
	 L68GB+vow58GPHI7OWIduBnG63rgiOTuXqbNYIyNSQyrRDBEZIqlUlxrbbYiXdi6sgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=EEoOlfRA;
	arc=none smtp.remote-ip=209.85.221.47
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B99F606A323
	for <patches@lists.linux.dev>; Fri, 27 Nov 2026 12:54:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2B99F606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=EEoOlfRA
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-4a68190a2a7so6844187f8f.1
        for <patches@lists.linux.dev>; Fri, 27 Nov 2026 04:54:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795784078; x=1796388878; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=TQkVH1jjDAMiibOHHeNRFPOznvXK/0Z03BJFc8UEQVY=;
        b=EEoOlfRAYPLcCyMW9v2OxwIu4UzVgug5jSNRsWIAlrUlNdTjc2Gn2ix9HNc6yV/xXJ
         4S+R2ARzSf/jpz62zyHC+Y3lstIuylRw7r/mFfpSFTAOIxXJVHA3/WgQXlFUw0rsLA4F
         8S/q3dJydnIshv+826ch2LKVtZUyLfVfbHVKIrAvjTJv8LzGXh1bPy76mamzx9Cvf9oS
         b1ocNoC93w1fZf0JUaPCLaL9hGIfLhHNRZH04uYu51dNMW4BSmq2swO3oPO9QqCwJKX9
         3T+m0w9MpWBuusC2sOFPuhXbjIoj4fS2OtIAMdlsfSCkOL1Qrq4VLZ4DuyfFmqlAxqWK
         J4Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795784078; x=1796388878;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TQkVH1jjDAMiibOHHeNRFPOznvXK/0Z03BJFc8UEQVY=;
        b=B//GyFfrdMjRc/sgCFGwX2rbiwkcUaSF2OhIVyTdnUIP/I8Cb80A/Lf1lomCTsedmS
         0tW1od3ymj3/GlUOtKwAJn3PfGRSqmfs0eestDpEMu2pgiVJFGZvQi1j3jtT0/yFvJQE
         Et4VXxVfoKcy8W0r4keJBTm7GHXKPmc/rxYPL1LMQA4VUMvhHCx88plExyBQc2Snepp1
         N83HJSSoTz3m4GyCCm+7m5jBw7qLDVNp78hvw/Xfyw3lAGgdJKVTkb5GBPKKKVrtmExi
         e2pkIOfew9zZGj0MY1u0Tlbd/DzBavi9OLhJZm0PJ8Xxgxv1xRAhNOMGY9C0cIAlxd5A
         MX+w==
X-Forwarded-Encrypted: i=1; AL+hErF12tlNCrXcLVFx/kMb+0dLRBXUc1Bu9ZIOXHcaOX0cHho+WHLIhmszG9mPLzd/66um7HZt2XDb@lists.linux.dev
X-Gm-Message-State: APuU4Z/lvG7vve3Wa9diSTkHNlWhl20gLhLrWX3EQCtxVKxfSNGhfyw6
	X4aq1d9fdOaEafOk9QopgAZBXTZSXVdmk4/bHVePjz1xFZGqCWZH3TN4
X-Gm-Gg: AZFdTZeghrHOobm3D7GL/9eU5jUCXxY5j7zqUeil/Gry0lmjHqkxVEfRbvq+IhHiMWT
	8dmPcoGuNsUMfCmOR0bfdwCugrC60rzbZJCr+DuIk16PaBz2ugdC7BIxhjyFbOswL0Lm15Cjj9X
	FoUrtrNuBbtCatXTZ4RaFULN2ykmEMYwTX7CWGwICrAQN/lYX8fJ1t7EPy86sPDsrzapgIz9Omq
	GXR9g8FX4A09AaqTq/nc42FmTuvCgE9KGdBfgrOIvm+D88W2UpJ/NSIVVxgFp6v/F91BdEE+row
	QQiZ+uchnM87DZt/q/Ej25jF9rNlYYKIL08TyJ9FKYU6rt+eHHk7vIXrcjTXV/rt/aXNNl6XXnV
	v3JFDJXFQztsx7cl6DO5+8w03srJwLQ/xbhcPakXLcPYaVGidqzpCN8X14O6HVo2Xg9HhAGyriC
	bS9/HzMqKmABHF7ggnAeDKQZYwt+ZnaNnscZ5husYpp7T2vi2DGFPgSUE+OPrpl0ggjwF6HKCjb
	V0+NYnwdDYAYeT3sxCXwzi74fKYVy2dvYYPUEgEM1nzS1/miJcmbTi2YCu4vgNIMpSM8FnzbfOs
	gho40t9bKJO8XwcIMyI9HznrPQLH2Z0/5SXAmyRgQrEPCAAs/Dj7UJcOT5KO5eradLpO4WXDV2z
	nZHzlUQ0=
X-Received: by 2002:a05:600c:5246:b0:4a7:9006:b176 with SMTP id 5b1f17b1804b1-4bb887fe892mr527018685e9.7.1795784078292;
        Fri, 27 Nov 2026 04:54:38 -0800 (PST)
Received: from [192.168.68.89] (host-87-4-46-207.retail.telecomitalia.it. [87.4.46.207])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab69bf630esm47880489f8f.16.2026.11.27.04.54.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Nov 2026 04:54:37 -0800 (PST)
Message-ID: <2b6444b1-c81f-4ea6-8981-9bd4bdcbab2c@gmail.com>
Date: Fri, 27 Nov 2026 13:54:36 +0100
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/990] 6.18.66-rc1 review
From: Emanuele Ghidoli <ghidoliemanuele@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Francesco Dolcini <francesco@dolcini.it>
Cc: sungbyeongchan <tjdqudcks0424@naver.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Nishanth Menon <nm@ti.com>,
 Vignesh Raghavendra <vigneshr@ti.com>, stable@vger.kernel.org,
 patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261125143822.072087159@linuxfoundation.org>
 <20261126173920.GA180459@francesco-nb> <20261126174236.GA183126@francesco-nb>
 <2026112702-donator-rebuff-16b2@gregkh>
 <9e86f015-0f0e-4897-80b2-9662b96a98f8@gmail.com>
Content-Language: en-US
In-Reply-To: <9e86f015-0f0e-4897-80b2-9662b96a98f8@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 11/27/26 13:13, Emanuele Ghidoli wrote:
> Hello Greg,
> 
> Reverting e498eb93f961 ("virtio_ring: use shadow flags when detaching
> split descriptors") on top of 6.18.66-rc2 fixes the issue. The tree at
> e498eb93f961 itself works fine, so it seems to break only in combination
> with a later patch in the queue. Still investigating.
> 
> The "Device Manager" is TI firmware on an R5F core that serves Linux's
> TI-SCI power/clock requests. Linux talks to it via remoteproc/rpmsg,
> which runs on virtio_ring. With rc2 the rpmsg channels to it are never
> created, and I2C transfers start timing out.
> 
> Kind regards,
> Emanuele

Hello Greg,

Correction to my previous mail: the "tree at e498eb93f961" I tested was
mainline (v7.4-rc1+27), not the stable queue, sorry for the noise.

On the stable queue:
- 44b6e54e4a0a (patch 203): OK
- 22944d517ff8 (patch 204, "virtio_ring: use shadow flags when detaching
  split descriptors", upstream e498eb93f961): broken
- 6.18.66-rc2 with 22944d517ff8 reverted: OK
- 6.18.66-rc2 with this change: OK

-       if (!indirect && vring_need_unmap_buffer(vq, &extra[prev]))
+       if (!indirect)
                vq->split.desc_extra[prev & (vq->split.vring.num - 1)].flags &=
                        ~VRING_DESC_F_NEXT;

According to an AI-assisted analysis (Claude), not verified in depth by
me, the patch relies on 03f05c4eeb7b ("virtio_ring: determine descriptor
flags at one time", v7.0-rc1), which is not in 6.18.

Please drop 22944d517ff8 from 6.18.

Kind regards,
Emanuele
