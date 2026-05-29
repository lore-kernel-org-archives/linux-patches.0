Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 708353BFE52
	for <patches@lists.linux.dev>; Fri, 29 May 2026 15:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780069550; cv=pass; b=f2dnKWksFO/arFlPrPvdyG83gMPituyXIVVtD0SkRIYZokHPj9VzzxMi/P2JWSsH+2Olv/wSyOwvMkmeHtBVelTPsxyWWOjI+6byjUBW1v3IqKMSevLbg3gtFmqNwl0o8pNHsJe2VVc885uWT0URZNDWP0HGvLIqLX1CEFSMYag=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780069550; c=relaxed/simple;
	bh=1hMieIIxqcU89DUFDk9X5WdEWgHHTxNRY3vF1kpWUpw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QS5gWgp6xNRP71XrUFyXpjM13xfFxyrr7zoSJ6KHGG7r4yGSFgMii8pvHopwxDdp0aDyX7J1cXpksKFEcg03F0yLSaPNO/5SRvC2lY5wy83XP1+ChWn1+yNHviERVRPJ++bDaKzGJokE8CPXuOMVcqql+Auk1gyAgDjVhT6yClg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=aOZdB4Ti; arc=pass smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="aOZdB4Ti"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-45ed18d8a1bso2825551f8f.0
        for <patches@lists.linux.dev>; Fri, 29 May 2026 08:45:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780069548; cv=none;
        d=google.com; s=arc-20240605;
        b=hhx9Ldta0JUigc+Ddqr9dl2mugeYyxoUfCVMVif44P2d/474mJ9WfcZp6ITxKKnIGj
         gmKFm/2/bzXKX1Mmw1j4DsmYpKtJOpqiZSxp04t7Gw1nnhOa2ZKEnBOIxa7nOtkSk8Mz
         CTIh5huSpDHAXbgUb2m9pK7fcCTFBLpw2onjXS/3gM53diDCt6lc2ROo9MLngUjhmvKN
         y76TWsVtF+bWOTA1P9csSRFzrt84jYZKEChLbs5xbDe5SL1qjXWw3MEh7bwXLOAiHYjR
         81qOuzSSYv4/KmsOARhnn1MCt+WYCwojrygdd64Rt5u9kon52AFEbpMSzDYICmgz0IWK
         Dcjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=1hMieIIxqcU89DUFDk9X5WdEWgHHTxNRY3vF1kpWUpw=;
        fh=c3v1vUdjLzLZE3ROpIbNSSzvAry8ho5rbfjx1IrOWAA=;
        b=ZKwljgizZFCr/cFjXpxhf762oEN7bFK9aQtNWcUDywYg0VwNey0J+Txk2Mdpi+SsDu
         LdaGtYh4Arf9g/qpEQbrT5uv+Llf4nBAB9Adt/wG6zzc51e33K2ecQNn3+hLEHshjsBW
         iiMlzybZPNHuAocsgfzcdn/JNN/wzwD61WdtWOMRM7197SNETtt3pJmSzQjk9sL/4pZS
         2LBUTq+40ErlQ2LsgKFFdCON19/3C7OUq1NjwYkJugYPj5cI6rOfXmGq9nrbrXBNQgjq
         aV+VRX/710+FOZKP2pykyaQsn+w4YKEprfEeK9YvGkLZWOA80L+IQ8KsATx+JJrmbjvw
         Js1g==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1780069548; x=1780674348; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1hMieIIxqcU89DUFDk9X5WdEWgHHTxNRY3vF1kpWUpw=;
        b=aOZdB4TiezfiVJg0RLsqXEkg20T8F5RxsbR4A486qdUe/usxS0HAL1ezGouvD7jxHR
         KaMg4ZzLIE3qA2LwijhZOPE7SVqyaA6pJrGsdyCj1fW9SL6lwFv+6V2oGHsFHukrsbTs
         5Sj1EOBXHW6TJutYAVKkvcC8RXDLHhmWe0N/kgXDY31XHyNtsMYsBLc+M4YmCrRe/eQI
         qvfrdx9yjXl9EkrcLrdzzuHCaBAmw698C9WvwnrYWBTBf7b4uRf9cVYWUmnhcCBe10VU
         nTLKyR8ov06kGHrqnrdg4ZiG3hYeGjRtlDUSTxTFkaDkrzUEBK57T+5/WrdGA0HkYePR
         zuCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780069548; x=1780674348;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1hMieIIxqcU89DUFDk9X5WdEWgHHTxNRY3vF1kpWUpw=;
        b=Hi0/BKuJdYuTUteriSuq6kl0Pg2wnzn3eFE5VT+vtAe9XDYLo1THpA7Qyo5+lJh/ly
         8j5WqbJ2PAB2YY2vKhlFXDHec/WeXzw0jNXP6jBMcYXPcapQMPy4jH92U8Svc7rqH5ai
         4iA8FPpQHk/wPl3ggow98R7WjOZ+TQTqItYdr1KEPzviSX8qftDeOfamOD/7m0mS6IqQ
         JpB3hJ29O3w3xYeoAspWEGjrTsMTUWHlw00i7vb3vQJuT5NELNoUwZulb1rSDwJIW5k/
         Hug3FAyPNRWx0VfeUDWTiij1ctoddo9JQttkCI0zgE6Tr20WbQvVWWdjBEmur5SKaWQf
         ipPg==
