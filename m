Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 559817C
	for <patches@lists.linux.dev>; Fri,  5 Aug 2022 18:46:34 +0000 (UTC)
Received: by mail-il1-f173.google.com with SMTP id b12so1764120ils.9
        for <patches@lists.linux.dev>; Fri, 05 Aug 2022 11:46:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7pB3CUQguyZpocpsTCxrp+VM0mZPpD9HY2PyAfQxq3M=;
        b=mqiqdp7VfmwVU+HdUvUa2IwML+0sE9i/8IuuQgkbYZa2RejZDdLMQ4sTKXZM3SvqMj
         KW0zqiicDNvIxcldubT0YJkivYkhh1KrJC04unspffI0ZJD1InS4aikxbd9YeJwMh/N5
         O1D09cTluvjPnizIEVxZrGYtMtKsdtHxMEb8Thr4kfS7PHRO3oPz4JmxHJOlHlKVdK7I
         WFQRD4jUI6yUFW2ZNBb4YvtjoetLuk4SrIg5XpBoInTz6r76hUGhnQB0Z/l6+YE1h3zE
         NAqM0icbnGgaJiuAh1T0DclODtnldWro3bxqMWFkfpGEBzd9U5+iqhWr7xSNOyDiKNre
         k6yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7pB3CUQguyZpocpsTCxrp+VM0mZPpD9HY2PyAfQxq3M=;
        b=ZEhypYRx0/jluO2ITbq/iAQxbRo/mfX42zewJl2M1VPy1W5GwMTXBO+l+IWBOmWzhW
         t7svDr4b4mkIKA2I70+JrxDxZAwq+i4nwGGyJdCRE/GjQC+QwV33x6UFJPNYNRoap8VU
         CrtyF66kA7E+VOpbB2TYTg3NVVyNCPJNI01aF1VQCfKY9TWW7nE6fdxz98RyOEixn5bi
         VvTqBZlQ8ZrfEoVFI9MN1y7q3UiG7usjF2kyLu8iEMjh7rjUdlWhZJTLi8jXisz/iQGT
         VZzuUf72RJnO68uKizfJ3HTdbIJVH6LT2+lINr6vtJ6vbTrbpd8q0PRUMHd59IwKnG58
         W6zQ==
X-Gm-Message-State: ACgBeo31ptb6hl8KoO4ZRx6/lwHmFLnI+09G8Vu3SflmHlyT007hKPHY
	vqnsOE9JT7AaAhddblRYRsjMbFKFSOpfe5jFB8o=
X-Google-Smtp-Source: AA6agR4YDYzXkvB7rHVbmM/Rp4RI4JkQJPt89N4l1KoM+JTZ+0Y9PTuGAO0CISMINEm7dCPE6TaMq7XLJwhWouw1hCU=
X-Received: by 2002:a05:6e02:1c23:b0:2dc:e497:8b12 with SMTP id
 m3-20020a056e021c2300b002dce4978b12mr3659739ilh.151.1659725193408; Fri, 05
 Aug 2022 11:46:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220805154231.31257-1-ojeda@kernel.org> <20220805154231.31257-2-ojeda@kernel.org>
 <20220805164834.4xq7hm6ee6ywjpjo@gpm.stappers.nl>
In-Reply-To: <20220805164834.4xq7hm6ee6ywjpjo@gpm.stappers.nl>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Fri, 5 Aug 2022 20:46:22 +0200
Message-ID: <CANiq72mXDne_WkUCo2oRe+sip7nQWESnouOJrcCYzyJMkG8F6A@mail.gmail.com>
Subject: Re: [PATCH v9 01/27] kallsyms: use `sizeof` instead of hardcoded size
To: Geert Stappers <stappers@stappers.nl>
Cc: Miguel Ojeda <ojeda@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	patches@lists.linux.dev, Jarkko Sakkinen <jarkko@kernel.org>, 
	Boqun Feng <boqun.feng@gmail.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, Aug 5, 2022 at 6:48 PM Geert Stappers <stappers@stappers.nl> wrote:
>
> Signed-off-by: Geert Stappers <stappers@stappers.nl>

Thanks for the message and the support, but please note that since you
are not in the path of the patch, you cannot use this tag; instead
look into Reviewed-by etc. See
https://www.kernel.org/doc/html/v5.19/process/submitting-patches.html#when-to-use-acked-by-cc-and-co-developed-by
and the following section for details.

> And I think that this patch and all other "rust" kallsyms patches
> allready should have been accepted in the v3 or v5 series.

Yeah, it could be a good idea to get the prerequisites in first. Let's
see if the patches get some Reviewed-bys (e.g. I had to remove Kees'
one because I had to split the patch).

Cheers,
Miguel
