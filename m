Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 306F0A28
	for <patches@lists.linux.dev>; Thu,  2 Mar 2023 22:56:53 +0000 (UTC)
Received: by mail-pl1-f180.google.com with SMTP id v11so861431plz.8
        for <patches@lists.linux.dev>; Thu, 02 Mar 2023 14:56:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1677797812;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=bh8uEZAD/yvWP1Lrn9R+0QNZba+XTTUTVdSRMgAQcmQ=;
        b=K//SvYScc9/RPlNzAc+bbNZPJfdelma3q9O4bB1wnxAJ4F3+DrxFkHfD9CzyFhzWbQ
         zxzjRce8GzbRVhw5ROu1iovSYFPgJkpXdsVV9KLRuZ+DLM3i6IU1sNlajSgCAnvliBm1
         V57qqveobMxUQT7AgmZQGrEwmKkrWRVbgNjpI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677797812;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bh8uEZAD/yvWP1Lrn9R+0QNZba+XTTUTVdSRMgAQcmQ=;
        b=MR8sgJtHJvi2RKY0xxVpVQNAF0Qt8IDlGE/4PGMa/KAe6swk787DGXXXQLK0OAq2yd
         BdS7Ulasx2e08C+UsyqDkfMMls0sZGIdbDzrLNAgOewiHdzR3SfTErc5a/hxYOPpO0u+
         KIiQKe31zZOp5qM6TucVlLMDBW2SwSqE2rnzaeTp2/frZzi4+KCxdUjVoWrI/wc8PlpA
         hKW8cnhApO+LuPHVEmyrLR1UeS0AdyZrWxixiTxoNWf322cl1oKTVcf6H+ZjF+WrZWSu
         8tAz7GOhVPjvQoASvtIJOph5l+hgCiBDgP7hp+Jejmc5FqQjKYMt8HUKxEW4nTTc5HiX
         ikhA==
X-Gm-Message-State: AO0yUKUtor/MbC77YJ97LnNE1X+US+Bois1WI1gBLoZTyWwKnLP03ONl
	1UflsYtJtUUux8MRDZwB36o+YQ==
X-Google-Smtp-Source: AK7set8NQA8CZRtcwSlTz7C5GCelOHtAp1Ylxj2HvVTT0A4/xUpLXx5v+dscM8DAlm1E4D6F1Zi9ew==
X-Received: by 2002:a17:902:d2c9:b0:19e:3b41:1828 with SMTP id n9-20020a170902d2c900b0019e3b411828mr4267544plc.22.1677797812569;
        Thu, 02 Mar 2023 14:56:52 -0800 (PST)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id kx7-20020a170902f94700b001990028c0c9sm192659plb.68.2023.03.02.14.56.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 14:56:52 -0800 (PST)
Message-ID: <640129b4.170a0220.e5ce3.0f65@mx.google.com>
X-Google-Original-Message-ID: <202303021456.@keescook>
Date: Thu, 2 Mar 2023 14:56:51 -0800
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
Subject: Re: [PATCH 06/11] yama: simplfy sysctls with register_sysctl()
References: <20230302202826.776286-1-mcgrof@kernel.org>
 <20230302202826.776286-7-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230302202826.776286-7-mcgrof@kernel.org>

On Thu, Mar 02, 2023 at 12:28:21PM -0800, Luis Chamberlain wrote:
> register_sysctl_paths() is only need if you have directories with
> entries, simplify this by using register_sysctl().
> 
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>

Acked-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
