Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 070552066DE;
	Sun, 19 Oct 2025 12:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760875522; cv=none; b=SCO0eHkmV9n6uATEtRrB0x7PKomKonhuM76t3UKVZCSC3bet0FoRRXXr0tCxqhzg2OHZJws8pJ+2WzcQcYbd7rYwJJZ3PkBWp9vCYsjCupuVhEevRIAwtN5lCxJM3na+f7ZXak4yq8YVp8xVHzR5K5DIB3Kf2DyREZR/24/Cjz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760875522; c=relaxed/simple;
	bh=fxBWX9RealHrVvF/cKYRG6ekOm40LsemzdSSOnLjHb0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gufrMp6ywGb/S5R5Php2uOCIczg4M8IoqfqrmJzfBulzBH0080N2iA99cw7oIhlrLybX1df7n9Ck8XFuLiLwQM1wM9Mw8zbX9o1fdPcRu+BQBb2Fta4ZdhK79akt+fej7H5MB/3OZgbJo0o006nhVgTqfLw+33eROJCIfROVb9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZJDiuqM6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZJDiuqM6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03EAFC4CEE7;
	Sun, 19 Oct 2025 12:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760875520;
	bh=fxBWX9RealHrVvF/cKYRG6ekOm40LsemzdSSOnLjHb0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZJDiuqM6WwUEzPusQ58NOWBUnaHr9/nrDSz4NQEfinJR94WZvB+B8PqoT/wAnxBA5
	 mx86MngunwDSBwz1cSXY2qLfAskMQ1XSGRqXoNWzzBIYcNOPpgVBDvHcsy7UCJyL16
	 C0cqUR+ouxg0H075m4EFdd3RS5UGEFWQaZ+KczCw=
Date: Sun, 19 Oct 2025 14:05:17 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	=?utf-8?B?6auY57+U?= <gaoxiang17@xiaomi.com>
Subject: Re: [PATCH 6.1 163/168] pid: make __task_pid_nr_ns(ns => NULL) safe
 for zombie callers
Message-ID: <2025101904-fantasy-creamlike-a8f0@gregkh>
References: <20251017145129.000176255@linuxfoundation.org>
 <20251017145135.053471068@linuxfoundation.org>
 <20251017153126.GD21102@redhat.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251017153126.GD21102@redhat.com>

On Fri, Oct 17, 2025 at 05:31:26PM +0200, Oleg Nesterov wrote:
> On 10/17, Greg Kroah-Hartman wrote:
> >
> > 6.1-stable review patch.  If anyone has any objections, please let me know.
> 
> Well, I don't think this is a -stable material...
> 
> This patch tried to make the usage of __task_pid_nr_ns() more simple/safe,
> but I don't think we have the problematic users right now.
> 
> And please see
> 
> 	[PATCH 1/2] Revert "pid: make __task_pid_nr_ns(ns => NULL) safe for zombie callers"
> 	https://lore.kernel.org/all/20251015123613.GA9456@redhat.com/
> 
> because we have another commit 006568ab4c5c ("pid: Add a judgment for ns null in pid_nr_ns").
> Which too (imo) is not for -stable. The panic fixed by this patch was caused
> by the out-of-tree and buggy code.

Thanks for letting me know, I'll go drop this patch from all stable
queues now.

greg k-h
