Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 630C428F7
	for <patches@lists.linux.dev>; Fri, 30 Dec 2022 17:04:45 +0000 (UTC)
Received: by mail-pl1-f170.google.com with SMTP id jl4so16149930plb.8
        for <patches@lists.linux.dev>; Fri, 30 Dec 2022 09:04:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=googled;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Rp8DP41XrSw0rokxDPlHiL2vJVa6DK6lhh3jR60QHzQ=;
        b=jQCEnGalnxhHOck1mpzCJTxyEOCEGMM0VObMvYaUwQc2WXxbmcxUI5KtICtKtBGnl5
         g7fyRVxFBJ+z9pjQZE6R9hiN2jSDc8G7vqObk/UDfqKKYnry4EYpkNudJSczMIJYbQGW
         pnqkBL+bWSkZSOsEVUmbf4c4QodAjzr8OgJGzLmBradO2skjYwSOv3cWngR0knKEeWok
         hSoSyEjWF+20dxo3ZdfNhaDBytq2A6G3SttD4KlLZd8D0FaBXicsFioM7RlTX37F9x12
         6UEF48zrn7hR1O086VTgp7fjZn8av6gvfn/NFNYUkId2XNiC+ocU1rXn3UYxa3idug57
         /Fiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Rp8DP41XrSw0rokxDPlHiL2vJVa6DK6lhh3jR60QHzQ=;
        b=JSa4lrxtWMaW4eL8T3OqmAD1zf3MXQak0G7Oo5eSoAhLQiSGVmTNY6BKBoCVISnXvF
         22ngUKwQTx25qbCoIU76V6oFir8DU+UXO+e+h53Qv0BlI48AQNeNKtEWkcbo7TdcZEFI
         d3Pdvbie1UL57Ci0LDvPNCrjGICNtDBBzQlDZF8MZX9u3lnsyo5INAJZtqy3yPfQTklb
         mDJ1fmGUhxDdY9vVPtDRQyl/1LQvJnXsAy2dAKMQWJKfLucuMyLp+zFt9s3/9kRLqZ9z
         ihsWCGqZSYNGJYsXzjFFcLgArjnyeV6OOB4aIvdy2NbXtnlEwr3grFX3xM6DP242MiCp
         /2Tw==
X-Gm-Message-State: AFqh2ko+DRirz3375iiHLfumiG6GQHJ3I9pNNHG+S9YQXvRN4vJOCxz3
	k+3kcydTD7WtOPU2IzQhUPX/Hi6fSUM5LKfIRptI4Q==
X-Google-Smtp-Source: AMrXdXtX6SgWkB8eYBoy55qpzn+bUv9TBTVEu1B6SElDTvzpS2nx6LNeZAYQfbA4yR9RNC/dBQ2cDlWs6+44t/eY99Q=
X-Received: by 2002:a17:90a:af91:b0:219:536b:41ef with SMTP id
 w17-20020a17090aaf9100b00219536b41efmr2903859pjq.71.1672419884549; Fri, 30
 Dec 2022 09:04:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221230094107.317705320@linuxfoundation.org>
In-Reply-To: <20221230094107.317705320@linuxfoundation.org>
From: Slade Watkins <srw@sladewatkins.net>
Date: Fri, 30 Dec 2022 12:04:33 -0500
Message-ID: <CA+pv=HMf6-d38AJLm4_gO2NOW9SAPJO5uBq59ga+SVFsexOQ1A@mail.gmail.com>
Subject: Re: [PATCH 6.1 0000/1140] 6.1.2-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

On Fri, Dec 30, 2022 at 4:49 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.2 release.
> There are 1140 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 01 Jan 2023 09:38:41 +0000.
> Anything received after that time might be too late.

rc2 - Compiled and tested on my x86_64 test systems, no errors or
regressions to report.

Tested-by: Slade Watkins <srw@sladewatkins.net>

-- Slade
