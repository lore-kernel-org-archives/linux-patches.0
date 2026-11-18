Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055571;
	b=pjvvVEzolIdJAGXuo7G+/aW54ZoYDIYPNQYPneS3+we52Nu5Di0OrcOAYWiDobV517os
	 dgtpo3ZtmSAVI0+0WKnI+o0m6y8aVh5R33+oaqXESXjXsl0Dg0qbtHPLu9yjW6wL89y4+
	 Aj1ysohpaMOBwEQv4gu92CiJ1RmgWdDe1uFDJKUeaAxhFimjCpaW27JwI1z9gmFr1g3l8
	 MrP3sT/zp1+QVZVN/jrRiHnoHTTCyBtjA3CvkVg4glCF+X9sn01YmYZDyNYNBuft7Veo6
	 6gdb8sQ09ON09UQ8uxSJ6LsOjtotfCE4rfQiSOqIBytBw4Co7CGWLNEOfhqt7kwq+NA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055571;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rulJwUvWeM0kM1IxXaPufLLPzAZ5Kwa6tqRsyW9dQu4=;
	b=oAeLzYgPBUMvHseTIlUJT2vqX3hk522i7/b5p8Kv3y8ux5x2wH5sAfkUQ6LiI35X/rE2
	 EP1LSNwwvAK9xYGZRuUXZFRtmGOgnzRNcQyGDu52VIFpnxr42QvOZqFBGSRPkFL7WJdR3
	 pk13bF5mFchIzqKnpqs2ubGyWaVFkxc0FDmq9d9j7EiOJmbsU2AJyAY8PtUk6FA06iDIR
	 4oXe6MrfHJS8R7tWPoBsz+brqJHjPimeVPhIC3Of+5cXxsjjn6bs1O+qChJroAZQlOlmz
	 EJHYqmkeOel9dhT/JdSKUOlt96UyFuhaDdc3WxoyT84gTXDGWiZZ34+v2fEfkE61XOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZRY9jLw5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4340C60A2612;
	Thu, 19 Nov 2026 02:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZRY9jLw5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 557161F000C4;
	Thu, 19 Nov 2026 02:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055570;
	bh=rulJwUvWeM0kM1IxXaPufLLPzAZ5Kwa6tqRsyW9dQu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZRY9jLw5yoi31Vme5IzkEU36OOjOml5pUpbkM45D2GqkdjeJsYHZVI/t5umpnmqDa
	 FbE/2+YwWmH6gAq9A96ygxbr9dC/nF+/f8ecEBbNTwnSrSVdQkG0lsymT0o4sfaqZS
	 dB0aGY0viHt5gLgPSFw7sk+hz/9eGqpotjElhpL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingshuang Fu <fuqingshuang@kylinos.cn>,
	Thomas Gleixner <tglx@kernel.org>,
	John Stultz <jstultz@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1677/2214] selftests/timers: clocksource-switch: Fix unchecked open()/read()
Date: Wed, 18 Nov 2026 15:55:53 +0100
Message-ID: <20261118150118.918412725@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qingshuang Fu <fuqingshuang@kylinos.cn>

[ Upstream commit 348f54c435bf3177baa78201952810b255d44b30 ]

get_clocksources() and get_cur_clocksource() open and read the
clocksource sysfs files without checking the return values and without
NUL-terminating the buffer.

If open() fails, read() is called on fd -1 and returns -1, which is
stored in a size_t as SIZE_MAX.  The token-scanning loop in
get_clocksources() then walks past the uninitialized stack buffer,
reading and writing out of bounds.  Even on success the buffer is not
NUL-terminated, so a fully read buffer makes the inner scan run past the
data, and get_cur_clocksource() lets change_clocksource() call strlen()
on a non-terminated buffer.

Check the open()/read() results, use ssize_t for the read length,
NUL-terminate the buffer, and close the fd in get_cur_clocksource().

Fixes: 7290ce1423c3 ("selftests/timers: Add clocksource-switch test from timetest suite")
Signed-off-by: Qingshuang Fu <fuqingshuang@kylinos.cn>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Acked-by: John Stultz <jstultz@google.com>
Link: https://patch.msgid.link/20260825064605.472889-1-fffsqian@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/timers/clocksource-switch.c     | 23 ++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/timers/clocksource-switch.c b/tools/testing/selftests/timers/clocksource-switch.c
index b57f0a9be4902..c00a88f3e492a 100644
--- a/tools/testing/selftests/timers/clocksource-switch.c
+++ b/tools/testing/selftests/timers/clocksource-switch.c
@@ -40,16 +40,23 @@
 int get_clocksources(char list[][30])
 {
 	int fd, i;
-	size_t size;
+	ssize_t size;
 	char buf[512];
 	char *head, *tmp;
 
 	fd = open("/sys/devices/system/clocksource/clocksource0/available_clocksource", O_RDONLY);
+	if (fd < 0)
+		return 0;
 
-	size = read(fd, buf, 512);
+	size = read(fd, buf, sizeof(buf) - 1);
 
 	close(fd);
 
+	if (size <= 0)
+		return 0;
+
+	buf[size] = '\0';
+
 	for (i = 0; i < 10; i++)
 		list[i][0] = '\0';
 
@@ -74,11 +81,21 @@ int get_clocksources(char list[][30])
 
 int get_cur_clocksource(char *buf, size_t size)
 {
+	ssize_t len;
 	int fd;
 
 	fd = open("/sys/devices/system/clocksource/clocksource0/current_clocksource", O_RDONLY);
+	if (fd < 0)
+		return -1;
+
+	len = read(fd, buf, size - 1);
+
+	close(fd);
+
+	if (len <= 0)
+		return -1;
 
-	size = read(fd, buf, size);
+	buf[len] = '\0';
 
 	return 0;
 }
-- 
2.53.0



