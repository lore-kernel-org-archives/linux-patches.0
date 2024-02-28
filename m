Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 563E215C9
	for <patches@lists.linux.dev>; Wed, 28 Feb 2024 01:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709083905; cv=none; b=jLl+8Dcxum4pK/Z7SP108bz5Nruy7nGpikr5VFBRA+lW+YWToVUZdqL9FIPYIiLYP9Z08ZcyZwBMnZ7cqA0Th/p9R9i4sOe2mx8XDEgOsfaEBS9JPZSLI/dZomD0msTf68tS8REiF7HtgU+PnvoF5Cg73Fw6mGvOMVjHMIWzBr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709083905; c=relaxed/simple;
	bh=lo90qNmEf2u/iKz2SPriQEoHzazmFcIyRZTw7xyiU2s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J7AKyZ1t6ZWsARjZAo/4pllGmgOhzhjFCxZvm4bcrkX/J2akWjgL6S/Q4f5+yTStBHoZa6ifor8ej1r+Zfe5JV+XR4MgW03Twj/yZazKbYL6n+smiCKJNC+Ne9YbWNOEg3OLYxGQpnMX76eMseDa155y7NgGsoqbms8p/9UOPbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=marliere.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=marliere.net header.i=@marliere.net header.b=UN4j956t; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=marliere.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marliere.net header.i=@marliere.net header.b="UN4j956t"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1dca8b86ee7so23670675ad.2
        for <patches@lists.linux.dev>; Tue, 27 Feb 2024 17:31:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709083902; x=1709688702;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from
         :dkim-signature:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HrvqkdOUAXPRhxSLjfLE8T4KzZHXLHd2ZvsCtEeb2W4=;
        b=mWZ21Qm/1EG1hA6kYI1TMKJWwVzwSeWtIP9BRGMBP/onoto2pZ6sM6VKx+zhSGpys4
         ptnasg7/2gjL60wiQvc3eZW44zrpswcaTNl82dMQuzA3V6NJlN4CwulvXZ8OLiDyyaa+
         ZaGJXCswrbknC5r9HemfKdxX4P7Ct8ZAymCXdKlAY5mK34bIDXIfzo0G4GvodFk+DCy6
         Yg3nHaFaK7SEC4AbomzfZutFTuxKTfoyfcmfIQAlyElc3o84PtIXShT3bmwQuQSSaXpb
         APRrwM5aKfQmRzxE7PmTWmANqCN+jh6ElwdtNpA2a47fOdu2dv3V/1XHmBUYskoTKglH
         ZOiA==
X-Forwarded-Encrypted: i=1; AJvYcCWpLh9XdNDeeLrOSLMBqJax/YV5bZbCPhR+DD+dB5xQ/eqoY8epf3E1yx5A1IvLGoAlO0NPkJ6ABjRiM7l3P6XFQMqsJTfzug==
X-Gm-Message-State: AOJu0YwIlkZ7bTaR/urBpYj4/pU7xpAXUkN0EnrNSjy0vEw/Wuc2IaQj
	WFsdQDLcNvo7K37UMxUgEuxFSMiANzJPsHOG5v5ilMIScp04gNlC
X-Google-Smtp-Source: AGHT+IEyhBuVjDaYfkmmyL/b3b4soBpFWL1neiM/GIphVzN5x9pPCCYM5ZaqutqQTAmxhKKjL7RJuA==
X-Received: by 2002:a17:902:ec87:b0:1db:47bb:65d6 with SMTP id x7-20020a170902ec8700b001db47bb65d6mr12693389plg.58.1709083902347;
        Tue, 27 Feb 2024 17:31:42 -0800 (PST)
Received: from mail.marliere.net ([24.199.118.162])
        by smtp.gmail.com with ESMTPSA id y19-20020a170902e19300b001dbcf653024sm2130472pla.293.2024.02.27.17.31.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Feb 2024 17:31:41 -0800 (PST)
Date: Tue, 27 Feb 2024 22:31:35 -0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marliere.net;
	s=2024; t=1709083900;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HrvqkdOUAXPRhxSLjfLE8T4KzZHXLHd2ZvsCtEeb2W4=;
	b=UN4j956tYV+3UxhnrfjQKBSIWcqqodQ/4TbtsbAujYm7PtTC3RTOGzVtXRLFvWmrHWBn7F
	hTywx4osz/h/xLIf1Jctsrr84J2svOoBRfHqa7733wnwNp6JJ9Tbh1Glj1vXGZ1jQXLLNm
	+uvTnIQCHUk4H400IpveMJklTHE/e7EZnHUeEU37EP5vYbeey/6Wgj5s7V525gMtNI4fDj
	nNJTxJyGNTj0TMUVGRyJfBJghc+WolGZW6d4hJBEdFPciQfvC+DRp0MjszbM6aHObzpjjZ
	AgF3m255PY2mn5dZZtUHsMX1UbJb9gM3C9fumRQ/wfZ4YtNC61lmcQmvNjrnJA==
Authentication-Results: ORIGINATING;
	auth=pass smtp.auth=ricardo@marliere.net smtp.mailfrom=ricardo@marliere.net
