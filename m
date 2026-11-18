Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017272;
	b=uwtebqZCy9IoeOjVmpHZdUpViRVcTkMzumv9vUCLK8qK1wdn9PGXycmvcJePRdSDzD+B
	 K15EUV5J1JWL3KY5WSJ41Wpo0oEeQffJbGMb/7fgu3nWs92tbvMGvA3zHm4/ndkafI9wj
	 ohq6/lO4Bf9qLEHwjuv/d8NCd0SQU10NUL9ibhpYSBika05/ATNNqBEyFYUH6/NwHo2mt
	 /mMYqIZxs92PbgHKq87M58yvCUTaSM7et58ycpDtS9QJa9h/cJeec9frVitN5wDrw3wZ1
	 1Pv0dtK35J3agdomsRPoP40GTDkrr46Fj0YJI0JzuYvhBen8n0s58AdBRqHtfAYX4ZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017272;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=4QDGeTp4KTn/BOASeE3mPxawZETA0CeVXObxeyXPdjI=;
	b=mwRbHtrjmzqzF1lifkIEMaTx62Kfx+3XTJ2qp2plgP7a0eEgyboi1VMAW3PcrbckFi3S
	 WWqfvyj36+z5UmdDIEJqIxzjrLIl9PcVMyNnmwybezWvfII5Bd/ueKqiXXMXdT9pxIJmS
	 aZfkE61eLeEY3kmfADRJzSr5UjnCOXk+IIKIWlYkmgaKYuOTM0b9tA7LNg6eJTWQV98Tj
	 KK0N1EpJMZ3q1n3WgPZ5o7nwyVlOuyItc3DgWaL12vOC0NAYtC7BCsf55sLcYBdL30QU3
	 JAoQ0zfyRcgb6XCOJiKYuH7PYTxw4yPrM33Hp/oALbqayuYPoH5dFvPHFI4IKCKHuFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n+C5UnZ6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6850B606A32C;
	Wed, 18 Nov 2026 15:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n+C5UnZ6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8E0C1F000C4;
	Wed, 18 Nov 2026 15:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017272;
	bh=4QDGeTp4KTn/BOASeE3mPxawZETA0CeVXObxeyXPdjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n+C5UnZ6kd49IbEcB1bPqzVc+Bld+W6pYpMMskqFkPQV7eTpX5H5PsUYEGVYEjDXU
	 MQZvrCqdIipTE2qUcqxYSyH7hGYVNIdmbf6mi7o2kZPrZ0igvekLfnpyzIcvXMMVHm
	 R6viCQPSlMhstpSRP1mMLAjfkg9QkyJYyZfHH4Rs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danish Khateeb <danishkhateeb03@gmail.com>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0784/2651] tools/nolibc: fix verrx() and errx() message formatting
Date: Wed, 18 Nov 2026 15:33:44 +0100
Message-ID: <20261118150316.112806980@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danish Khateeb <danishkhateeb03@gmail.com>

[ Upstream commit 6f114ae7b6006ca7cf72e3e3348d263bbfec4525 ]

verrx() passes its va_list to warnx() instead of vwarnx(). warnx() is
variadic, so it takes the va_list as its first and only argument, and
the conversions in the format string print the va_list itself and then
whatever is left in the following argument slots. On x86_64, for
instance,

	errx(1, "int args: %d %d %d", 1, 2, 3);

prints something like "int args: -1699009032 1 2", where the first
number comes from the address of the va_list and changes from run to
run, and

	errx(1, "%d %s", 1234, "foo");

crashes with SIGSEGV, as "%s" takes a leftover argument slot for the
string. errx() goes through verrx(), so every message with arguments
printed by either of them is wrong.

Call vwarnx() from verrx(), as verr() calls vwarn().

Fixes: 9da0f529c089 ("tools/nolibc: add err.h")
Assisted-by: LLM
Signed-off-by: Danish Khateeb <danishkhateeb03@gmail.com>
Link: https://patch.msgid.link/20260924120958.23698-2-danishkhateeb03@gmail.com
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/include/nolibc/err.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/include/nolibc/err.h b/tools/include/nolibc/err.h
index e22ae87a72892..61978d537ed8f 100644
--- a/tools/include/nolibc/err.h
+++ b/tools/include/nolibc/err.h
@@ -60,7 +60,7 @@ void verr(int eval, const char *fmt, va_list args)
 static __attribute__((noreturn, unused))
 void verrx(int eval, const char *fmt, va_list args)
 {
-	warnx(fmt, args);
+	vwarnx(fmt, args);
 	exit(eval);
 }
 
-- 
2.53.0



