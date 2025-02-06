Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6D4B22A1C2
	for <patches@lists.linux.dev>; Thu,  6 Feb 2025 11:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738842102; cv=none; b=MLrwaq4rTu4khM2Vfack8mC3VPxmwof4e3eAoY9tYbnAg/uUMX39eClCIEVN4DgoSG53si2mJrB8hmEhfXQs9mL/jV8LYGs1t6fkI0yf9yzBStjENdxsP9q7izP+UCxMJrua9+BARTNz/0t18oAOm75sebs4zWBIkVHbXSYqDV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738842102; c=relaxed/simple;
	bh=uPd/seLc0R/OCTGhswhENSfy993FEKKvyB0nCxN2bzU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XUjb3IkfY/EE81/AMjQy44Bg88zJgb7OVETm0C49rhHZlV4w4rKTeSnn0//ba1oUXC6HfRLZIUH1XzlXeSIyWXSjmoMHbRH27BBK8KqH3ETS6bgBVhkwjlzaDs1ZAyyl+oT3ch2wQcL4QMlsQdJCkoYqiwj4RddqvuMusZ8T9dU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b=QIl6y0TA; arc=none smtp.client-ip=185.125.188.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b="QIl6y0TA"
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id BD2273FA55
	for <patches@lists.linux.dev>; Thu,  6 Feb 2025 11:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1738842097;
	bh=pxRegLnQ2ckk9B0H5x44QGdXpNaEQZAvL/r+edA76Vc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:In-Reply-To;
	b=QIl6y0TANfE0ScNe8nDceY8rRjWZOYEdu+XQI9m5aCz1DP7wTDFPJD3dCwNS0ZiJz
	 gpa/NuJBD7mRqz3n7mKEnZqzPjEDw12nIMWmsDTAINyV8i/TRJyjjggtc3h5pXw2Xb
	 o55MTW2KoQmL1Ce4InzrF3BwXvB01CrWWo7IiQFbYKiN02LWz+OycpzrPeoS93c0KY
	 WEKd4ll0h/3i9JTjNo6wULIs8EHuPxtC1ParG8rrPySAdX/aUnG3ItIUII4N/NoDwz
	 zAsN6iUQiv5sKBvZRsW88FZ8xC82CtU5/JUj+j2pf6ezZA0OWgFh1+r/PkFw6se9iH
	 Eki40SpkcGkhw==
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-2f9c34c0048so2468615a91.3
        for <patches@lists.linux.dev>; Thu, 06 Feb 2025 03:41:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738842096; x=1739446896;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pxRegLnQ2ckk9B0H5x44QGdXpNaEQZAvL/r+edA76Vc=;
        b=DRqf3GmUqOW1zJgjRdxSQtqC2hhE9fGP+isrFj+3N//5U3a6pLaaT26VbsYHKaPju7
         ldaKhclRq4/fMZzSf5PcpBI7oQLzwO90QOetb0E3TTAiaJRX7likhM7PRQNss8B5mcKL
         NtqSATD66Qopi2jSDYuCLhbjbpFxnBF9St/SYZEeDi23UzgkQa6J/GGHR72n69Ztf0gg
         eF4RrzaNjzdL5NFJNjwcf8ktOFT0wZwT8CkGT4f4JVnMwZMWrIxnN2EWEQgBCddRU7wy
         LyYaugtliwJyyh2zi9KsbKHf0IlFqLix/zAoW7pjoXt70lcxyK7+qijkFZafmdjNWMuE
         AB8A==
X-Forwarded-Encrypted: i=1; AJvYcCV8LiPLReyNQnXosmJxL2Pph4AGiXoWpLktHigcHBK7Gjxdp98cjqBQG6PzSPso86T3+hp5lUiO@lists.linux.dev
X-Gm-Message-State: AOJu0YwLQcuDElhdRsJnQKdvdWxD2tQjUlak/euSJb/Xis6EMvfzaeaB
	4KvfF6OdAL/VwVLEMW1M3nUGjZsT/95H9GJKT55EcbZ5wgRTNEkhdABHw1Vvm6mYwuoXXVTSHHg
	y3itmn6LRyAfrcI/KXoRdlfsSHor79n1SsM3bg0lTitbVE6jPMumEtbYGx1C5ojhr69iKRe8=
