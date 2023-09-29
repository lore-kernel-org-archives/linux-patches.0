Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E38FF9CC
	for <patches@lists.linux.dev>; Fri, 29 Sep 2023 12:19:33 +0000 (UTC)
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1c6052422acso128015ad.1
        for <patches@lists.linux.dev>; Fri, 29 Sep 2023 05:19:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695989973; x=1696594773; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PLnTSnR7uTYwv5cSSHGvio2GQZKRL0FdjNM2CJ3aoLI=;
        b=Oki89JocZ1m8nrLxO99VVUET/f1iPcORvkCYdWw/sd07YasMBBJ50J5yX1EyaL7GEi
         00alNoJZ2CeYeXZXYNO2Sy8vv1uZYWkVJiiNAkTaahRpTts+L0Dk8IJMHfr66N7gEUaY
         XPxicYvCfX+74IXv3/oEl7M/yw/DLpWkyDUbBRs+mXCur1OFjeeFAbCPLcBFALqudg63
         deMPlmLW1U6mLDY4olMi8Y525pNsjVoEUksOtrss04p2DqQ5iR/nsh36Ep61oOEYmST8
         ueJ/KdBH8kos13fSh3qc8C3hsAkjJkl3Pqkva47AfkkLnDfDlLLmlZyH4SK75DfAxyIq
         pMZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695989973; x=1696594773;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PLnTSnR7uTYwv5cSSHGvio2GQZKRL0FdjNM2CJ3aoLI=;
        b=IVfgDjfv5n2AU3+iIQKzroI2fPr+0L/3Hfa7VgNPEesJ5EDLKP6ek7jRbtnMxI0C9X
         v8zasXyzNLRj0fPnOF49oo5zOCFSVZuthGMi2bmq/6q4pBzeZ/h/NydHLPYIvWx2F8Ga
         vZl3RdftD9M4tSLrEWo5LQIA6OxHeQVMTVs5HeEo9r/mby4j3r2QATCh5tA26nURmI4E
         2+tVTRXKfXvaFPfo49wkNyqTfaZavNFQPRjaAs5iglRy7bOMnp37dqAgY67TTs+kbTQN
         5MDYBL/2NY5d+1v0Piae2/mH/rgGxi4mssKHEHQ7kInb8xqYuSloaMbdu0aDOtSjo6Tw
         3Frg==
X-Gm-Message-State: AOJu0YwSzbNbf2+6SHktz2+v4uK/m9yKyhlYOmh0LmOwAUImlK117+2k
	EcnayrmR1KbWBUBvgqSUpUgFDPtYJX7E5HYsOFRAPQ==
X-Google-Smtp-Source: AGHT+IHK0oqlHr/4SkAVwSnoYFDhD0879DbB4ErNGUhs0U4worNdVRcdhOsKTjQ4Igq01cBWv+xbWUqPjPXdZzGdc40=
X-Received: by 2002:a17:903:5cc:b0:1c4:36c:b917 with SMTP id
 kf12-20020a17090305cc00b001c4036cb917mr971296plb.6.1695989973149; Fri, 29 Sep
 2023 05:19:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230829234426.64421-1-tony.luck@intel.com> <20230928191350.205703-1-tony.luck@intel.com>
 <20230928191350.205703-3-tony.luck@intel.com>
In-Reply-To: <20230928191350.205703-3-tony.luck@intel.com>
From: Peter Newman <peternewman@google.com>
Date: Fri, 29 Sep 2023 14:19:22 +0200
Message-ID: <CALPaoCiLRA9NnP_rynYi60F_USW0zi_NWqRd702RJC_E2SeCFw@mail.gmail.com>
Subject: Re: [PATCH v6 2/8] x86/resctrl: Prepare to split rdt_domain structure
To: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>, Reinette Chatre <reinette.chatre@intel.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, x86@kernel.org, 
	Shaopeng Tan <tan.shaopeng@fujitsu.com>, James Morse <james.morse@arm.com>, 
	Jamie Iles <quic_jiles@quicinc.com>, Babu Moger <babu.moger@amd.com>, 
	Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Tony,

On Thu, Sep 28, 2023 at 9:14=E2=80=AFPM Tony Luck <tony.luck@intel.com> wro=
te:
>
> The rdt_domain structure is used for both control and monitor features.
> It is about to be split into separate structures for these two usages
> because the scope for control and monitoring features for a resource
> will be different for future resources.
>
> To allow for common code that scans a list of domains looking for a
> specific domain id, move the "list" and "id" fields into their own
> structure within the rdt_domain structure.

On this one I think you can say "No functional change"

Reviewed-by: Peter Newman <peternewman@google.com>

Thanks!
-Peter
