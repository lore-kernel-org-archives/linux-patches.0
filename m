Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 017A64C92
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 14:41:44 +0000 (UTC)
Received: by mail-wr1-f44.google.com with SMTP id o4so18546281wrq.6
        for <patches@lists.linux.dev>; Mon, 14 Nov 2022 06:41:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bvyXMscut8YtEUKW0LG7nYy3yoEfhlS82oiHCR3CSTA=;
        b=nBCLDpGkM5mebGQGvixi+YigkSYDmBsWLWELZxL9jFfsjrljrr+pBEzI9x2krcbwcw
         9Yyt4KCrFx0iQN2UFJzlSZUkQNUjofLU8vOkIZRGBNHm61882c2eJGChwnekcsC4BtHK
         DBtIvFa+0a3Pey2ja3P7/ufvbMwZa7HAMvAv+7oxoBqTrsMEvBrpnl3ndNU5j/j7lohM
         V4zcDjwttVNphV3BzRFMxU94OgRHzK4idmiNfOUEt9+xM9IgUY8uqvO7t59xzUasE9iS
         p5vnXIMI1rOJIJQnJzTyb+FU+TQsC+eyVE9lWtrjxAIBlMrEW4dYrmmJekgF+g+pHgdD
         B96Q==
X-Gm-Message-State: ANoB5pmQ0Qb4/KUyXjC1I+YNIUfESQqPJC+Nfs1shvec+eZU9r+ZW+uZ
	Sd8zWtF4rCavREk/TvmrNX2ZE+hptq8=
X-Google-Smtp-Source: AA0mqf7A1q532W+LuavPbVaU6245v6ZBJf1IycKelwo/r+3ik49TGY4koSyx5vprQlZib8ZH7EERyw==
X-Received: by 2002:adf:fc02:0:b0:236:ea0d:e49b with SMTP id i2-20020adffc02000000b00236ea0de49bmr7933863wrr.472.1668436903315;
        Mon, 14 Nov 2022 06:41:43 -0800 (PST)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id bg40-20020a05600c3ca800b003cf78aafdd7sm13149048wmb.39.2022.11.14.06.41.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 06:41:42 -0800 (PST)
Date: Mon, 14 Nov 2022 14:41:41 +0000
From: Wei Liu <wei.liu@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev, Wei Liu <wei.liu@kernel.org>
Subject: Re: [PATCH v1 04/28] rust: samples: add `rust_print` example
Message-ID: <Y3JTpdt47xuY/8cz@liuwe-devbox-debian-v2>
References: <20221110164152.26136-1-ojeda@kernel.org>
 <20221110164152.26136-5-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221110164152.26136-5-ojeda@kernel.org>

On Thu, Nov 10, 2022 at 05:41:16PM +0100, Miguel Ojeda wrote:
> Add example to exercise the printing macros (`pr_*!`) introduced
> in the previous patches.
> 
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Wei Liu <wei.liu@kernel.org>
