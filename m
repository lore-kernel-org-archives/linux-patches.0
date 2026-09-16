Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5870B409103;
	Wed, 16 Sep 2026 19:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789586949; cv=none; b=sp0G53kdpmRaAcYZqFPiXUopZoWt0oQYQepgdTnCcRI17qx4fKihXUHxqw5P7Z25EZ7Oqr7jeCVHlmkCSqD4PqFxE0kSpJoS0PjTa6GswTd1BoCmXvhsC1vU55WJ3Ts+yHggOc+hrUuhL0yY53ZwLMInOtIi3PBJXeQYgM9sOlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789586949; c=relaxed/simple;
	bh=f3+Nwc0ClZxs4XZjo7K6q0R3UI/3OTeGqRK5r6WXvKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O1QUWowzCsUtzcSMdHry4MeLYbMhn88x2t08/aELgIr1zVNbV0mEJNB3wdMhBARr/ZhJDuXtUywkXDV/oAOjZGjw4pAMcViBwbXPhMKzbktqe5J5cHzPEZNfi02+BjXNV18y6DuhELbJo4+LRx+xtGRytoj1/PLtgPeTPxuN7PM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l9rerQIo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l9rerQIo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 761861F0089F;
	Wed, 16 Sep 2026 19:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789586920;
	bh=hvF1VrWKE+GcjeWvB9qffuANz5aN89iJg7z3UO9vj4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l9rerQIoURruo9DgEXWeL+f/6SmswgWmu8LFOrAUHB02Gg642Fqj583euIjy0I7xg
	 jFtOWPxSMOzhAZmrSQxLbCaqPgMjZHtFCBlis0Ic1WcAXfUnb+J2BkXgJKpdC7onup
	 mkXKbaPJ+cFnxqk9D5tn5meQAhVZK+fmjk+jA+E3UW5jzmN+Qh9GrnkCteWCaaO1mt
	 yQkIeiG3GRGE2A+3kp5pnEJX9qvZHcUAVnhyfPGYa5AVD1GuUOyvPjfJSnf3wIARmT
	 b9gtBNwq8vJeDCEsxVKQwan08yIbqd3TcDqxrCPkTPFnWlfDTn2/NrlMn4ZtKgok9x
	 9qiPb+a5lFk7A==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Hao Ge <gehao@kylinos.cn>,
	Suren Baghdasaryan <surenb@google.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 6.12 1374/1376] slab: reset slab->obj_ext when freeing and it is OBJEXTS_ALLOC_FAIL
Date: Wed, 16 Sep 2026 15:28:02 -0400
Message-ID: <daily-reply-20260916-0012-re-slab-obj-ext-dup@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <34a69126-8408-4761-9b38-6ac9041b5b46@oracle.com>
References: <34a69126-8408-4761-9b38-6ac9041b5b46@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> The text is similar, but downstream placed it in the wrong lifecycle
> function: alloc_tagging_slab_free_hook(), not free_slab_obj_exts().

Confirmed. The hunk anchored there because both functions open with the same
two lines, so the apply found matching context in the wrong place.

The duplicate is reverted on 6.12. The correct copy of 86f54f9b6c17 ("slab:
reset slab->obj_ext when freeing and it is OBJEXTS_ALLOC_FAIL") is already in
free_slab_obj_exts() on that tree, so there is nothing to reapply.

-- 
Thanks,
Sasha
