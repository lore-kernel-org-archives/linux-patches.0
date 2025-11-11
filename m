Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46ECE36655F
	for <patches@lists.linux.dev>; Tue, 11 Nov 2025 15:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762875373; cv=none; b=lOr76N45RAdZoZAvOX4fJI97h145PrtuzS9SftN7WJAs95du3QY4CU7QlRZxfV+Kn60Vr8yNCH/0Y0VPbfzHW1gAiebwxtydH46YnBUFON7XCni5OH6mzQILgkib31fuP84jGgM4+TiNGr53OYZ1O6ATY9shKnTQaFWJjSFoR/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762875373; c=relaxed/simple;
	bh=IkdCNuwQBj0E/byUN80NSHnSj8LYAZwsDDKIrEasEbk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=u8XmQ3ehzpDpPVdzdjYoWtchXCsRTEDoQaW73rFWDZBAifZmNOTX3jWtaolkWP1Scq1UPPFqEim1meE4AFd+Ur1P5lob+8alvApO1no/TKFUnb4xij71kH5GCMprpkIRQVnp8niYgCYgHQ4G2qOBdgW9TQYpoJO2rd8RBwEiOp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=ekyMDMuV; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="ekyMDMuV"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-477775d3728so26559725e9.2
        for <patches@lists.linux.dev>; Tue, 11 Nov 2025 07:36:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1762875369; x=1763480169; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ppR1x+hLMCIFniD0aWhZe//Po7//TeOQkjJokWKR8R8=;
        b=ekyMDMuVs2U51kHAyxe5L/VJZT9L1C3KIYDNR5zHRKJMzGY4EMsHk5zXpfVNQ62ul6
         87ivdTpb5G0ATLLEWAaBCG+Ne0EIk59sIH0zVv0aw/G9O2DYhEUav+tC3kFlHfT2oSyh
         5DnHG1yBIzCoCDEzqdp6lSmyFvmejIn8DnpjvsaUSI9llA+k+8XhIniQWrFaiXLrr2or
         PiTdUSrGxdJ6c936bhNluj0a7zS4CB9wHEeWzF3f4/6mJPEzQmUSyhfj5sJA3ATZaD7D
         6a0cMxrbcpfkQ98RVJt25HLK2kAtLSYNYlNKOwYD6Q6xFA8/Jo3vK2tQTGGLw/94ra7+
         xwzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762875369; x=1763480169;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ppR1x+hLMCIFniD0aWhZe//Po7//TeOQkjJokWKR8R8=;
        b=CdvnwkzFalOOKEwpvSRs92wuMVq2J8z9AHFHuCHmWygwk51tiBgjWZpGqngdKQx0fV
         xN+k/h4doRKoM8gHmYkDtUYKh+00i3JXgF8GCZtpadjwXtjMAvS7vYXZszf5PZGfaDL/
         1ULCuMx/9f6YIK9BbUt9T1M6wjMvekOdbFzJ+bfVfWOv7nGJfO7NmYe9GS9uOddHjsgC
         uCGfYBSI9rSI+tOa8KwzNMNCwQOZPUSVgCTp6zxkIoT3notalYpYaGqmyr4QDRfNrzhS
         pcq3crNkLeFG1kFMc8wmqCKFnQPX6IzR40z5hkOwzBRW4wvFeh5CfczLt2Jf1jAz/d7E
         WkSQ==
X-Gm-Message-State: AOJu0YztvYULLIPjYo6QIoBE6udifG1ufuvndIGLuB3zLovVXuhXvFBu
	RZHNnJhmp40EkCSvqBnZaTCGN4F8LHnrgxcm+fZwHe7s/3BYovNGWIY61cV2
X-Gm-Gg: ASbGncsIAR19tjilmnea5WGb0rEzgMwS9GoJQRJhXSxwFdLx1vaDEiWHyyE6Leqdh1X
	xzMaU/gdtM75SwvbTyxUNIweKruNFv9vHPHZNwKfabzBCTo/1DZK53aqA2ogTISRcELOZ9f/o08
	QIv075yE0A19r70O2i5DE7nhJsnhE6mKwIMfZ80757pfki4W6kcY8fuMOaTKYBUf61xOW3emXdB
	Cp2butkJhWhh4fFziw5AwDKf8QpAd07i/Q/PJGGABwgVMgAD6rQbrnsBfLov5k8x6Alv5hVKPJ+
	6Dvbeyo+rb8nCblcWPefNVdffFYheST9ijzYaDTQoXX4SjfFWJoAunbmjGJYgBefyukc8JE/ZFF
	rOWQo3TUGzPJgsvhcPih7OAyaVrLdI6X9XyKKRWLLaiRmEqJs+B5ZX8lhcEg5kCYl7aE9D4xgPO
	yRY9B7fEENksmhhU6012va2T9gWVfvD4tzVtShu+4H8bhyPhhgonqC
X-Google-Smtp-Source: AGHT+IEojolfoccSO+8VSzilqIjHUxDcGXaj6DHabhOg/LEXqYLd3SjX02gv/CDQ8AJjB3/I7SQ/bA==
X-Received: by 2002:a05:600c:3b8d:b0:46f:b327:ecfb with SMTP id 5b1f17b1804b1-47773230895mr107537725e9.9.1762875369310;
        Tue, 11 Nov 2025 07:36:09 -0800 (PST)
