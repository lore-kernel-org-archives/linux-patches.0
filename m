Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1029A240234;
	Mon, 13 Jan 2025 15:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736781348; cv=none; b=e+BXtQdXumN54gwPs1siRDeERc1izlA5wL6DVEY4JIfspSZ2GvvHk1jBzAjnP+F3ibpc9H2bXHBBXIoWbSOa6KA3qdMm89BKXFTqJmQ6ORME+eIj3vdIKizLu0vN6GfbWrzA5/CxHP8Cyxgavq8PWYhaMc2wCxtMPg7IcWSXWIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736781348; c=relaxed/simple;
	bh=tOsr0u6YI6rJI+UIEQnPUVOnfKu2wPIvBt2tMwFgtQQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XtnmSIQDSUWdJcpHxd7bJBU8nMX5SxJAw9nrHYjEz3+RJsLf35C1Z2uaSbbVYusdd7qOT7XTtmaTAjypuf5XDWc9gorMjUgk/bVBt4sIkQRMPlFwhr/9l/hbXyTfOlcsuoBdt/XP1t7Y5ryOKcnwhaHIhjFnfXd8avSrhPZxqq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1FE2C4CED6;
	Mon, 13 Jan 2025 15:15:45 +0000 (UTC)
Date: Mon, 13 Jan 2025 10:15:44 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Jani Nikula <jani.nikula@intel.com>
Cc: Neal Gompa <neal@gompa.dev>, Miguel Ojeda <ojeda@kernel.org>, Jonathan
 Corbet <corbet@lwn.net>, workflows@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev, Sami Tolvanen <samitolvanen@google.com>, Masahiro
 Yamada <masahiroy@kernel.org>, Luis Chamberlain <mcgrof@kernel.org>,
 tech-board@groups.linuxfoundation.org, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, Linus Torvalds
 <torvalds@linux-foundation.org>, Shuah Khan <skhan@linuxfoundation.org>,
 Dan Williams <dan.j.williams@intel.com>, "Darrick J. Wong"
 <djwong@kernel.org>
Subject: Re: [PATCH 2/3] docs: submitting-patches: clarify difference
 between Acked-by and Reviewed-by
Message-ID: <20250113101544.527e157f@gandalf.local.home>
In-Reply-To: <87ikqij3dj.fsf@intel.com>
References: <20250112152946.761150-1-ojeda@kernel.org>
	<20250112152946.761150-3-ojeda@kernel.org>
	<CAEg-Je81VAYecajUjYVJKBJUT+YqKemWsWEoWFgOcF=vtfPRPw@mail.gmail.com>
	<87ikqij3dj.fsf@intel.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 13 Jan 2025 14:38:00 +0200
Jani Nikula <jani.nikula@intel.com> wrote:

> As a maintainer, I mostly use Acked-by for two slightly different cases:
> 
> 1) I've seen the patch. I have no objections to it being merged, I
>    approve of it. I haven't done a detailed review of it. Additionally,
>    I may indicate whether a detailed review (by someone else) is
>    required, or whether I think the ack is sufficient for merging.
> 
> 2) I'm fine with the patch to the area I maintain being merged via some
>    other maintainers' repositories. I may or may not have also given my
>    Reviewed-by in this case, which alone is not an approval to merge via
>    other trees.

Interesting. When I give a Reviewed-by: to a patch, I am most definitely
letting it be merged into other trees. For anything I pull in, I don't add
a Reviewed-by and will strip any tag that says I did review it as my
Signed-off-by includes that I reviewed the patch.

The difference I give between Acked-by and Reviewed-by is that my Acked-by
is "I don't see anything wrong with the idea of the change, and it can go
via another tree", where as a Reviewed-by is "I took time to understand the
change itself, and have not found anything wrong with it".

Basically, an Acked-by is "I took a quick look, and I'm OK with it, but if
it breaks something of mine, I expect you to fix it." and Reviewed-by is "I
took a deeper look, and if it breaks something of mine, I hold myself at
fault, and will fix it myself". ;-)

-- Steve

