Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057599;
	b=nAQu6Z1tBcuQPvToCrDqfMgnOWW2vz6H8TzAGpGc819VMWYVz6hIs488W7mMBQtYmevA
	 Pov+ZJrMpbdmSDmiI7ey5d8B7qRDscGhRY2FLPedYNu2OWxahIJyGvziQ/qnt6EQV601I
	 o26ZeXxYppQSMqxPV+a2JLHPlr2XtHNu8fb6d4tdRJpJ+hAafJ7CLmzy5+usbVLM2asXb
	 fvmXzE+vRLOWrPFDLJLeOUceh20YJuwNqd9firuTm0sLr00Glbsl+O02W3hCxxh5gRfNe
	 zIlEvMMS/7aq/IWB5a9tWqYz2vTqSluyaARDLRhfjq1/Q8q0NY1E1//MKr/0B5MlMAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057599;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HwYBXl2vmhgHuG4R67Joi3rLtVD48XopTrgDzRlj4ts=;
	b=nT1cwoH9Vr5EEX5Syd3LSHB6GFmyNoiKGSYsD/OQZAHbbLNEcYTLiehlrlRgGog3ASNs
	 ZuJ3j0YqyydF6VVMRAvB9eTpDkK1k78dnkqDdCGfptN6qj6N0MDIWsm7Po4MZYoYblGyA
	 kpznBo4mABXHvyzBfUd7P06nHmnXJ7iZ/+IXnpdqQ1lB32r7+8pJo6zJN/gDPqYYz+3LE
	 nXBxZJ5FrVd/tkfC3HPz68taf/o5OEqPrEc1LtzfwJZidvu115Ml1l/EC/SMQiLcUR989
	 Joik9ShqyaRJ5QTjOBbiRgQtnHR9XqDn7XlwdMdDEnvN7KwPXVmcuqPajbanoWhJtoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NG+tkqc8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15ED1606A33B;
	Thu, 19 Nov 2026 03:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NG+tkqc8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69F701F000C5;
	Thu, 19 Nov 2026 03:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057598;
	bh=HwYBXl2vmhgHuG4R67Joi3rLtVD48XopTrgDzRlj4ts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NG+tkqc8w/nmAWOJac6hQykz6Uq0rnL6lg8x4XGMKtF71WBxRk+CIaFqlmH1oayBf
	 5uQpkfNHnpKEupZsVCDTnQwKLfaEo57aCPdh3TP0S/Gb6jAPxaSFWsB0y5eL32UULV
	 aDuCVtfNDz8e7BXF1luVUDLoznMyEodev6RXkU+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jenson Johnathon Reggentin <mail@jregg.de>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0188/1848] docs: block: fix dead http link in blk-mq.rst
Date: Wed, 18 Nov 2026 15:37:06 +0100
Message-ID: <20261118145919.541253412@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index a980d23af48c2..c880197034589 100644
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