From: "Ricardo B. Marliere" <ricardo@marliere.net>
To: Nathan Chancellor <nathan@kernel.org>
Cc: sre@kernel.org, linux-pm@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH] power: supply: core: Fix power_supply_init_attrs() stub
Message-ID: <xhy64utzqccidzklge4oztj663ctcd7dyepi4c7ltu6ekgzek4@yex53vr72vi7>
References: <20240227-fix-power_supply_init_attrs-stub-v1-1-43365e68d4b3@kernel.org>
 <mlfrfarnnv3i4xwgqd3pavpwxjktkqf2afidoc4ogdq3634jah@kposnyo6725z>
 <20240227214916.GA3699076@dev-arch.thelio-3990X>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240227214916.GA3699076@dev-arch.thelio-3990X>

On 27 Feb 14:49, Nathan Chancellor wrote:
> On Tue, Feb 27, 2024 at 05:39:55PM -0300, Ricardo B. Marliere wrote:
> > Hi Nathan,
> > 
> > On 27 Feb 13:34, Nathan Chancellor wrote:
> > > When building without CONFIG_SYSFS, there is an error because of a
> > > recent refactoring that failed to update the stub of
> > > power_supply_init_attrs():
> > > 
> > >   drivers/power/supply/power_supply_core.c: In function 'power_supply_class_init':
> > >   drivers/power/supply/power_supply_core.c:1630:9: error: too few arguments to function 'power_supply_init_attrs'
> > >    1630 |         power_supply_init_attrs();
> > >         |         ^~~~~~~~~~~~~~~~~~~~~~~
> > >   In file included from drivers/power/supply/power_supply_core.c:25:
> > >   drivers/power/supply/power_supply.h:25:20: note: declared here
> > >      25 | static inline void power_supply_init_attrs(struct device_type *dev_type) {}
> > >         |                    ^~~~~~~~~~~~~~~~~~~~~~~
> > > 
> > > Update the stub function to take no parameters like the rest of the
> > > refactoring, which resolves the build error.
> > > 
> > > Fixes: 7b46b60944d7 ("power: supply: core: constify the struct device_type usage")
> > > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> > > ---
> > >  drivers/power/supply/power_supply.h | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > 
> > > ────────────────────────────────────────────────────────────────────────────────
> > > modified: drivers/power/supply/power_supply.h
> > > ────────────────────────────────────────────────────────────────────────────────
> > > @ drivers/power/supply/power_supply.h:25 @ extern int power_supply_uevent(const struct device *dev, struct kobj_uevent_env
> > > 
> > > #else
> > > 
> > > static inline void power_supply_init_attrs(struct device_type *dev_type) {}
> > > static inline void power_supply_init_attrs(void) {}
> > 
> > I've missed that #else in my building test. Thanks for catching it.
> > 
> > Reviewed-by: Ricardo B. Marliere <ricardo@marliere.net>
> 
> Thanks a lot for the quick feedback and no worries, it is hard to test
> to catch these without doing a lot of build tests.
> 
> Unfortunately, I caught another problem with that change that is
> independent of this one:
> 
>   ld.lld: error: undefined symbol: power_supply_attr_group
>   >>> referenced by power_supply_core.c
>   >>>               drivers/power/supply/power_supply_core.o:(power_supply_attr_groups) in archive vmlinux.a
>   >>> did you mean: power_supply_attr_groups
>   >>> defined in: vmlinux.a(drivers/power/supply/power_supply_core.o)
> 
> It looks like power_supply_attr_groups refers to power_supply_attr_group
> but power_supply_attr_group is declared extern without a definition with
> CONFIG_SYSFS=n. It is not immediately obvious to me what the fix is.

Ah, indeed. I was able to build with the patch below. The problem is
that power_supply_attr_group is needed in power_supply_core.c but
defined in power_supply_sysfs.c, which is only targeted with
CONFIG_SYSFS=y. This was needed in order to make power_supply_dev_type
constant [1]. I will see if there is a better way of fixing it and send
a proper patch tomorrow.

Best regards,
-	Ricardo.

---
[1] https://lore.kernel.org/all/20240224-device_cleanup-power-v2-1-465ff94b896c@marliere.net/


diff --git a/drivers/power/supply/power_supply.h b/drivers/power/supply/power_supply.h
index 232fdd8c1212..ef9f1b2e87d5 100644
--- a/drivers/power/supply/power_supply.h
+++ b/drivers/power/supply/power_supply.h
@@ -13,16 +13,16 @@ struct device;
 struct device_type;
 struct power_supply;
 
-extern const struct attribute_group power_supply_attr_group;
-
 #ifdef CONFIG_SYSFS
 
 extern void power_supply_init_attrs(void);
 extern int power_supply_uevent(const struct device *dev, struct kobj_uevent_env *env);
+extern const struct attribute_group power_supply_attr_group;
 
 #else
 
-static inline void power_supply_init_attrs(struct device_type *dev_type) {}
+static inline void power_supply_init_attrs(void) {}
+static struct attribute_group power_supply_attr_group;
 #define power_supply_uevent NULL
 
 #endif /* CONFIG_SYSFS */



> 
> Cheers,
> Nathan
> 
> > > #define power_supply_uevent NULL
> > > 
> > > #endif /* CONFIG_SYSFS */
> > > 
> > > --
> > > base-commit: 3da8d71754d3c1aa0b72d74c8a324a4bc7fab473
> > > change-id: 20240227-fix-power_supply_init_attrs-stub-7be5328b4e72
> > > 
> > > Best regards,
> > > - 
> > > Nathan Chancellor <nathan@kernel.org>
> > > 
