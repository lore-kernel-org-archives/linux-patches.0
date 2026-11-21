Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795274878;
	b=Yxdl6zpt6Z/pzXufVA7JV7xfBi9anGHoo+uHMQ3eURLhhXidE9pFaHJCR+xxRpgy9uQH
	 tLoP3X6SfYW14B8GvQwyBnhks/nUJfM/CABYOl1OpOqUvu/SKKLKn0SEw044vwSVuNkYa
	 p1PYx4r9McRn711SDqRmcCEFNM147NqLQ5nILVkJLLNf4SpviOGtPJvTlC6FTQixFooMO
	 kcfRyBrd5uQ2wivwzry1cBEDnTWlJFln82wkuMTmYpQezWOjGcQH1P7MFgL475h0vY6Tc
	 nxW6lev22twIW0B1p33mLCtwqptDk1oAbU5NAWB7WTqm75OwdsCBokYNoWinE209LBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795274878;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=RoaqfeYj0M3+kMrLAGcYl3dWxuZ9yWry88GvRJVrI3w=;
	b=O68xcTRlXKJfK3HjxpBLja9dKb2PzI+MiIIjaNs+K0wRnuv/A63DlMPpCosFdoCL1CTB
	 IsnD93285h/0YYlPIhx9heKRtSOZpQFbh6egp8FdYv+HfIDn/0GkurII53M6E6vO+VAU4
	 fkXcax4cixTsV4Go2VsT5Is3kKOTpBYJ5Gmw7in6Kupqa/DZY3uLqRycs0x3P4ZqSQkHo
	 s7VDfGbKzVllfKlnhhu9uQGtogsrPwltUCwtzbDXFLC1SXyI6ew8KmT3DHQl9wzQDoM/C
	 N/H4J2430zF1oIcR3yYguGilKFoLp2VkHqYMepKoUqVcxuFe1bVot0iLt42vPE2l4iw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="QIw0jB/H";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DF47606A32C;
	Sat, 21 Nov 2026 15:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QIw0jB/H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 286021F000D2;
	Sat, 21 Nov 2026 15:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795274877;
	bh=RoaqfeYj0M3+kMrLAGcYl3dWxuZ9yWry88GvRJVrI3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QIw0jB/Hv7o9XtOjYQgUtcHL6RkvS2bi0rfklsihwl0720Ncly5XczZMZ+FOcH+vE
	 aPKqaUWrd6/2gktCzXTlvOBRgPFDVHMl0b9xfqynvqPLHSaWTglWXtQFeKj00A4FDf
	 6vtBJ3qZU9HKWdSZi7Y7xc7DtmKRoZKfELpMeboZ/0MmHKGJ+knhXfKkTpgZrH+tpa
	 wVZKKtRbUdauNXzceW0lmMX92z49URw/T8iRiV6t+wxHERByVtvot9OJ2eXecPyKcD
	 fOD9RY08VSn2E17Jk0vhCpid4nVG3PlzLGd+yQg+kxcXxBaINPNmCeBR9tbJN8N/hT
	 p+nZybH/TyAdg==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 5.15 0437/2214] media: streamzap: Add missing rc_unregister_device()
Date: Sat, 21 Nov 2026 10:27:38 -0500
Message-ID: <2026-11-21-1-daily-reply-0010@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <85a50fb0-0bc1-447a-ab03-6565d657f77a@oracle.com>
References: <85a50fb0-0bc1-447a-ab03-6565d657f77a@oracle.com>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> In 5.15, rc_unregister_device() already frees unmanaged devices.
> The driver uses an unmanaged allocation.

[...]

> lets drop this maybe ?

Dropped from 6.1, 5.15 and 5.10, thanks. Those trees lack dccc0c3ddf8f
("media: rc: fix race between unregister and urb/irq callbacks"), so
rc_unregister_device() still frees the device there. 6.6 and newer keep it.

-- 
Thanks,
Sasha
