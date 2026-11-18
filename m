Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057084;
	b=f+GpBFuihbAaI6OdBXShO3d1J+8kWk8em4/DsvCEDiKlqUo1Q3U06t0IlifSW6AviMGN
	 j9VtNJqAWCe8i1sroOQ5HRYHurk65l/32gJZ3/xr6T1fDCg/L1UHN6qWh/nGs8Ru227iu
	 3UOYKxqjrBLOtEpEabcrSaPXIomS9LdoHU3t0Wf+6+sz288OD418Jo3v4GR6d77z5iGM2
	 AeMDJRWiuPKBeMSLf+lLv6z+zpHwSOWQRz4lqu0HROGmz6MTUBYFzkGWmOBz+DUwY4jNs
	 srYyNdoJpKLQnm4+VJrI+Pk3xSLREyGtiLBMW09j6owvxaRhT3sdrMmRy3ImtqkCCJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057084;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=ZxHQwPqTJHenByRaNi4Y+tqx2j5nbziaDyvaRv2AHxk=;
	b=ry3OZT1NagwNLlkPZtznRUiDifM1COkEi37sgxvX6xJAQnOUbw/Op9DdIruioaIUe+VW
	 1wZc6B2JiSWWwaJdZdpPfK1EgSutFgFaOkiunUgIpzX++mtyklNHpZ8BZ87NtVP52jyEk
	 mbMKC+7z++RaS7i4xGyG8DRg+QBWb4KJwuRpYctT+7i8QRdJgw1zcBro5MJGgxHxh+Zo4
	 x+T3MIpmGbAh4MJbvq1+78nYcXYhZbMN9XUqD725VnpKFjd7kd/KCGKwim8q2SagUxHkr
	 z7lf9ksex2CaATbfshxbbSUmDnAMK1BgFSpmh4zELCvJ+L1OlB36+Dy3ZACfUgPl7Og==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="AWj/l80u";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C86A606A325;
	Thu, 19 Nov 2026 02:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AWj/l80u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83C0B1F000C4;
	Thu, 19 Nov 2026 02:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057084;
	bh=ZxHQwPqTJHenByRaNi4Y+tqx2j5nbziaDyvaRv2AHxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AWj/l80upCol5wf/Khz4P5Ocp6EvOC9ZckZBRNXCQPceZBDHRn7Xax7O6bfLZt19F
	 L87RcKB8Nbu/FpmFbk3NQyvwIQQlaYJ38jHTAT53UcSwqT5NPpmAdJC0rITuNhWpOm
	 nbsj2lfs3PnoRJwMqyZ4FQwbPwZKrN7cWps48vjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <keescook@chromium.org>,
	Nathan Lynch <nathanl@linux.ibm.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.15 2211/2214] seq_buf: Make DECLARE_SEQ_BUF() usable
Date: Wed, 18 Nov 2026 16:04:47 +0100
Message-ID: <20261118150138.695672342@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Lynch <nathanl@linux.ibm.com>

commit 7a8e9cdf9405819105ae7405cd91e482bf574b01 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/seq_buf.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

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
 


