Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 390BC4350
	for <patches@lists.linux.dev>; Mon,  7 Mar 2022 21:28:13 +0000 (UTC)
Received: by mail-pf1-f175.google.com with SMTP id s11so15471161pfu.13
        for <patches@lists.linux.dev>; Mon, 07 Mar 2022 13:28:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PImHJe2UAKTKdLzbka2oPzbR4jyxspwMY4yN+DC78os=;
        b=YIwcUYinBHuQkOw71MFOJWXaviYwDf15Zt5dUlHw84q4j9Oc2/RPyplay1J6d8oA8J
         6llbD5EBv8KpGaTOmo8ubzhcn4XVaMCoJ4tfZHncBCvOj+o4lYL6gbtLjah7KvbaJos0
         V4jPV3R8UjHI6WMXCHQPpAbebPTxZjmnBLWKMZTiiMSrF1xMH85S1MdVQNueDJuazC+N
         VUzW8sUj8xICv6NIlCIo3Mu7OJRwGl1L8oQHm6LXCZfG5lMEW6PFATgnWGxJgD37CoR/
         w0B/JTTUsxeqCxM8+st3XJUzoHNB03Cpcu2FTkL9wkkVnDjZfxcV1LDbdHFAmV6N+I92
         mq4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PImHJe2UAKTKdLzbka2oPzbR4jyxspwMY4yN+DC78os=;
        b=pHq9Sy3iMJKPGEPm2bLqPqpozWcgf1x5Xxl7Ce1LFeA9ndjbSKepZBxZTYuJ4MHmaz
         0V9HuUwQle7Ubdhb0ly78n12uCYZRZig/RSE+TiOz0YgwM00tTtjc8VHA4Gei6arsm4Q
         zZI0aw+Du81t/2hf02ar9zzrno16M2yHN83KoLctIkJbPf1PbVWW8PDvrC1YxDPwYvDk
         jBVybQ+MbB1pULqhrgk5xMpKz2oGi2MSxCFCWTOxDPLtuloq1CjE5HeGACM32azxT0iO
         DfB9geYgnb5LbY8K/IvbF5iLMaqvhJh9lcs29nLplKbYw4Im3d6cKUOg50iIXLtn1N8L
         VNzQ==
X-Gm-Message-State: AOAM531fOLzC9dQApxMyDBTnzDpUt5NarsGRkmPHoftg2wNQtmExDq4X
	7yZzawxYDV49Y2Sdx0qP0VzDiWiZ+TvAABFbpajeog==
X-Google-Smtp-Source: ABdhPJwuLzmS+KlSHxrMx4r8+wjAkPbvfS39sMJUhbtoQlDMdOBplYzGmTuAc3AWOm7gWL9xtmeUhJBVldl1o9SJVLk=
X-Received: by 2002:a05:6a02:283:b0:342:703e:1434 with SMTP id
 bk3-20020a056a02028300b00342703e1434mr11374652pgb.74.1646688492661; Mon, 07
 Mar 2022 13:28:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220301195457.21152-1-jithu.joseph@intel.com>
 <20220301195457.21152-9-jithu.joseph@intel.com> <188492dc80c017375da76d444347b1d00c2031f6.camel@intel.com>
 <7b9c788e-21dc-eedc-a1b4-9c6877fa48fe@intel.com> <CAPcyv4h=qPFrP+mRqaZhkh5ZmYjuQawsqvf+-R036ZJVKBNK4Q@mail.gmail.com>
 <33d0e764-86d9-8504-17fa-14b31c87de4e@intel.com> <CAPcyv4g5bq9+u0iLjhpeJw8bkbCREUw60H2z_KfDz4hHCrKdFQ@mail.gmail.com>
 <7c620f8a-189e-5ac4-30fe-1fa14ba799ea@intel.com> <CAPcyv4iUuZ0aAWckWvwbxJJgt5tDJRpeonfE4DegWS6KPtJq8A@mail.gmail.com>
 <eab8177d-eb73-ec64-ec1f-4f2a51be8aee@intel.com>
In-Reply-To: <eab8177d-eb73-ec64-ec1f-4f2a51be8aee@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 7 Mar 2022 13:28:04 -0800
Message-ID: <CAPcyv4h7E5mJ5FAhO3pkqyJPTSnRs-3+0e8zFXbX3FcW838ctA@mail.gmail.com>
Subject: Re: [RFC 08/10] platform/x86/intel/ifs: Add IFS sysfs interface
To: "Joseph, Jithu" <jithu.joseph@intel.com>
Cc: "hdegoede@redhat.com" <hdegoede@redhat.com>, "markgross@kernel.org" <markgross@kernel.org>, 
	"corbet@lwn.net" <corbet@lwn.net>, "Raj, Ashok" <ashok.raj@intel.com>, "Luck, Tony" <tony.luck@intel.com>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, 
	"patches@lists.linux.dev" <patches@lists.linux.dev>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, 
	"rostedt@goodmis.org" <rostedt@goodmis.org>, "Shankar, Ravi V" <ravi.v.shankar@intel.com>, 
	"tglx@linutronix.de" <tglx@linutronix.de>, 
	"platform-driver-x86@vger.kernel.org" <platform-driver-x86@vger.kernel.org>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, "bp@alien8.de" <bp@alien8.de>, 
	"gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, 
	"andriy.shevchenko@linux.intel.com" <andriy.shevchenko@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, Mar 7, 2022 at 12:56 PM Joseph, Jithu <jithu.joseph@intel.com> wrote:
>
>
>
> On 3/7/2022 12:25 PM, Dan Williams wrote:
>
> >
> > I am speaking of the state of the case where 2 threads are doing
> > run_test and polling for results. Unless you can guarantee that run2
> > does not start before the results of run1 have been collected then
> > they are lost in that scenario. No amount of kernel locking can
> > resolve that race to collect previous result which would not be a
> > problem in the first place if there was an atomic way to log test
> > results.
>
>
> Yes "status" shows the status of the latest run. You cannot get the status of the previous run.
>
> Also some context on test frequency: Hardware has  strict rate limiting of tests.
> Every core can be tested only once in every 30 minutes. So it is pointless to test at high frequency.

Is that enforced in the ABI? Did I miss that detail in the
documentation? Does that per-core time limitation also mitigate the
race to read the global status? I.e. back-to-back tests on the same
core may need to be spaced by 30 minutes, but between different cores
as well. Again, these are questions that can not even be posed with an
ABI that eliminates the possibility of result races like uevent.
Please think through that suggestion, that's my main motivation for
continuing to poke at this ABI as currently presented.
