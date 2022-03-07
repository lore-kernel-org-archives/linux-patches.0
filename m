Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C5797C
	for <patches@lists.linux.dev>; Mon,  7 Mar 2022 19:15:27 +0000 (UTC)
Received: by mail-pj1-f51.google.com with SMTP id v1-20020a17090a088100b001bf25f97c6eso485737pjc.0
        for <patches@lists.linux.dev>; Mon, 07 Mar 2022 11:15:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Ec12nJBSkE86MnU2yz3hD3Crn8S+e1l2jeH9YuRdiFg=;
        b=0h/eT9ol31u+aaBaTF7odf5szx32PTHZvNh5Ed8dtxAx4adLg/+T6CA8K5Pfs/Tagh
         OgbhX2q9ZHDjCi/dTmUbkTxxK1983owlpY53/jvF+3vrcsvfG1cL9vDQt5N8ygzHQ1Qy
         NYNxWAM5UaEp7EFh7Tlun5++cjfAxUjai4dv4X5cqyiDOECQ8eVz3mGDEWujnIOQ7C5z
         W13m/XjsDWandN+9u/WHP2fsBkHIosdm7CnfqdxGcwUPS5l2wg9HSzXIYmHW6ShJ0mRK
         Ie8xjGMmg4Uyl772AdwLuqQ57FIC982eSgqVR1uaj37nar0BYitY8uFm5hRmzhSQLuuL
         YX7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Ec12nJBSkE86MnU2yz3hD3Crn8S+e1l2jeH9YuRdiFg=;
        b=tCwy+B4jnpQkTnm5xn2qrE4MPbVrnZcWR707nlPgAtDP7+b9fbUU8WzUd0BA5esVMn
         bKA4K7NMR/X5AMFPQUTxK3RRZHyH3ymPI9Havnl6ibXnG1M4CgsaoHpfyGeo6F/PIGc2
         Rp3tNWUZYKVOCKXHA/NU0+TY6dPFu6AA4y52XJplAgOIJT/cfqu/WykjSGp4Likzp2k2
         7fX06+dWGqj1D0kxE7kEMRr1AzVhNKLdVLKXc1NBJN0efeU6qUAfHbq6MExmeiplpOhQ
         7xRuZgREELvpQoz3S24C/2KZCoE/fhh4Mxl5EQ3y6ATV/vo5c986DodOhmPwopUCsgBT
         M4hg==
X-Gm-Message-State: AOAM5312zaR6wtayRzH9+f8yr4jA3OWagcQAxn9FuVVta3dxXz55gT/A
	jbx8v8oz3QELNMgiQ/urFzioqShKLboVpCBIHCzSXg==
X-Google-Smtp-Source: ABdhPJyyCiet5Mfd0KFLhDhyKkh5WyTvUsGLB+U4nAW5fU0bwYJ6hjsEn/Zf4pjIYjWajMfWtQADvqo6T0HCv6fkeA4=
X-Received: by 2002:a17:902:7296:b0:14b:4bc6:e81 with SMTP id
 d22-20020a170902729600b0014b4bc60e81mr13651116pll.132.1646680526576; Mon, 07
 Mar 2022 11:15:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220301195457.21152-1-jithu.joseph@intel.com>
 <20220301195457.21152-9-jithu.joseph@intel.com> <188492dc80c017375da76d444347b1d00c2031f6.camel@intel.com>
 <7b9c788e-21dc-eedc-a1b4-9c6877fa48fe@intel.com> <CAPcyv4h=qPFrP+mRqaZhkh5ZmYjuQawsqvf+-R036ZJVKBNK4Q@mail.gmail.com>
 <33d0e764-86d9-8504-17fa-14b31c87de4e@intel.com>
