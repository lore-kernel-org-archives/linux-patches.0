Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE7057C
	for <patches@lists.linux.dev>; Mon, 13 Jun 2022 20:12:29 +0000 (UTC)
Received: by mail-wr1-f52.google.com with SMTP id o8so8476596wro.3
        for <patches@lists.linux.dev>; Mon, 13 Jun 2022 13:12:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LOq+BPckvYHQKeGJ0rXgOkEOuJiM+yu8YvLI9pqoBQg=;
        b=qbUZAt+v2CC3Q4p5lcEFp4Xh1PKc/r5H9G7bNEQigUvWNsRWB4MhuO/Ezj6rAtwRO+
         9mxq2US6cR+VK5ELpo/lGOXCy78OLH1Tte5aNJVOG4tYTk0sKdkGGmSJrf9QJPeJu7xq
         a2mnDe8z6Gw/ibphd2lPonjlj8G1gllZSrn+7X3QreVjL5oJL/N1/g0V/JQHoBFNFjeF
         L3ZOnnkwPt1+XHBfbkUf14MLpuDJIx33DbK4PBkMPCSV5lqJT15pIdKLc8WKKPGoAhrG
         zQiGgqA6N42M154UgN1I44grr8G7D7qc2rLsUF6yRkhfkcH5jgl6Aw9HNcA2oteX4aNf
         vQVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LOq+BPckvYHQKeGJ0rXgOkEOuJiM+yu8YvLI9pqoBQg=;
        b=RdDCrkKQPsn0XgdTi1X4BYsUCRzseUW5+CKl9Oi442xgK18NoyWUe0Sw45MX17+iZ7
         6bFqyurH1U3JaJN+wY2uRX1/Sr0U7a3spZpi+6s1YpdtmCMglJ+6EHyKvj8saMmIfgd+
         qsoK6MxFNU9aAtueuu6iuTbkAFnQWo22US84qwFfAEhz0JCo08PgTkx/DVa773MT2Poq
         G8T2BdRtlhnKD+J9zH7PtEQ/jDbQOhu8B4HNIyvNMUGylehtStnGLEq9RYUysrmllbDg
         1lE28nRp9kMQEScZfm69ZnFMZ92RKPZFYR7YG2q5X4JbAHrkb5lXxvWzQmzwM13UXm4z
         8Pdw==
X-Gm-Message-State: AJIora/W/HlZdJf9Pmb63Qmszq8qNy0cFpghxQgV4BO6/U7XO9qKRnaR
	DF7XTF3NMBANOjbV/PVVbCgGEGow2ADBA0muwZoi
X-Google-Smtp-Source: AGRyM1tFkfiIW9amUpPXfaCCRQ/xd+Xqwkzg6K5j832uqkVmOJDT5j0HzXP4wx7mJlOsDpCCDoWXKNtJYb1IDHc0cQQ=
X-Received: by 2002:a5d:64e7:0:b0:218:5626:7e7f with SMTP id
 g7-20020a5d64e7000000b0021856267e7fmr1374504wri.245.1655151148059; Mon, 13
 Jun 2022 13:12:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220301041454.18960-1-rdunlap@infradead.org> <CAHC9VhSuzpuEm437SCYC8pf0mU6qdWXRU38sb2+JjVtj-8T4Kw@mail.gmail.com>
 <CAHC9VhSa74OFVV=XcceO12kVOxivm5cnyvBo-yeMbyPT8+t5Kg@mail.gmail.com> <87mtegz7t5.fsf@meer.lwn.net>
In-Reply-To: <87mtegz7t5.fsf@meer.lwn.net>
From: Paul Moore <paul@paul-moore.com>
Date: Mon, 13 Jun 2022 16:12:26 -0400
Message-ID: <CAHC9VhTSzVH+jrYieE8WbRLGgkAR65jDX7qtATuFCQRSX+dSgg@mail.gmail.com>
Subject: Re: [PATCH] docs: selinux: add '=' signs to kernel boot options
To: Jonathan Corbet <corbet@lwn.net>
Cc: Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org, 
	patches@lists.linux.dev, Stephen Smalley <stephen.smalley.work@gmail.com>, 
	Eric Paris <eparis@parisplace.org>, selinux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, Jun 13, 2022 at 3:23 PM Jonathan Corbet <corbet@lwn.net> wrote:
> Paul Moore <paul@paul-moore.com> writes:
>
> > I assumed the doc folks would have picked this up but I don't see it
> > in the tree so I'm going to pull it into the selinux/next tree right
> > now.  Thanks again Randy, I'm sorry for the delay.
>
> Sorry, the "doc folks" have learned that, in general, folks in the
> security subsystems prefer to carry their own patches upward, so I
> assumed this one was taken care of.  If you'd rather I picked up SELinux
> documentation patches, I'd be glad to do so.

Hi Jon,

I don't care much either way, as long as Linus' tree is correct I'm
happy.  In this particular case there were no changes under
security/selinux so I assumed that the "doc folks" would merge it; I
have similar assumptions regarding other subsystems when it comes to
SELinux adjacent patches.  However, we all know the old joke about
making assumptions, so I generally keep tracking those patches for a
while and apply them myself if the other subsystems do not.

Generally speaking, if I add an Acked-by for a patch I'm not expecting
to merge that patch (hence the ACK to let the other maintainer know
I'm okay with the patch).  Otherwise I'll merge the patch and send a
reply to the thread that it has been merged into the relevant SELinux
branch.

-- 
paul-moore.com