X-Forwarded-Encrypted: i=1; AFNElJ86E/wwwRJOWld/+lYel3YGTYqsNUuBjV4NmrSBBUyYWHR9G2gJDFxk8uwx6IwXu/nCpLavGywd@lists.linux.dev
X-Gm-Message-State: AOJu0YyjWtFWUMFqZZmOdto28zNATgFqlMZ66G2RSulAtcKEgr74gbui
	Uil+zEPgqdiSphE//ghQ+sVtuDAykA3Zr1EufdqJ/UeNvqIktMyThU9Bv486xsVG/+G1NSg6V4R
	SGh2CVdHjj6yG7xy83z8R47lusMPLe2rogGlE0SR1Hw==
X-Gm-Gg: Acq92OGMDVaf0y5YaSngaoCf1c/gcHZAP+QHb0jIQf2hHrdcq8LY1IeGk2J9L5H+9ov
	+kTI+xiTd+i+s3dLzbZ9kWEKENiVngouiCT0186tgE92sgoz4EXMoOLaRBoMXLogtW5cBsKx65/
	xVgY2NDMSTSHX4ktqD014n9IMDgDNlakgqSFwfDOS91RVVG5qv3k+BhtLOaFMz3Guhz67i4bnQv
	jRIFOZXg1UXenbaKY+tv4lUH941xd50DmINekJ6BAPODpN0ZjjJB3+2zGwZmeFsHT7cJ5aZQv38
	gpPp4R3QsofBSKr2xA+JJ6kUacU04u+lBz8a3i/IdT/azYl7h8ZKCUP8KFprmpa/p3NbptKnfWl
	z6qjdhzXAAD6aSRI=
X-Received: by 2002:a5d:6e89:0:b0:45e:a0ab:8bd1 with SMTP id
 ffacd0b85a97d-45ef6af783emr544721f8f.7.1780069547846; Fri, 29 May 2026
 08:45:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260528194638.371537336@linuxfoundation.org> <20260528194647.015775177@linuxfoundation.org>
 <CAPjX3Ff-a8JHxeMr1Hk83BmQX9YLGNR+g+7waygn43ZD7pWMHg@mail.gmail.com> <20260529120000.btrfs-inolookup-keep@kernel.org>
In-Reply-To: <20260529120000.btrfs-inolookup-keep@kernel.org>
From: Daniel Vacek <neelx@suse.com>
Date: Fri, 29 May 2026 17:45:36 +0200
X-Gm-Features: AVHnY4KdAWpYm2FShY6ZN8oR0VRdT_3F7I0pxlt6c9pg_DFkco-beqT3hh1-SlY
Message-ID: <CAPjX3FdGqfvAW=Uj70bg9PKngBQOUypMz9wZgwwsUKspRJTxKQ@mail.gmail.com>
Subject: Re: [PATCH 6.18 299/377] btrfs: dont search back for dir inode item
 in INO_LOOKUP_USER
To: Sasha Levin <sashal@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, Johannes Thumshirn <johannes.thumshirn@wdc.com>, 
	Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, 29 May 2026 at 14:44, Sasha Levin <sashal@kernel.org> wrote:
> On Fri, May 29, 2026 at 08:39:10AM +0200, Daniel Vacek wrote:
> > This is not a bugfix, rather, it is a cleanup.
> > Even though it's kinda small and limited to a single function, I'm not
> > sure it's worth the stable backport.
> > Is there any specific reason you picked this patch?
>
> You're right that it's a cleanup on its own. It wasn't selected as a
> standalone backport - it was pulled in as a dependency (it carries
> Stable-dep-of: 1e92637722ae "btrfs: check for subvolume before deleting
> squota qgroup") so that the squota qgroup fix applies cleanly.

Nah, right. My bad, I missed that. Sorry about the noise.

--nX

> --
> Thanks,
> Sasha
