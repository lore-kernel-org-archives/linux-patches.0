Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB5B2E9EDC
	for <patches@lists.linux.dev>; Thu, 14 Aug 2025 09:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755163102; cv=none; b=gX4YzNwJaSJPMs2v1Er0OcR5DuSiBQR6BiDCJgjIkmj1/QpINCgsBc0Dm3e4fNQZuC2JKHYB8jvnqPZyFyYrK9dKBw+FIBeZm/kvxEchSDyRpVOnAM47qMeI/s2JuNBOes8KtMJwK4NtmW2Rxx4Ub5v9GR7XAQypQ2sgf4qYAi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755163102; c=relaxed/simple;
	bh=9jfsBBqeJOEl9hddqXnvpXQHYPzROEJTWzYp929WPI0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=BwpfQ9fYNMFQVPhJ8Sj2JN24CERO6sBIM877KgwT2UvlZNI3UaZziiH0N9JcXwdXepuGNV/wdZb40CazwCqmuXC2+CVNWz2cN3XwFwOkrKYGScf8Vvo2sLd7Ix0UqIC2DhBMXTaG/Cx8MOOSgyXddslX0WoygcWavqdxCc0ELiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CS3M40Fd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CS3M40Fd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755163099;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7KJnGM2svr7YW4cpJgDglh0IED9NSFfVKuR4V+h5zek=;
	b=CS3M40FdiMwM8oQtuOuRPjrcV4Plias1NnoApDNFl2d56VvukcRLJqqGZfY/gx66hT8DEA
	6JWeQd76MsxDc/nkXsVU/jB4HuYSeNlN14JP89aIKkjBYAuAtQ62iDfHTXm3BNV3ANXxTs
	JuOAkNY4nYk2KGJxajKZbhFrZ+d4mhg=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-215-zbwrBS1MPCiDMQ-h-dRHUg-1; Thu, 14 Aug 2025 05:18:18 -0400
X-MC-Unique: zbwrBS1MPCiDMQ-h-dRHUg-1
X-Mimecast-MFC-AGG-ID: zbwrBS1MPCiDMQ-h-dRHUg_1755163098
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7e870646b11so162565885a.2
        for <patches@lists.linux.dev>; Thu, 14 Aug 2025 02:18:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755163098; x=1755767898;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7KJnGM2svr7YW4cpJgDglh0IED9NSFfVKuR4V+h5zek=;
        b=Z+rwZLoBA3n5VSTn34UrV+oTUzQhw8zZZ82zARFNGjCwLNEXcmmWsoY5q+Etrh65cc
         Pt7A8tzcSUmso+7i1vNioEMqUrgP07ftX9sXfYGpPeU+7QGo4FcjhGY6zeFPV5FdDAXk
         heptP2tykn9O0R0LLvG6dInLx1UcL7IdAta+j6NZ0Cx6AICBAja4DqpQuVJKyMOZQdeZ
         XEnGukrQ8yLkFP4n49mB11KaHXeLf0lryJVhetqETrtEzsHOJB18PcdD0Y0JJniuXD9u
         rYYOa7BScu9OfCtjOTv/0UzA9bB1GZYWgqgB6CCFtgIAp/sSnXnfBzQYzLHagpUeFMU4
         2EqQ==
X-Forwarded-Encrypted: i=1; AJvYcCVu3TTDdcAeSOiOPsY5OMfwT7K/C41FqrjDXLYE3Hno35b0w/Ajw96Wf0IA552qNc2c/jjusgem@lists.linux.dev
X-Gm-Message-State: AOJu0YyFaf+slCPh8zWmeqYiDUc+/sbOK2Abs0qAmBQCu4rU58rFy6cs
	twlulZaguLx4Soc+MsMLCSTNGLK8ISBU8/GJ8qaDo6DZILfXu7JFBbBLfNfIeQJUYsmmVJSudrN
	gsXEZn3CyoUc6hEHEsvQU3OaRoC05WFsFZH8sTzuGBvYxA//h1dtSQGIK5qY=
