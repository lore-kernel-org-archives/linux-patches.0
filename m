Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DA42380FD4;
	Mon, 18 May 2026 19:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779132065; cv=none; b=M0G/BlYljzAfjdhU4p2ZU6YdPKEuepT0o59DAyDxCwfAGVP17GwGNokX62XpgfwSNU8g3una9Rno+3JaU4tzIIiYG/td6Fre6FrCyESogliIRVUZVtsxcKtbUqraMaC3yHvskx3ZCG24/ZRafID8N+1dJNqjDap06teT9/sgm0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779132065; c=relaxed/simple;
	bh=ciSdeKCzLdxyYARH7TYEGoLvETwf+T+4txP93ZYtwUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uDzS7JUGJsraXqI23G5kLZLWjdemHWqQkYJBb/FZIFjq1zQ91wBlaBNd5+jGFseIxyiMP0H9iaSwTGyh856FIIeN/heIhg/QNBEJcITW+ymk74R1qF5+pLbxCMX9dPbQWJQajsLbXe9w/iGQ14CplOAj+a+c369IuispE3bf5mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BgiOHrJN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BgiOHrJN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44067C2BCC6;
	Mon, 18 May 2026 19:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779132065;
	bh=ciSdeKCzLdxyYARH7TYEGoLvETwf+T+4txP93ZYtwUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BgiOHrJN98Tm48F67rAlwOjs+jgjvh2FjhagoHPhZN912HRKgclE3FLdtX60xo0f8
	 762Z2RcWq5nlME4k7qq5xsh1d1TyTeNb8TfjcjlMyQQ+MfnElIdkZ38rnyQE0W/EoX
	 q6sFUyTiAbCOWtn2SrSrdAjq5yUZXXDIIVcOWxy5C4TM8y/JqLJYkptGrpgzmC4uKH
	 AzNS0WA+EFQ9cDddYrvKhq8QmTnW4qaDjJM7zEcriilFZbK4EZCunf16LuDNZqoxq+
	 9qtFPTCn/JoxW9IPw7USfgBn+8Ahfs2mGBYEg7aWe3i8RKElbZRYuiw74KUnLQ8/BG
	 oHaXqUa6L/j8Q==
From: Sasha Levin <sashal@kernel.org>
To: gregkh@linuxfoundation.org
Cc: Sasha Levin <sashal@kernel.org>,
	brauner@kernel.org,
	patches@lists.linux.dev,
	stable@vger.kernel.org,
	kernel@gentoo.org,
	dist-kernel@gentoo.org,
	Sam James <sam@gentoo.org>
Subject: Re: [PATCH 6.18 160/188] papr-hvpipe: convert papr_hvpipe_dev_create_handle() to FD_PREPARE()
Date: Mon, 18 May 2026 15:20:51 -0400
Message-ID: <20260518155236.reply-0002@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <87cxyuq6oa.fsf@gentoo.org>
References: <87cxyuq6oa.fsf@gentoo.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sun, May 17, 2026, Sam James wrote:
> FD_PREPARE doesn't exist in 6.18, it's from:
>
> commit 011703a9acd76edc7c85d80dbccb6e50dba53aad
> Author:     Christian Brauner <brauner@kernel.org>
>     file: add FD_{ADD,PREPARE}()

Thanks Sam. Backporting the FD_PREPARE/fd_publish primitives to 6.18 is
too invasive for stable, so I've reverted both papr-hvpipe commits from
pending-6.18:

  - 09c15bbbed533 ("papr-hvpipe: convert papr_hvpipe_dev_create_handle()
    to FD_PREPARE()")
  - 6542e180fa6e1 ("pseries/papr-hvpipe: Fix race with interrupt handler")

The race fix can be reworked later without depending on FD_PREPARE if
the maintainers want it in 6.18.

--
Thanks,
Sasha
