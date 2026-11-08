Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794110850;
	b=Tk4oPLYjH5I9SVwzn7rKn9WeRURWsglX0mdKOlxjtvD1WWkgmswT4cZP7BGZ3PN2TKKc
	 8BERVFjp0BjFotV0IzclCKL27pvwNZKjUVrRptsgjlNxD1eGikKijwUypZdgcPhSlk9iH
	 pmjOe3h4GASIXhZPrzbv/4NjP2eHBjCqctzh5MoFWqJlGFGn7+Uz26b+64KW1ckcQdxou
	 WNx7RweBn5NFOTKpq5l40Vzm2Xyqsn87siZBB0YuHi0x2LzGiYpAspSqbHM4+XzO1DvQZ
	 VaY8Rj4Zhb1rO0lGYak0IbLEVWWo/2nK2Vkw4oLQU15U9r0x8cn/DpgLzz6EY3cBWrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794110850;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GRtN9zT+RI+2mfrHlzv7j/45DTS+Jv89S927Nei8sc0=;
	b=gEdTiDUgUuwys8/2wr4PMnlPcJ65+qv06CmT54BjM+uIi0gk3cdjLqWeU51fYcOCE6Zo
	 2jedZErNTCXzu0t3C/EqcYiouJ8cEypHIsJYjpt7G6TYT9ZizMGt1jiSHN0F7vscC/NqF
	 iRYRndt0NHf4jY7RcXp81yvaG9kIOLRpjZSLoMZDoi2/ah+UaBxkTbwvWm/f+DLiDswgV
	 LUP+7Q+ip+XFDKWX9XalcSNguL+k1TsYVeHlwNrz2OIShji1jLByK48BoxQeWC6WtAVpp
	 JjCzavU6a2eanqv5M0okMfFRZTPZBb1iyR3Hsr6TMN8/Xd1eSMrdb6dnPaA8nMjMDZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Jode6FmF;
	arc=none smtp.remote-ip=74.125.82.171
Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16F0A606A31A
	for <patches@lists.linux.dev>; Sun,  8 Nov 2026 04:07:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 16F0A606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Jode6FmF
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-370f4e5cfc9so16138eec.0
        for <patches@lists.linux.dev>; Sat, 07 Nov 2026 20:07:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794110849; x=1794715649; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GRtN9zT+RI+2mfrHlzv7j/45DTS+Jv89S927Nei8sc0=;
        b=Jode6FmFTIhQo13fCG2THYAPsAbxviLkcuY5KrA6ljK9xvW6bHs5jQakBGB9i3QukP
         g+3M4L5SxvtHDTp3fmjku6XJif7JBApta8I2YVIhF9G/k0d2aotIWMZbncokQPMCghnL
         Kg5gIkC6ax1a91HhMOKThRDYsLNyRzdP02JZX2vaRF7FuJ4Btq+S9D1Ix2BWrJSnyJSX
         dHJtwWvlz/ES3Lc1ds0s/ejWopBx7gz0Wr8H3MFecV94AAJ1zeVWnx+/G8zo0++9H55L
         gTPmLxhe2gavXPyCPlj7O/YxRt2D9qfZDCT6AKf4HscGl9Tradolewk27vnWPbg5hiEW
         1WNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794110849; x=1794715649;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=GRtN9zT+RI+2mfrHlzv7j/45DTS+Jv89S927Nei8sc0=;
        b=vEUA1okssLvG/tUgEX5eda+i+wIXYftY4TQuNu7YqXk951aWPQnTcf+EhHfOvxseJ/
         ai3nz49T6Vhk4XnY9O4ePyyAp+/xq9JyCUuamlPMVujdeUZzHZEThuyDRpwcgpfGav17
         z6hlmcVtpOXAUgU6We96jovh8JJmSB7pF5Dmt0Jy5UN/sPZBYPJ/IZIpQsb+AqxZpKVx
         efgGnJYiriStMASL3Exp0C4QOPF1IfGqXd/lyh9o8qWi5Te0wVPBAkvCQ5G2gGyRhPla
         PqihIgbiHEO9xUTey/tZP9FfTrEDcFRfRU2zbim/oTn+x0MGyQCV9PBGQwj0VSYWAeAS
         lnaw==
