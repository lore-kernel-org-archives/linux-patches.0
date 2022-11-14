Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0395D4C92
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 14:41:02 +0000 (UTC)
Received: by mail-wm1-f43.google.com with SMTP id o30so7633910wms.2
        for <patches@lists.linux.dev>; Mon, 14 Nov 2022 06:41:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I2XGpRVkoLcHrK4SdNeUCfF/+fZQfRpvuPV7B8PRXUk=;
        b=uiAGsUMsR2M/YTY8LVNsvXHOyc61CoNc7tTYr3ZLQysdK4szJOPcAAuDaii2ddujlk
         A68Io4fa4yxNWg7ztJo4UOl/IbFWTkINLPMV0eu4K6HeUtSaEkDOEFe8lcCDknDS4V94
         bt2DI2POdi/yzAb0+G5Q8oWpgUbRZymiS2YDzO/gojn1ey/U1+Rp0TdOFImb5Do84nFR
         m+fVpJPi/Lfv3Wu6/UHAWUxzm6TvgaCsXqcS0z1JRZSaYK42vm79bDtITgo8vZleWXkD
         QnH7Ltg1MxUzzeftszTMamF3TaKTpe2O0xl43OYOJi+IvPRBDowBJg8Uvt0xd5MAOLsQ
         FChg==
X-Gm-Message-State: ANoB5pldcYsD3WpxJW/wUuyvZx9q1kw95Ej6gjoWm8X9h19W3Cpv1H8s
	RedlJVtiY9fc5CeTq91Ta5M=
X-Google-Smtp-Source: AA0mqf6K7lETjAus41mGe4n7aRQ1xnrRmdVD376b1yWbbN5z6Pazk7VE7IAy5LFXcnMYzW/bcIE3fg==
X-Received: by 2002:a05:600c:1c06:b0:3c3:77c2:cfff with SMTP id j6-20020a05600c1c0600b003c377c2cfffmr7978664wms.171.1668436861234;
        Mon, 14 Nov 2022 06:41:01 -0800 (PST)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id k5-20020adff5c5000000b0022e344a63c7sm9760993wrp.92.2022.11.14.06.41.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 06:41:00 -0800 (PST)
Date: Mon, 14 Nov 2022 14:40:58 +0000
From: Wei Liu <wei.liu@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev, Adam Bratschi-Kaye <ark.email@gmail.com>,
	Wei Liu <wei.liu@kernel.org>
Subject: Re: [PATCH v1 03/28] rust: print: add `pr_cont!` macro
Message-ID: <Y3JTelPR1zXgaDV8@liuwe-devbox-debian-v2>
References: <20221110164152.26136-1-ojeda@kernel.org>
 <20221110164152.26136-4-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221110164152.26136-4-ojeda@kernel.org>

On Thu, Nov 10, 2022 at 05:41:15PM +0100, Miguel Ojeda wrote:
> This level is a bit different from the rest since it does not
> pass the module name to the `_printk()` call.
> 
> Thus add a new parameter to the general `print_macro!` to
> handle it differently.
> 
> Co-developed-by: Adam Bratschi-Kaye <ark.email@gmail.com>
> Signed-off-by: Adam Bratschi-Kaye <ark.email@gmail.com>
> Co-developed-by: Wedson Almeida Filho <wedsonaf@gmail.com>
> Signed-off-by: Wedson Almeida Filho <wedsonaf@gmail.com>
> Co-developed-by: Gary Guo <gary@garyguo.net>
> Signed-off-by: Gary Guo <gary@garyguo.net>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Wei Liu <wei.liu@kernel.org>
