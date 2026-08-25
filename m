Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA290388E7C
	for <patches@lists.linux.dev>; Tue, 25 Aug 2026 21:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787693941; cv=none; b=FOI8RmGR3sYH59OW6+lBSkB6RKgV1Bj8w9sFzHnvcM2Rzbk2NJPMNS9ACwclalQLKDTP/sJ6ipAiZi8Hm3awhp1GL1mB/N7O9T7LZARCZYP3cVa9VuAT7Jo0heYxBghGrG+uSWgzWiDbvwgXhrScdNrqmvjRWHSNZg2WaJDw8lM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787693941; c=relaxed/simple;
	bh=00h7okbFqgmPyvAM1n5ncVkjkrKDlt58MlCbOI+cFJg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rh4YH49f1C7DmA9sZ3Oskfn9g8QplEQwLwQWA13M787pUFYhtusaAFie7D4rlhZsOpYjMdFl5Tidi2YXPF9LiNVaSJJ51K4DnP+2+nrZ0J1TrkGUIVwzGDCIwlxqiO2JGmVKXgsoQ3UleB5S1ODybPvMcPkhFJjDReUirngW2xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=U0akY/Xk; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="U0akY/Xk"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-90cbdb54616so3529676d6.1
        for <patches@lists.linux.dev>; Tue, 25 Aug 2026 14:38:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1787693938; x=1788298738; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:sender:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=bKDEf02ixSJvguzEg7rShr1aTUKMeAy3c/vPwS4ofl4=;
        b=U0akY/XkrQCLNz0Lt/nWyUrDznagMkYY26hKqKa3QpNje+HjWm3SIYxDJ719n31u7z
         unSfdmrAikhkLuhqOBHCpQ3AvvwGMTxH14pyGMkVq6E22ttGEgFOTVix0HUDS/pMnw0k
         5tPJDbpzbvxv72QVt6WPlYOVtKWLMP3qtcu30=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787693938; x=1788298738;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bKDEf02ixSJvguzEg7rShr1aTUKMeAy3c/vPwS4ofl4=;
        b=okygZEq5YHWjYsP9W8ljJU/JkYfLt/ZICRJO2aBepl3q7tH3CAwQ9/1B9usGFqTn2w
         U/Dn1gi5xFYJToKKamYjWNz6Caz3gQvNDih7UDMiW8CrcvjruYI7TmkScs6CbPx0ID/O
         XxkKAND4P81TlzWn8QyqVmWNkc07F1H1K8L2Qpnf3jv9iiXSAHx5/p001OUgiztuhz1A
         UDtjY5MB5C2dedUcxrchhPy4+Xm3HHiuLUuUGiDrKlW+lcuYceLR3eOCkzjAl9HHo3Q6
         PfG4v+czx8xM7CpKvyg+3WHKkZPB0TFvyc++z+Z5pksD1aX7CYDpl6/2LuwmpLkniYzP
         oAlg==
X-Forwarded-Encrypted: i=1; AHgh+RrZ5gwe1IlkuYeCf7nLB2FmwJDPRQj5W2TPSadUlnFUUmTINmPO8jGNbrAX6K4vnzn+C+5MZAWs@lists.linux.dev
X-Gm-Message-State: AFuF++kWdfpHAoyzLRvxqr1f4yNR8lLLJagmG7zy9jCfBes0x1m+YZN2
	XjFxm55XgrSQoU6CI3GOfTTDqtAcp8Rq0gUXpu4GAPdmLITz5JwVnKCBQTEge++ikA==
X-Gm-Gg: AR+sD11PKymCnwwC0t7LuXMgezg0PcsMXFQkUj4oXZwsphhrScUL8o3fS2AuflbtcFx
	W6+xpXpdJTMds6Rupx3NXw1GSlM5r+e9zsl94Io8uf9iTHohf9Of+pK+3UWM8pjKvmt+eiQCUNl
	fDpV0euq2rtjL08Wf9rQ2WSUaC7IWUhqaUaLcVaXNQEpGnIPoHQ3BaYiLyPDZu5LRgBzi/ET2Kj
	iG7wOoMnJLaqImxAq3VB9ZWVthWzSYNYJ2/DI6Xykm7Ka2rOPiXd7Z9UUFOL65WBwYXDXzQ61Nh
	bNInqv8XEchVxt1H+vNKI6d41JqoNrVng6j/f7Cjav+xSsYA9Rx+/MH0bAhb42DGe/yJ2PY9DMs
	LS8d73yxPCaalfUipUDOg+ONqBv+qolb9f8xXnleK7qrByTt9Lhj3pdLUkuLnK120dTV0gK/MP9
	xZdsSwenZc1zhRk0P0GP3uG8RmDPu2DU91osK7DUnlqMrph8NZkFkglglJ5XW9NcKlUrBH+mD25
	JRh
X-Received: by 2002:a05:6214:1cc8:b0:908:a729:73bf with SMTP id 6a1803df08f44-90cc792fe20mr20043566d6.22.1787693933801;
        Tue, 25 Aug 2026 14:38:53 -0700 (PDT)
Received: from fedora64.linuxtx.org ([98.97.3.217])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90cc63e3108sm8829586d6.11.2026.08.25.14.38.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 14:38:53 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Tue, 25 Aug 2026 15:38:50 -0600
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
Subject: Re: [PATCH 7.1 000/101] 7.1.11-rc1 review
Message-ID: <ao4LatQTBK5zThtD@fedora64.linuxtx.org>
References: <20260825132541.986300899@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260825132541.986300899@linuxfoundation.org>

On Tue, Aug 25, 2026 at 03:24:38PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.1.11 release.
> There are 101 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Aug 2026 13:25:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.1.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
