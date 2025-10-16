Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E19061624D5
	for <patches@lists.linux.dev>; Thu, 16 Oct 2025 02:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760580519; cv=none; b=lktJkVZ+yKtULEk4BaRDOEyZFyXiRt8EPFYC/piuLUg1FK4VMRttdR3XVHEe2MSFOaXIXdiFhVNhMHiKJYmWbmRv5HqotYYnDJzzHnBi/jPWOKqg4ZUioQGAGDLSeRYaUO0NhlLJWtv10q7vHTxNyo/TtXxuV+PsAR4xoaD9wTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760580519; c=relaxed/simple;
	bh=yLSAW0BvSIprjBOvjLWDFlo3zpGUDliqA93OBfwvqK4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jiL1rnNx2dYIFDaE2189Xj7uk7mM1YLDzf3RQSnGdlgkUu8LIvDKYBcBj/rvGSYFTE1GHNSQOvZoQsOCxmNJ/DZAF4ln4LYZhHE3TTXsSQOANjMkAkB1hZbgZmy4pu9uHR5Ia3RjCXM5KC9KbsHSGrDVH0qONVkUknAHgFd0NjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RKgdIWes; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RKgdIWes"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-b633b54d05dso116518a12.2
        for <patches@lists.linux.dev>; Wed, 15 Oct 2025 19:08:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760580517; x=1761185317; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JmQmlMgZWUc3/3kOb22L5i35I5CqDvoiZHY/YAnIw9I=;
        b=RKgdIWesAsIsvRXs6D8J7UFf7GleIULriIn6RWs5ew0j6GYm5iatg0VBqfne6en9M0
         pSqodejgg9th9DeNrThfjYHixEYXooQwV133r64LEmr24ML9n1ksCjbWYCPfVm6kfV/i
         w365WgetwYyTpQzg2Q2YhbxVhKZAqErapQGfaAd3sPbMf1/pbhQ2Y6E1UFx8aIvm6wc6
         ACabaQYAB0WwqOtgmO2c82tyEqoZPC1dVBUFkx4agI85K7ObSQ6rq4A8cUPP9B2YSyLz
         279V7tp4Dydfy9DpGtMWQhx8vR2+7Yu/6gspZQucs1h+VAq6R8A9yXUgleFm7Q78k28a
         Z8yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760580517; x=1761185317;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JmQmlMgZWUc3/3kOb22L5i35I5CqDvoiZHY/YAnIw9I=;
        b=ornxQcxcAcNA7grApEEfkAYrLJlpjLM3VsDlE3Ssb0mwdrJsHhhMs9bhEbuCk7tC8d
         X5ybp7PVTAHhOIXyX8b+NGLZHvSzdLASFYOtV4l4mdCFD+wFOqKyMCsgnSA+f1VDXndg
         JsCyLUfOC3TOX1jQyHAltKhuEHIHcDWqCUssnCTIw0rlWFJwrrm1bfGLUSHMhFb23NVt
         /4LI6yEtR9Dq3f3/+Q+XuXJ9wyJLAmh/N5vCy5AdX6HdHBLGnpTCsPYtKHJ+M5nwuqHs
         h3lE1CP78pVs9kaOYVXAxpjzoAj76yKfF+KH5IPKA6o3CM1oGBiZYt3OIXP8ruS79knj
         Mw7Q==
X-Forwarded-Encrypted: i=1; AJvYcCWXcfPlsewWq4UhuB0pEsxSKDaT3Ue3EoAjd1kmsoEtmgX73nC/PQHAXONDavE8yJfGxbsQxsXi@lists.linux.dev
X-Gm-Message-State: AOJu0Yz0+yCFWzCoGAmnsEpx+jtKqr2aYa0xnAeHSE10uf8N8jKw39KQ
	9S42S8CUK0I/4jT/u/k4kXM76rSNxaxBHfmdzXQBBXKOl6/96sVg+MgU
