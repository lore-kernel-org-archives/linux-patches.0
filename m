Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 088BC36A37E
	for <patches@lists.linux.dev>; Mon,  8 Jun 2026 11:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780918827; cv=none; b=pI6+d5yBPDlKtr6SxXwmnWub8CEENVBy4yFs8pycbun9TYo7BV09HRstiYrgEoTD0uVP2Y33XcUzjKdCEpQ5kmo2oexTkyDPuzxNVhWLdrjp4C9Qp4MCXX70SmQzHnnGI9IbkM4nRG+wGQCig3WxTVgHbOSRY6Q/k6/4qxx9Z8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780918827; c=relaxed/simple;
	bh=gt817j5d2FZcQYx9aiRFtGll+41qpg8M37eW3rPlaLM=;
	h=Message-ID:From:To:Cc:In-Reply-To:Subject:Content-Type:Date; b=uDLueJ+ZP06Ix9sRTNJ1CBHcSQGSeXzkk41wNoE0VJV/7FaRRYX370zCOsKzp09nbS6WbLI+BQw4f3O1P98I0MaEXH0Rc996RT6pnOjUxMksNF29thNqd36wvpkQ01WGvgjkLahgmIBiOgyttfObKmr05e+l9vZTr4h1Ur31a6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Ca5hktma; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Ca5hktma"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-45ef1629ff4so2764855f8f.0
        for <patches@lists.linux.dev>; Mon, 08 Jun 2026 04:40:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1780918824; x=1781523624; darn=lists.linux.dev;
        h=date:content-transfer-encoding:subject:in-reply-to:cc:to:from
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=gt817j5d2FZcQYx9aiRFtGll+41qpg8M37eW3rPlaLM=;
        b=Ca5hktmayMxvSkQccRaX0B64NGXMDJ1pHgwsCp7fSQ9vR5tKLaT4aMCpZPX9dUx9MM
         +lKZXYyIFOA0WcQ81B1xnbZS2w7gUBkt6S7tquuD7IPlpfO/rumHdopS2xo+trBi4WEZ
         AnGdeu4ikRT0AwWz1zcev8oB8CsOE7FW1bv43TUlyGovY1s3HomuS3TnXNJkinTPi9w1
         ilERqcztGveLE0NAnLrL784jAYFFHmvm975eJTlInIrYUw1BUsIjVb7os7SDsAS3J5iB
         qHELTF2gY88VCAcL44PNs1EDBG32KK8jUD8nmIrmyq6rDeZYpGxBVdO6RMLd5x+czvfc
         UEoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780918824; x=1781523624;
        h=date:content-transfer-encoding:subject:in-reply-to:cc:to:from
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gt817j5d2FZcQYx9aiRFtGll+41qpg8M37eW3rPlaLM=;
        b=cpfdkW4rI2he/qjRACghKIURHBbDN3eJo+6NEFeOIU95VGC7SfsGdAycxxSntQIPLK
         jy+rYQebI4CbNDPnUEHQiDHdMI0zc4RgV8bH0XoHBrVr05HYycjuxLF/mhMVIJsPHK1H
         LTwD06jul1KIpyotrhqBnLrsXOkTWRbD6XHsJebHxJXULpZGxbOoteAycd7O3r3i2zHV
         z/zzpzNrYg1387O7eHT/oxdaegWfvT7L45HzeI5CqHV4xEF4td815wtl8GqysJWBMULl
         yHt3NvrwOtuGLM+eRYBVF+T4ip4/4okT53vwR7A2N5cNsZNuViC/tZfoWWEfzdi8l/pZ
         sQpQ==
X-Forwarded-Encrypted: i=1; AFNElJ/MMsdKDY3lTBuyna+5K1gVtHVVWROHyuAbwXZ16JuHXStyrvC5jGuyvd91m18HXJVvz4W0Z86N@lists.linux.dev
X-Gm-Message-State: AOJu0YxJSupuBuG//M9+1yiO/pYXx6Di8cX4q4EC7jH/J28gZbQdlU6D
	1UR8V05nTSBgQPgrRjnfszqCsQZDIomnZLM+pJieCUl2Bhe/rvGtGClwCjbsxUVBh74=
