Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207520;
	b=SpiiBKtEp0CTh6ahLzQTiOBZlbniSgYTlVZKGOweNy4bZDR+oFoXsz3kvdgueMNqeN+j
	 3RMZGHGPxTwSUQnY+g81LXRM7GDajtjcDCr9jnNEkgzhxy/xULCvcgFvZzmAODOUap0FV
	 M8gq7RZD2CCRmQ0pjwLsuhhNSvQpqmVsNG1jahfJMaCB7wnTJUBs22hmQS5+JMCjjYlnp
	 vOTKi5HsR9otC0k71LJ8/qR6OmTBKqo9R6zuZveJuXXB8FR/kT/pF0SOVtEiT/ZdMNRUe
	 UD8dawMzIzIGGEBBipvnXAT6vPs5rne+qGT3q6o8gtZZTcOjem71jEM0XQhfqbC2bHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207520;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=90WghW4yPhFpB/0yxxY7V1w+QKwXMZXAz1vknH+rVn8=;
	b=UsfJcIzI3eOw2a+ZIsSYqlW2Oo/hzvn3hDA3bfBdxS950yzfwmyKv5dvrUdXJ3jHmFHZ
	 Oz2XXhrWL+J118JT2VqVIjYuTN49HnaOJ7asNn3qJYBVm5SRYS1ZCiOULYMP4AOr+sQNj
	 btoOYWD6dh7IiDcynjKQbUEY74lvO2ezG/BE7aFZdfOuyXoWB4XERBVmoIT1fsiSChRJg
	 JxP7U2t5ld+/ONkOEDsaMxREL5fuC9G276TZfF71MRvyi3aWrGCJbSCubxgH4Y50T3GyE
	 rYW+fxyVKe9WY3jKnK3NaySS0X3KJF+NS2jXyMB9Wwt7WaEpe4FKoVWj9mpQY38CXhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F+EF8fD9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD1F0606A31A;
	Wed, 28 Oct 2026 17:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F+EF8fD9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 181981F01828;
	Wed, 28 Oct 2026 17:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207519;
	bh=90WghW4yPhFpB/0yxxY7V1w+QKwXMZXAz1vknH+rVn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F+EF8fD9L3mMIxjCAHv39+q5OBRmYPa2FgiPJIq3pk6lDymJC8J64nNyXNegTTHBm
	 n82x0wmgsRMehLffSDTDh1Wt34Ho/VlydbzzzkXUwIVlV+BB6BwWQYW8uWDQZRql/K
	 G0VcDJ8Jh4/1Oq+77l6cJelnTFJW+vCXTaDcbZhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.12 046/247] samples: pidfd: fix userprogs typo
Date: Wed, 28 Oct 2026 17:57:29 +0100
Message-ID: <20261028165948.465598356@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

[ Upstream commit f1365f97fb7498d805981102eee22d362ae643f2 ]

The Makefile adds pidfd-metadata to "usertprogs-always-y", which kbuild
does not know, so the sample has not been built since the conversion to
userprogs, even with CONFIG_SAMPLE_PIDFD=y.

Fix the variable name. pidfd-metadata.c builds without warnings with
gcc and clang for x86_64 and arm64.

Fixes: 60fb0b1239719 ("samples: pidfd: build sample program for target architecture")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Link: https://patch.msgid.link/20261011223358.2327625-14-sashal@kernel.org
Reviewed-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/pidfd/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/samples/pidfd/Makefile b/samples/pidfd/Makefile
index 9754e2d81f70d..d82409f7061f3 100644
--- a/samples/pidfd/Makefile
+++ b/samples/pidfd/Makefile
@@ -1,4 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0
-usertprogs-always-y += pidfd-metadata
+userprogs-always-y += pidfd-metadata
 
 userccflags += -I usr/include
-- 
2.53.0



