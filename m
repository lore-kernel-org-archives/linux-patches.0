Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9492D174FF
	for <patches@lists.linux.dev>; Fri, 18 Aug 2023 23:24:50 +0000 (UTC)
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-6889350bc2bso1357246b3a.0
        for <patches@lists.linux.dev>; Fri, 18 Aug 2023 16:24:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692401090; x=1693005890;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U7NQ83aYIyQxi7gLafpFyrR+b24flZ6QbANwWTmLCvc=;
        b=fYGVdtkKjcvLfYkgTKPvlRmkqO68YPVAmGEyWt5FGq3CDlpjVPmny0D+HJIidyH+f0
         +B6CcMZWdcDRC8WpHxY/MIy04nS1RuzdrE/7rZDNZZtIHbucKJ/0qSyUvKHQqNQcW4Yf
         T49lsR+Z5ZqJmlnhgmZxW+Ke3yIBLyXQE9C8pvuIUmjRvin0JaDgDIgS4bM0zm9Yez+k
         MMkmIKDkbQy5d7UzFAZCfbMMD9TwgA4EH8SQRH4J+4bgaQUhGP53dVyXkwfRk17xGVnB
         HnQvouIjnVEsFrsrA9kNiBeOwr7E3wxxncs4VrWeBZFnXwiT0WbU7M+fuYJA4hlbChgE
         QyaQ==
X-Gm-Message-State: AOJu0YziwjEMJsxOvI+kU2pnXf42/ymREJV7RcZJS9IrKqXGGhmHeOEV
	q7MV9TWRJxkT/Etcq+2jItE=
X-Google-Smtp-Source: AGHT+IEhwfhB6DQr618hbfaHC/KUNo74Puro/TMirr0jusK9J3sseJ3LnC6RZE3HgIJvtyH7WvqT0Q==
X-Received: by 2002:a05:6a20:13c7:b0:135:293b:9b14 with SMTP id ho7-20020a056a2013c700b00135293b9b14mr587775pzc.55.1692401089779;
        Fri, 18 Aug 2023 16:24:49 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([20.69.120.36])
        by smtp.gmail.com with ESMTPSA id o9-20020a639209000000b0056946623d7esm2062591pgd.55.2023.08.18.16.24.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Aug 2023 16:24:49 -0700 (PDT)
Date: Fri, 18 Aug 2023 23:24:31 +0000
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
Subject: Re: [PATCH v2 12/15] Documentation: Reserve ioctl number for mshv
 driver
Message-ID: <ZN/9r7bX47g7rkcf@liuwe-devbox-debian-v2>
References: <1692309711-5573-1-git-send-email-nunodasneves@linux.microsoft.com>
 <1692309711-5573-13-git-send-email-nunodasneves@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1692309711-5573-13-git-send-email-nunodasneves@linux.microsoft.com>

On Thu, Aug 17, 2023 at 03:01:48PM -0700, Nuno Das Neves wrote:
> Signed-off-by: Nuno Das Neves <nunodasneves@linux.microsoft.com>
> Acked-by: Jonathan Corbet <corbet@lwn.net>

Acked-by: Wei Liu <wei.liu@kernel.org>