X-Gm-Gg: Acq92OH9JNpPBVNcJ52I1whgjHAs5dPz1+lGAGmDxmNC5dg+axlRGKI0doOQ8HDxuMe
	7CIfmxrQq65Ac5STOHTUeG5j5i9Mg8MlueP9+iR0KW1aTiWGqIdke95svRdVBKxG9SPwH57YKRw
	R7NwpSa8zLSngiqwRgFa3Tt6Q4vRk/s+iXw8L8yXAUlIB/rHv0yHO77Zdakh/JUVxVnw5IeMCRP
	pReenYFvD7rp8U+U7hQTKm9PFYhfxHhBTaTa4GP7aI68X7VQ5FJt4aCTpQZ86D+/IeaxARH1sTi
	KNoLbCQM/SCmtj48BEV/rAvipVVU5Tqp+y5ygeS2LFhwBWQf2DzoTKcy15sbPAt1RwhRQ8wQBXK
	Wf1R7mg/ehtI9WoUjZ+hbTBQbvgTR/JvLyQwlqmppC9otUzVxk+Ng98jhRT8oGUXpPi8Y5QqxnW
	sXqwTzlfGUQUBL84WAOIPcU3ixCK7snERsz/7YeBuEOcqG63ge2E9D7JRDQrcSLr9exBx8HC5RN
	5uAY11Pj0sTriPRD5K9rIVX1HuZ98d0laj+c0iBkNsM9A==
X-Received: by 2002:a05:6000:46cd:b0:460:1492:4f0d with SMTP id ffacd0b85a97d-4603063c591mr15377117f8f.34.1780918824402;
        Mon, 08 Jun 2026 04:40:24 -0700 (PDT)
Received: from localhost.localdomain (p200300ef2f13eb00c11aebd17f9598f1.dip0.t-ipconnect.de. [2003:ef:2f13:eb00:c11a:ebd1:7f95:98f1])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f2f2710sm40821903f8f.14.2026.06.08.04.40.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 04:40:24 -0700 (PDT)
Message-ID: <6a26aa28.283787d8.1f1282.ba36@mx.google.com>
From: "Andrea Cervesato" <andrea.cervesato@suse.com>
To: "Askar Safin" <safinaskar@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, "Christian Brauner" <brauner@kernel.org>, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, "Jan Kara" <jack@suse.cz>, "The 8472" <kernel@infinite-source.de>, patches@lists.linux.dev, "David
 Howells" <dhowells@redhat.com>, linux-mm@kvack.org, "Collin Funk" <collin.funk1@gmail.com>, "Joanne
 Koong" <joannelkoong@gmail.com>, "Miklos Szeredi" <miklos@szeredi.hu>, "David
 Laight" <david.laight.linux@gmail.com>, "Matthew Wilcox" <willy@infradead.org>, "Christoph
 Hellwig" <hch@infradead.org>, "Steven Rostedt" <rostedt@goodmis.org>, fuse-devel@lists.linux.dev, "David
 Hildenbrand" <david@kernel.org>, "Pedro Falcato" <pfalcato@suse.de>, ltp@lists.linux.it, "Jens
 Axboe" <axboe@kernel.dk>, "Stefan Metzmacher" <metze@samba.org>, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, "Andy
 Lutomirski" <luto@amacapital.net>, linux-api@vger.kernel.org, "Andrew
 Morton" <akpm@linux-foundation.org>, "Linus Torvalds" <torvalds@linux-foundation.org>, "Willy
 Tarreau" <w@1wt.eu>
In-Reply-To: <20260606061031.3744880-1-safinaskar@gmail.com>
Subject: Re: [LTP] [PATCH 0/5] vmsplice: fix some problems in my previous
 vmsplice patchset
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 08 Jun 2026 11:40:22 +0000
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

Hi Askar,

the patch-set doesn't apply:

error: fs/read_write.c: does not exist in index
hint: Use 'git am --show-current-patch=3Ddiff' to see the failed patch
hint: When you have resolved this problem, run "git am --continue".
hint: If you prefer to skip this patch, run "git am --skip" instead.
hint: To restore the original branch and stop patching, run "git am --abort=
".
hint: Disable this message with "git config set advice.mergeConflict false"
Applying: vmsplice: open-code do_writev and do_readv
Patch failed at 0001 vmsplice: open-code do_writev and do_readv

https://github.com/linux-test-project/ltp-agent/actions/runs/27129052434/jo=
b/80065058557#step:8:21

Please update it to a new version after rebasing with the upstream master
branch.

Regards,
--
Andrea Cervesato
SUSE QE Automation Engineer Linux
andrea.cervesato@suse.com
