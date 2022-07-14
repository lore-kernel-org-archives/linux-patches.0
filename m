Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67FB97E
	for <patches@lists.linux.dev>; Thu, 14 Jul 2022 21:01:38 +0000 (UTC)
Received: by mail-qt1-f172.google.com with SMTP id i21so2426966qtw.12
        for <patches@lists.linux.dev>; Thu, 14 Jul 2022 14:01:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qMS8Mn7wGz7XtMN7xQJ8lMrziQIJCiH2YSP6pqhg5W4=;
        b=CvAsv8uvXetW4fUT+uCfRI3Zf1Qyc6be8diIyjoZ0rrRW0kFaJqXBW0U2Y0YhUZwa9
         SL6ZY9wLTnrMH/S7WJvcw0Es2Pj6pC9+Im82IjunVjB4tvMAkW1Gf8OZ+7ThH4a/OQiy
         IopuucKhBYwFwI7T+xQ08sFw6v9SAc02QDq8U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qMS8Mn7wGz7XtMN7xQJ8lMrziQIJCiH2YSP6pqhg5W4=;
        b=J5Fqg+jEPY7d4/0dVQHOoIA+F4+bnAXPKqgdBPBze7mfYT3VTxN97t6vfSwiO8GCZh
         EA+waOTl9ZxiMG2cg2p37tR+CxEV0a4wg4GnAFrFhtJ5PAi64AguJ3NaTx+ZT7iQbk+G
         EZAKBq2v8WD6n4MbBwlc/pjKi1t4/olUSaD+Wh4rJqdl0JIe+3lL0MrjKZUiETQpZYzO
         4OSm9YP96QOnvZkAWuGh+RicL72KHa4oWBLhZyVxBhRV87gz+28f3X3yDHO0deEhDrHr
         n8AFd7OOs69d+uZUoT1TcUgHgPdtbmyDPj6pIVx4NkeCKJsfyr6XdkcmXT5iTD5D2g3h
         6jaQ==
X-Gm-Message-State: AJIora/ueG6zHr59O9Xnk0yUS0t4V7ZmqOBnLzEsYKpv2Bw3r9cEzG37
	XBam5/vfoeD3s0/MKZ3tcbWMqw==
X-Google-Smtp-Source: AGRyM1vAvkq9jTZP+cpfEDsXRnC0E/cD7zD40np4HC1DwP44sHxw/RKiaKV+gBCZTop7gM4pYPkeRQ==
X-Received: by 2002:a05:622a:1208:b0:31e:7b14:9bf4 with SMTP id y8-20020a05622a120800b0031e7b149bf4mr10064936qtx.393.1657832497224;
        Thu, 14 Jul 2022 14:01:37 -0700 (PDT)
Received: from meerkat.local (bras-base-mtrlpq5031w-grc-30-209-226-106-245.dsl.bell.ca. [209.226.106.245])
        by smtp.gmail.com with ESMTPSA id j15-20020a05620a288f00b006a5d2eb58b2sm2343594qkp.33.2022.07.14.14.01.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jul 2022 14:01:36 -0700 (PDT)
Date: Thu, 14 Jul 2022 17:01:35 -0400
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To: Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc: patches@lists.linux.dev
Subject: Re: [PATCH WIP v1 3/3] Add myself as ultimate maintainer
Message-ID: <20220714210135.nfiwkvvf3y54bij5@meerkat.local>
References: <20220707-my-new-branch-v1-0-8d355bae1bb5@linuxfoundation.org>
 <20220707-my-new-branch-v1-3-8d355bae1bb5@linuxfoundation.org>
 <b49b97df-8051-ea88-dfa7-5c64f611a10f@gnuweeb.org>
 <fa7a99b1-11a7-c170-05f9-3327bbf7fdfa@gnuweeb.org>
 <20220714200758.hzweoskhf4kottoo@meerkat.local>
 <97675707-1da9-d32e-c5d1-c74fa3c6a851@gnuweeb.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <97675707-1da9-d32e-c5d1-c74fa3c6a851@gnuweeb.org>

On Fri, Jul 15, 2022 at 03:40:57AM +0700, Ammar Faizi wrote:
> BTW, these patches are missing an "In-Reply-To" header to the cover letter.
> Just noticed my Telegram bot doesn't properly group this series because of that.

Hmm... It's kind of redundant with the References: header, but I guess it
doesn't hurt to duplicate that. I'll add that in.

-K
