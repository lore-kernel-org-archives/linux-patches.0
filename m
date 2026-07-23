Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 177D33E2752;
	Thu, 23 Jul 2026 22:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784845149; cv=none; b=RLDasItjVom/FeITQ1QTJc4HErGfIdy59KdgTy+X1vRQInoew2xIA+M4BsAxeWIJ7PtbzbDeFkOUSjo+G0jAaH9AcrA0RhDZetYGa1r+CANOO1d5I8R3ha5crBTXFoeB+LmZ7PqvZWODVb94lGZC4MeDT6AtmbCqyoqtvtF60T8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784845149; c=relaxed/simple;
	bh=q4p9PkPJUM7G3ivMzpi65gXPZa/zknRyU+k4/hfNR60=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=sQrt86Vy9hylDs6uTKn0gSjekI9f0mkspt+AoPSLcqiwNYvLZqPdaoo7yzS8vuBs4WHurT3WwVZ6+au2UVQ2XO+a7buqkCojHXIqbvJlpsPWEUQXwFJRwC8PTWVlmZ1PGWg3NnjK3TuHbmgmTw7WQi1tGjzYKoobpTh1X08VGzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K5OrMIQo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K5OrMIQo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 928EC1F00A3A;
	Thu, 23 Jul 2026 22:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784845147;
	bh=Tyb77pZl1z2IA8w/fvqrQsZu+VbcGMjE5wRb8nhJ3x8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=K5OrMIQojSESc+vjo+cC6VJOm7/TzAbzUqbzM8hFRQ5B3Ir1DIAniq2Yddz+7FMPz
	 b+i8RM5l+BOGNF1oURYdzKnclEsNJPMJ9Mx+FQheH6ZHG9Jhjw6CcUkIpgcm9wkuhE
	 yVwSkBi/enGv1QmotkjstUUn7gyP2rXPL7RvHim7jwEPmkEN5UxUs7P9rS/DMSJgDM
	 NLkJgiUx0bRmZOAIRMJq9vKpedmg5BRGugAxzQ9aZMR+bjItws4r3ERCNjTPXScDub
	 mqVnWdZf1+AKncFzFbugb3rg4DWeglGZ/CE1bchJRLT4+x6f4qs+xDXXKh9zGIESgj
	 TTOx2ktaSG0fw==
Date: Fri, 24 Jul 2026 07:19:02 +0900
From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
To: "Barry K. Nathan" <barryn@pobox.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 patches@lists.linux.dev, Yuan Tan <yuantan098@gmail.com>, Yifan Wu
 <yifanwucs@gmail.com>, Juefei Pu <tomapufckgml@gmail.com>, Zhengchuan Liang
 <zcliangcn@gmail.com>, Xin Liu <bird@lzu.edu.cn>, Huihui Huang
 <hhhuang@smu.edu.sg>, Ren Wei <n05ec@lzu.edu.cn>,
 "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: Re: [PATCH 5.10 137/699] tracing: Prevent out-of-bounds read in
 glob matching
Message-Id: <20260724071902.7469bfe5b1f9bfd3bced2cc0@kernel.org>
In-Reply-To: <3308ea85-4ae5-4c5d-bfba-67bf7164a5d9@pobox.com>
References: <20260721152355.667394603@linuxfoundation.org>
	<20260721152358.800887633@linuxfoundation.org>
	<1d60d21d-ea26-4502-afee-c49c750df1e9@pobox.com>
	<2026072339-reshuffle-blizzard-42e9@gregkh>
	<759ee068-9519-4cfa-9be5-1deb0d9fc877@pobox.com>
	<20260723114247.00a3f66d@gandalf.local.home>
	<3308ea85-4ae5-4c5d-bfba-67bf7164a5d9@pobox.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 23 Jul 2026 09:57:56 -0700
"Barry K. Nathan" <barryn@pobox.com> wrote:

> On 7/23/26 8:42 AM, Steven Rostedt wrote:
> > On Thu, 23 Jul 2026 08:32:23 -0700
> > "Barry K. Nathan" <barryn@pobox.com> wrote:
> > 
> >> In the process of testing, troubleshooting, and eventually bisecting this,
> >> I've tried rebuilding the kernel from scratch maybe 6 or 7 times now. I've
> >> tried on two different build systems so far, and it seems deterministic
> >> that the build succeeds without this patch and fails with it.
> > 
> > When you say "from scatch", do you create a new directory and build there?
> > 
> > Is it reproducible with a "make mrproper"? (Need to copy the .config
> > elsewhere to not lose it)
> > 
> > As I don't see anything in this patch that would cause filp_close to be
> > unresolved. Sounds like a bad object was added somewhere.

Yeah, or BTFIDS command (tools/bpf/resolve_btfids/resolve_btfids) may
be broken?

> 
> When I say "from scratch" I mean something like:
> 
> rm -rf build/linux-5.10.261-rc2
> cp -al linux-5.10.261-rc2 build/

I recommend you to use "O=" option or use git shallow checkout instead of
copying all files.

git init
git remote add origin <url>
git fetch --depth 1 origin <sha1>
git checkout FETCH_HEAD

This ensures you have completely same source tree which is managed by git.

Thank you,

> cd build/linux-5.10.261-rc2
> cp ../../configs/config-5.10.257 .config
> make oldconfig
> make -j#
> 
> (where # is dependent on the hardware of the build system in question)
> 
> I just tried again, doing a "make mrproper" after
> "cd build/linux-5.10.261-rc2", but it didn't make a difference,
> the build still fails.
> 
> (By the way, I tried downloading a fresh 5.10.260 tarball off kernel.org,
> extracting it, and running "diff -ruN" between the new extraction and my
> existing copy of 5.10.260. The diff output was empty.)
> 
> Oh, also, this might be useless information, but if I disable
> CONFIG_64BIT then the build succeeds.
> 
> Anyway, there are several different things I'm going to try. Perhaps in a
> few hours I'll have a somewhat better idea of what's happening, hopefully.
> -- 
> -Barry K. Nathan  <barryn@pobox.com>


-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>
