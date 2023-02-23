Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97DF22C9E
	for <patches@lists.linux.dev>; Thu, 23 Feb 2023 17:07:42 +0000 (UTC)
Received: by mail-pf1-f182.google.com with SMTP id cb13so6206744pfb.5
        for <patches@lists.linux.dev>; Thu, 23 Feb 2023 09:07:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:references:in-reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=wa/UzGyQDBMefYBiQESGpwhapQ4idUbLe6ID5walvV0=;
        b=HHa+hxiUtYH+XZPnVyEe9J1v5M9eo8BAz4RfQ/dT3ofq5PK5mIT2hMY+0S9ODdpzGT
         c/P2w7oBXBc4Rz6h1/qQyyU49q0EzluvqRfJ6fAYuh9Ltq+pV6lBPJI6WQ5kquf0J0WZ
         GYZV+4clHK2dZo8ra3dMBlbYimVopIeBmyn1ReqL0Lb6fhVzvgapFNb0O0eLeF3L9GPt
         Xm/AgQW2+mcACNXItRX6ZvnzHz7ApZe1cUd79v2Nx/vZxTcjvjURm/wqhloi5pyQZQMt
         +3P+0pBWVVvKJCnemUjSB89ksyqTjzY9arTOaaYgIPJ88ZxxlcLOmCE2vdSHpfoVFMZT
         Enpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:references:in-reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wa/UzGyQDBMefYBiQESGpwhapQ4idUbLe6ID5walvV0=;
        b=oxjq3DyJAfO6SkWUw1C0cwDN41EoylDncRKd1R9dXu4QsncNcb+utXMwSGUR1iWCke
         g64SEBr8Y0w/2q09l/n85pBehPb4Mf2MQ0I4S+cFlVySbXgv3oltd8LZTkoCrgriNx+B
         io0FPlfVuNCaJIN/RsyZ77Upw+pdr8SbhtxUQGxqgJ7BD/zu6s2TKfhHpQhcfucASlvO
         SapdKEbuukrMp2aNuFklQxjT2M1VLAqKeKSMOYIc03KeVjWiQdOsCpKPJJAFL8ITYnan
         /K+Ww8Vx/u+1km4m9ArgrJgPnnzJ206aShhW3GgcKzhq4NudFO08y9uyAOvst89YGANe
         947Q==
X-Gm-Message-State: AO0yUKU+vE0jFLMjqWMPHzyNVao93Jo/PTp5xit+/3W0QkU8x+Ks3o4f
	vV9sg97zxtHkAHDxch9YBPlcOaPQ2cruiG/kZNU=
X-Google-Smtp-Source: AK7set8eYk9XZY9hlTLkfI6zqrLU2JHutM80UFVX+j0Nz7E+y8A+CDttLk8pNQEuY71QIVxCIQvjtAgqop2Yko1g7zI=
X-Received: by 2002:a62:86c8:0:b0:5a8:168b:4110 with SMTP id
 x191-20020a6286c8000000b005a8168b4110mr1951081pfd.3.1677172062027; Thu, 23
 Feb 2023 09:07:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Received: by 2002:a05:7022:f8b:b0:5e:61ba:8807 with HTTP; Thu, 23 Feb 2023
 09:07:41 -0800 (PST)
In-Reply-To: <20230223141539.893173089@linuxfoundation.org>
References: <20230223141539.893173089@linuxfoundation.org>
From: Luna Jernberg <droidbittin@gmail.com>
Date: Thu, 23 Feb 2023 18:07:41 +0100
Message-ID: <CADo9pHgOp6hHC396k9yE4e1i=0U=_ca-tNtbYNd=Br0tzEWqqg@mail.gmail.com>
Subject: Re: [PATCH 6.2 00/12] 6.2.1-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, droidbittin@gmail.com
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

Working on my Arch Linux Server with an i5-6400

Tested-by: Luna Jernberg <droidbittin@gmail.com>
