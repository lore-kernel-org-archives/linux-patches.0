Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A03E27B;
	Thu, 27 Oct 2022 22:25:20 +0000 (UTC)
Received: by mail-oi1-f181.google.com with SMTP id o64so4171883oib.12;
        Thu, 27 Oct 2022 15:25:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5TrIIhVZx5BXAQ8nT8vfvPQ7H/iZjq+OzPVDs0LA4cw=;
        b=MAv6HPgqfMygKs4BTr7A1U9j44lASKl92+O5gK6Jduhv540AVv0A6qWGSZQPhfBPUR
         yU/pzd5FIYlVg+ivxD0wlld9CLV4KLhTMg4HjhEzlozgEROj6wD2/V10aAh4aXQcP35U
         BafnDpsvMD09E4SRDLfNlxZnDUA98DW/atAWsyjouJMoTF39YF5qUxKgT2HKGmoPvNs7
         10teZts3aMs9T5wV9egaMWF493y0DsYnvC5tFR1v2iYOOeaO9k/0DcpjDm87935i1Xkv
         jkbuDvE3yWYSOVKjh/2ivDegzeWuZMFR0claopai1LeNUuf33rzsByUqaqwVleAFccHR
         dszw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5TrIIhVZx5BXAQ8nT8vfvPQ7H/iZjq+OzPVDs0LA4cw=;
        b=flkUYq4UPF/DZ+v6PfyaqhNn4kexQir6uqb/dJht+giE8+2/MiF/ZBFSeX3kMVCCA5
         nb6Om0bCep2FRdo7Vb9SlELXlSJ3i6Ylc01xwhETRzhNit8Su6J7ZKNvgg3QrJ9vRsyV
         WYvAL9MZdQL2fyvw1D738MUF4uL7NfuP1Vs+GvADXMChB2WNF+rINVO311gDMbLaGot6
         jJyjZSr2+oLr0KGNL8ElcOnMsjkYb+4TJK7tYEC4hWiCm8dedNH5N7dHXxvlmjlLb9Cq
         aBGwGFHqKnyRjPZlnMj3fTlxtwl9N+J05sF/BQt4VXnPTRgyeR/XIckKs/oBsLfq37xj
         lAjQ==
X-Gm-Message-State: ACrzQf0+frsNg56doWu0xkWpNMvWjqKGbMYJ9VbMwrQlqyMPHatSwdTY
	iiEikhKsVEcElYFiV7B+sfM=
X-Google-Smtp-Source: AMsMyM4HyPKTVue/7qcHWPFRtfbuE/YEWKdjke4PrvWEFGKaDXaKoQo6j4ADz/XbbOo50/dADPB5vw==
X-Received: by 2002:a05:6808:1495:b0:354:fff1:e0c7 with SMTP id e21-20020a056808149500b00354fff1e0c7mr6360344oiw.114.1666909519681;
        Thu, 27 Oct 2022 15:25:19 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id f6-20020a9d2c06000000b0063b24357269sm1009481otb.13.2022.10.27.15.25.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 15:25:19 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 27 Oct 2022 15:25:16 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Jean Delvare <jdelvare@suse.com>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Tom Rix <trix@redhat.com>,
	Quan Nguyen <quan@os.amperecomputing.com>,
	linux-hwmon@vger.kernel.org, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH -next] hwmon: (smpro-hwmon) Add missing break in
 smpro_is_visible()
Message-ID: <20221027222516.GB3123386@roeck-us.net>
References: <20221027195238.1789586-1-nathan@kernel.org>
 <20221027210016.GA1938309@roeck-us.net>
 <Y1ryPDF4CD+6gIMY@dev-arch.thelio-3990X>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1ryPDF4CD+6gIMY@dev-arch.thelio-3990X>

On Thu, Oct 27, 2022 at 02:03:56PM -0700, Nathan Chancellor wrote:
> On Thu, Oct 27, 2022 at 02:00:16PM -0700, Guenter Roeck wrote:
> > On Thu, Oct 27, 2022 at 12:52:38PM -0700, Nathan Chancellor wrote:
> > > Clang warns:
> > > 
> > >   drivers/hwmon/smpro-hwmon.c:378:2: error: unannotated fall-through between switch labels [-Werror,-Wimplicit-fallthrough]
> > >           default:
> > >           ^
> > >   drivers/hwmon/smpro-hwmon.c:378:2: note: insert 'break;' to avoid fall-through
> > >           default:
> > >           ^
> > >           break;
> > >   1 error generated.
> > > 
> > > Clang is a little more pedantic than GCC, which does not warn when
> > > falling through to a case that is just break or return. Clang's version
> > > is more in line with the kernel's own stance in deprecated.rst, which
> > > states that all switch/case blocks must end in either break,
> > > fallthrough, continue, goto, or return. Add the missing break to silence
> > > the warning.
> > > 
> > > Fixes: a87456864cbb ("hwmon: Add Ampere's Altra smpro-hwmon driver")
> > > Link: https://github.com/ClangBuiltLinux/linux/issues/1751
> > > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> > > ---
> > >  drivers/hwmon/smpro-hwmon.c | 1 +
> > >  1 file changed, 1 insertion(+)
> > > 
> > > diff --git a/drivers/hwmon/smpro-hwmon.c b/drivers/hwmon/smpro-hwmon.c
> > > index ee54e21c2c12..667e88b6bae5 100644
> > > --- a/drivers/hwmon/smpro-hwmon.c
> > > +++ b/drivers/hwmon/smpro-hwmon.c
> > > @@ -375,6 +375,7 @@ static umode_t smpro_is_visible(const void *data, enum hwmon_sensor_types type,
> > >  				return 0;
> > >  		break;
> > >  		}
> > > +		break;
> > 
> > The alignment of the break; statement above is also bad, and a default:
> > for switch (attr) is missing.
> 
> Would you prefer those fixed in the same patch or a separate one?
> 

Same patch, please. The resulting code is ultimately the same.

Thanks,
Guenter

> > >  	default:
> > >  		break;
> > >  	}
> > > 
> > > base-commit: 0ffb687b6508c36a17b99bdaf014b38532404182
> > > -- 
> > > 2.38.1
> > > 
