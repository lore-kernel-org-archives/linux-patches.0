Received: from gw2.atmark-techno.com (gw2.atmark-techno.com [35.74.137.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CFED3FD4
	for <patches@lists.linux.dev>; Wed, 22 Jan 2025 00:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.74.137.57
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737505824; cv=none; b=U3/NaO1q6waXVErG8gGGONKCYU0d96q1Z/VuTBJKA5ZI2jLDbR5hKbA+c3/WJuFnuobRxr9j4w/c/fjhGTZrbq9ilXIowkEOOirYx/E86c34b0kUlCIBMntnRlqlZBTVVuS18IlR6JvxI0L2F5dV49KUd6PObFsOnlF63ovbKJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737505824; c=relaxed/simple;
	bh=DPkLAf7+HErf4szdsvzc51ZrGaUYw7BrIYp1rs8ZBOo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QLR2KfJc9XhXev59GmHBKfsKEP7rGA8QFpBUQOMoPyIaOrztgyl/PJRY7mnJz6JmKhYH+uV8fljL2+gm60MUOY7FpqBznulDpR6qsD/qlE7+oH7rcX35emn1R0f8ZOUkEwjrEwcq6By95MtRlzhx8zac/EaI5Vzd1nlO9FZgeBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=atmark-techno.com; spf=pass smtp.mailfrom=atmark-techno.com; dkim=pass (2048-bit key) header.d=atmark-techno.com header.i=@atmark-techno.com header.b=S1vuzXBi; arc=none smtp.client-ip=35.74.137.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=atmark-techno.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atmark-techno.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=atmark-techno.com header.i=@atmark-techno.com header.b="S1vuzXBi"
Authentication-Results: gw2.atmark-techno.com;
	dkim=pass (2048-bit key; unprotected) header.d=atmark-techno.com header.i=@atmark-techno.com header.a=rsa-sha256 header.s=google header.b=S1vuzXBi;
	dkim-atps=neutral
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by gw2.atmark-techno.com (Postfix) with ESMTPS id 8E4F01B3
	for <patches@lists.linux.dev>; Wed, 22 Jan 2025 09:21:24 +0900 (JST)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-21648ddd461so129122855ad.0
        for <patches@lists.linux.dev>; Tue, 21 Jan 2025 16:21:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atmark-techno.com; s=google; t=1737505283; x=1738110083; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=a1TLfeOz9Q4gtSY6IBD+sYaU477uQa7FYhohbKlqeeU=;
        b=S1vuzXBiAozwfTUFJ/KBCe4bF6Blhr8i4ewkXhb092fA3Pj+1qIX3w4ux7XGn5LB+W
         Rg8MZfnxyLDn9zzAPkiIdQh5D+PtqvsmqrdbHXwecaVB/I6Tww9K+gvmgPBViddIWmmM
         HSIcjX5KLv5KBJszIyJRHKfl0dqQRg1J/ayfUzxeZ0e0EzirNbogAhh1gf2xMAoSSEXb
         zhQh5ofzmQXiJjt/FC9vte+d84OFBPgXTOob1isj/sMfT2qTPrOZhJ9DemjAnf0yVopz
         S6HkNV5Kq0JhxWyoMCIpSIfUSwm3e/5r+JLrP3LNkW9CyxZ6buyS/Lsv1Ah+t+eSuSAm
         23ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737505283; x=1738110083;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a1TLfeOz9Q4gtSY6IBD+sYaU477uQa7FYhohbKlqeeU=;
        b=kNgEBiccJC2ENbwBVpCUKAn5XiOTzq4bSQoO9v5ISciTuFkHrB7hXSKZWjJmuWsBNv
         GD0eOKLLHRq3/+LNAqybel4YSaYfB6ny9YJiD6yoOENCjGu9ypGwMb5GSfNtBh1Rm8MR
         FQ7dm9FYQTTAqcSpXAjfo+34xqTi1WRG0uD1Sabk8lCTKnt/Zqqtt63lpBepoPfeq6lb
         C+4QPO7twKqslBLTxgHh6iLkEbHluD0e4uWrdPGeeDQ0zmZ02w5rlpKZKBO9NOLwx4jX
         ryTgsQVCoR/+uzHzY5sHEft61ENptzxcClhIkdjdVbpoe/HfjKlwSq2x+jeSedcDtS3P
         OYJQ==
X-Forwarded-Encrypted: i=1; AJvYcCUz3YnwmJj56XXIe58krPVdnpNK82UOBjpURfCZzTGTcMzx3VtFq+++iYS4gG7yHECy6luORLfc@lists.linux.dev
X-Gm-Message-State: AOJu0YxjXkIG6f8w9u04gxBWDwbrKVqlTybttUx+U0NQgK3MCzuhNt6u
	qYQftHUAqLRsPBkYBnrc0nWdu0NwrSMsqmZ45IZZkYLY5tvkUsUVTpN751vRhqB94J22olI6/ey
	ttCEvTKJ1/UjAczyO4yv3m3eSur7OOH9cRcldP4+kVPvOR89Xc/KemLd0
X-Gm-Gg: ASbGnctr6XkjYCdYeRmN29ErWVlnjGytlHlTn8iDs6tG9zQg+JFT4VxiJcMUe3MN+vG
	wKNiw9jLxPiRdqpY81oSbVYSxSZIEs+hkvV50eURVcmzteYKwQtpILP+2+LOofbY3HOKXoUUayB
	/W21+aBfSVFx1RO04KKZbaFLvUsrDxqMP3XDHKJ4ZtfW1WTsrQszbMvs4mW94BpiUQUiMl/DIYq
	I1LVtzMpn3Jz/S7E8fSAUstaC8ZkB2MZBpwnJpNLWTTnkO0r0nH8TJBXrKRVUY5JtVKArU7rmHF
	8nYPIFE2WF03KaEzgQlY/AAOtzL94nU8rglhlQFX15cKI+6JP51dKw==
X-Received: by 2002:a05:6a20:7f89:b0:1e0:dc34:2e7d with SMTP id adf61e73a8af0-1eb214650camr28305976637.5.1737505283640;
        Tue, 21 Jan 2025 16:21:23 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHMk4BHzoOUBtE5QE8ZHEBytolUrs3TXUxb7D2pbR8ua6hwu/NV+x2bdDU+hUiQJm1/xA/0BQ==
X-Received: by 2002:a05:6a20:7f89:b0:1e0:dc34:2e7d with SMTP id adf61e73a8af0-1eb214650camr28305951637.5.1737505283357;
        Tue, 21 Jan 2025 16:21:23 -0800 (PST)
Received: from localhost (103.131.189.35.bc.googleusercontent.com. [35.189.131.103])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72daba5340asm9637484b3a.150.2025.01.21.16.21.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 Jan 2025 16:21:22 -0800 (PST)
Date: Wed, 22 Jan 2025 09:21:10 +0900
From: Dominique Martinet <dominique.martinet@atmark-techno.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 034/127] drivers/block/zram/zram_drv.c: do not keep
 dangling zcomp pointer after zram reset
Message-ID: <Z5A59tcFS22YMZAt@atmark-techno.com>
References: <20250121174529.674452028@linuxfoundation.org>
 <20250121174530.999716773@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250121174530.999716773@linuxfoundation.org>

Greg Kroah-Hartman wrote on Tue, Jan 21, 2025 at 06:51:46PM +0100:
> 5.15-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Sergey Senozhatsky <senozhatsky@chromium.org>
> 
> commit 6d2453c3dbc5f70eafc1c866289a90a1fc57ce18 upstream.
>
> We do all reset operations under write lock, so we don't need to save

This branch does not have said write lock, please either also pick
6f1637795f28 ("zram: fix race between zram_reset_device() and
disksize_store()") or drop the 3 zram patches from 5.15
(see https://lore.kernel.org/all/Z4YUmMI5e2yPmzHl@atmark-techno.com/T/#u ;
sorry I didn't follow up more thoroughly. As said there, I believe that
with the extra patch this backport is now sound, but given this isn't a
security fix my opinion is that this was too complex of a backport for
an uninvolved party like me to do)

Thank you either way,
-- 
Dominique
