Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7D5E33CC
	for <patches@lists.linux.dev>; Mon, 10 Oct 2022 17:39:24 +0000 (UTC)
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-1324e7a1284so13211026fac.10
        for <patches@lists.linux.dev>; Mon, 10 Oct 2022 10:39:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fXqpXa4IyHrDSP2AtB2YWiprFebXlxfr4+UnrmeiBVA=;
        b=KqviEEBaSdVH2q+WuAtppLJiJW/8K6S5Glb5rAQ1xGk2IYY4NmIr7n1xHK2pgCGJ65
         znOSOrK76CINQtx3yf5p2bq5o0lAFX5Fzj3ydTXddzJFvd+3aFgudyg4m7sUtD/0Egr+
         Iy0W1VBbhV+D5CKtpTeWh7wiBEkb52P/V1czk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fXqpXa4IyHrDSP2AtB2YWiprFebXlxfr4+UnrmeiBVA=;
        b=v8TcokpBGqcAuEnM1/v924a2ElvnHYkav/8Q4CfXtpQ2gXwtDH1t/9HxOP3VpZrJKb
         FCEaBYaBa8avezLgr638xrz6aBt1rijodMJChAE3FFXqwI4s3979cNblNG7FWnK7udX6
         AXGX+Nu6egoK7CvJPBN8oMbkLTJ5r7tkffiQC3EfDsNImTUoouy0qcaTPrzUJDL6A380
         ai7N0Z9UZ5EnMAcqMhTBYvjA8rE/MdP4QrVRe2jL+hleR5wFPPAunJu5mE9CchxAiHLt
         aIrjjYLdpRt4iS79Zwuh2u9Vm7+wV9TtxC5hxL64ch/jAgin7qYCoSTxl4YsQ7el4+An
         Uo1Q==
X-Gm-Message-State: ACrzQf1GnK2/7L1AQ3KUiC6TIOBUvSRCD5szLxYieBtdJJNCnbb2QyxH
	BVKKBJcPIc5LktP3JLHZmb43FEnxfeLlIg==
X-Google-Smtp-Source: AMsMyM6/V5DgKPozsTJ+ryKF4TGT98ceGnFFjjyH6aziVK68xCQ2m/BHehcqWNC+NFrVTwe/ItbE8A==
X-Received: by 2002:a05:6870:40cb:b0:131:4fec:3c7d with SMTP id l11-20020a05687040cb00b001314fec3c7dmr16041109oal.147.1665423563769;
        Mon, 10 Oct 2022 10:39:23 -0700 (PDT)
Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com. [209.85.160.47])
        by smtp.gmail.com with ESMTPSA id k16-20020a0568080e9000b003549db40f38sm682913oil.46.2022.10.10.10.39.23
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Oct 2022 10:39:23 -0700 (PDT)
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-132fb4fd495so13198647fac.12
        for <patches@lists.linux.dev>; Mon, 10 Oct 2022 10:39:23 -0700 (PDT)
X-Received: by 2002:a05:6870:c0c9:b0:127:c4df:5b50 with SMTP id
 e9-20020a056870c0c900b00127c4df5b50mr10186924oad.126.1665423562950; Mon, 10
 Oct 2022 10:39:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <d1eaa4f7-6b88-9c14-91d2-84cdbd4b8a31@suse.cz>
In-Reply-To: <d1eaa4f7-6b88-9c14-91d2-84cdbd4b8a31@suse.cz>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 10 Oct 2022 10:39:06 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiUA_3pO2jSsMZauVibx20fSdZV+aan217fy+MuGDJT8A@mail.gmail.com>
Message-ID: <CAHk-=wiUA_3pO2jSsMZauVibx20fSdZV+aan217fy+MuGDJT8A@mail.gmail.com>
Subject: Re: [GIT PULL] slab changes for 6.1-rc1
To: Vlastimil Babka <vbabka@suse.cz>
Cc: David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, 
	Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	LKML <linux-kernel@vger.kernel.org>, patches@lists.linux.dev, 
	Roman Gushchin <roman.gushchin@linux.dev>, Hyeonggon Yoo <42.hyeyoo@gmail.com>, 
	Kees Cook <keescook@chromium.org>, Feng Tang <feng.tang@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, Oct 3, 2022 at 9:07 AM Vlastimil Babka <vbabka@suse.cz> wrote:
>
> This time I tried using topic branches much more than previously, hopefully in
> an acceptable way. After rc5-ish I also tried to stabilize their merging into
> for-next (and thus the resulting for-6.1) as well. Hence branches
> slab/for-6.1/trivial and slab/for-6.1/slub_validation_locking appear to be
> merged twice due an extra cleanup and fix, respectivelly, being added and
> merged only last week. In slab/for-6.1/kmalloc_size_roundup I however decided
> for squashing a fix last week [1] to avoid needless build errors while bisecting.

Looks good to me. And thanks to the topic branches, you can actually
see the different series (particularly that "common kmalloc" one
clearly in the history.

Thanks,

                  Linus
