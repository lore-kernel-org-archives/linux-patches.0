Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 199902F21
	for <patches@lists.linux.dev>; Tue,  8 Feb 2022 15:04:39 +0000 (UTC)
Received: by mail-wr1-f41.google.com with SMTP id v12so2580572wrv.2
        for <patches@lists.linux.dev>; Tue, 08 Feb 2022 07:04:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QucZOh+L0x1kuUchXX+XOyw1VcfuGS6zeDhpxjRwhpY=;
        b=PkMkAHn32wn1oj3AjB6hNFd8JXghauWpEpUhkWEB1TdQMlLEZzITPQhav9n/jIiC1o
         RBQocoml5MwGgOej4MjSzRTyrkzZZW9RVklnf8oxfFu3kAX1TyL2IHWLRIBnmgBS8xmu
         PeMQq7QcNxlT8VGrBn82k6iXrbpcrYDDU8stssQuCCffOEqfmcHei1gHBmoBWvZ7Wp4P
         8L/cnJS/GksURJ3mcjA9prf+QdEfh7WtZDD8BbaUNVc4fWp/xi+6SeDsar6t4x2dfYwO
         9UJGoDUn8LuiwBj0qQ3aa6YRzFqwsKuDFnzrGJRdSVCHpbS1j1oUiykZ4DK86Flv97WU
         Ei5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QucZOh+L0x1kuUchXX+XOyw1VcfuGS6zeDhpxjRwhpY=;
        b=nHCFb/D6bAL7m2qnl1JBI3HV0Dwg6PK95Un9/lnO+Tbl1Z9S7IduTXPcjQd1kgGTHV
         k5opYfCMI1uHpLlMcmx2bN3ehqCtVzjO/dEM/cX7uzvzcEN7eMm7LYAKAp8waA32uoBb
         rBcYlRP1+iuLRLW304Oys/el1dufdp+waMQI4ZfK0XG+XgBHLgQLPWKb8gNzOs9oRA/k
         5dgbG0uxU5AZ6h6z6zikZRBY00Ca5TULZFqvf3LtZkU58HEeRIN9FejolVq9cAs4t+Hn
         8YU/FgRv1PH1qspP6EwHOUhpgFLb84fdHfbWE6EDjORq+2Yzyp9D/5KPTvXLFD5WLP1H
         XKaQ==
X-Gm-Message-State: AOAM533vkIv1MkktTjV2KPbJO/TY3viyNi4oYqh1bwj+MG/w2w9akEhG
	Vf9AN5K2iS/QL5ehwRoBkXy/n4UtVEjRuVCUatobPA==
X-Google-Smtp-Source: ABdhPJwVhk+3SRtHLUVcgo7zQF+9ELDXxEw6Bomr25Q3I4fffDfwTfnqbDNaX0bakz7CzNz+/fFYgaZFk3D4cOSd69M=
X-Received: by 2002:a5d:5848:: with SMTP id i8mr3861203wrf.342.1644332678074;
 Tue, 08 Feb 2022 07:04:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220207043640.2829295-1-juew@google.com> <YgFqiJOU5tZsHbY6@zn.tnic>
 <YgFyBRIOIquMI2ng@agluck-desk2.amr.corp.intel.com> <YgGAv/aCVG+RDADI@zn.tnic>
 <be53997f26704089b941d33d9bf47bc6@intel.com> <YgGNDenGMCE5ixXw@zn.tnic> <5293d81863b54d6ab0835012201d44da@intel.com>
In-Reply-To: <5293d81863b54d6ab0835012201d44da@intel.com>
From: Jue Wang <juew@google.com>
Date: Tue, 8 Feb 2022 07:04:26 -0800
Message-ID: <CAPcxDJ7nriZEJHF6dMPR7tQ+dGuueyRjw1NC+4CbjxiAT_S+ZA@mail.gmail.com>
Subject: Re: [RFC] x86/mce: Add workaround for SKX/CLX/CPX spurious machine checks
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Borislav Petkov <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

Thanks for the feedback, Tony and Borislav.

I will send out an updated patch.

Thanks,
-Jue

On Mon, Feb 7, 2022 at 1:51 PM Luck, Tony <tony.luck@intel.com> wrote:
>
> >> The erratum has made its way through to the public specification
> >> update yet :-(
> >
> > You mean "has not"?
>
> Curse my pathetic typing skills ... "has NOT made its way" is where we are today.
> I don't know when that status will change.
>
> > In any case, I guess you could say something like:
> >
> >       pr_err_once("Erratum #XXX detected, disabling fast string copy instructions.\n");
> >
> > or so and people can search with the erratum number later where the doc
> > will explain it in more detail.
>
> When the errata (plural, there are separate lists for SKX and CLX) go public
> we could update this message with the names.
We've found this message in combination with logging about the
faulting process info
in do_machine_check helpful when analyzing the originating context of the MCEs.
>
> -Tony
