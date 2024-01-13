Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E121A6AC0
	for <patches@lists.linux.dev>; Sat, 13 Jan 2024 20:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DnDOL4f0"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-40e67e90d04so14406595e9.1
        for <patches@lists.linux.dev>; Sat, 13 Jan 2024 12:24:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705177487; x=1705782287; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cKEq8xL6hjiRfQkJvWxWBqnYfOkhF+HaDfsjTwVFzGo=;
        b=DnDOL4f0bcPu93WUuV+rsZSZQSOzWWxuNEdAQFGP5O7CVuMGIPZRdnB/qT+DiD2FFi
         WXbk9sQAjzk37yqlAL879//vy4TukgD5v7gx26iVGSqXeXXKVYfMDaY8fHLYXIZbNiVA
         SxzP8lasKBH5QP1qJBPKnDomgG2VcgD5HOM5qmM7jjT1UBVq+jt0WJle8A4dgOVV7ZqU
         4TJnbtwPHrXaYe4z+8rBtRaucBC3BJcaiYupPl4n+SJ9HoSPvCG+iFQHDm3d2kZIcm6e
         RD3DU8xVBXCxB6ZLB+BQpH+rsqOl+U89ti6nD/UQw42Zla10i9fekSCAN6khlAKDcY5L
         NZWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705177487; x=1705782287;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cKEq8xL6hjiRfQkJvWxWBqnYfOkhF+HaDfsjTwVFzGo=;
        b=adRmXz05YFXyy0OAuw0a7jU+SAXuaZI3iupHGQGlGzARpL2FgoeSbBAmT3AebAuDxR
         iKPhpuQxeif836MQsjdUj06UbFWZSp2yMdFhKdKYA3v5Cpf3jmzKPPoDPWNkEVYf0QCW
         KZamLSVYTtBlXivQ9jkAF9Gbl8qLeovVniO3MLcupXYbbOixWhJOWTBy2RYG0KIb1/M2
         Ak/fLQJRTkZ4C8vJDmgiro+APU47IJeGredZ/hz0b36qBiSlWIt7ajNTKg1phb+/xveM
         J2Tr4scgzootiNCGq6rO9sWTI2kUoWXbq7MACs00OX0B+KZxmBBATtdpuFyeo6+P51zt
         gC9A==
X-Gm-Message-State: AOJu0YwBgWHI1hko2lCTdQSjhXuhm/o2VWAQfuEIUhRQ6ZopIM9/B01J
	pWvLK0xCAiEdc71x9OZ5oYs=
X-Google-Smtp-Source: AGHT+IG0sf8/ujoTWS7Y2SB8Ls44pQqw2T4a4xp/I7KtzrSiYqoH6B0v9j4B7OzANTeXBZo+2iQijw==
X-Received: by 2002:a05:600c:754:b0:40d:8557:8d85 with SMTP id j20-20020a05600c075400b0040d85578d85mr1781839wmn.80.1705177486961;
        Sat, 13 Jan 2024 12:24:46 -0800 (PST)
Received: from eldamar.lan (c-82-192-242-114.customer.ggaweb.ch. [82.192.242.114])
        by smtp.gmail.com with ESMTPSA id c8-20020a05600c0a4800b0040e4746d80fsm10396845wmq.19.2024.01.13.12.24.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Jan 2024 12:24:46 -0800 (PST)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Received: by eldamar.lan (Postfix, from userid 1000)
	id A4471BE2DE0; Sat, 13 Jan 2024 21:24:45 +0100 (CET)
Date: Sat, 13 Jan 2024 21:24:45 +0100
From: Salvatore Bonaccorso <carnil@debian.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Steve French <stfrench@microsoft.com>
Subject: Re: [PATCH 6.1 1/4] cifs: fix flushing folio regression for 6.1
 backport
Message-ID: <ZaLxjaye2GcRlok2@eldamar.lan>
References: <20240113094204.017594027@linuxfoundation.org>
 <20240113094204.068608649@linuxfoundation.org>
 <ZaLt0qdHACUjlyOv@eldamar.lan>
 <2024011336-oppressor-ocean-17c2@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2024011336-oppressor-ocean-17c2@gregkh>

Hi Greg,

On Sat, Jan 13, 2024 at 09:19:46PM +0100, Greg Kroah-Hartman wrote:
> On Sat, Jan 13, 2024 at 09:08:50PM +0100, Salvatore Bonaccorso wrote:
> > Hi Greg,
> > 
> > On Sat, Jan 13, 2024 at 10:50:39AM +0100, Greg Kroah-Hartman wrote:
> > > 6.1-stable review patch.  If anyone has any objections, please let me know.
> > > 
> > > ------------------
> > > 
> > > filemap_get_folio works differenty in 6.1 vs. later kernels
> > > (returning NULL in 6.1 instead of an error).  Add
> > > this minor correction which addresses the regression in the patch:
> > >   cifs: Fix flushing, invalidation and file size with copy_file_range()
> > > 
> > > Suggested-by: David Howells <dhowells@redhat.com>
> > > Reported-by: Salvatore Bonaccorso <carnil@debian.org>
> > > Signed-off-by: Steve French <stfrench@microsoft.com>
> > > Tested-by: Salvatore Bonaccorso <carnil@debian.org>
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > ---
> > >  fs/smb/client/cifsfs.c |    2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > --- a/fs/smb/client/cifsfs.c
> > > +++ b/fs/smb/client/cifsfs.c
> > > @@ -1240,7 +1240,7 @@ static int cifs_flush_folio(struct inode
> > >  	int rc = 0;
> > >  
> > >  	folio = filemap_get_folio(inode->i_mapping, index);
> > > -	if (IS_ERR(folio))
> > > +	if ((!folio) || (IS_ERR(folio)))
> > >  		return 0;
> > >  
> > >  	size = folio_size(folio);
> > 
> > Note, this one needs to be revisited:
> > 
> > https://lore.kernel.org/stable/ZaLNlyo8cDCpATPm@casper.infradead.org/T/#md6a3f0beceaa886ca0d1e4a47ff5a575340d7e8f
> 
> I see that, thanks, I'll go fix this up.

Thanks!

Please note, the metadata for the commit needs as well some fixup: The
actual first reporter was here:

https://lore.kernel.org/stable/ZZhrpNJ3zxMR8wcU@eldamar.lan/raw

and was "Jitindar Singh, Suraj" <surajjs@amazon.com>. I only reported
it as regression from the Debian perspective following up on Jitindar
Singh, Suraj first reporting.

Sorry did not spotted earlier that reported-by was missing in the
above.

Thanks for all the work of the involved people.

Regards,
Salvatore
