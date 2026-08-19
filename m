Received: from mta1.migadu.com (out-69.mta1.migadu.com [95.215.58.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDE23274641
	for <patches@lists.linux.dev>; Wed, 19 Aug 2026 04:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787114991; cv=none; b=jYNptujgxUVWWOOkklYENaUjT7F9Nbh+nXMv4O/YD6g5wAGLHDAROZnQY3hbROqTcl2ibmQxkXoYk1S7u2AkyH76ncdxvuAKFRYiVdOd8fesZGUvS2v4+u1/wRu3hQPB6ywMCxzyuva00qpImi7kPUWJsAIb43fIrP0rXx0LYD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787114991; c=relaxed/simple;
	bh=vK1GcmrCM2HBb97Fmyp4VUN3T6osFaaIJirq/q1oYnc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YvTrTOMwCI/ixz4fQ2y/RxUHPFPdBWgy/tk7nN/Yw3F53KzxcydALWeOnvkNNpygEk0Zyuywbwz2/XnA7wCeLQky2kNi8D0Ncv/JKP1hT/140SlDSu6BHRs/Tnm4JUG/V+TDD2Xi2JuWYnl/7T97n4vZys626KFAvElf2VKQoqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=HnxePEOV; arc=none smtp.client-ip=95.215.58.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="HnxePEOV"
X-Envelope-To: patches@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=vK1GcmrCM2HBb97Fmyp4VUN3T6osFaaIJirq/q1oYnc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787114984; v=1; x=1787719784;
 b=HnxePEOV2C150FVIoS+/Q4TBFhqju3b2Uu6s2beaV5N1m2UyIAn7grnkV1hjlh9axW673YdI
 2Jh3NTyOkxKTRYHFSaS+DUGnFNIiMIJff3KfD6x4VQ6M6I3S9DZliCwvu17nwdLNAE7vy5sC6+J
 yo/KkKMii26TnDRjwEspj+KI=
X-Envelope-To: patches@lists.linux.dev
Received: from linux.dev (52.89.24.131)
	by smtp.migadu.com with ESMTPS id 30761f6d58e5e484;
	Wed, 19 Aug 2026 04:49:44 +0000
X-Migadu-Flow: FLOW_OUT
Date: Wed, 19 Aug 2026 04:49:37 +0000
From: "Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>, 
	patches@lists.linux.dev
Subject: Re: [PATCH 6.18 227/250] eventfs: Use children field for rcu head
 and add memory barriers
Message-ID: <aoU1on2mnwB4pSGa@linux.dev>
References: <20260817132536.466235697@linuxfoundation.org>
 <20260817132545.791907087@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260817132545.791907087@linuxfoundation.org>

Hi Greg,

Harshit's report on the 6.12 copy of this patch applies to 6.18 as
well:

  https://lore.kernel.org/stable/24644fdf-54f1-470c-9183-8f5c420c760f@oracle.com/

6.18.y also lacks 4d9b262031ff ("eventfs: Simplify code using
guard()s"), so the new direct return leaks the SRCU read lock. The same
fixup works here. Lockdep confirms the leak on 6.18.44 with the two
eventfs patches applied, and is quiet with the fixup. This one is also
from AI-assisted review, which I checked.

6.6 needs the same fixup too. 7.1 has 4d9b262031ff, so it is fine.

Thanks,
Jose
