Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62E8323A4;
	Fri, 28 Apr 2023 07:36:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76526C433D2;
	Fri, 28 Apr 2023 07:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682667378;
	bh=mzgSqMupDXVzsWnPg4AuzcSqXsmJxNaSF5qDcycX6AQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EmpUgvO29Yft7dbzvDv7iRAvX9Pc3gxG0YYxFPRwfNs8VeIttYWN/VMwF32Ni7+za
	 qGvoqJ4Km81wQfhL3RdNmfCT17aHmyT5cg/GTFMBzH0zefbuN0E+Ox7AdJ/W4OV9ml
	 /rw77kF3sNmn6KBwFCYPjipRNsc1KdRnHQP6kNks=
Date: Fri, 28 Apr 2023 09:36:15 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, lstoakes@gmail.com,
	regressions@lists.linux.dev, linux-mm@kvack.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	Jiri Slaby <jirislaby@kernel.org>, Fabian Vogt <fvogt@suse.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH for v6.3 regression] mm/mremap: fix vm_pgoff in
 vma_merge() case 3
Message-ID: <2023042802-frolic-racing-112b@gregkh>
References: <20230427140959.27655-1-vbabka@suse.cz>
 <2023042719-stratus-pavestone-505e@gregkh>
 <3cc6e10c-f054-a30a-bf87-966098ccb7bf@suse.cz>
 <CAHk-=wgdGzy6-3jzN6Kvtz1QxStTZBZPz1zy9i4gM9nbe5FGbA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHk-=wgdGzy6-3jzN6Kvtz1QxStTZBZPz1zy9i4gM9nbe5FGbA@mail.gmail.com>

On Thu, Apr 27, 2023 at 08:12:40AM -0700, Linus Torvalds wrote:
> On Thu, Apr 27, 2023 at 7:39 AM Vlastimil Babka <vbabka@suse.cz> wrote:
> >
> > Sorry, I wasn't clear what I meant here. I didn't intend to bypass that
> > stable rule that I'm aware of, just that it might be desirable to get this
> > fix to Linus's tree faster so that stable tree can also take it soon.
> 
> Ack. It's in my tree as commit 7e7757876f25 right now (not pushed out
> yet, will do the usual build tests and look around for other things
> pending).

Thanks, I've grabbed it now for the 6.3.y tree.

greg k-h
