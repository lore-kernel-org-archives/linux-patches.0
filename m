Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA61B379C4E
	for <patches@lists.linux.dev>; Sat,  8 Aug 2026 22:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786227780; cv=none; b=uPzqb84NtW3KHlm6NC/xY7k/9fLRwSmHw+VQJphfxcxnBOip6/4/Ue/tVgg8M+hlX9opsJD1ROyw5BZy9ZfWHcZbOiHkmEQmubF8ny9j7zEPQ8RY+hR78CQwuBfG2Q/dOO1O2UFFuKq79fhjVvzKWku1motWsbjN+5h35mVBFt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786227780; c=relaxed/simple;
	bh=lQpQYwkOvVwrgYs9az8mhZJeBerJ5y3FVv5cE6d3WEA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ud+ghmkJ1gcnCw0yhB3SUJ/yg/snNlRxwxBjw4IsDs8C1sbWGMdG5E1BgVlWLxFqCm9zAlKapVulfa2iu3ku002y3nupGdalo/6fS2sk1kto2h195Y8o4lgsJjc6plt5lxKu5Upu86dJJgC3LbqsNvxE897kGMjcACaw3V26EIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 92E301A0460;
	Sat,  8 Aug 2026 22:22:50 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf01.hostedemail.com (Postfix) with ESMTPA id A76126000C;
	Sat,  8 Aug 2026 22:22:48 +0000 (UTC)
Date: Sat, 8 Aug 2026 18:22:47 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 patches@lists.linux.dev, "Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
 Sasha Levin <sashal@kernel.org>, vegard.nossum@oracle.com
Subject: Re: [PATCH 6.12 117/337] tracing/mmiotrace: Add NULL check for
 mmio_trace_array in logging functions
Message-ID: <20260808182247.39dc80fc@robin>
In-Reply-To: <e4f43ad5-7f15-49bb-97b4-3035220261b8@oracle.com>
References: <20260807143418.516897842@linuxfoundation.org>
	<20260807143421.067366429@linuxfoundation.org>
	<e4f43ad5-7f15-49bb-97b4-3035220261b8@oracle.com>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A76126000C
X-Stat-Signature: y58tmj3emswfysibbx5fajworgkrgscs
X-Rspamd-Server: rspamout03
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19uVgCvDKBXhgXpCk74tNgA1LOKlSXpCG8=
X-HE-Tag: 1786227768-843444
X-HE-Meta: U2FsdGVkX1/BnnlPW2BlXgw76iE5QR6Jlg6f/6SHJ+QYF/aOvp0B2NOJX3QgV2VeOE8w8aJhTUfh6OUJVHLfgX0wEyQttZgh52Z5AS9PV03+0mvQEdvXRSXKNoPA9ZcZUIGCKKZENXenHGZyZsm9QtzSz5w7KIyRAf+kHJQqJJJBdyU7r7tofaPgsxN6cfdhxHzlKBpfZMh+OtiF60imLtm4lXO0Muh21m9dLkiM0mYQVm+1HnZzfgezH0HUbRHSg4FZb6c6s331IsqHRfn/aL5JNHa21BCEemiOPDAGm7RqzW3r+pN+SQlak1Mgbb0sAxeF7TMCoYdk4zXNNRoADNJZGiQencGu

On Sat, 8 Aug 2026 22:53:31 +0530
Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com> wrote:

> I ran an AI-assisted backport review and then checked the 6.12.y code. I
> think this backport is missing a small prerequisite.
> 
> Upstream's wrappers pass tr directly to __trace_mmiotrace_rw() and
> __trace_mmiotrace_map().Each function checks tr before dereferencing it:
> 
> if (!tr)
> 	return;
> buffer = tr->array_buffer.buffer;
> 
> 
> The upstream fix follows commit: 6936298393d8 ("tracing/mmiotrace: 
> Remove reference to unused per CPU data pointer"), which removes the 
> unused data argument.
> 
> 6.12.y does not have that commit, so both functions still have that 
> argument and their wrappers compute it first:
> 
> struct trace_array *tr = mmio_trace_array;
> struct trace_array_cpu *data =
> 	per_cpu_ptr(tr->array_buffer.data, smp_processor_id());
> __trace_mmiotrace_rw(tr, data, rw);
> 
> 
> Consequently, if mmio_trace_array is NULL, the dereference in
> per_cpu_ptr(tr->array_buffer.data, ...) occurs before either function's 
> new NULL check.
> 
> I think 6.12.y needs commit: 6936298393d8 ("tracing/mmiotrace: Remove
> reference to unused per CPU data pointer") before this fix.
> 
> Thoughts?
> 

Yeah, it looks like the kernel could crash for the same reasons without
commit 6936298393d8.

Greg, care to backport that one too?

Thanks,

-- Steve
