Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB6B6FB9
	for <patches@lists.linux.dev>; Thu, 27 Apr 2023 15:13:00 +0000 (UTC)
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-953343581a4so1321281166b.3
        for <patches@lists.linux.dev>; Thu, 27 Apr 2023 08:13:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1682608379; x=1685200379;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/tnBlwR2KgjIrpyr1ey4GRZA/jG9gwGR13N6cjFqMs0=;
        b=fKUaWjUJ8mKf36zHO3vuQML5HdFupvkc97Aet0N6roPO9Mvl1emFYI5ASnORVKNVVP
         24vG050RF1h/m2pGUsY4Qs7K0X6dBSNg3CLH/amgUBi2nJnumZkI+F+rsnlHaA144sYe
         0UxQZGO4FZAwz4bCC/i3t/YZamxccbGa10nE0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682608379; x=1685200379;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/tnBlwR2KgjIrpyr1ey4GRZA/jG9gwGR13N6cjFqMs0=;
        b=U6OQNgevct+Q8Vkbp9rN5AtPvbGEM9KMfJQpnIZlhf9L8q3LYXeVGipx528twRS/NC
         UaxYXxq9LV2JsIgylqQsM4q3wsL623/GaXy0t9oEYmIp2k54CVo8vBJ6OR8PQVIZcyyu
         4hSkoUrfuLiFm83oTkDEPmbK1QcHT53MBFzQJob1GuYCvBvzSktMk4eDu8UT0h7RIFvf
         pY+hi6U1YaZ/jsaXAN9ggEyFmSwJxViq6jN97siQuGQoBB5ub3Yc5V4ShZAEv3bcfp9z
         UUs7btlEw4j86Z7DG/FNLXFpxFT1f9nPgMX+tOotFSBiyEpa6RWvKGJeE5KUXJ9zE7ge
         +a8A==
X-Gm-Message-State: AC+VfDwOah71govPhO33R0IjfLmwM4Tf5y3E2z4Q4uFY0o7OJiNdXkTt
	47krX0BCWajtY6AQOCAA/ui6U+1pBHkVpyRhy1PyHw==
X-Google-Smtp-Source: ACHHUZ6rnTpxAlm+hXpQScNczXWeoMioy5llHUELi1sfs5ms1S/9lEVl0e/SLbz5GNH/9R9qDNkUIA==
X-Received: by 2002:a17:906:9754:b0:94a:921b:c805 with SMTP id o20-20020a170906975400b0094a921bc805mr2283508ejy.45.1682608379088;
        Thu, 27 Apr 2023 08:12:59 -0700 (PDT)
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com. [209.85.208.48])
        by smtp.gmail.com with ESMTPSA id d16-20020a1709063ed000b0094f499257f7sm9828949ejj.151.2023.04.27.08.12.57
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Apr 2023 08:12:57 -0700 (PDT)
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-506bf4cbecbso12812266a12.1
        for <patches@lists.linux.dev>; Thu, 27 Apr 2023 08:12:57 -0700 (PDT)
X-Received: by 2002:aa7:c946:0:b0:508:3b23:d84c with SMTP id
 h6-20020aa7c946000000b005083b23d84cmr1902412edt.1.1682608377021; Thu, 27 Apr
 2023 08:12:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230427140959.27655-1-vbabka@suse.cz> <2023042719-stratus-pavestone-505e@gregkh>
 <3cc6e10c-f054-a30a-bf87-966098ccb7bf@suse.cz>
In-Reply-To: <3cc6e10c-f054-a30a-bf87-966098ccb7bf@suse.cz>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 27 Apr 2023 08:12:40 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgdGzy6-3jzN6Kvtz1QxStTZBZPz1zy9i4gM9nbe5FGbA@mail.gmail.com>
Message-ID: <CAHk-=wgdGzy6-3jzN6Kvtz1QxStTZBZPz1zy9i4gM9nbe5FGbA@mail.gmail.com>
Subject: Re: [PATCH for v6.3 regression] mm/mremap: fix vm_pgoff in
 vma_merge() case 3
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, lstoakes@gmail.com, regressions@lists.linux.dev, 
	linux-mm@kvack.org, patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Jiri Slaby <jirislaby@kernel.org>, Fabian Vogt <fvogt@suse.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 27, 2023 at 7:39=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
>
> Sorry, I wasn't clear what I meant here. I didn't intend to bypass that
> stable rule that I'm aware of, just that it might be desirable to get thi=
s
> fix to Linus's tree faster so that stable tree can also take it soon.

Ack. It's in my tree as commit 7e7757876f25 right now (not pushed out
yet, will do the usual build tests and look around for other things
pending).

                 Linus
