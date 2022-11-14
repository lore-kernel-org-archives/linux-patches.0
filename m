Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 197864C92
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 14:40:43 +0000 (UTC)
Received: by mail-wr1-f42.google.com with SMTP id cl5so18640163wrb.9
        for <patches@lists.linux.dev>; Mon, 14 Nov 2022 06:40:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VB9I5ZAWCtKhLs2tRpa3Gm4Asdyf5i+TqTp4v6wgnV4=;
        b=OYNq8S87ktWZS7PJSQp9pp/oCegVjPpenU5qsxHZNe/LgKQ3qdjNkkiYbXv12UGRox
         3gVpLUyb2+VYoPZfsLIVLGkXIkDV1nfFF4PIEwoktOVi1PKboZ7oaKDiQ8Xh2sSxCOy+
         WRP0V4K8DhfR/wCHFjDKZs0GZDcLh1SbGnu9CM+DuBNBJacwxmnxIrFGSqmNmThWghos
         ul3kjvgawEcQOr8ynvaPEyaIIjkhUoeB6/vSroMYZs75yPMfHR0hTVJAlE3ecIBinSLq
         d2ndMDQQ5LCemn8z0Niwk3K4lrZXJp4XoQmYSJ3RCS0hMjJ6CXo1n8fgu6L/T8hm1/dw
         MLVw==
X-Gm-Message-State: ANoB5pkk75b/RYWWSx1cyPWraWOo2rX/FljmNzhKPZ3nVJqISsE/4Whh
	N9RytEmHn7z3/o6GUgmhdY8=
X-Google-Smtp-Source: AA0mqf5gcV2w2db+R2nSHxwSW27AHxtczMBvcmJooGoudwALEd21KAK5DO0DMANsAmA9m8z9SPwrcg==
X-Received: by 2002:a5d:6743:0:b0:22e:28fe:39d6 with SMTP id l3-20020a5d6743000000b0022e28fe39d6mr7811102wrw.701.1668436841384;
        Mon, 14 Nov 2022 06:40:41 -0800 (PST)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id ay19-20020a05600c1e1300b003c6bbe910fdsm22597325wmb.9.2022.11.14.06.40.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 06:40:41 -0800 (PST)
Date: Mon, 14 Nov 2022 14:40:39 +0000
From: Wei Liu <wei.liu@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev, Adam Bratschi-Kaye <ark.email@gmail.com>,
	Wei Liu <wei.liu@kernel.org>
Subject: Re: [PATCH v1 02/28] rust: print: add more `pr_*!` levels
Message-ID: <Y3JTZ5sle+/A/CdD@liuwe-devbox-debian-v2>
References: <20221110164152.26136-1-ojeda@kernel.org>
 <20221110164152.26136-3-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221110164152.26136-3-ojeda@kernel.org>

On Thu, Nov 10, 2022 at 05:41:14PM +0100, Miguel Ojeda wrote:
> Currently, only `pr_info!` (for the minimal sample) and
> `pr_emerg!` (for the panic handler) are there.
> 
> Add the other levels as new macros, i.e. `pr_alert!`, `pr_crit!`,
> `pr_err!`, `pr_warn!`, `pr_notice!` and `pr_debug!`.
> 
> Co-developed-by: Adam Bratschi-Kaye <ark.email@gmail.com>
> Signed-off-by: Adam Bratschi-Kaye <ark.email@gmail.com>
> Co-developed-by: Wedson Almeida Filho <wedsonaf@gmail.com>
> Signed-off-by: Wedson Almeida Filho <wedsonaf@gmail.com>
> Co-developed-by: Gary Guo <gary@garyguo.net>
> Signed-off-by: Gary Guo <gary@garyguo.net>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Wei Liu <wei.liu@kernel.org>