X-Gm-Gg: ASbGncu2nSX2wv3ZpWF8atRm9HBs4iEcE+oasr6kf9nbaWBp3T55y3gMWhyOZonXuNY
	PJSv5SBr6LK8uhE2YuWpvOET6/77sKBRXqV9Df6iZ24ya+/QGEQKyqrPYEc/KxHnoKJ47Ry2QBK
	83BLL17xsC0FiEKOoD/Lv8D5WCaLL1pBfh9ZOAvSqLgSGmcSAMnw8UuzWKZxLVZ7DnMFhtCQX9n
	hr0xpn/JcdU7qabjbYN8p+lwrMTIJA+HzVe+KIrQzzdNfcS0xFmab+0lIZOT+2NxsPM83C/SEGD
	CWTo0r+zgWFq2J1aiBHBdX7LLEIEmdcbJbDMHEJNduC9LaFwsE5u227/i+f6zCBvI9Wc2ILkdDv
	8z+KtGTNiuDEoBOluzjDOe/vzshqfmF0VdFoj0VHzAk7PwF+lwTI8/zUktTz+gESFEztxqunOBb
	s=
X-Google-Smtp-Source: AGHT+IE4kaxo/0J6sXYQafAXDYDfRrB+jJbQaa8rsXequYMNbs/eknPqCiTM1l9jpvXtki2gsxjLdA==
X-Received: by 2002:a17:90b:1a8a:b0:32e:8931:b59c with SMTP id 98e67ed59e1d1-33b5139a212mr41848203a91.27.1760580516925;
        Wed, 15 Oct 2025 19:08:36 -0700 (PDT)
Received: from localhost ([2001:19f0:ac00:4eb8:5400:5ff:fe30:7df3])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33ba93cbb7asm315334a91.1.2025.10.15.19.08.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Oct 2025 19:08:36 -0700 (PDT)
Date: Thu, 16 Oct 2025 10:07:49 +0800
From: Inochi Amaoto <inochiama@gmail.com>
To: Stefan Lippers-Hollmann <s.l-h@gmx.de>, 
	Bjorn Helgaas <helgaas@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	stable@vger.kernel.org, patches@lists.linux.dev, Thomas Gleixner <tglx@linutronix.de>, 
	Inochi Amaoto <inochiama@gmail.com>, Chen Wang <unicorn_wang@outlook.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Sasha Levin <sashal@kernel.org>, 
	Kenneth Crudup <kenny@panix.com>, Genes Lists <lists@sapience.com>, Jens Axboe <axboe@kernel.dk>, 
	Todd Brandt <todd.e.brandt@intel.com>
Subject: Re: [PATCH 6.17 068/563] PCI/MSI: Add startup/shutdown for per
 device domains
Message-ID: <o7hrpbeszf564cznyns3zorrofz4kkffugbmvwwub5arh34vki@dgrqpuasd7ks>
References: <20251013144413.753811471@linuxfoundation.org>
 <20251013211648.GA864848@bhelgaas>
 <20251016030711.57e92e97@mir>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251016030711.57e92e97@mir>

On Thu, Oct 16, 2025 at 03:07:11AM +0200, Stefan Lippers-Hollmann wrote:
> Hi
> 
> On 2025-10-13, Bjorn Helgaas wrote:
> > [+cc Kenny, Gene, Jens, Todd]
> > 
> > On Mon, Oct 13, 2025 at 04:38:49PM +0200, Greg Kroah-Hartman wrote:
> > > 6.17-stable review patch.  If anyone has any objections, please let me know.
> > 
> > We have open regression reports about this, so I don't think we
> > should backport it yet:
> > 
> >   https://lore.kernel.org/r/af5f1790-c3b3-4f43-97d5-759d43e09c7b@panix.com
> 
> I've received a similar report for v6.17.3-rc1/ v6.17.3 (v6.17.2 was 
> fine) on a Lenovo 82FG/ Ideapad 5-15ITL05 (i5-1135G7 and Xe graphics), 
> failing to (UEFI-) boot already within the initramfs (Debian/ unstable, 
> initramfs-tools).
> 
> Backing out (only) the changes to drivers/pci/msi/irqdomain.c and 
> include/linux/msi.h from patch-6.17.3 fixes the regression again.
> 
> Regards
> 	Stefan Lippers-Hollmann

This is caused by the vmd driver, as vmd driver rely on the assumption
that pci domain template does not set irq_startup()/irq_shutdown.

I think this may needs the following patch:
https://lore.kernel.org/all/20251014014607.612586-1-inochiama@gmail.com


