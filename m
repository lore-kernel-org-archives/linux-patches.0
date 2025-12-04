Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C7D2FC00B;
	Thu,  4 Dec 2025 16:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764866623; cv=none; b=mMX4ydT+3MlC2Bw8TFxOJFL7cHrdz7cZRpWcZVSL0p5hkIKcCg55vTHz1/Ph4o9F+WIj9JZ2TfcTVDQjKDF+BXx/vYUfQkM+0M9QfcbadO8wUTZDz4zXFrYSVQEsZAul0n5KMLxOEQadC6PkXp9hPCQXF5wrH+ANnKvHpRee9uU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764866623; c=relaxed/simple;
	bh=QMKIDQg1PZq9cz8LVq74rzJ6LRDjvQ3Ka9tci70Fqgw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QnW9JfEL5ZVzRKcRHkrLUboPh9PBwYGP6PkC5IW2PWCQxwfKkQiYQMzPk8J0oR1W3tQAHFYOzt7TSg+sttmDNoyYIow5oWIAk3di1wu4RotFLMrTPu5c4LKwXG9iQFsPAZ8sV7gm8npuddic5DexQGJhJ60SbWYXBzv38Zuaw6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lE2uBjeO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lE2uBjeO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CAEEC4CEFB;
	Thu,  4 Dec 2025 16:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764866623;
	bh=QMKIDQg1PZq9cz8LVq74rzJ6LRDjvQ3Ka9tci70Fqgw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lE2uBjeOsMLtjoVxAPJyqwxMZBUpzzKNyy7g/sLgwC12VolNi5ncYsJ3fIxSoQigQ
	 rPGaf3i6pedg89CSCNYHDr7TO/MaMQpTUIhYiM7et9FMsAtTg2y2aORi/DOpupyGhO
	 UeB1fGzKvJ81L4eFEcBnkT5I+y3kVVhemwK620fw=
Date: Thu, 4 Dec 2025 17:43:39 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Barry K. Nathan" <barryn@pobox.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Philipp Hortmann <philipp.g.hortmann@gmail.com>,
	Dominik Karol =?utf-8?Q?Pi=C4=85tkowski?= <dominik.karol.piatkowski@protonmail.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 6.12 114/132] [PATCH v6.12] staging: rtl8712: Remove
 driver using deprecated API wext
Message-ID: <2025120437-ladle-childlike-7f5d@gregkh>
References: <20251203152343.285859633@linuxfoundation.org>
 <20251203152347.516234988@linuxfoundation.org>
 <d1588e38-c109-4784-86bc-a45d370430d7@pobox.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d1588e38-c109-4784-86bc-a45d370430d7@pobox.com>

On Thu, Dec 04, 2025 at 08:31:29AM -0800, Barry K. Nathan wrote:
> On 12/3/25 07:29, Greg Kroah-Hartman wrote:
> > 6.12-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Philipp Hortmann <philipp.g.hortmann@gmail.com>
> > 
> > commit e8785404de06a69d89dcdd1e9a0b6ea42dc6d327 upstream.
> 
> As far as I can tell, this isn't the correct upstream commit. Commit
> e8785404de06a69d89dcdd1e9a0b6ea42dc6d327 upstream is
> "Bluetooth: MGMT: fix crash in set_mesh_sync and set_mesh_complete"
> and I think the actual upstream commit for this patch is
> 41e883c137ebe6eec042658ef750cbb0529f6ca8.

Good catch!  I'll go fix that up in all trees, thanks.

> Once the incorrect upstream commit ID caught my attention, I also noticed
> the following:
> 
> > The longterm kernels will still support this hardware for years.
> 
> The commit messages for the 5.15, 6.1, and 6.6 backports removed this line.
> (I'm mentioning this because I'm guessing the 6.12 backport commit message
> was also supposed to remove it.)
> 
> > Find further discussions in the Link below.
> > 
> > Link: https://lore.kernel.org/linux-staging/a02e3e0b-8a9b-47d5-87cf-2c957a474daa@gmail.com/T/#t
> > Signed-off-by: Philipp Hortmann <philipp.g.hortmann@gmail.com>
> > Tested-by: Dominik Karol Piątkowski <dominik.karol.piatkowski@protonmail.com>
> > Link: https://lore.kernel.org/r/20241020144933.10956-1-philipp.g.hortmann@gmail.com
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > [groeck: Resolved conflicts]
> > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Another link that I believe does a better job of explaining why this driver
> is being removed from LTS kernels, and why now:
> 
> Link: https://lore.kernel.org/stable/20251204021604.GA843400@ax162/T/#t

Good point, I'll go make these changes, thanks!

greg k-h