In-Reply-To: <33d0e764-86d9-8504-17fa-14b31c87de4e@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 7 Mar 2022 11:15:18 -0800
Message-ID: <CAPcyv4g5bq9+u0iLjhpeJw8bkbCREUw60H2z_KfDz4hHCrKdFQ@mail.gmail.com>
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
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 7, 2022 at 11:09 AM Joseph, Jithu <jithu.joseph@intel.com> wrot=
e:
>
>
>
> On 3/7/2022 9:38 AM, Dan Williams wrote:
> > On Fri, Mar 4, 2022 at 12:42 PM Joseph, Jithu <jithu.joseph@intel.com> =
wrote:
> >>
> >>
> >>
>
> >>>> + */
> >>>> +static ssize_t details_show(struct device *dev,
> >>>> +                           struct device_attribute *attr,
> >>>> +                           char *buf)
> >>>> +{
> >>>> +       unsigned int cpu =3D dev->id;
> >>>> +       int ret;
> >>>> +
> >>>> +       if (down_trylock(&ifs_sem))
> >>>> +               return -EBUSY;
> >>>
> >>> What is the ifs_sem protecting? This result is immediately invalid
> >>> after the lock is dropped anyway, so why hold it over reading the
> >>> value? You can't prevent 2 threads racing each other here.
> >>
> >> percpu thread running scan_test_worker() will update per_cpu(ifs_state=
, cpu).scan_details. (before signalling this thread to run, this lock would=
 be acquired)
> >> This is to protect against the scenario where if the percpu thread is =
running a test and if at the same time a user is querying its status, they =
would see busy.
> >
> > That begs the question why would userspace be polling this file? Is it
> > because it does not know when a test completes otherwise? How does it
> > know that the result it is seeing is from the test it ran and not some
> > other invocation to start a new test?
>
> I think I should have explained the need for locking at a higher level .
> It is to make sure that only one of the below action happens at any time
>
> 1. single percpu test
> 2. all-cpu test (tests all cores sequentially)
> 3. scan binary reload
> 4. querying the status
>
> (There are h/w reasons for why we restrict to a  single IFS test at any t=
ime)
> If 4 happens while 1 or 2 is in progress , we return busy.  My earlier ex=
planation was trying to explain why we are preventing 4 when 1 or 2   is in=
 progress.
>
> As to the question of why would a user do 4 while 1 or 2 is in progress, =
there is no reason for him to do that, both the run_test (percpu and global=
) are blocking.
> But if he issues a test from one shell and uses another shell to query th=
e status  (while it is still in progress) he will see busy.

...and what about the race that the semaphore cannot solve of test run
launch racing collection of previous run results?

>
>
> >>>
> >>> Just have a CPU mask as an input parameter and avoid needing to hang
> >>> ifs sysfs attributes underneath /sys/device/system/cpu/ifs.
> >>
> >> The percpu sysfs has the additional function of providing percpu statu=
s and  details.
> >
> > That still does not answer the question about the input parameter for
> > selecting cores.
>
> see below
>
> >
> >> The global interface is unable to provide the status and details for a=
ll the cores in the system. It does give a summary, which
> >> guides the user to the appropriate percpu status/details
> >
> > It does not sound like the global sysfs interface is all that useful,
> > especially as it just expands the window for the global results to
> > become out of sync with the per-cpu results. With a uevent  the tool
> > can get called to handle results on per-cpu / per-test,chunk basis
> > atomically. I.e. a udev rule like:
>
> The global/percpu design was chosen after some thought on how a user migh=
t want to test his system.  And the sysfs files are grouped accordingly.
> To start with he might want to see if everything is fine with his system =
(all cores).  The global interface is for this. He can do that with a singl=
e line command
>
> echo 1 > /sys/devices/system/cpu/ifs/run_test
>
> if "/sys/devices/system/cpu/ifs/status" says anything other than pass, he=
 can identify the failed/untested cores using "/sys/devices/system/cpu/ifs/=
cpu_fail_list" and "cpu_untested_list".
>
> Now to understand why a particular core failed or retest that particular =
core, the percpu interface is present.
> (So  global and percpu views are  a simple and convenient way to expose t=
he available functionality and we went with that =E2=80=A6 I agree that an =
alternative was to provide an input parameter for selecting cores)
>
> The whole testing can be done with simple interaction with sysfs file  =
=E2=80=A6 without the need for any elaborate user space tool.

I have not asked for an "elaborate" user tool, sysfs events and
uevents allow for basic shell script tooling. Now, a more polished
tool is certainly welcome, but a sample script is better than nothing.

> Perhaps we can add recommended testing flow in the Documentation

Documentation is good for describing architecture internals and
motivation, a sample user tool / script is good for validating ABI fit
for purpose.
