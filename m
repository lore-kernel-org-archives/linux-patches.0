Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043175;
	b=Gxz2OnPGggdL89YSsd6qIeMbz+2G24P/PCJ7ReeNFcSwENgTOZ0Rwo/nb/drKhMuWbCi
	 xEqE7I+hppGiG781kbLg6tYZCKNr8ssQS2CtLiYxLhvhQXAQXirrrMn4eMV83HZGOtT9F
	 xdvejNnokFsp2a9pZFmZ6Lcoq3Y5bTHs7p3X9NnIhfUmb9/HAOt8/pdWWjO5fGnWfkJ0n
	 SmWxr0PP2Tezr1XVF5lSRVFmazWMzcCsRw3nC2ylOQJMivv7rAPBlQ6VHT+N6k4w/6Lg7
	 LfXkrj2UIJxI98UbQEWmeHjiM3pGAfvEJExMFC+vSN6C3LvxGl2wVe2WeQkhTbzMx6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043175;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HSxS6YdRLX6Ftr8vLI1Rev0EU3gj+tuyJGkG0olA4VA=;
	b=El15sViLPvh/m4SYFbUML4lFG7M8/Ng9BRCIGCzp4LOPYLoztPmhe32IYvbalIRQgNgC
	 QJ3m/JLG3EoDroEa53gvAPwYp57rBGA1Kmrg7KQEGTr6Oylx6u1L5ZkWXVugzboNI1tF4
	 JN2OMhUjTFiMQogeERtb9gnLNu9s7M+3v8ov/+xBSpPDLkQO4C5oHmO8c5OuyleScuO2J
	 we4VTEpZHMBdGGVAwvSLbo3nMbEmTcl7jnYR1dTM6gXcOVgKflEaCfVEBhWSjooRo4RpI
	 fAtPEnUiH2rEyJjmhpLUty8zfHnCJm6/brDp+HqpdXt3qZTq3+Qgj34yTIzWtM6RHog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oj6eQNvQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9695606A31C;
	Wed, 18 Nov 2026 23:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oj6eQNvQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2FD61F000C4;
	Wed, 18 Nov 2026 23:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043175;
	bh=HSxS6YdRLX6Ftr8vLI1Rev0EU3gj+tuyJGkG0olA4VA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oj6eQNvQljWvJtUeC1fgqDy2s3luDjWdOll9LPmRSq0BndDB6RZV/w1L2Q/E4Q7N5
	 +vY8hH4YHvvAON3TXx+JYyYpLNDA+kbZjvVcXC4H2+FzwH+zzNjJf+MnwVbPb7fSnW
	 CeDC6EzEDzGXcVn8jz1mdmamkZLCUSt9f3ZSRNRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0118/2857] greybus: manifest: validate string descriptor header
Date: Wed, 18 Nov 2026 15:19:12 +0100
Message-ID: <20261118150205.606452450@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 18b6510f642dbcb856c3af8be974d1600f3ba2d3 ]

identify_descriptor() computes a string descriptor size from
desc->string.length.

Require the descriptor to contain the fixed string descriptor header
before reading the variable string length. The existing descriptor-size
check then reports the short descriptor.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260706091935.78020-1-pengpeng@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/greybus/manifest.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/greybus/manifest.c b/drivers/greybus/manifest.c
index dd7040697bde9..469da3f39afb4 100644
--- a/drivers/greybus/manifest.c
+++ b/drivers/greybus/manifest.c
@@ -122,6 +122,8 @@ static int identify_descriptor(struct gb_interface *intf,
 	switch (desc_header->type) {
 	case GREYBUS_TYPE_STRING:
 		expected_size += sizeof(struct greybus_descriptor_string);
+		if (desc_size < expected_size)
+			break;
 		expected_size += desc->string.length;
 
 		/* String descriptors are padded to 4 byte boundaries */
-- 
2.53.0



