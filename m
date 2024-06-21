Received: from mout.web.de (mout.web.de [212.227.15.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A1E413D521;
	Fri, 21 Jun 2024 17:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718989563; cv=none; b=u0Iznx9pTQ0Lu6YZWWJ3Ntq0HXWwv5D81iyF6CjA+k02g+byRjiRIpIKtDVg1k7yQLyypLQ9PDvf03GQdKF4Byx703JxbpAAgBJ4L/ZcRf0YPpGCsUb+tz9cu/pInje9SAZxs9NB0UKMpurRXBXA3zPB/CTIhQeLSXv01Gi0oBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718989563; c=relaxed/simple;
	bh=UE3R47+fz+IA4212daMCKta9Lg7sKnBQTgaxJxh8U2I=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=ntemuMIMO42xSFKtCftiwrtMZVdjxLm8TsTT5DFDmP4wGqNTE/ZGEW3Bpwry4P3GsEhaiDflUcyLTtq5raaPm+akj9GGkex8qZN5cIGG7/D3wp3nlzkhXxIFqLtezfgva5OL+mLocqFFMmZ7qsfw0U/aCNr0475B+1rWCL/b4+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=V6maYA28; arc=none smtp.client-ip=212.227.15.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="V6maYA28"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1718989545; x=1719594345; i=markus.elfring@web.de;
	bh=dxP9/lSDXgivp4gsf9vSl+d2Pg8HPjlAzqdpPQ/rqlk=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=V6maYA28AqPQ4073DgV4wM9gaQvOYxxwhUH7pL4/jKGehT8s/aF7Z0fudA2y2nYZ
	 97IuPmnyxc0ySC4lFu3lqBO0NKqaLNsiqMhbk82z5k4b9KWFf8qIOtULDYq+2plMT
	 2Zh5SidZm1nr+80QOUzK0pfo0ukFZB66sIm29c2Wj6f//G2qeatptyS7N0a1wBXc1
	 ZEVQMumJJsgAt1uroyMuqk9uDQyS/5YCRRnM24TLgvh3qEveS5IiNAOnfL5Bz6a8v
	 SEVps6n4xySjOPykzp9MuKmLY40eZQ6gBVReHXL/FAfju9oqP3V91NBo7tDEXVU9f
	 twn+8DTgeiOxVQELzQ==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.21] ([94.31.85.95]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MHEbk-1s7S9p2RO4-007Xdf; Fri, 21
 Jun 2024 19:05:45 +0200
Message-ID: <c9a00f59-eaa7-40a9-a118-66f87b11c118@web.de>
Date: Fri, 21 Jun 2024 19:05:40 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Tony Luck <tony.luck@intel.com>, x86@kernel.org,
 Babu Moger <babu.moger@amd.com>, Dave Martin <Dave.Martin@arm.com>,
 Drew Fustini <dfustini@baylibre.com>, Fenghua Yu <fenghua.yu@intel.com>,
 James Morse <james.morse@arm.com>,
 Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
 Peter Newman <peternewman@google.com>,
 Reinette Chatre <reinette.chatre@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, patches@lists.linux.dev
References: <20240610183528.349198-18-tony.luck@intel.com>
Subject: Re: [PATCH v20 17/18] x86/resctrl: Sub-NUMA Cluster (SNC) detection
Content-Language: en-GB
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20240610183528.349198-18-tony.luck@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Y/EsdlTZ9QScx7b8NlH9skCchG5JfIk2sNZDgRAXD+l4hjZVT7Y
 4ee7RyIMXU33VOyG9Ggk6TIHPtIXoECZxts8JQCCx2xvDxi4ocwTJj8n8P1ifGYYi+AsEce
 w3RxIzZrgqNH8MZhkDNXX0Sm08GsUPWwrGBpvtGvfVIFPfAYA9IvoHy6ZLq5yJG472PE185
 xwd9x1FYH1/ttDitwiNQQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:/ZBBsfWxGxU=;6/KAFrq505yiemCRUDxpxynriW+
 QBylRPgPVqzSbKYjAhmPPwuKdhiT53DJJvooj/Sex4I1g/MxlxoCzFXkueQdoWpmbvDqC7NIH
 c9pCrSujuZ5+2z14UoGQeno6WGGyf+xj1zUB+yBO2UiqXRYGYTf7DK45hJwMPS13Mt/eUisBq
 AQ33SBVzSLNtJtdqv/IGnJZa9WcEs9vfGibefrluGxCzC3vw2sO+KnkDLxWwh/JiStAvislF2
 QcssN8i7h657zFWOx2GRTpICIG1e9aqrFdAw6KbTTDrLXPW7KqiWAEyx50WCCpnx24e48iZep
 kerUETzp1BzCrs2eBTtBg873cThwyfo6ZzEgFcC84mPd5O6kIhrvh2MN7wNOlX3DD8G/6DAFi
 1s8o3NYKq4KTDtToBASuQn9xaOTYseJ8Bo3pn+84YrbRj7jVnr2h849JoGb+lFoYS2R9mNI9Z
 BJH5OF/dfpmOsHXvTVqHQejGiRoVBHSr+QeNEpjaoxZ1s3XDVY/DNTA/Qj0ZX32U2eUMWTqnN
 w659OHpcA9IGNVRI32EwgRWkmMBZDjtgSM+vV/lvdhxfrU+Pq/So3M49xIhtd88+BK5prMsva
 Wof0bnVh49vJd3vMX5Uvp/wu1zeMPnqRtjrViNpdlCMvUIc9Him15lQBurqFMnZSQ/+KOqK+4
 XqhEUj/Q/xHdjG76bLqK7ipuD9LShQZR1gHohEnGApMuxerL9DwpL6iy9Patrv+/jZu5qLoGl
 nsX8xS6LTs8IYkPKJMu9hrtIOdsaOWETolFxuyf3QkLx83KhwgxEffDdXih8iD28e97PRJwRV
 UFOHfht/0YRlmqGBlABztry41ySfc7YaDNjXUQvO6hmOY=

=E2=80=A6
> Add the missing definition of pr_fmt() to monitor.c. =E2=80=A6

How do you think about to add the tag =E2=80=9CFixes=E2=80=9D accordingly?


=E2=80=A6
> +++ b/arch/x86/kernel/cpu/resctrl/monitor.c
=E2=80=A6
> +static __init int snc_get_config(void)
> +{
=E2=80=A6
> +	cpus_read_lock();
> +	if (num_online_cpus() !=3D num_present_cpus())
> +		pr_warn("Some CPUs offline, SNC detection may be incorrect\n");
> +	cpus_read_unlock();
=E2=80=A6

Would you become interested to apply a statement like =E2=80=9Cguard(cpus_=
read_lock)();=E2=80=9D?
https://elixir.bootlin.com/linux/v6.10-rc4/source/include/linux/cleanup.h#=
L133

Regards,
Markus
