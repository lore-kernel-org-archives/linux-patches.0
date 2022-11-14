Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 719134C92
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 14:32:47 +0000 (UTC)
Received: by mail-wr1-f44.google.com with SMTP id v1so18565318wrt.11
        for <patches@lists.linux.dev>; Mon, 14 Nov 2022 06:32:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YCY5hqYU1SfTXWjQyYMV6/iKq7L1yppgMWYjdS1kJoY=;
        b=0K0r6Jp9K3kkFN7hF0f49NDNacn3xFil/JQHKYYLnzMGpYV+5gQN3iycRtrGYoRvO/
         MAfjfTLIujlt+8VJtnsWBK+JT2vI/TCg2iWGc9ySXj4Bn1XQMOt/qudHlF99MCG6p7XU
         G0MQNG1FaUxAE/5JRun1mX19gAC45cPa/MoRAZw+lRPk++xy8VplJ+BVnxodf2VhgWWT
         RRogkAIi7lgtkAL96NG73StsVSr1frWpV9ka3nHsksjRrnG/1znPVBBS4hyIdzW6zrSS
         D1Ob5EVBLQ+JdfNNlb6otO8JQ1SCShJE5vsBJsMAeOnIN2WfRYNTbHQZ1lBuC9laHpgs
         7NFw==
X-Gm-Message-State: ANoB5pmOyeTaMkjl1FQxctJCacq/M02gABIztPkDGrAiPTnjYi0apsJY
	jMSlCE2GCcAIi3nhW6cUFAc=
X-Google-Smtp-Source: AA0mqf44IOc5pBuohngXoHzggcsR7YAaWDyqU68BandfFZcF4YWXfAEJc2IF2+LorP2JCqRjywxesA==
X-Received: by 2002:adf:f342:0:b0:236:57cf:1b6f with SMTP id e2-20020adff342000000b0023657cf1b6fmr7859753wrp.153.1668436365814;
        Mon, 14 Nov 2022 06:32:45 -0800 (PST)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id g4-20020a5d4884000000b002383e977920sm9651659wrq.110.2022.11.14.06.32.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 06:32:45 -0800 (PST)
Date: Mon, 14 Nov 2022 14:32:43 +0000
From: Wei Liu <wei.liu@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev, Wei Liu <wei.liu@kernel.org>
Subject: Re: [PATCH v1 27/28] rust: types: add `Either` type
Message-ID: <Y3JRi2cn77rzunaW@liuwe-devbox-debian-v2>
References: <20221110164152.26136-1-ojeda@kernel.org>
 <20221110164152.26136-28-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221110164152.26136-28-ojeda@kernel.org>

On Thu, Nov 10, 2022 at 05:41:39PM +0100, Miguel Ojeda wrote:
> From: Wedson Almeida Filho <wedsonaf@gmail.com>
> 
> Introduce the new `types` module of the `kernel` crate with
> `Either` as its first type.
> 
> `Either<L, R>` is a sum type that always holds either a value
> of type `L` (`Left` variant) or `R` (`Right` variant).
> 
> For instance:
> 
>     struct Executor {
>         queue: Either<BoxedQueue, &'static Queue>,
>     }
> 
> Signed-off-by: Wedson Almeida Filho <wedsonaf@gmail.com>
> [Reworded, adapted for upstream and applied latest changes]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Wei Liu <wei.liu@kernel.org>
