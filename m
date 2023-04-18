Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDB78C94A
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 21:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=cK6WZTCqxBa6ulq6LX+4lU7vuWA3n6M3EQUmCRHWpYg=; b=NPbEVuM/gB2VHB7LlJAfo3Fvnq
	Q94MvKr/Mjw1VVA5m0mr0SDBIKwDmayD4OX+U2blHmcTrhBjX0JK0K/CKpAd4L594ptFESoihQ++Q
	zKnN0osw36CLv0LWXd3TYsO2h85VQCXjJs96/jf2e1l95aWYKUMQQ2gNhBsW9fR1UtSHIEOHPtupB
	qN3pyOtizpgPvK++8LlAzcnFMEH3mcbbTdJobh9Xf5d8UtircxI5INvR9EWBvxyu7AQwjH2wyG74f
	V6JaJOGV+OWVLom9tgE5GzVvlmaMjTG7D6hovQFrAgjcxGoORSqffonxycqoN4EAlriCLFIZXeWJB
	XVIX4O4g==;
Received: from [2601:1c2:980:9ec0::2764]
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1posug-003OEO-1k;
	Tue, 18 Apr 2023 21:30:58 +0000
Message-ID: <5db6179d-985b-c08c-fad2-d7fbb2d40e4d@infradead.org>
Date: Tue, 18 Apr 2023 14:30:55 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v2 6/6] shmem: add support to ignore swap
Content-Language: en-US
To: Luis Chamberlain <mcgrof@kernel.org>, Hugh Dickins <hughd@google.com>
Cc: akpm@linux-foundation.org, willy@infradead.org, brauner@kernel.org,
 linux-mm@kvack.org, p.raghav@samsung.com, da.gomez@samsung.com,
 a.manzanares@samsung.com, dave@stgolabs.net, yosryahmed@google.com,
 keescook@chromium.org, patches@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20230309230545.2930737-1-mcgrof@kernel.org>
 <20230309230545.2930737-7-mcgrof@kernel.org>
 <79eae9fe-7818-a65c-89c6-138b55d609a@google.com>
 <ZD8J+I6uCqfp31sv@bombadil.infradead.org>
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <ZD8J+I6uCqfp31sv@bombadil.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/18/23 14:22, Luis Chamberlain wrote:
> On Mon, Apr 17, 2023 at 10:50:59PM -0700, Hugh Dickins wrote:
>> You'll be sending a manpage update to Alejandro in due course, I think.
> 
> Sure thing! Just need a git tree. I can send the updates as we reach
> a consensus on where to store / share huge page shmem updates.
> 
>   Luis

From the latest man-page announcement:


	man-pages-6.04 - manual pages for GNU/Linux

The release tarball is already available at <kernel.org>.

Tarball download:
	<https://mirrors.edge.kernel.org/pub/linux/docs/man-pages/>
Git repository:
	<https://git.kernel.org/cgit/docs/man-pages/man-pages.git/>

-- 
~Randy
