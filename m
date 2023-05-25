Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD18C5C97
	for <patches@lists.linux.dev>; Thu, 25 May 2023 07:02:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC9EEC433EF;
	Thu, 25 May 2023 07:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684998126;
	bh=/zSCak2aKBEwS4L7xxLIATIg6Pb+0BRjbcVTt5j19I0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nmeUkigEx9ToiO75DmOjWBqyf3E23jOheRvmRlWmZ+aQ1Rb5oJqjUJNdiSguWKRZ+
	 qqwVy5iRE95ZKwlAAqTA4kV+HMSMkqTTUekm2eKO5a6RuaoUwVj0p0W/TpJHv0Xjdn
	 Sr0SXuk1b0u7NdgwlVhejgy2ypdDcXBNDDLluKr71TXP2vwImSwol7A7ng4SU3OKC0
	 qE2nrRUd/oIcfTj5oSjn32oVFMqY24RnYVW+ov5aF//ppikCRjNoddfNyl3sPZ4M0d
	 yOlV7Sx6CgEXqdW9lG/dL98Yt2wIHTR1iWjON2ndRseQch+uwr4+usFVaW6zy5I7HR
	 MdrYnNKJXmVVQ==
Date: Thu, 25 May 2023 09:01:55 +0200
From: Christian Brauner <brauner@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	Luis Chamberlain <mcgrof@kernel.org>
Cc: david@redhat.com, tglx@linutronix.de, hch@lst.de,
	patches@lists.linux.dev, linux-modules@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, pmladek@suse.com,
	petr.pavlu@suse.com, prarit@redhat.com, lennart@poettering.net,
	gregkh@linuxfoundation.org, rafael@kernel.org, song@kernel.org,
	lucas.de.marchi@gmail.com, lucas.demarchi@intel.com,
	christophe.leroy@csgroup.eu, peterz@infradead.org, rppt@kernel.org,
	dave@stgolabs.net, willy@infradead.org, vbabka@suse.cz,
	mhocko@suse.com, dave.hansen@linux.intel.com,
	colin.i.king@gmail.com, jim.cromie@gmail.com,
	catalin.marinas@arm.com, jbaron@akamai.com,
	rick.p.edgecombe@intel.com, yujie.liu@intel.com,
	linux-fsdevel@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 1/2] fs/kernel_read_file: add support for duplicate
 detection
Message-ID: <20230525-sporen-gesittet-b1cf61aa5dfa@brauner>
References: <20230524213620.3509138-1-mcgrof@kernel.org>
 <20230524213620.3509138-2-mcgrof@kernel.org>
 <CAHk-=wjahcAqLYm0ijcAVcPcQAz-UUuJ3Ubx4GzP_SJAupf=qQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHk-=wjahcAqLYm0ijcAVcPcQAz-UUuJ3Ubx4GzP_SJAupf=qQ@mail.gmail.com>

On Wed, May 24, 2023 at 02:52:50PM -0700, Linus Torvalds wrote:
> On Wed, May 24, 2023 at 2:36 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
> >
> > Add support for a new call which allows to detect duplicate requests
> > for each inode passed.
> 
> No.
> 
> This is all disgusting.
> 
> Stop adding horrific code for some made-up load that isn't real.

Also, this series adds non-trivial amount of code to fs/ without ever
having Cced fsdevel. As I told the bpf folks already if fs/ code is
touched fsdevel should absolutely be Cced, please.

It's literally also the first thing that get_maintainers.pl spews out.