X-Forwarded-Encrypted: i=1; AL+hErHPPcue/DfDAzC7sMzJ4NgiE3NDGANE9RDalgBHZmjU/6K3z1SRH5bTjdTym6iYQftsIhYntwsW@lists.linux.dev
X-Gm-Message-State: APuU4Z9hkdYsq6k7Wdd6T4gxNa90cfecsmUtWTBkkVLrPc/JSy4279C7
	RbhHd8djbO83GNlgZ5qQN3ePX9PgxoT1ebRxJYKFmAG6laO+rXq6NCDI
X-Gm-Gg: AYBFou0CgJSr33JcFl6+4jb6A8Q6uH/MfCnBkOLsF7T/6yxEGgfzNvnceazVDMG1caG
	Ozyu8W3N0+sBFxYagAbfQU3uTRZ7uuI0o2aQQA102D+sqZ1vXyJfvbU/X6wuIob2ZQAL1wu7t7X
	GYMlJzd03bXLp2YfOBO0rEA6Q9Y9onkvwyi1A4CjnQaHl8jyYuX8DV3NMKwlFCdFdkP91B4fb6i
	YpbXAhZIV3MS6ggIf8i0A1Lzd/XAzhRuwUWX/OmubTLywtSsYMoHcDpEMk2nRRKzvNDDb5Wa1n0
	Th1XF9hT9K2F8h+8ijO+k/RfQwr9I1uwlTLJTYPy8cdokyaE10JTu48riTWLRi8ggN3oLOUOUxK
	4DPYoiOvAkAzS1DAqS4dPeGacJ9hOX7iTw0xMR05Xof09iqXlgVoEovkpRA3A9//TVtMZqAHers
	3LZTWICSn1XQKpOv6fNGUf8bftES/ryQI6o1roh0gt9eZlZcyOB8E4Z2oo/xxZCt6sOSXa2cfqR
	dORAbj4zl6m01AD7ieHRVfpCgB58g79XXn/BEsqd+EkJz4mbP4R6SYM7PNyZkUPlO+XTKwyw37j
	BMyUk/DXUrSmO7d3dY3NkDbLOxjNhBeoKkW3R4H92CiGwLBt8q/Nojbw/8ko7Vy9uOw/RD+RjQC
	zYlTIC75vEsUTJ0XUujaruefxw38dMfbWbm4Iq4SX8zMiCdTpWDfj21hQgkugYWiGdN7iN3s6nG
	l2a3vFalz9rg==
X-Received: by 2002:a05:693c:62cc:b0:36e:66d8:1424 with SMTP id 5a478bee46e88-3725024039amr2449285eec.0.1794110848938;
        Sat, 07 Nov 2026 20:07:28 -0800 (PST)
Received: from cachyos-aura ([45.112.151.150])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-37265a16f9csm2291812eec.12.2026.11.07.20.07.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2026 20:07:28 -0800 (PST)
From: Navon John Lukose <navonjohnlukose@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org,
	patches@lists.linux.dev,
	Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
	=?UTF-8?q?Tales=20A=2E=20Mendon=C3=A7a?= <talesam@gmail.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	intel-xe@lists.freedesktop.org
Subject: Re: [PATCH 7.3 0001/1257] drm/xe: Implement Wa_22016122933
Date: Sun,  8 Nov 2026 09:37:21 +0530
Message-ID: <20261108040721.203040-1-navonjohnlukose@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.482764241@linuxfoundation.org>
References: <20261107134939.482764241@linuxfoundation.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On ARL-H at least, this commit adds about 3 s to xe probe and 2.5 s to
every s2idle resume, because the GuC buffers are now mapped UC on the CPU
side. A follow-up maps them WC and keeps the TLB fix. It has Tales's
Reviewed-by and Tested-by and a Fixes: tag for this commit, but is not
merged yet:

https://lore.kernel.org/intel-xe/20261003222145.67240-1-navonjohnlukose@gmail.com/

Whether to take this now or wait for the follow-up is up to you and the
xe maintainers (added to Cc).

Thanks,
Navon
