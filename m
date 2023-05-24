Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C92B22627
	for <patches@lists.linux.dev>; Wed, 24 May 2023 22:04:17 +0000 (UTC)
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-2af1a7d2f6aso18221281fa.1
        for <patches@lists.linux.dev>; Wed, 24 May 2023 15:04:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1684965855; x=1687557855;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BGJNYAB8T/lr+YL5tSEXLDHHn2s+eih/Ya1hsZucDVU=;
        b=HwqCMQfaDZsmkz/wpFqYetyRFwz5Pp9aVTRTT1EXnLL60SOphIXEYdZ10OGgdNPiME
         EJ5to2S3hSKuh7Qz69szfW3MNIGUcsCOgDt3xJ1wXtGtDuvf9ual9eIkXchcUggIW8vA
         yLEK7VOgcibiV9W05ZecVdlKl1hnKt182gBbo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684965855; x=1687557855;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BGJNYAB8T/lr+YL5tSEXLDHHn2s+eih/Ya1hsZucDVU=;
        b=DNbum6j80Ky0fXW4T/w56xvxt2a59IaZcpV3Om2bUUKz3u0FIcJiiUtbYcBnVt5iRs
         H1qpl0Ke0ZlyH4J7goXPMcUldnF50oS/XkeyoKDiJmJ83r8Ks4Lxs3jO+VRh+wwjulFr
         kw1kBbGBaWury6lQ95mgTh4Blkild7LER3jnq2DJCbiJN9IOKaDA8iPoM5SWv4UoAP/3
         6abOK3/KuNrj4T0TeqJ+S91HEHD4n21OUQOyfHgdTArIJJwr7T6mFI+sIw9RrHXJytvb
         eYwaWtcxzY25+saoF9laVsVOkKZ8sUXLw4o8JcnXveeqoj03KUHAzr3c3RAT6kWtz/z2
         k6YQ==
X-Gm-Message-State: AC+VfDwUnFqkL44pbBONBDFbC7GdOWGA5yz2neIRCg9pxnTY3Z4+qi9o
	mptc3gN0Pp+jzdQhbz2o50pREdBGWdhaQ1nhR3rEQKLK
X-Google-Smtp-Source: ACHHUZ447otPhrfAfTybMnDrrwL4vnqWxCtRSiRpW6cG0DPopQzamVZ/fJ60z6OePskoBD+gTdUlgg==
X-Received: by 2002:a2e:97d0:0:b0:2af:1adb:1726 with SMTP id m16-20020a2e97d0000000b002af1adb1726mr300060ljj.38.1684965855093;
        Wed, 24 May 2023 15:04:15 -0700 (PDT)
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com. [209.85.208.182])
        by smtp.gmail.com with ESMTPSA id 16-20020a05651c00d000b002a8b8baf542sm2239821ljr.126.2023.05.24.15.04.14
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 May 2023 15:04:14 -0700 (PDT)
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-2af177f12d1so18389671fa.0
        for <patches@lists.linux.dev>; Wed, 24 May 2023 15:04:14 -0700 (PDT)
X-Received: by 2002:a17:907:268c:b0:96f:65db:d6d2 with SMTP id
 bn12-20020a170907268c00b0096f65dbd6d2mr16749757ejc.14.1684965423649; Wed, 24
 May 2023 14:57:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230524213620.3509138-1-mcgrof@kernel.org> <20230524213620.3509138-2-mcgrof@kernel.org>
 <CAHk-=wjahcAqLYm0ijcAVcPcQAz-UUuJ3Ubx4GzP_SJAupf=qQ@mail.gmail.com>
In-Reply-To: <CAHk-=wjahcAqLYm0ijcAVcPcQAz-UUuJ3Ubx4GzP_SJAupf=qQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 24 May 2023 14:56:47 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi9oPrxcMK469X0zAueKQ4tqX80SdFqCx9StcL82vuEkw@mail.gmail.com>
Message-ID: <CAHk-=wi9oPrxcMK469X0zAueKQ4tqX80SdFqCx9StcL82vuEkw@mail.gmail.com>
Subject: Re: [PATCH 1/2] fs/kernel_read_file: add support for duplicate detection
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: david@redhat.com, tglx@linutronix.de, hch@lst.de, patches@lists.linux.dev, 
	linux-modules@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, pmladek@suse.com, petr.pavlu@suse.com, 
	prarit@redhat.com, lennart@poettering.net, gregkh@linuxfoundation.org, 
	rafael@kernel.org, song@kernel.org, lucas.de.marchi@gmail.com, 
	lucas.demarchi@intel.com, christophe.leroy@csgroup.eu, peterz@infradead.org, 
	rppt@kernel.org, dave@stgolabs.net, willy@infradead.org, vbabka@suse.cz, 
	mhocko@suse.com, dave.hansen@linux.intel.com, colin.i.king@gmail.com, 
	jim.cromie@gmail.com, catalin.marinas@arm.com, jbaron@akamai.com, 
	rick.p.edgecombe@intel.com, yujie.liu@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 24, 2023 at 2:52=E2=80=AFPM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Stop adding horrific code for some made-up load that isn't real.

Even if you trigger some "worst case 3x memory use", that is
_temporary_, and will be free'd in the end.

The patches to "fix" this are worse than the disease.

                  Linus
