Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FCE033CC
	for <patches@lists.linux.dev>; Thu, 16 Mar 2023 13:57:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0301CC4339B;
	Thu, 16 Mar 2023 13:57:49 +0000 (UTC)
Date: Thu, 16 Mar 2023 09:57:48 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Mukesh Ojha <quic_mojha@quicinc.com>, Masami Hiramatsu
 <mhiramat@kernel.org>, Ingo Molnar <mingo@elte.hu>,
 linux-trace-kernel@vger.kernel.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev, Mike Rapoport <mike.rapoport@gmail.com>
Subject: Re: [PATCH] ring-buffer: remove obsolete comment for
 free_buffer_page()
Message-ID: <20230316095748.0b93bfc5@gandalf.local.home>
In-Reply-To: <c5d9c8b4-663c-c00f-438b-f104e1228ef7@suse.cz>
References: <20230315142446.27040-1-vbabka@suse.cz>
	<72de48c7-014d-80ac-51e9-ba22450f1d5b@quicinc.com>
	<1cb12058-f59e-1433-6ba6-f500be250996@quicinc.com>
	<c5d9c8b4-663c-c00f-438b-f104e1228ef7@suse.cz>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 16 Mar 2023 09:29:30 +0100
Vlastimil Babka <vbabka@suse.cz> wrote:

> On 3/15/23 16:53, Mukesh Ojha wrote:
> > 
> > 
> > On 3/15/2023 9:21 PM, Mukesh Ojha wrote:  
> >> 
> >> 
> >> On 3/15/2023 7:54 PM, Vlastimil Babka wrote:  
> >>> The comment refers to mm/slob.o which is being removed. It comes from  
> > 
> > nit: mm/slob.c  
> 
> Thanks, Steven can you fix that up while picking the patch, or need v2?

I'll fix it up.

-- Steve
