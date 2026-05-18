Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5329238F65F;
	Mon, 18 May 2026 19:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779132078; cv=none; b=HK7LQXR4SsITS2shjkXirUQctPH5AQKiRKiG6h36avm02WUx1e2NI+ilSTuVEa0EQu2lhGQQaulJeFmlJAJnNtHW+3Gr9l/PyeKfVtKRDPwqR/TT+A6lUVbgOnxB3Ff5aDlYqD/tsvu3oXJJOWtYcfUgH03Z8n9wa9KzHstnr20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779132078; c=relaxed/simple;
	bh=aQU4RQ6ZR1rOLLvgv665SBEu8mh+LEtOS4apP7bMXaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=stpHlHM7xiWqvvBq35XOchK9El8lt336XWFVgIshYtfWjeOriz3026Pmh6jTzPILMH32wWvSXeteV0xFVyrvhtJ3uiqtSdBcQXUuM1MGBmhTPiK+fjwkevJ7z70+1c+1orLcd2+5xaHj2YJQtd7fe0mmDGZ8s4TdcnO7sbb4JTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T7DSAIAY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T7DSAIAY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24193C2BCB7;
	Mon, 18 May 2026 19:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779132076;
	bh=aQU4RQ6ZR1rOLLvgv665SBEu8mh+LEtOS4apP7bMXaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T7DSAIAYpNrQKURFUAZAnegtSOgTRT206Tlc8qMFLkcRxzMrvqIJdkWnoQekwVD18
	 AgdjflXjp0AmVIqmGruQrJVxDfj8wz5qwmCmrE6Abd1W/dBKu4Hx4kL3RyDp23/j7m
	 IVDjYjN1HrdQ1m7eozdmgewEUAkaFSCU7onMFKnqz8v8WqvvptWRIoeNbq63k5u0j4
	 3XDmrhcHxwNRjHkEK+pmCwFQ7KtfHdmqJc0iHTeyBHTQu3bkbTYlkJOBwIM/QbS7Bp
	 rrvymjbhiAWVDONB0l8MIgzVBCYw4ODs++4uacZIeZLfBwzFg3HnDoTCtwHSJBKc7Z
	 KrZu2k7nxTErg==
From: Sasha Levin <sashal@kernel.org>
To: gregkh@linuxfoundation.org,
	stable@vger.kernel.org,
	viro@zeniv.linux.org.uk
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	almaz.alexandrovich@paragon-software.com,
	ntfs3@lists.linux.dev,
	Li hongliang <1468888505@139.com>
Subject: Re: [PATCH 6.12.y] ntfs: ->d_compare() must not block
Date: Mon, 18 May 2026 15:20:59 -0400
Message-ID: <20260518155236.reply-0010@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260518042130.489507-1-1468888505@139.com>
References: <20260518042130.489507-1-1468888505@139.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sun, May 17, 2026, Li hongliang wrote:
> From: Al Viro <viro@zeniv.linux.org.uk>
>
> [ Upstream commit ca2a04e84af79596e5cd9cfe697d5122ec39c8ce ]

Queued for 6.12, thanks.

--
Thanks,
Sasha
