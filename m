Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82A7D174FF
	for <patches@lists.linux.dev>; Fri, 18 Aug 2023 23:26:55 +0000 (UTC)
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-565334377d0so1103950a12.2
        for <patches@lists.linux.dev>; Fri, 18 Aug 2023 16:26:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692401215; x=1693006015;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FsfLkqBQqdxaRuo7uj/qF8hlDrHgr+MRrYHL1O0X1hM=;
        b=AqywAuwfitvIhm4eSzC2bxNkrkzsrYfcL3pDIf1TS240OKjQWwlGIIlXK3NAli+jzI
         YAJVNJjvnrTqYS7vZXzUrpu1KOayrYWnIePBY21dZ0cTcJps0qoSyH6amyrZGQGI6oxT
         RWa5vGxr6Kbv4ghHa6F+e2D7Sizw3cBtA/Vckby+yJYorz7BNaXThRC141ymK9FqVDfm
         c+d63ah+Sg6D7F4EtwdQKcBwCHnu6I/sYkJJpAD7GJGmSoahIEYEHHSMSngj0NjHlW8N
         TIQfQXaPoRwhOmx7FJLvvLQ2mOkBcsIhakyStN44aUaLzuubPygezNU0NzqB+MDYeZRW
         8Wag==
X-Gm-Message-State: AOJu0YyGzuxXoNGcfHbu3d8aeP+oVxycZE93GFP/QXAG2YqWfq2sPr19
	pRqURseiwx0eqDp3nB/t85c=
X-Google-Smtp-Source: AGHT+IGWjyNpgrOJ/NI64D+xsix0f/F8Hn5mj10s4nYBcvXzKG4Z2V+m193dmTs1JWaRTUKcpzhssQ==
X-Received: by 2002:a05:6a21:498e:b0:13f:5234:24ce with SMTP id ax14-20020a056a21498e00b0013f523424cemr692055pzc.28.1692401214839;
        Fri, 18 Aug 2023 16:26:54 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([20.69.120.36])
        by smtp.gmail.com with ESMTPSA id m18-20020aa78a12000000b00688701c3941sm2022882pfa.111.2023.08.18.16.26.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Aug 2023 16:26:54 -0700 (PDT)
Date: Fri, 18 Aug 2023 23:26:36 +0000
From: Wei Liu <wei.liu@kernel.org>
To: Nuno Das Neves <nunodasneves@linux.microsoft.com>
Cc: linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
	x86@kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-arch@vger.kernel.org, patches@lists.linux.dev,
	mikelley@microsoft.com, kys@microsoft.com, wei.liu@kernel.org,
	haiyangz@microsoft.com, decui@microsoft.com,
	apais@linux.microsoft.com, Tianyu.Lan@microsoft.com,
	ssengar@linux.microsoft.com, mukeshrathor@microsoft.com,
	stanislav.kinsburskiy@gmail.com, jinankjain@linux.microsoft.com,
	vkuznets@redhat.com, tglx@linutronix.de, mingo@redhat.com,
	bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
	will@kernel.org, catalin.marinas@arm.com
Subject: Re: [PATCH v2 08/15] Drivers: hv: Introduce per-cpu event ring tail
Message-ID: <ZN/+LD2KMa8ANMiA@liuwe-devbox-debian-v2>
References: <1692309711-5573-1-git-send-email-nunodasneves@linux.microsoft.com>
 <1692309711-5573-9-git-send-email-nunodasneves@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1692309711-5573-9-git-send-email-nunodasneves@linux.microsoft.com>

On Thu, Aug 17, 2023 at 03:01:44PM -0700, Nuno Das Neves wrote:
> Add a pointer hv_synic_eventring_tail to track the tail pointer for the
> SynIC event ring buffer for each SINT.
> 
> This will be used by the mshv driver, but must be tracked independently
> since the driver module could be removed and re-inserted.
> 
> Signed-off-by: Nuno Das Neves <nunodasneves@linux.microsoft.com>

Reviewed-by: Wei Liu <wei.liu@kernel.org>
