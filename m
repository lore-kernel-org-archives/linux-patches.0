Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA2D614B950;
	Thu, 15 Oct 2026 00:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792022932; cv=none; b=astEW0y75m355LKMDb3WbdSM92uvY1+OgsyZK+/ESDXVXf/1nSMhm8NJUNhzJOE9Rq0og1NksPzBnNVrQuzys4M8AO+f1fdpKG3v48gcTd/AckqEEVKgkr1lzLLhXnSYcx4xSo2VR5H4JXD55UdqnpoTXWioD8yE1Tl1vi5pBL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792022932; c=relaxed/simple;
	bh=D+1JdJ65mO43MX4wgVJKEXSM7YSU6IaWM5TNSm5uKWo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VlOZ24NjnApDftH84POoOWNPifUBsdyBDcxSsv8wmiNlGirRgO3QAAo7lh2l+9S1trweks6SmDQYecn06iFyAhEKUOMJJVydcnbRIHBfzsFzdsR7JdxKJFG7kRcgo08sZs1N1KzWmjSSY/zSMehiylOqI6bOCjTiKuePWXkVDt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YTnAt9G/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YTnAt9G/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 836F01F000C4;
	Thu, 15 Oct 2026 00:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792022931;
	bh=nUWIDfP6T6F3jy8XVD643J3S/drFOfmyoN4fEr5aUUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YTnAt9G/7IrIe7i3T7A+QeNBDDz0C4/1rQ09rhFUFBtHjOKVAW3ZjdEbmSedC4KkR
	 87WV7ZB7B4oagR1qanGAjUk8DTPXwe7EuxbAAwN+oP2QPq0cNKanXExUM/ZVhGGG8r
	 1WgiAjvSBy551UxHAvQu7305MNPv5FGAZ+rCgZm0dOQK/AVw8uJyVpdiAAwevXPYah
	 YLXkSfUbclBy7IhRJ1PQhZ59/6jAPCzMM5l1sKbWhG2ytIxMzJ3aM0UmWuGyHx1+cr
	 1nv8Wlax2Bi52L/lpVSYgWe/M8YmSGZoavmEUD5e8iHUDG1jyE8NJKBGmX60aNVsBK
	 JMVDDksu3vF/w==
From: Sasha Levin <sashal@kernel.org>
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: Sasha Levin <sashal@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH 6.12 264/497] net: phy: aquantia: fix system interface type not updated in forced mode
Date: Wed, 14 Oct 2026 20:08:39 -0400
Message-ID: <a0c5c3bc7c9c4c59b3ddaec6@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <bb8ea4fa-7edc-4eaa-9ca6-e0b3eb729295@oracle.com>
References: <20261013112907.864180619@linuxfoundation.org> <20261013112914.157376699@linuxfoundation.org> <bb8ea4fa-7edc-4eaa-9ca6-e0b3eb729295@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> 7e5b547cac7a ("net: phy: aquantia: poll status register") supplies the
> upstream protection. Should we backport that first ?

Dropped from the 6.12, 6.6, 6.1, 5.15 and 5.10 queues, since 7e5b547cac7a is
missing there. It can come back together with 7e5b547cac7a.

-- 
Thanks,
Sasha
