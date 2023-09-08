Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B85815C5
	for <patches@lists.linux.dev>; Fri,  8 Sep 2023 05:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694150856;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kKCsrqis+BsCzL1au9M77zkgSqfPeD5/UYOFu7ubnBU=;
	b=R5gwUl1QW/7KQlg9lMwIKnWjgpmjufM1XZEXs9ZdJK19vTzVTsR0nH9hETF+I7xCzGWs1U
	W7q+/5SlIJn7wvwt411JfjdcJkt6d8RDs9vUTI5YddQSa50+Ve6GQEn8x669lnzLIuPA8f
	UhStcyntstx2gO8DlIyGXvPyeOwbI7I=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-537-oE0pxHqHMNmCMd155ab6-g-1; Fri, 08 Sep 2023 01:27:32 -0400
X-MC-Unique: oE0pxHqHMNmCMd155ab6-g-1
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-1c0aaf4caaaso22542045ad.2
        for <patches@lists.linux.dev>; Thu, 07 Sep 2023 22:27:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694150852; x=1694755652;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kKCsrqis+BsCzL1au9M77zkgSqfPeD5/UYOFu7ubnBU=;
        b=kSJfF8gJcelHLYXUlozNCJMhAbm8p2/PQLoG0VLY7ZmUi91TV8sKF4WqAS/f/lBSoU
         0PSe+mwSGO7O80V0sFUISSeFgYZ3ap/12NDlmwP5AKz2U3H/xcHuedl0U9cGiyO9MOix
         Fv3xM++2WJKMie3bfCDi7dEAQZo6pkOlfsgi+hMKyoOfgC0+R6i9MnVRuX5iLdyvPla4
         sIK5Gdb/2/g4u6B1LtOTfrSOaGNL4YxI5kuHopZnV/pis9MVXzpK4619Gc9AycDOWmVp
         Ot8tSDkTkcad7NiCs40TDlLZvin4XK4eOnU0Xi0qd3OyGW/QBL7Y/hl3oDls2BBgPQ4N
         Qbig==
X-Gm-Message-State: AOJu0YyXQYdZ1+GTNlW+9XbX9p4MxBrmiUrgoEBjxckSSMkz8INKZVBP
	ahK35r81PMkHVnmwNdSQng+KpW8+JXY+Wt0UGfn7TGsy0CFz4r2Bicr4MMP1G8EPV75L3sal4wI
	yy1/RQao9gzZQG7tOFg==
X-Received: by 2002:a17:902:c945:b0:1bb:32de:95c5 with SMTP id i5-20020a170902c94500b001bb32de95c5mr1976914pla.65.1694150851694;
        Thu, 07 Sep 2023 22:27:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGJ40qCvKRfoIkm0b84FGgfTzvKoPpRC2DfetekChbsCofR092otCbVr1txAVQ/nG9XCDpMRg==
X-Received: by 2002:a17:902:c945:b0:1bb:32de:95c5 with SMTP id i5-20020a170902c94500b001bb32de95c5mr1976899pla.65.1694150851352;
        Thu, 07 Sep 2023 22:27:31 -0700 (PDT)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id jf20-20020a170903269400b001b80760fd04sm646012plb.112.2023.09.07.22.27.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Sep 2023 22:27:30 -0700 (PDT)
Date: Fri, 8 Sep 2023 13:27:27 +0800
From: Zorro Lang <zlang@redhat.com>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: fstests@vger.kernel.org, aalbersh@redhat.com, chandan.babu@oracle.com,
	amir73il@gmail.com, djwong@kernel.org,
	linux-fsdevel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH] check: add support for --start-after
Message-ID: <20230908052727.ccyxadtibouis74h@zlang-mailbox>
References: <20230907221030.3037715-1-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20230907221030.3037715-1-mcgrof@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 07, 2023 at 03:10:30PM -0700, Luis Chamberlain wrote:
> Often times one is running a new test baseline we want to continue to
> start testing where we left off if the last test was a crash. To do
> this the first thing that occurred to me was to use the check.time
> file as an expunge file but that doesn't work so well if you crashed
> as the file turns out empty.
> 
> So instead add super simple argument --start-after which let's you
> skip all tests until the test infrastructure has "seen" the test
> you want to skip. This does obviously work best if you are not using
> a random order, but that is rather implied.
> 
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
>  check | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/check b/check
> index 71b9fbd07522..1ecf07c1cb37 100755
> --- a/check
> +++ b/check
> @@ -18,6 +18,8 @@ showme=false
>  have_test_arg=false
>  randomize=false
>  exact_order=false
> +start_after=false
> +start_after_test=""
>  export here=`pwd`
>  xfile=""
>  subdir_xfile=""
> @@ -80,6 +82,7 @@ check options
>      -b			brief test summary
>      -R fmt[,fmt]	generate report in formats specified. Supported formats: xunit, xunit-quiet
>      --large-fs		optimise scratch device for large filesystems
> +    --start-after	only start testing after the test specified

This option conflicts with "-r" option.

>      -s section		run only specified section from config file
>      -S section		exclude the specified section from the config file
>      -L <n>		loop tests <n> times following a failure, measuring aggregate pass/fail metrics
> @@ -313,6 +316,11 @@ while [ $# -gt 0 ]; do
>  				<(sed "s/#.*$//" $xfile)
>  		fi
>  		;;
> +	--start-after)
> +		start_after=true
> +		start_after_test="$2"

Do we really need two variables at here?

> +		shift
> +		;;
>  	-s)	RUN_SECTION="$RUN_SECTION $2"; shift ;;
>  	-S)	EXCLUDE_SECTION="$EXCLUDE_SECTION $2"; shift ;;
>  	-l)	diff="diff" ;;
> @@ -591,6 +599,15 @@ _expunge_test()
>  {
>  	local TEST_ID="$1"
>  
> +	if $start_after; then
> +		if [[ "$start_after_test" == ${TEST_ID}* ]]; then
> +			start_after=false
> +		fi
> +		echo "       [skipped]"
> +		return 0
> +
> +	fi

I can't understand how you use the --start-after. I though you'd like to remove
all cases before the "start-after" from the running list. But when I saw here,
I'm a little confused.

Thanks,
Zorro

> +
>  	for f in "${exclude_tests[@]}"; do
>  		# $f may contain traling spaces and comments
>  		local id_regex="^${TEST_ID}\b"
> -- 
> 2.39.2
> 

