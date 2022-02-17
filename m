Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 499664602
	for <patches@lists.linux.dev>; Thu, 17 Feb 2022 19:33:47 +0000 (UTC)
Received: by mail-lj1-f179.google.com with SMTP id o9so1003041ljq.4
        for <patches@lists.linux.dev>; Thu, 17 Feb 2022 11:33:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s/oXewggFOpjaRjDxmMp91h85U911KTGRKHlUJsGGsQ=;
        b=FLYJj+HDXnNK+2/4k1WZ2enZbSNYyOZHY5fHdZ6/uCEhjkTyF6AePplpqyVtXKiacB
         fn8KWnnuFV6Vcr6GX7B0JqPRswxiPTZdc9jlevxWgNX3OoVMFimiSx9dFnoXmHAOGLKY
         T8CZDUUO8aw/RcZNk3m7HhNmK+LErsoJQsLG0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s/oXewggFOpjaRjDxmMp91h85U911KTGRKHlUJsGGsQ=;
        b=Cl3cdevdeUdm3fscUr8oo01/7p2rxKNH7SC86LDwSwTAqYWpXISDFOCqKT6GXMtEdv
         wr5vtDb/Zd5QngrNLIsmXQv9uXFxHINvprQyPzy4NavO0WmuZkcbuxpptuugqyWkRlyW
         Go+ib1RwZCi4Ye4GGyNI9jd6DW4YG1VKJBdkOhGZ37EBJzXeAQlTX0FYMVhhjyJ3Ps//
         NcXKUW5SAcu8xSvBEjYIPCSbW6BaF9LzVj22OcLjiq6EJyb4mzgD2B0V3j0DHxnC8Dlw
         4j7vtpfq11C1rUlGEnkHhOUaZCpgtQPRhLTJdQKJ7b0kfaRQIinz3hdOi/hVJ1b1UniN
         1QZg==
X-Gm-Message-State: AOAM533f3QnlEF+/Wrxece4iBAkn7zK4xAdi9w73raAmnQHKf2huUX1l
	c28dr43OcbuVwOGlvLnRYLO75ZsJwUvxw0DL
X-Google-Smtp-Source: ABdhPJyvldHL4jd+sdrtPpxd8J4i6Vj8VlfcYQNc31/z4YH5bh81ni5KWc6T3HappCWbco3ROa9O9A==
X-Received: by 2002:a05:651c:1787:b0:244:3308:eb71 with SMTP id bn7-20020a05651c178700b002443308eb71mr3259346ljb.492.1645126425070;
        Thu, 17 Feb 2022 11:33:45 -0800 (PST)
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com. [209.85.167.41])
        by smtp.gmail.com with ESMTPSA id i8sm48037lfj.226.2022.02.17.11.33.40
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Feb 2022 11:33:42 -0800 (PST)
Received: by mail-lf1-f41.google.com with SMTP id i11so1209948lfu.3
        for <patches@lists.linux.dev>; Thu, 17 Feb 2022 11:33:40 -0800 (PST)
X-Received: by 2002:ac2:4d91:0:b0:443:127b:558a with SMTP id
 g17-20020ac24d91000000b00443127b558amr3044488lfe.542.1645126419579; Thu, 17
 Feb 2022 11:33:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <Yg2C2NTphV3eMkUp@bombadil.infradead.org>
In-Reply-To: <Yg2C2NTphV3eMkUp@bombadil.infradead.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 17 Feb 2022 11:33:23 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjR67HKkrPkmHXYET5M0EVwtrfAFC+AvZPd4obpzvXLLw@mail.gmail.com>
Message-ID: <CAHk-=wjR67HKkrPkmHXYET5M0EVwtrfAFC+AvZPd4obpzvXLLw@mail.gmail.com>
Subject: Re: Modules fixes for v5.17-rc5
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: Jessica Yu <jeyu@kernel.org>, Colin Ian King <colin.king@intel.com>, 
	Dmitry Torokhov <dmitry.torokhov@gmail.com>, patches@lists.linux.dev, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-modules@vger.kernel.org, 
	Aaron Tomlin <atomlin@redhat.com>, Vimal Agrawal <avimalin@gmail.com>, 
	Christophe Leroy <christophe.leroy@csgroup.eu>, Michal Suchanek <msuchanek@suse.de>
Content-Type: text/plain; charset="UTF-8"

On Wed, Feb 16, 2022 at 3:03 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
>
> So far only one fix has trickled through for modules. It is part of this
> pull request. It's a minor build fix for when CONFIG_SYSFS=n. Let me
> know if there are any issues with this.

The only issue I have is that because you didn't put "[GIT PULL]" in
the subject line, the pr-tracker-bot doesn't pick up on it, so you're
not getting a "this has been merged" confirmation email.

My own search criteria for pull requests aren't as strict, so I saw it
in my pending queue. But then I spent time wondering why I didn't see
the pr-tracker-bot response when I pushed out, so I actually prefer
for people to use the stricter rules that the pr-tracker-bot looks
at...

                  Linus
