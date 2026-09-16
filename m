Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 148D2418A55;
	Wed, 16 Sep 2026 19:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789586953; cv=none; b=ppKlYq8IA2o8k+0m7WBB7QFuC9vWIzMSz6f7vqOnM/lzLg0xuVW21B7bWOZaYDwnpQIh13g6aKFbFbGAiAnrbTRLILZ8z791fvOUAjErjU7+f+Ja1z/VOtRugAn5uRDTsmW2WlFBZaY1sBjzQ2GbpE5lRE4CeaXhW7c+lmbWPzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789586953; c=relaxed/simple;
	bh=iqcd9iouVl0nL6/JWNq+gxNzPANNnzubdOQQceSjT1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QBqkEadYEyXV1LDtyTsP5v3Hk3RPV9cEeT5aU35DHvU0YEi6vp7v22M4hXHjk0yWLiNvUtWhsXcP30MYtehwxMGzcD9CUYdrjikOOI21yCnY0ZH66/5qOIHLnLcfzSGBbw1Put1nmMAKiA5X7If1839nVpdlpNM3gLeUUHZZM6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dsv7sNBW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dsv7sNBW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E07991F008BD;
	Wed, 16 Sep 2026 19:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789586935;
	bh=K3RsAqekZ74X6lO/VunQ77l1A/RnVL/PE2oMdyBhwnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dsv7sNBWmmLPQO/U06ul7TThAxn02H9V9fcJpwkNOCE6fsDANzEy7eeTxMuSVeXhB
	 2dmzvriYglBttXQKNe800S9fj6b/Wxl8F7S32Ep9Ok5YtwVLlGaKBZltqn1GvooJbI
	 DDsJSAC2gEW2+zKSF9bn5JFi8Z0Lgw/SgfqutL6LL6ytBFRT2p6KeAENzlzwq6NoBf
	 nzcrSf21WVnIBowMXUAHTbhhRgDJBUugmvAzUkcvxEq2bgyH3jTbNlATKOO0R373fd
	 mNwUDD2yi0MdpGmeb/oJ1PmsODfXVxGOVCJBfoBM6MPwafFHxAJ1bD9eVXj9QKAdpi
	 OvAXu3YNKQehQ==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	syzbot+99d6c66dbbc484f50e1c@syzkaller.appspotmail.com,
	"Jiangong.Han" <jiangong.han@windriver.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 6.12 0191/1376] media: em28xx: fix use-after-free of dev_next->devlist on disconnect
Date: Wed, 16 Sep 2026 15:28:15 -0400
Message-ID: <daily-reply-20260916-0025-re-em28xx-devlist-revert@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <58d2f55d-4194-4e47-98fd-f61d4f4a66b0@oracle.com>
References: <58d2f55d-4194-4e47-98fd-f61d4f4a66b0@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> The new unconditional list_del(&dev->dev_next->devlist) can consequently
> operate on zero next and prev pointers during disconnect, causing a NULL 
> deref ?
>
> Let us revert this ?

The analysis holds, but mainline has the same defect, so a stable only revert
would diverge from it and regress anyone moving to 7.3.

826915b6b65e ("media: em28xx: fix use-after-free of dev_next->devlist on
disconnect") wants an upstream revert with Cc: stable on it, and then it
reaches all seven trees the usual way. Hans, Jiangong, could one of you take
that through linux-media?

-- 
Thanks,
Sasha