X-Gm-Gg: ASbGncuLteK2U/8boiT2l8d66bwqhQNZFr6uRT905yxpWzCUrsyzt+zauxFfVSx5RiX
	hlBn8PyoKHCTMq2CfkPAlwQ6YHjANPzOZxuAVbW6JfwBH36WRJ4gZTCHpTFkdMfxSaTQZxlg//+
	GHYDeGFh6L6jwEOqeJ1msVrG3cP2PPMjA5iWGYIXvsD0XnSB0DUoJoXt5Sscz3VHzQdJ2YCTz4I
	BqUsZNYFGwuULDwX4or7wXRDrGTrnFsEByXARWuJmvL2ikCU/bphoG+TIXj1NZO5UpP0DWATZUf
	LekW0b0=
X-Received: by 2002:a05:6a00:3a01:b0:726:54f1:d133 with SMTP id d2e1a72fcca58-7303513960bmr10558143b3a.12.1738842096300;
        Thu, 06 Feb 2025 03:41:36 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHgWFlboY9bVv95oILpdZGtSBQdmygikI9ZzimmOUBKZ9x2HbGcBkcS+B2DV7qPOnVt92hGlw==
X-Received: by 2002:a05:6a00:3a01:b0:726:54f1:d133 with SMTP id d2e1a72fcca58-7303513960bmr10558106b3a.12.1738842095895;
        Thu, 06 Feb 2025 03:41:35 -0800 (PST)
Received: from localhost ([240f:74:7be:1:c489:148c:951f:33f1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73048bf1375sm1075175b3a.119.2025.02.06.03.41.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2025 03:41:35 -0800 (PST)
Date: Thu, 6 Feb 2025 20:41:33 +0900
From: Koichiro Den <koichiro.den@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Qu Wenruo <wqu@suse.com>, Filipe Manana <fdmanana@suse.com>, 
	David Sterba <dsterba@suse.com>
Subject: Re: [PATCH 6.12 102/114] btrfs: avoid monopolizing a core when
 activating a swap file
Message-ID: <q6zj7uvssfaqkz5sshi7i6oooschrwlyapb7o47y36ylz4ylf7@dkopww2lfuko>
References: <20241230154218.044787220@linuxfoundation.org>
 <20241230154222.045141330@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241230154222.045141330@linuxfoundation.org>

On Mon, Dec 30, 2024 at 04:43:39PM GMT, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Filipe Manana <fdmanana@suse.com>
> 
> commit 2c8507c63f5498d4ee4af404a8e44ceae4345056 upstream.
> 
> During swap activation we iterate over the extents of a file and we can
> have many thousands of them, so we can end up in a busy loop monopolizing
> a core. Avoid this by doing a voluntary reschedule after processing each
> extent.
> 
> CC: stable@vger.kernel.org # 5.4+
> Reviewed-by: Qu Wenruo <wqu@suse.com>
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> Signed-off-by: David Sterba <dsterba@suse.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  fs/btrfs/inode.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -7117,6 +7117,8 @@ noinline int can_nocow_extent(struct ino
>  			ret = -EAGAIN;
>  			goto out;
>  		}
> +
> +		cond_resched();
>  	}
>  
>  	if (file_extent)
> 
> 

Hi, please let me confirm; is this backport really ok? I mean, should the
cond_resched() be added to btrfs_swap_activate() loop? I was able to
reproduce the same situation:

    $ git rev-parse HEAD
    319addc2ad901dac4d6cc931d77ef35073e0942f
    $ b4 mbox --single-message  c37ea7a8de12e996091ba295b2f201fbe680c96c.1733929328.git.fdmanana@suse.com
    1 messages in the thread
    Saved ./c37ea7a8de12e996091ba295b2f201fbe680c96c.1733929328.git.fdmanana@suse.com.mbx
    $ patch -p1 < ./c37ea7a8de12e996091ba295b2f201fbe680c96c.1733929328.git.fdmanana@suse.com.mbx
    patching file fs/btrfs/inode.c
    Hunk #1 succeeded at 7117 with fuzz 1 (offset -2961 lines).
    $ git diff
    diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
    index 58ffe78132d9..6fe2ac620464 100644
    --- a/fs/btrfs/inode.c
    +++ b/fs/btrfs/inode.c
    @@ -7117,6 +7117,8 @@ noinline int can_nocow_extent(struct inode *inode, u64 offset, u64 *len,
                            ret = -EAGAIN;
                            goto out;
                    }
    +
    +               cond_resched();
            }
    
            if (file_extent)

The same goes for all the other stable branches applied. Sorry if I'm
missing something.

Thanks,

-Koichiro
