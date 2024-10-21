Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F33F1E0E0E
	for <patches@lists.linux.dev>; Mon, 21 Oct 2024 16:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729527744; cv=none; b=tOJEnZ8fyuS7Dd2ygoq2lfG39zg9hyIl0zIw7wnz8H9D6VsFfmmXlUXWMf0ANcbLKXHJODyzARif9VhvSSBqlEht9OtA6OGHZu/2ZVV1wk2+exf7NKvYw6izEGQmlNf6xLxJkFrmTZYStD/YPUcQZ9GHvbeXd3uj57jAgyGFxHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729527744; c=relaxed/simple;
	bh=OPwLm4KbXRPjPPUsnhN3viq6xYmj5UJS4BgPDBMUoO0=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DfYFLd6BYC1Vbi5K6yPrtTrXVwqAlRjP7oyS66rDcv7S7rs1TMkMEoEMYmGj02OYEb6Ret/5u/bQuyIOBShEGO60AgjqXtMwlycZhJtDy+WzyFYfW6i4HEAD4+e1ZvQAu17ejrLt6bUEL4iHO+DR8vkJKF9GpfqrmQiyyc93rpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cpMAoE0E; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cpMAoE0E"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-539e3f35268so2900964e87.3
        for <patches@lists.linux.dev>; Mon, 21 Oct 2024 09:22:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729527741; x=1730132541; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7bhwla8+6KA+J2l2zXzoT/1T3zQj3xRspy+bneLu4x4=;
        b=cpMAoE0EZGMrWou6kDHiMX05K3072g1EP6Jhji5PklWfvwvyWvcumStKchKU/KUTl4
         SfC5bJMCrerCE8r8todyoFjhN5gSH9GSP6wNCmlkV3ig9n4d3skrtIFGVNB9bzHK7EXo
         uFPQ4MQu5FaXSB7jh9nv7bDQXmYn3S0EddT2Xdk7h7C4igK5tXi9e9yAoKyHVUYBLwx5
         W2lWXAECx3LAC86icCjgxsuzK16O39rMQ62IuHtsU/2HE5a/pnl5rKk37p06nkUvv5Wm
         I7H57vEfHbsEcQLl1HRctbuYogpCA/JN9Sb/pUOXodV/SyAjeJ27a+cdp8SKGGu00oDw
         MF+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729527741; x=1730132541;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7bhwla8+6KA+J2l2zXzoT/1T3zQj3xRspy+bneLu4x4=;
        b=uoWHtSNF3hyxrrlQ73O+jbyJ1bpSzGN2CbENLK2PwbWqGUA9IHQH635AjbAfb3066q
         XNVphfAPNvgWq2iK15IDwKiBcv3u2RLF3iDJ1zM8kgBSwuTLSpqCNthzcaPZg/THg1Cp
         Z9EiS+Kcf0BTHuT+7UxLhRoHsPPW+V+/bX3YXjT7z3mBffnHy/qkIAg+AvWiKFUteo/t
         sjMrnNRN0Dt9i5ohIElunVCaQfTDxCtfL8H5Crky9SA+wbw5kP6RKUAtLlZnPgKc/+ME
         8u1xLNxBk9VAqpCmlBmESV/22pmXdLaWdbrhnrM5y11NpuFJVx3gaSJjTs8PpViPokTD
         uSDA==
X-Forwarded-Encrypted: i=1; AJvYcCVHuSgO8MAxPjqY4dHTyfHFRl2zCWFUqhzEAqqP04XRijRoYVCSSFfJ5LFlhk0BUVEh2IOHgyMl@lists.linux.dev
X-Gm-Message-State: AOJu0YyXEfrpxJT7NQDtUCyi7bfAqVNLei/WYqZ8R6uZu4AmL7x5vLvZ
	YJDFUxgeU/XktpV61Ug+952DaKJOF2aCRfhegakGm9+3D1u0Nu/j
X-Google-Smtp-Source: AGHT+IG0ia65F5bFAoAh4IwlqxoYqOtesCPVPMKTH3oy6uQ69GOTbPfTqJEHKVXBSwaxhqJSuLqKMw==
X-Received: by 2002:a05:6512:308d:b0:536:55a8:6f78 with SMTP id 2adb3069b0e04-53a15219180mr5534266e87.17.1729527740521;
        Mon, 21 Oct 2024 09:22:20 -0700 (PDT)
Received: from pc636 (host-90-233-222-236.mobileonline.telia.com. [90.233.222.236])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53a2243ecb4sm518168e87.247.2024.10.21.09.22.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2024 09:22:20 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Mon, 21 Oct 2024 18:22:17 +0200
To: Ben Greear <greearb@candelatech.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, Florian Westphal <fw@strlen.de>,
	Uladzislau Rezki <urezki@gmail.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 6.11 024/135] lib: alloc_tag_module_unload must wait for
 pending kfree_rcu calls
Message-ID: <ZxZ_uX0e1iEKZMk5@pc636>
References: <20241021102259.324175287@linuxfoundation.org>
 <20241021102300.282974151@linuxfoundation.org>
 <a4163f51-cc1a-0848-d0fd-e9b94dafc306@candelatech.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4163f51-cc1a-0848-d0fd-e9b94dafc306@candelatech.com>

On Mon, Oct 21, 2024 at 09:16:43AM -0700, Ben Greear wrote:
> On 10/21/24 03:23, Greg Kroah-Hartman wrote:
> > 6.11-stable review patch.  If anyone has any objections, please let me know.
> 
> This won't compile in my 6.11 tree (as of last week), I think it needs more
> upstream patches and/or a different work-around.
> 
> Possibly that has already been backported into 6.11 stable and I just haven't
> seen it yet.
> 
Right. The kvfree_rcu_barrier() will appear starting from 6.12 kernel.

--
Uladzislau Rezki
