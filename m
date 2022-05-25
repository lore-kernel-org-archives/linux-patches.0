Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1533CEC4
	for <patches@lists.linux.dev>; Wed, 25 May 2022 14:05:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F9D1C385B8;
	Wed, 25 May 2022 14:05:28 +0000 (UTC)
Date: Wed, 25 May 2022 10:05:26 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Jakub =?UTF-8?B?TWF0xJtuYQ==?= <matenajakub@gmail.com>
Cc: linux-mm@kvack.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, vbabka@suse.cz, mhocko@kernel.org,
 mgorman@techsingularity.net, willy@infradead.org, liam.howlett@oracle.com,
 hughd@google.com, kirill@shutemov.name, riel@surriel.com,
 peterz@infradead.org, david@redhat.com
Subject: Re: [RFC PATCH v3 6/6] [PATCH 6/6] mm: add tracing for VMA merges
Message-ID: <20220525100526.2a7a0eb7@gandalf.local.home>
In-Reply-To: <20220516125405.1675-7-matenajakub@gmail.com>
References: <20220516125405.1675-1-matenajakub@gmail.com>
	<20220516125405.1675-7-matenajakub@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 16 May 2022 14:54:05 +0200
Jakub Mat=C4=9Bna <matenajakub@gmail.com> wrote:

> +	TP_fast_assign(
> +		__entry->merged =3D merged =3D=3D 0;
> +		__entry->predecessor_different_av =3D merge_prev;
> +		__entry->successor_different_av =3D merge_next;
> +		__entry->predecessor_with_successor_different_av =3D merge_both;


> +		__entry->same_count =3D (merge_prev =3D=3D AV_MERGE_SAME) +
> +			(merge_next =3D=3D AV_MERGE_SAME) +
> +			(merge_both =3D=3D AV_MERGE_SAME);
> +		__entry->diff_count =3D (merge_prev =3D=3D AV_MERGE_DIFFERENT) +
> +			(merge_next =3D=3D AV_MERGE_DIFFERENT) +
> +			(merge_both =3D=3D AV_MERGE_DIFFERENT);
> +		__entry->failed_count =3D (merge_prev =3D=3D AV_MERGE_FAILED) +
> +			(merge_next =3D=3D AV_MERGE_FAILED) +
> +			(merge_both =3D=3D AV_MERGE_FAILED);

The above looks like it can be moved into the TP_printk(), as you have the
merge_prev, next and both saved already. Why waste more ring buffer space
and execution time for information that can be derived at the time of
reading the trace event?

-- Steve


> +	),
> +
> +	TP_printk("merged=3D%d predecessor=3D%s successor=3D%s predecessor_with=
_successor=3D%s same_count=3D%d diff_count=3D%d failed_count=3D%d",
> +		__entry->merged,
> +		__print_symbolic(__entry->predecessor_different_av, AV_MERGE_TYPES),
> +		__print_symbolic(__entry->successor_different_av, AV_MERGE_TYPES),
> +		__print_symbolic(__entry->predecessor_with_successor_different_av, AV_=
MERGE_TYPES),
> +		__entry->same_count, __entry->diff_count, __entry->failed_count)
> +
> +);
> +
