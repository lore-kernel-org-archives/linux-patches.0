Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061053;
	b=hBu16M/zyixwPFs15iq8AYQaZw23gWIAKCoCPlgNZkS6BMST1gl7+r7niaOw5L5tRwhs
	 ojeWsEUBLsvqt4l2yVS+dI+bblEoerbgJN3sraq7OMb3BcR7PAoyRqgozQzyYxMaZ5/pH
	 fFjgkP2NTU3dzP3za42iCqHJRvlmOxnn1Bz4kE3KjZE21wh+/49ZpfZcA1pLmnwFzu6Wi
	 intgW2JHakpGDvj3sVRRkpXj9yPO/mVfTP8Rx7VpyTNPpvjPBggTx4FSzqXruOeiD7lV6
	 KPpJlmCtsTrKibySRjrAJ4n66zWNslly7hS7dOM2f9g7DS5ztLEwGkXy/c7l4uWtZIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061053;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LrharG9EV727QoTMnYsXj8G1kd9uRiiWgzMEdt1fudQ=;
	b=cWKND5rtwDm04Nu6aeRlT40cvh3W5WYH0WJnHnmiZtdSKmvTgnuIjwEQZnbhz8g8TgQx
	 GoAg+EpgFttcEGBTOee9jw/rp44okN5FLXdHBOlQIYiPVHjl+h3peXLrguYXCCa9dgVsK
	 l/lyS9D0swmH3c9GOPnrz9HR63UnCrKUFud9VhApsPM4REaezEavBEshAdfAB1sxSkqv2
	 QX5KTHi/j7ptRRgpyfHFvYRL6LfOqjivaHg3KqbRzM+E/7u2RG+HMQlJmpzkqWtkdFxOY
	 xGmKHpbpc2cFtu4gpyJoAArkGpBuNzd8eXucYmz3OfclU3E/sK6cAsYldzcErQLxWnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AjjLTA9H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FE01606A339;
	Sat,  7 Nov 2026 14:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AjjLTA9H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D6D41F0089F;
	Sat,  7 Nov 2026 14:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061052;
	bh=LrharG9EV727QoTMnYsXj8G1kd9uRiiWgzMEdt1fudQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AjjLTA9HHCmTj3v+3XfpKLkVRpyQXabXw/VOn200c9ANcGTOtuuf+hDEoagqYPz4Q
	 031d7XM85ypuEmoU1KB7LGKZ6JN/TqBfe9MTjjsbOiV6aSUFvcNkfFo6SjbAjO1kPP
	 6Z2gqcJSp93SUtwyAqZ02LNh2IqQ601M7mx3+o4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jenson Johnathon Reggentin <mail@jregg.de>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0384/1536] docs: block: fix dead http link in blk-mq.rst
Date: Sat,  7 Nov 2026 08:40:00 -0500
Message-ID: <20261107135008.402572361@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jenson Johnathon Reggentin <mail@jregg.de>

[ Upstream commit b40a680ea4efe4ef2addada63e304a94d19500d1 ]

The current link http://kernel.dk/blk-mq.pdf leads to a 404 error page.
https://www.kernel.dk/blk-mq.pdf leads to the correct document.

v2 to add the missing www. prefix in the actual file change.

Signed-off-by: Jenson Johnathon Reggentin <mail@jregg.de>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Message-ID: <20260819192422.42189-1-mail@jregg.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/block/blk-mq.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/block/blk-mq.rst b/Documentation/block/blk-mq.rst
index fc06761b6ea90..2798761efe0d6 100644
--- a/Documentation/block/blk-mq.rst
+++ b/Documentation/block/blk-mq.rst
@@ -139,7 +139,7 @@ completed.
 Further reading
 ---------------
 
-- `Linux Block IO: Introducing Multi-queue SSD Access on Multi-core Systems <http://kernel.dk/blk-mq.pdf>`_
+- `Linux Block IO: Introducing Multi-queue SSD Access on Multi-core Systems <https://www.kernel.dk/blk-mq.pdf>`_
 
 - `NOOP scheduler <https://en.wikipedia.org/wiki/Noop_scheduler>`_
 
-- 
2.53.0



