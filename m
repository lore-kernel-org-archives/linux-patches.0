Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88B0A1854
	for <patches@lists.linux.dev>; Tue, 17 May 2022 16:42:14 +0000 (UTC)
Received: by mail-lf1-f49.google.com with SMTP id p22so2950735lfo.10
        for <patches@lists.linux.dev>; Tue, 17 May 2022 09:42:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=X+ZIsvVjUuwlh/wMsd673AwYnSIKugcP1RnbxXgeB7M=;
        b=V8osDecpKG1CjUJgHbXhszmxjy2U6L5nGE72cpZ9wzdBseZt01yt+Z4mmHiEAt594M
         BNqhFNGWjAm8E9llNlZJhF++9DHOQfxrAZVLSUa3Axy8oqQ+ReQqs74mJBVZgyQZa4lT
         qOpPZirzW3loPIh1wPdjoJshtTrfYXMGx/KgiEQMCw5CVv0fVVqc0R5kTe6xea1aoeRo
         UCxDV8YnZi0hgkTAF5f38w3ARVMhSRvJbZt0TIhplhn9V70cOcfuemjsVkA+vfLl5GYQ
         fnELcWbYh9v4jj6y6/n6LCNH9i8RWUqtgra/HnsQkQlsOI8pNTwR4uTbKE3aFuawAaZl
         6jVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=X+ZIsvVjUuwlh/wMsd673AwYnSIKugcP1RnbxXgeB7M=;
        b=s2d8LPVUyIeg+xAQJh/yiTWZlZN2JQivqtZ74GEKQgxePHD8LEpZKuABA23g4MSKJz
         Y4Fj3e7uqnz23HeODFfruYiVqZRqHO7RQxgvpiIZDN+Y5URAQzyvd8Fxl0McCPrmRBAX
         Sokbw4fh/DqzufQPMFpVGz5YGqB77GdNN3zQRpe6UkRGLTjNszlNMBtRrrvuuf8/V8h7
         uS05dORBWwHumBDsuctxCFMjh1eJvFsNXQogEidR9rhHvuw5KFKWQYzkpRR6k2hOBBmb
         NeWFoZgz5X4xCkw8zuO4YxIkk4wEa4CTQfmVrsimOdL1ubiuBLPa6sqI3fTrq5zFjqE4
         ebFw==
X-Gm-Message-State: AOAM531EbLiQjEWZYXJMQB0/8QZKEzvQIxI7NhujkJN6nk2HrZ9Bva4i
	h3N56aOGiLB4UcDj79nQkSE38A==
X-Google-Smtp-Source: ABdhPJxmKZP+YUmR4TA93TjSj+0oUrnGYJTJhLZ9zVqZmhZg9tbge+VD7odfkhYj4w2QPj6YTGDhpQ==
X-Received: by 2002:a05:6512:4008:b0:450:bd56:50b3 with SMTP id br8-20020a056512400800b00450bd5650b3mr17936796lfb.552.1652805732538;
        Tue, 17 May 2022 09:42:12 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id a2-20020a056512390200b00477b38eabd1sm6624lfu.94.2022.05.17.09.42.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 09:42:11 -0700 (PDT)
Received: by box.localdomain (Postfix, from userid 1000)
	id 74B9F10453E; Tue, 17 May 2022 19:44:03 +0300 (+03)
Date: Tue, 17 May 2022 19:44:03 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Jakub =?utf-8?Q?Mat=C4=9Bna?= <matenajakub@gmail.com>
Cc: linux-mm@kvack.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, vbabka@suse.cz, mhocko@kernel.org,
	mgorman@techsingularity.net, willy@infradead.org,
	liam.howlett@oracle.com, hughd@google.com, riel@surriel.com,
	rostedt@goodmis.org, peterz@infradead.org, david@redhat.com
Subject: Re: [RFC PATCH v3 0/6] Removing limitations of merging anonymous VMAs
Message-ID: <20220517164403.nabrtbkezex7uof4@box.shutemov.name>
References: <20220516125405.1675-1-matenajakub@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220516125405.1675-1-matenajakub@gmail.com>

On Mon, May 16, 2022 at 02:53:59PM +0200, Jakub Matěna wrote:
> This is a series of patches that try to improve merge success rate when
> VMAs are being moved, resized or otherwise modified.
> 
> Motivation
> In the current kernel it is impossible to merge two anonymous VMAs
> if one of them was moved. That is because VMA's page offset is
> set according to the virtual address where it was created and in
> order to merge two VMAs page offsets need to follow up.
> Another problem when merging two faulted VMA's is their anon_vma. In
> current kernel these anon_vmas have to be the one and the same.
> Otherwise merge is again not allowed.
> There are several places from which vma_merge() is called and therefore
> several use cases that might profit from this upgrade. These include
> mmap (that fills a hole between two VMAs), mremap (that moves VMA next
> to another one or again perfectly fills a hole), mprotect (that modifies
> protection and allows merging with a neighbor) and brk (that expands VMA
> so that it is adjacent to a neighbor).
> Missed merge opportunities increase the number of VMAs of a process
> and in some cases can cause problems when a max count is reached.

Hm. You are talking about missed opportunities, but do you know any
workload that would measurably benefit from the change?

The changes are not trivial. And rmap code is complex enough as it is.

I expect common cases to get slower due to additional checks that do not
result in more merges. I donno, the effort looks dubious to me as of now.

-- 
 Kirill A. Shutemov
