Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BADB12B73;
	Sun, 11 Aug 2024 10:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723373133; cv=none; b=E9VrGT1W/Q0uHB+YdUwpCNgcJ020cI0byC4Jewuebvc1O6Ru1zgu5koNhdyDquFXKQIoyJT+0VtG1BtkhF6feceOAwYwvK+Lw5++GY2NQSwvI1NmhTmRMH6QDy9aD9qF3TcM5MPGbLt6oj2XrKRxzf0pKWkQJybMKvgrvp0p65U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723373133; c=relaxed/simple;
	bh=8C1vTMT0IyfeZnlkHH6FsmR/BI413oTcqaLCM3nykxE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IwAWpGWsjBfAoAlWhOgX+1G09dA++74dPW2ArsOKvyss2nwMpiFTTsbsdl6FRJti9jYspM90Hmlu5XJzOPLfTFnkxIEJX75e1UJ/7Zd1E+z/m8QiAvVVfRyhjgWNDanEzyRaBXKr805YKuqQfk3uAhc/mb/vKuykXHAW2735EDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ttnsJIAR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ttnsJIAR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9307DC32786;
	Sun, 11 Aug 2024 10:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723373133;
	bh=8C1vTMT0IyfeZnlkHH6FsmR/BI413oTcqaLCM3nykxE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ttnsJIARaioM/qf9O9zClLHpO54y13xvEU3rhcK9pGhVqu/Qqkmlq4ZPYsuOApXLo
	 IX8VrxZSgFhb4x8yDQo4vFFac7n6FgVeJuM2XLsMPpJ6LGhgFBckTpp8Teiw7JfFG2
	 K7Oyl+BBdLbLS685teWxIJMR8Di03JX/UDMDE2Fk=
Date: Sun, 11 Aug 2024 12:45:28 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Thomas =?iso-8859-1?Q?Wei=DFschuh?= <linux@weissschuh.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Joel Granados <j.granados@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.6 015/121] sysctl: treewide: drop unused argument
 ctl_table_root::set_ownership(table)
Message-ID: <2024081152-retriever-reword-e74a@gregkh>
References: <20240807150019.412911622@linuxfoundation.org>
 <20240807150019.868023928@linuxfoundation.org>
 <0352ae40-ba3e-4d27-84c6-19926a787c33@t-8ch.de>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0352ae40-ba3e-4d27-84c6-19926a787c33@t-8ch.de>

On Wed, Aug 07, 2024 at 06:38:13PM +0200, Thomas Weißschuh wrote:
> Hi Greg,
> 
> On 2024-08-07 16:59:07+0000, Greg Kroah-Hartman wrote:
> > 6.6-stable review patch.  If anyone has any objections, please let me know.
> 
> I don't think this has any value being backported to any version.

Did you miss this line:

> > Stable-dep-of: 98ca62ba9e2b ("sysctl: always initialize i_uid/i_gid")

thanks,

greg k-h
