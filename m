Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030012;
	b=H+Hc35ruMMtAs6+d5VbSri7LT4LJQ07E+UaUeHJjo7qyP0TWm53c29dWSVdZqk5Vrv/Q
	 p0vkU/wuhXWzmEKVeG0rRc+B3dsABsriKcrRv7IIhMs9uAU9a8H1INprEaHBWl3QtEL0O
	 FJgCqjsBgGjv+GeqwhS0CS4bRkPcm4LDK0kmFJ/kDctVbKZPyKlsvpLH0ExFWrwYrjic+
	 qZl2KZM9DskryHUKt0R2j7LpRcpl9M0BXUYF8vE7PbG5KTQb9DkIYlFPiJJTnPOAsdh+A
	 2K/UFUgJqZqa5KRx0OwDcAFIvP7Ps34fC/kls0fokv9wWTQv+/uH1IALW4K7SqOEpgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030012;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=t8PIW8DFKK1kS478Z8XH5jADoCYNW+I2wprKX6NscnM=;
	b=rq97DiJhO6YtcYtfFwHf+KHgp2mlyNZzUOELUu0aQJUIg9AmFOtIagkJOsx369o4NOxs
	 zBG7PcJAO+gifTC/GTh9GPLOplLxJbzNzXLkQswYEtDhqP7B8ByOhjhsj1inEEi/5WaVD
	 lGtfx2IUWLvxf9Pu5E3wkeUhYkZVeTkYQxakIHX93LzpKYWwFbBFbZ33uhcrWDdJaOz/L
	 Dgw9iiXx5YzlmJVVZP4gvcncZU6HXdIJCJ4m1h8IrZ7ITclofBKv+mVeaJK14kESku4ZM
	 IsM2+ZnyqlDwl1vkn25gPxnaT/mVKYsRISY92jOJfRtoAug43tNz78YFw0NlWnWof3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QPmVeQZj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00FF4606A31C;
	Wed, 18 Nov 2026 19:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QPmVeQZj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 595F81F000C5;
	Wed, 18 Nov 2026 19:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030011;
	bh=t8PIW8DFKK1kS478Z8XH5jADoCYNW+I2wprKX6NscnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QPmVeQZjTE2EI7HTOb9Wu4cGyHEjP/BzJgcEHK0ePoylA9YE+hBm7icehP2f1JrnG
	 F8jPo1hzxQcYrwq5dGM4NwFWHSZP5ZxmcULguBokf7MilEmcA8r+UjZ99hXpKaehUz
	 EHoKYu5cBRK04ZXlWpMu11Kf2Q3zDOSge68GkfI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danish Khateeb <danishkhateeb03@gmail.com>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0551/1756] tools/nolibc: fix WIFSIGNALED() for status 0
Date: Wed, 18 Nov 2026 15:44:38 +0100
Message-ID: <20261118150031.054070978@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danish Khateeb <danishkhateeb03@gmail.com>

[ Upstream commit 368fae47c6cae28a312c5dc86e5bdb8f9369fd26 ]

WIFSIGNALED() needs the subtraction to wrap around for status 0, so that
only 1 to 0xff, a terminating signal with or without the core dump flag,
pass the check. But status is an int, and 0 - 1 is -1, which is less
than 0xff. A child that exits with 0 is therefore reported as both
exited and killed, and a caller that tests WIFSIGNALED() first sees
"killed by signal 0".

Make the subtraction unsigned, as musl does in the same macro.

Fixes: 8c934d4822c7 ("tools/nolibc: add helpers for wait() signal exits")
Assisted-by: LLM
Signed-off-by: Danish Khateeb <danishkhateeb03@gmail.com>
Link: https://patch.msgid.link/20260923205622.1123270-2-danishkhateeb03@gmail.com
[Thomas: Drop stable@ Cc]
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/include/nolibc/types.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/include/nolibc/types.h b/tools/include/nolibc/types.h
index 9d606c7138a86..30cc9fad57ecf 100644
--- a/tools/include/nolibc/types.h
+++ b/tools/include/nolibc/types.h
@@ -108,7 +108,7 @@
 #define WEXITSTATUS(status) (((status) & 0xff00) >> 8)
 #define WIFEXITED(status)   (((status) & 0x7f) == 0)
 #define WTERMSIG(status)    ((status) & 0x7f)
-#define WIFSIGNALED(status) ((status) - 1 < 0xff)
+#define WIFSIGNALED(status) ((status) - 1U < 0xff)
 
 /* standard exit() codes */
 #define EXIT_SUCCESS 0
-- 
2.53.0



