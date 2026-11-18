Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034300;
	b=rPmXoqRPQ202AbNhZnxLMNyoqf/Rix6r/bSnH454OzVdvluxWRvUJA9PaBDRPJXaJTx7
	 tCU61KmpyCvynNimpK/YTQ8HiHJS6kF5tGx67WgQp8BI9TBGDBYcRhJHRJD30a5EuzVtR
	 m/+13TY8laKKLFJaG3aCN+mTA8Eshva9O4izNbBSXyYITS8fcFhUjc00bO8EV8a3R09yV
	 pEUxEkzlIS6A8ccWFhRKrAmO3VrMJuvWNKHvQqCrWAu19Z1W75VoKH1p0H3Oj0l+js28Q
	 ZJdOWPIng5Vm2j/ui1HiztNCNrm+GyvP0LNLH9QgCwl0mNu4076L8StFLjc9NUJ463w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034300;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SUm486nOokzeyut2ToI+hRQ07ZIcmZV4VYrKj6IvQN0=;
	b=3VWxPP77mckZWWWDvqHY79cnbEHsOYMzerdkAYakAjfztI7xyHaYy9D9Jq4dkZJ6Frip
	 QWmcsMjuVmzijugj9mUmde/TRaH/hP2Ne2Y/zr0xl9xBS8B5UK8/r5obECIr2clOYJHjK
	 P8/7FbyZphVL6S+X3p/XtMgwxxEl2aO9JlPNL85QFAhYHZ10S50LHkWCgaVbivs3pfaDi
	 mVkVjT3AwiGBILpy1n/W0eeVa+CHg1BF/i+hkGvmd5Qk1i/WrfgkWYQHgXnwYIOEQC5Bt
	 q/Cv2mvcDlmCzR9aP5UC5NfuzvH7m0rDkqHJvsJo+7quOHa/LyEZTbKdGcZ8gcUTO5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ghfLXIJK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECA3B606A31C;
	Wed, 18 Nov 2026 20:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ghfLXIJK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51B991F000C4;
	Wed, 18 Nov 2026 20:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034299;
	bh=SUm486nOokzeyut2ToI+hRQ07ZIcmZV4VYrKj6IvQN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ghfLXIJKwmJHzyzQZOXr/ty3hVGf9Om4lGTdKJrhqf8q8QtCAQrnDQ+NC2PokO8RL
	 v6JWm61B31gGfhkqGrk5NHu+D9OgvrQFZVKipRR+Sew3q67URyYkajtcvnugQrYHPO
	 EHtwX8fBtznamjoR7TYj4FUn1OiKMeSojdG39zvc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jenson Johnathon Reggentin <mail@jregg.de>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0319/3318] docs: block: fix dead http link in blk-mq.rst
Date: Wed, 18 Nov 2026 15:15:41 +0100
Message-ID: <20261118150325.418002083@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 31f52f3269714..9a8b3899e5581 100644
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



