Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE56442BFB
	for <patches@lists.linux.dev>; Fri, 22 Sep 2023 18:48:58 +0000 (UTC)
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-68cbbff84f6so2925174b3a.1
        for <patches@lists.linux.dev>; Fri, 22 Sep 2023 11:48:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695408538; x=1696013338;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hL5bEyIdwLqLeBmJpTNF22yRvuv3aGh3Q9CwJkae028=;
        b=COdqUefs5J3maX0wUOsL4QIwHvCZxPZZoybndreqU7xYNunALAych+E5uKZ9be7Y72
         CZuR8LUhZO3nistMIm4oXQ4SjaNRBB1eDy2a4iPnmlmfnZRMXtfCXomZDheinGFsSmNt
         sWCnkKLL/KKSAinrhtwFi/W3zJ5YHxNW03EDo3lzOT9QkUZoOZpMeFQyYaJGZBTz1enD
         t16K4j/Pje0s2sKQ44hGxa22QLtggwta8+jJr3xQnceryuqK0irnLO2ikU0vzTTuJH0Q
         +OKym7NzJ6Ur5NBy8b9Iwb/s+USWdEjotwkXciRA6Vys+zqmnR3BO0aospP0Jv/lem6F
         lbiw==
X-Gm-Message-State: AOJu0YzRK3DT6v4HJc7TdJCnIrFSRFBu8cAsA/1domR+hnjyzkrAbbXG
	1Dmk+BBpTy/gUQhyU998J8Q=
X-Google-Smtp-Source: AGHT+IHH3V+wn81SPydKnVucq6fioEnuRLf9tOh/vQim6/QBf0odXijPI8phhlNSwrYfPzOStF+8kA==
X-Received: by 2002:a05:6a21:7891:b0:152:4615:cb9e with SMTP id bf17-20020a056a21789100b001524615cb9emr696294pzc.13.1695408537936;
        Fri, 22 Sep 2023 11:48:57 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([20.69.120.36])
        by smtp.gmail.com with ESMTPSA id q17-20020a637511000000b00570574feda0sm3473414pgc.19.2023.09.22.11.48.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Sep 2023 11:48:57 -0700 (PDT)
Date: Fri, 22 Sep 2023 18:48:14 +0000
From: Wei Liu <wei.liu@kernel.org>
To: Nuno Das Neves <nunodasneves@linux.microsoft.com>
Cc: linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
	x86@kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-arch@vger.kernel.org, patches@lists.linux.dev,
	mikelley@microsoft.com, kys@microsoft.com, wei.liu@kernel.org,
	gregkh@linuxfoundation.org, haiyangz@microsoft.com,
	decui@microsoft.com, apais@linux.microsoft.com,
	Tianyu.Lan@microsoft.com, ssengar@linux.microsoft.com,
	mukeshrathor@microsoft.com, stanislav.kinsburskiy@gmail.com,
	jinankjain@linux.microsoft.com, vkuznets@redhat.com,
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
	dave.hansen@linux.intel.com, hpa@zytor.com, will@kernel.org,
	catalin.marinas@arm.com
Subject: Re: [PATCH v3 12/15] Documentation: Reserve ioctl number for mshv
 driver
Message-ID: <ZQ3hbhOJdjbveIUH@liuwe-devbox-debian-v2>
References: <1695407915-12216-1-git-send-email-nunodasneves@linux.microsoft.com>
 <1695407915-12216-13-git-send-email-nunodasneves@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1695407915-12216-13-git-send-email-nunodasneves@linux.microsoft.com>

On Fri, Sep 22, 2023 at 11:38:32AM -0700, Nuno Das Neves wrote:
> Signed-off-by: Nuno Das Neves <nunodasneves@linux.microsoft.com>
> Acked-by: Jonathan Corbet <corbet@lwn.net>

Acked-by: Wei Liu <wei.liu@kernel.org>