Received: from [192.168.1.3] (p5b2b46e7.dip0.t-ipconnect.de. [91.43.70.231])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42ac675cd25sm29278958f8f.22.2025.11.11.07.36.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Nov 2025 07:36:08 -0800 (PST)
Message-ID: <657784d1-72df-43f1-91c4-2d19984dfb14@googlemail.com>
Date: Tue, 11 Nov 2025 16:36:08 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 070/565] drm/ast: Clear preserved bits from register
 output value
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Thomas Zimmermann <tzimmermann@suse.de>,
 Jocelyn Falempe <jfalempe@redhat.com>, Nick Bowler <nbowler@draconx.ca>,
 Douglas Anderson <dianders@chromium.org>, Dave Airlie <airlied@redhat.com>,
 dri-devel@lists.freedesktop.org
References: <20251111004526.816196597@linuxfoundation.org>
 <20251111004528.526435608@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20251111004528.526435608@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Greg,


Am 11.11.2025 um 01:38 schrieb Greg Kroah-Hartman:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Thomas Zimmermann <tzimmermann@suse.de>
> 
> commit a9fb41b5def8e1e0103d5fd1453787993587281e upstream.
> 
> Preserve the I/O register bits in __ast_write8_i_masked() as specified
> by preserve_mask. Accidentally OR-ing the output value into these will
> overwrite the register's previous settings.
> 
> Fixes display output on the AST2300, where the screen can go blank at
> boot. The driver's original commit 312fec1405dd ("drm: Initial KMS
> driver for AST (ASpeed Technologies) 2000 series (v2)") already added
> the broken code. Commit 6f719373b943 ("drm/ast: Blank with VGACR17 sync
> enable, always clear VGACRB6 sync off") triggered the bug.
> 
> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
> Reported-by: Peter Schneider <pschneider1968@googlemail.com>
> Closes: https://lore.kernel.org/dri-devel/a40caf8e-58ad-4f9c-af7f-54f6f69c29bb@googlemail.com/
> Tested-by: Peter Schneider <pschneider1968@googlemail.com>
> Reviewed-by: Jocelyn Falempe <jfalempe@redhat.com>
> Fixes: 6f719373b943 ("drm/ast: Blank with VGACR17 sync enable, always clear VGACRB6 sync off")
> Fixes: 312fec1405dd ("drm: Initial KMS driver for AST (ASpeed Technologies) 2000 series (v2)")
> Cc: Thomas Zimmermann <tzimmermann@suse.de>
> Cc: Nick Bowler <nbowler@draconx.ca>
> Cc: Douglas Anderson <dianders@chromium.org>
> Cc: Dave Airlie <airlied@redhat.com>
> Cc: Jocelyn Falempe <jfalempe@redhat.com>
> Cc: dri-devel@lists.freedesktop.org
> Cc: <stable@vger.kernel.org> # v3.5+
> Link: https://patch.msgid.link/20251024073626.129032-1-tzimmermann@suse.de
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   drivers/gpu/drm/ast/ast_drv.h |    8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
> 
> --- a/drivers/gpu/drm/ast/ast_drv.h
> +++ b/drivers/gpu/drm/ast/ast_drv.h
> @@ -286,13 +286,13 @@ static inline void __ast_write8_i(void _
>   	__ast_write8(addr, reg + 1, val);
>   }
>   
> -static inline void __ast_write8_i_masked(void __iomem *addr, u32 reg, u8 index, u8 read_mask,
> +static inline void __ast_write8_i_masked(void __iomem *addr, u32 reg, u8 index, u8 preserve_mask,
>   					 u8 val)
>   {
> -	u8 tmp = __ast_read8_i_masked(addr, reg, index, read_mask);
> +	u8 tmp = __ast_read8_i_masked(addr, reg, index, preserve_mask);
>   
> -	tmp |= val;
> -	__ast_write8_i(addr, reg, index, tmp);
> +	val &= ~preserve_mask;
> +	__ast_write8_i(addr, reg, index, tmp | val);
>   }
>   
>   static inline u32 ast_read32(struct ast_device *ast, u32 reg)
> 


I think that with this patch (which fixes a bug in the original ast driver affecting AST2300), it is now safe to also 
include (in both 6.12.58 AND 6.17.8)

6f719373b943 ("drm/ast: Blank with VGACR17 sync enable, always clear VGACRB6 sync off")


which triggered that bug, and which you dropped from 6.12.55 and 6.17.5, respectively, because of my report

https://lore.kernel.org/dri-devel/a40caf8e-58ad-4f9c-af7f-54f6f69c29bb@googlemail.com/


NB: 6f719373b943 fixed (IIRC) an important issue for AST2500 users. I have tested the combination of both patches in 
mainline 6.18-rc2, and they work fine together, and Linus has both of them in his tree since 6.18-rc4.

Also, I tested both of them already on top of 6.12.5 and 6.17.5, and they were fine, too. Please see:

https://lore.kernel.org/lkml/045e6362-01db-47f3-9a4f-8a86b2c15d00@googlemail.com/


Beste Grüße,
Peter Schneider

-- 
Climb the mountain not to plant your flag, but to embrace the challenge,
enjoy the air and behold the view. Climb it so you can see the world,
not so the world can see you.                    -- David McCullough Jr.

OpenPGP:  0xA3828BD796CCE11A8CADE8866E3A92C92C3FF244
Download: https://www.peters-netzplatz.de/download/pschneider1968_pub.asc
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@googlemail.com
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@gmail.com
