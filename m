Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3978DA28
	for <patches@lists.linux.dev>; Thu,  2 Mar 2023 22:56:29 +0000 (UTC)
Received: by mail-pj1-f41.google.com with SMTP id 6-20020a17090a190600b00237c5b6ecd7so4325781pjg.4
        for <patches@lists.linux.dev>; Thu, 02 Mar 2023 14:56:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1677797788;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=qXTwXNN5BPBJ/NZ3OYbXwmxOPd3hLZf5+C8HCX49djg=;
        b=cPNPEoDiS/HfsiIItPLGT3E2KS7Pa2nDCzgKjzoBCNTmF5ovdMVml+ppsm005Cz2gc
         pMD41ueS/rsqWBDjk0Ang+swrwWISO9NpTVI+XcAlfsXxlunEfDcOqSyRkjHfJ2N7W3M
         nXhJv2G01aF56hxwfL9a8N8s/N1YUs1FWh6Ok=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677797788;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qXTwXNN5BPBJ/NZ3OYbXwmxOPd3hLZf5+C8HCX49djg=;
        b=yG6eamFf37bxOYQ3yvLX1E6qiBFdZp2mf/zPy+4+++IXCWFok4OkqGdedxmcca5cwf
         CA38Rbmtc+PMTOmCDksemenwMl4mkEQkUEFVtgeTAzQY/Q2qNBJzcavS2k8M8DxUf9mw
         fO432UC5r2lc9V+Cjrd3Sg82gPFWITYyrw6p55N3ezL7+o3NL7xwO1mpB+Adwj7+FKVV
         dyqHXDijQGecR5RyR0Bv2SvV9/eYSX1l59zV8zwAQbJu1EG7lVt/SVWVuI60g7gxxZEN
         WC7YG1jGi+deTTMjyOcl3dBJOWUvbClZJ8dI5Pezh713n3q9LNvob50s9h1GHAlN1NE2
         uThA==
X-Gm-Message-State: AO0yUKXG79SNOkKGUZuuSH1QYMYY/QYVEBVnJBk5roLUUMGMuPGI4JjO
	Hx2K5qr0E92FeJQxPUEuM1Spzg==
X-Google-Smtp-Source: AK7set+MdZhHyeith+B94HrQd6WpkfpBD5XCV21gXOzsSKhUw+dB78RFefTe7N6XbvDbdrdQDA//KA==
X-Received: by 2002:a17:902:ec88:b0:19a:e762:a1af with SMTP id x8-20020a170902ec8800b0019ae762a1afmr3404427plg.33.1677797788585;
        Thu, 02 Mar 2023 14:56:28 -0800 (PST)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id b9-20020a170903228900b00198d7b52eefsm168326plh.257.2023.03.02.14.56.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 14:56:28 -0800 (PST)
Message-ID: <6401299c.170a0220.3a2e.0b8a@mx.google.com>
X-Google-Original-Message-ID: <202303021456.@keescook>
Date: Thu, 2 Mar 2023 14:56:27 -0800
From: Kees Cook <keescook@chromium.org>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: ebiederm@xmission.com, yzaikin@google.com, john.johansen@canonical.com,
	paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com,
	luto@amacapital.net, wad@chromium.org, dverkamp@chromium.org,
	paulmck@kernel.org, baihaowen@meizu.com, frederic@kernel.org,
	jeffxu@google.com, ebiggers@kernel.org, tytso@mit.edu,
	guoren@kernel.org, j.granados@samsung.com, zhangpeng362@huawei.com,
	tangmeng@uniontech.com, willy@infradead.org, nixiaoming@huawei.com,
	sujiaxun@uniontech.com, patches@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, apparmor@lists.ubuntu.com,
	linux-security-module@vger.kernel.org, linux-csky@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/11] seccomp: simplify sysctls with
 register_sysctl_init()
References: <20230302202826.776286-1-mcgrof@kernel.org>
 <20230302202826.776286-8-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230302202826.776286-8-mcgrof@kernel.org>

On Thu, Mar 02, 2023 at 12:28:22PM -0800, Luis Chamberlain wrote:
> register_sysctl_paths() is only needed if you have childs (directories)
> with entries. Just use register_sysctl_init() as it also does the
> kmemleak check for you.
> 
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>

Acked-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
