Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF5BEC2C5
	for <patches@lists.linux.dev>; Wed, 28 Jun 2023 13:43:39 +0000 (UTC)
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4007b5bafceso241171cf.1
        for <patches@lists.linux.dev>; Wed, 28 Jun 2023 06:43:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687959818; x=1690551818;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O+iaMZwyBIh+11qrQSGLnV1Wu07chjDvH/4Aamfu59w=;
        b=HiMTruj17NQKh3aQ7JiBVNXSofLwSd76IwEZQnN9fPPiO0AR5W77NsPh8Xp1x/8WmJ
         X3jvWoRsB+ACfV3nd/3X/vxoF2kX4W46iMNnUjdCN6GLAPNcZ5Q/t/g9ds7XOI/QLI95
         i+FNnGNonBF+yaBMUPSFiNn9ec3Z59ujQhWG9iuHFSIZ3jn+/3y69xRMNtTFzkZeHDST
         PX5pgi9ER1J84aZ8NfvUV6uEEaU8JHRIuyPPsL9bxQnZBpD2kC9izUum41N3fwJNgAEa
         NL7PysDCTgPWOp5mgE/VOaRpiWsrKWJc6hP7c4QOnflz86dSOyjneePhQEFJYmCdi209
         PgpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687959818; x=1690551818;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O+iaMZwyBIh+11qrQSGLnV1Wu07chjDvH/4Aamfu59w=;
        b=EgQa6AEEBLrRAAX9UOg++wp0ye8bv4uSAYfQ23CiMvK8wQ8tWtsiXdOqRvRQIY4LOE
         g40RZw1yot+td7dfl1XB9bga9i9pG4z8/UuG5Xmv59RpQrlvfISvVJv9JUOuYcLqIC5b
         km4zAd/dVb77AtM4B20GTXootI27h4kwSy2u8Wz+1/0DUwHr6SvEME1kaftNfrpfqe2F
         zjhykdkcfK2R/TGbf5A8Pozah3b9aBuDDgd7pyCPHRjaWlqSbwzOjFImp9Uy392IFfVp
         LII+TQHVbWAiUTtythr6xSi6pgjO7PZtlfl4mfdMKlt9I+/4F2fLroqKI2UcuPjvtMyl
         fqgQ==
X-Gm-Message-State: AC+VfDwLqt4+UhJKMPnNecLFp5ejszTzsQpgJbbkYfUIBeHa5Yd2Cvyl
	dNKltAMnB9FEiVI0dTGsU71N1XqGyAR1bLfjoKMCPw==
X-Google-Smtp-Source: ACHHUZ4WogTNREVg5u/95oFGa4sWXVU+6iCyc2kWX1TQbQZvq1XwK8rb+EFydSpQWW4vJUCNttfcK9GjATSMfRgTQDI=
X-Received: by 2002:a05:622a:1b9f:b0:3fa:3c8f:3435 with SMTP id
 bp31-20020a05622a1b9f00b003fa3c8f3435mr134285qtb.27.1687959818387; Wed, 28
 Jun 2023 06:43:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230621174006.42533-1-tony.luck@intel.com> <20230621174006.42533-8-tony.luck@intel.com>
 <CALPaoCi+A5TxoReh=HRMsRKYDWb4eQ-NOB75Lj9674L6aV0T=Q@mail.gmail.com> <SJ1PR11MB608334F6555F9CEF3F740DE8FC26A@SJ1PR11MB6083.namprd11.prod.outlook.com>
In-Reply-To: <SJ1PR11MB608334F6555F9CEF3F740DE8FC26A@SJ1PR11MB6083.namprd11.prod.outlook.com>
From: Peter Newman <peternewman@google.com>
Date: Wed, 28 Jun 2023 15:43:27 +0200
Message-ID: <CALPaoChuVYpv2aEycaT85mf_2kyEpHcsKbaeZSEVP94i1QHTRw@mail.gmail.com>
Subject: Re: [PATCH v2 7/7] x86/resctrl: Determine if Sub-NUMA Cluster is
 enabled and initialize.
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "Yu, Fenghua" <fenghua.yu@intel.com>, "Chatre, Reinette" <reinette.chatre@intel.com>, 
	Jonathan Corbet <corbet@lwn.net>, "x86@kernel.org" <x86@kernel.org>, Shaopeng Tan <tan.shaopeng@fujitsu.com>, 
	James Morse <james.morse@arm.com>, Jamie Iles <quic_jiles@quicinc.com>, 
	Babu Moger <babu.moger@amd.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Tony,

On Mon, Jun 26, 2023 at 5:52=E2=80=AFPM Luck, Tony <tony.luck@intel.com> wr=
ote:

> Thanks for testing and review. Did you also test on one of your systems
> with a memory-only node? I recall that was an issue with my very first
> patch series.

It turns out the people who reported the crash to me were running an
experiment, but they were able to find one machine they hadn't yanked
the AEP DIMMs out of yet.

It was a cascade lake, so I had to yank the CPU family match check to
ensure that your fix was actually exercised. I can confirm now that it
booted successfully.

-Peter
