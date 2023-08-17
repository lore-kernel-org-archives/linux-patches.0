Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C09933D1
	for <patches@lists.linux.dev>; Thu, 17 Aug 2023 16:52:53 +0000 (UTC)
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-2b9f48b6796so120663341fa.3
        for <patches@lists.linux.dev>; Thu, 17 Aug 2023 09:52:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=contractor.linuxfoundation.org; s=google; t=1692291171; x=1692895971;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ztGvz8uNxOI/bQI2P8CZHv87jak4Ko/ftFFZxp9rlvk=;
        b=qVlZtKi7s8HBd6v7L3aWhgBiRLueasXYFf65ll/JynhCfa4lGlfVOow4Gb3J7RA+xr
         MKMO/Y1sVwGVJxvLhN/4jCiSL1uzQ+ZCFBZk7A9Tvuzv2xvj8veTYb1LnUWNOT2AgJz7
         PtUZHACqrAeJQHEcGIm1ciPm0CZkXFCUwjGOo4pK0kR8BkkBl6qtnOLfgcfLg0w6/2fw
         0L91uI6TGdsBb71Yjz9XCFgEMaikm4p7Ea4o+GgbE6mqDcd/uCJkmYza9R+G+RJpAnUY
         oUTMjDgmf6dJ/YKHk+7RyUruX2zkuPl/B2XaJV8BKEP6ihp8qhI18YH8ZZMr7S2o7Kff
         Pvag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692291171; x=1692895971;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ztGvz8uNxOI/bQI2P8CZHv87jak4Ko/ftFFZxp9rlvk=;
        b=S1EZgBS/0bNavtq4r94sVLPjXDdWUGHTmhZ2kKO2JN1iPDxVAGRxL2ss1L32n8uwVP
         1e9G3Z7Si4x+UU9IKpTfGM8aKh8BJwIwYwsxeAl/RHAeY/ana3b96VhdTQ2/a2JCIvBg
         e5NZxqoDuB1skAe9WXXu8sm5evA5KKU2EYaf6J6QdbvR3SBumwSKeMURImK5fooU7lBf
         P3mdh7h1LDVlmbVYbbwXVBBPYhRVnuyZ5dfLT5oRyN5hnvZrobBCqy2JRO6ziyqWbuTm
         V7ihA4kY3IRZ0TsNsRJ4sATBeaS9RvzEWAj3YkAnmQIvQiNeHQfefIox31yO83NCup92
         i7AQ==
X-Gm-Message-State: AOJu0YwyMoWv6g8fD5PLQdWeKaBjm5+JWP/gp6qasePDARgTIjMT/U8D
	PClIPEvWRzi66hJxomgeq82nDrVwDzwKcfTLAr4ddQ==
X-Google-Smtp-Source: AGHT+IHf6cCDZaNwNiBuJ3qbgRyDANdFN8kl83BWCivzk7LDIfsUP6YNWdSLe7nW1VlLpCdmRXoE62rkfRh8VgZTHu4=
X-Received: by 2002:a2e:96d9:0:b0:2bb:97f2:b219 with SMTP id
 d25-20020a2e96d9000000b002bb97f2b219mr4766770ljj.32.1692291171114; Thu, 17
 Aug 2023 09:52:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <ZN1jMaKKQ3ZRwiL3@bombadil.infradead.org>
In-Reply-To: <ZN1jMaKKQ3ZRwiL3@bombadil.infradead.org>
From: Shyam Kumar <skachukattu@contractor.linuxfoundation.org>
Date: Thu, 17 Aug 2023 22:22:40 +0530
Message-ID: <CAH=dH9_JZU7jPdVHX3qsK1aCwAbcUH6ZMjN=4S22vikyN7bmrQ@mail.gmail.com>
Subject: Re: Create kdevops@lists.linux.dev
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: helpdesk@kernel.org, jlayton@kernel.org, amir73il@gmail.com, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello

The list is created. It is listed here :
https://subspace.kernel.org/lists.linux.dev.html

Thanks
shyam

On Thu, Aug 17, 2023 at 5:30=E2=80=AFAM Luis Chamberlain <mcgrof@kernel.org=
> wrote:
>
> Address    : kdevops@lists.linux.dev
> Description: Linux kernel kdevops project
> Owners     : mcgrof@kernel.org, jlayton@kernel.org, amir73il@gmail.com
> Allow HTML : N
> Archives   : Y
>
> Reasons for the list and additional info:
>
> kdevops [0] has picked up momentum over the years to the point we now
> have a community and reviewing patches is becoming more important.
> Although we are on github and gitlab and share an organization together
> I just noticed 3 pull requests have gone unnoticed for a while. So I'd
> prefer to just avoid web GUI pull requests and instead we deal with
> patches just as we do with Linux kernel subsystems.
>
>   Luis



--=20
Regards
Shyam Kumar
The Linux Foundation Core Projects
