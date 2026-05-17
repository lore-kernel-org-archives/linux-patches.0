Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66DC336F42B;
	Sun, 17 May 2026 13:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779024795; cv=none; b=JBdhy208ckxaynqrKTsArxOg7lr8sthd/DVNMECoeSbilSOSqlj64Xc8TW/WvNgIYtR0W24lwNr/U1w670YM/rFZMu0CHgigLx2g730V7nzyK5UTbMr8OIEq9OYLXlIUl7VP6asmZjibN1cUX846U2/mf82qE4Yg91NkZVhANUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779024795; c=relaxed/simple;
	bh=IdinB7sTl6FdyjpnyNarYNQYP0c3VL4anWA+C6BTDKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bunMOVoRvZ2JND5/SY/Y+W7mjOyXziR0eh8D8zbH+RbJU985tPG9RT5r0cdJLLpYG+oi0b5YSGr0z4dN2QIhYom3Qm6WKdbQaRd8xEQAr1VRi80Az2RRsnr4SqQwuy9tdbEnAC6McOHiy3t45hsAozaUtHR7Bulf9+hbQVEItkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kTmRStPs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kTmRStPs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C48CC2BCF5;
	Sun, 17 May 2026 13:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779024795;
	bh=IdinB7sTl6FdyjpnyNarYNQYP0c3VL4anWA+C6BTDKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kTmRStPssQPEDsXzEgsXWS2E7fKbaBSG28LO5m7Bq2PI1MrFseOLmn4FZBdJH4p9x
	 ijEx14JCRqnkZwLdO14NMKjmkZ71QP7KRBoz8lE2TvJSDCZPFIjN16CBIqjFlTvu67
	 sOvC/wZv7H9tteYxl41cS958xVMbhZM/lP3OosaLVm3sNu8adhsSK+9pxhioEo/wvH
	 xyU2rRgLzflNW2GVupCwxR6lSLIwQuwdlPJgdDVHkoaVxJ2rRSnzKr9c/1Wku7yP2g
	 YzYH4jZLB75f8PSI6OAiPmz2RxfehQKvFmsJJeMLLYK3vnkcHRkwObOPnqwlSD6sbt
	 YvN01xNylXxRg==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	Jacopo Mondi <jacopo.mondi@ideasonboard.com>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Daniel Scally <dan.scally@ideasonboard.com>,
	=?UTF-8?q?Barnab=C3=A1s=20P=C5=91cze?= <barnabas.pocze@ideasonboard.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: Re: [PATCH 7.0 016/201] media: mali-c55: Fix wrong comment of ISP block types
Date: Sun, 17 May 2026 09:33:07 -0400
Message-ID: <20260516170159.mali-c55-comment-drop@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <agdO8lvv9vj9_1n8@zed>
References: <20260515154658.538039039@linuxfoundation.org> <20260515154658.887165119@linuxfoundation.org> <agdO8lvv9vj9_1n8@zed>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> I know this is borderline for stable, however it's in a uAPI header
> so I considered it worth adding stable to the cc list.
>
> If you don't think it's necessary, feel free to drop the patch.

Dropped from the 7.0 queue, thanks.

--
Thanks,
Sasha