X-Gm-Gg: ASbGncuuAyuAK2gu7wnQAzy5EMoZZopO/gmy53qdTgE3Zd+Z19quT8wvLR1h3nyqjlu
	489ojUpey9pPktzrYptlkh1AknDKM9oMwfhZxmJiDuUWK1fwxo2ct/dgdivFz9FVWa87PvEOA9Q
	C7oNrPBkwvK6gMrC1boM2qcYGtVyB8vBjZ4dP4Tgm81zkaVChOVHd234qlgNNpZS44Z2t2eeF5a
	23q6CSRqp/sraiJ1Qd/VIuO1WpKyU3PUtRYZX9erFW7Kw+49SsS2fbFhJcKLu1KToASYMV0ZXel
	XxcKhvmHsGoIJ6r3qLuzFak1crVqi8IJrTnSJluNLIe+brTvSWb4KTk7VppzMgkDg1pf
X-Received: by 2002:a05:620a:4009:b0:7e8:710d:a514 with SMTP id af79cd13be357-7e871b61fd6mr232211685a.53.1755163097781;
        Thu, 14 Aug 2025 02:18:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE/rNDxfUSF41mvaZG3MitrVFYLyJLI3VztVogKFuFPmYJr+uIbJGy5RLElJh3Ry5C/7l4gNg==
X-Received: by 2002:a05:620a:4009:b0:7e8:710d:a514 with SMTP id af79cd13be357-7e871b61fd6mr232208885a.53.1755163097411;
        Thu, 14 Aug 2025 02:18:17 -0700 (PDT)
Received: from jlelli-thinkpadt14gen4.remote.csb ([151.57.34.72])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7e81bc7a1e3sm1302247985a.74.2025.08.14.02.18.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Aug 2025 02:18:15 -0700 (PDT)
Date: Thu, 14 Aug 2025 11:18:10 +0200
From: Juri Lelli <juri.lelli@redhat.com>
To: Jiri Slaby <jirislaby@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, Chris Mason <clm@meta.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.16 199/627] sched/deadline: Less agressive dl_server
 handling
Message-ID: <aJ2p0vhe6-2S2ZtJ@jlelli-thinkpadt14gen4.remote.csb>
References: <20250812173419.303046420@linuxfoundation.org>
 <20250812173426.853672780@linuxfoundation.org>
 <17955c87-1a82-4eae-94ee-3ac1447d4e71@kernel.org>
 <58c46200-95b0-4cd8-bb5e-44f963a66875@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <58c46200-95b0-4cd8-bb5e-44f963a66875@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: VTrBhkOyWs1vvlNS_lBwLTX2VYv8IOJD-PoKvCkJvjc_1755163098
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi,

On 14/08/25 10:37, Jiri Slaby wrote:
> On 14. 08. 25, 10:22, Jiri Slaby wrote:
> > Hi,
> > 
> > 
> > On 12. 08. 25, 19:28, Greg Kroah-Hartman wrote:
> > > 6.16-stable review patch.  If anyone has any objections, please let
> > > me know.
> > > 
> > > ------------------
> > > 
> > > From: Peter Zijlstra <peterz@infradead.org>
> > > 
> > > [ Upstream commit cccb45d7c4295bbfeba616582d0249f2d21e6df5 ]
> > > 
> > > Chris reported that commit 5f6bd380c7bd ("sched/rt: Remove default
> > > bandwidth control") caused a significant dip in his favourite
> > > benchmark of the day. Simply disabling dl_server cured things.
> > > 
> > > His workload hammers the 0->1, 1->0 transitions, and the
> > > dl_server_{start,stop}() overhead kills it -- fairly obviously a bad
> > > idea in hind sight and all that.
> > > 
> > > Change things around to only disable the dl_server when there has not
> > > been a fair task around for a whole period. Since the default period
> > > is 1 second, this ensures the benchmark never trips this, overhead
> > > gone.
> > 
> > This causes:
> > sched: DL replenish lagged too much
> > 
> > Maybe some prereq missing?
> 
> Not really, this is present both in linus/master and tip/master.

https://lore.kernel.org/lkml/20250615131129.954975-1-kuyo.chang@mediatek.com/
should be addressing it, but still under review.

Thanks,
Juri

