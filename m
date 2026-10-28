Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217358;
	b=yt4yQjMAPlAiTzae/jc2UT5saRAstgxePvzPIXvWaEauec9BEcCupfHgOf+0GcKEHntP
	 hciR3Eo7WuGzZe9zr2aynPzzfpebxqK4+18kHd2XSmu7bEZAVasKs+EF6qlA43LA45S/q
	 UFobpc1FIPdvAFCZBK5oX1FQYZ2c03iTvBKfGThsQWk8O0r5JDXOAzBbHCk2kKdvupUJL
	 NnWqySRV56Mcolgj1wd39oSxJiT9P3c/F9AySpnwcMP0fAbEuGtHNfElE5iYxA+ElGs8g
	 95by+ZtZYyrpfVSPJBQ2OKuDLTjHxH7dbC+7pCBeZO/UD3XMT7CXertyfwa8wBax4VA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217358;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=w3hMwOvFExnWxotrDvTt8ByYjYGJxhYI9PFKM4nwNKE=;
	b=uwscWGcz4JcytCkbVj0LVElplbXeI8+2FUgOZZOmDCpxsIXmUBCNUR5GndM/KlUmB09H
	 n2WIq8EFmCH2MULpka/cegRZM/RWoU9Src3p+wq9MvzBqEUUhQxP4VeANzUq4uMycusME
	 MpXPbRL/5j+VDi5uByx77DWC/b6WSnGYwnDiJZJRjUULb+iL6yUNwO/Kl9cwNAq6WC16L
	 r8q7FTYuIYqC4nyqn43mUt5E4G7RZt+R6ybrHxeyOqxvv09/Psy7k6VRUXUGUSEK1OG1Z
	 OC6FO02dX+BsrAPZ5oCxQnx0EAu0jV0HXbjAY+hEUctEiIbTaz9ZOWrrC9trCun4l1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GW4qucNB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF5FD606A31A;
	Wed, 28 Oct 2026 19:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GW4qucNB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A7211F01828;
	Wed, 28 Oct 2026 19:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217357;
	bh=w3hMwOvFExnWxotrDvTt8ByYjYGJxhYI9PFKM4nwNKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GW4qucNBS0oufHeedRhAkDs6wN1gRYhFn5jv7cuwyCEzFkIk9hrWHN/5JDuZyqehI
	 yL1YmLvjWbN1T1TGdbUGW45Ap7ctl/uaVA/hMRcwqvNdV6bHNOuDM8YB9R0tILw5hU
	 qsvgvoiLZJlDk5evUmmzenYolID3knSmzoSkpQx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <keescook@chromium.org>,
	Nathan Lynch <nathanl@linux.ibm.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1874/1887] seq_buf: Make DECLARE_SEQ_BUF() usable
Date: Wed, 28 Oct 2026 18:06:10 +0100
Message-ID: <20261028170542.101144073@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Lynch <nathanl@linux.ibm.com>

[ Upstream commit 7a8e9cdf9405819105ae7405cd91e482bf574b01 ]

Using the address operator on the array doesn't work:

./include/linux/seq_buf.h:27:27: error: initialization of ‘char *’
  from incompatible pointer type ‘char (*)[128]’
  [-Werror=incompatible-pointer-types]
   27 |                 .buffer = &__ ## NAME ## _buffer,       \
      |                           ^

Apart from fixing that, we can improve DECLARE_SEQ_BUF() by using a
compound literal to define the buffer array without attaching a name
to it. This makes the macro a single statement, allowing constructs
such as:

  static DECLARE_SEQ_BUF(my_seq_buf, MYSB_SIZE);

to work as intended.

Link: https://lkml.kernel.org/r/20240116-declare-seq-buf-fix-v1-1-915db4692f32@linux.ibm.com

Cc: stable@vger.kernel.org
Acked-by: Kees Cook <keescook@chromium.org>
Fixes: dcc4e5728eea ("seq_buf: Introduce DECLARE_SEQ_BUF and seq_buf_str()")
Signed-off-by: Nathan Lynch <nathanl@linux.ibm.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/seq_buf.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/linux/seq_buf.h b/include/linux/seq_buf.h
index d9db59f420a49..468d8c5eef4a0 100644
--- a/include/linux/seq_buf.h
+++ b/include/linux/seq_buf.h
@@ -22,9 +22,8 @@ struct seq_buf {
 };
 
 #define DECLARE_SEQ_BUF(NAME, SIZE)			\
-	char __ ## NAME ## _buffer[SIZE] = "";		\
 	struct seq_buf NAME = {				\
-		.buffer = &__ ## NAME ## _buffer,	\
+		.buffer = (char[SIZE]) { 0 },		\
 		.size = SIZE,				\
 	}
 
-- 
2.53.0



