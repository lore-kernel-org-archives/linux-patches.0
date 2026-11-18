Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040463;
	b=zWpQ5tpzIPVcA7dCqxvYxCVL8u2Cmuasvy4gqHqfebCQ/wXdqbhYXXQ/d5qlZmqAtZao
	 xEyaJPJBN5rj7bX3afo6ID/MJ3HmdILa/eXEXhNbeACWxcwPjeWxQWGNfPOdGvrdnSaR9
	 SktF3WSsfzGgtkqKvdWh712fDCvcWZWExrT6Ra6pbyCIwUFX9sB9bDJsNdVqL8Y+ktl/6
	 yCYtIhOOp61fP0+o/vswtMIGdkVE2eMEtBVIHZScKdQtvfA9khNduRcJv0KMXYdETCXBo
	 NFQN5OwcFGzPD3Ol5LWXVGRl3iXi/vWHrC+7TFYv6POii4Rt3EQ0/w3hU0x3IvLOfVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040463;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZTCsD2e8SeGTopj5E4SVEAfW1pLI7ap4UkzTtV+q+8g=;
	b=rWmuQaUkoyXHJYjgADZs2Ekt7AH8PeYu1UKTjAwoLSY5oeszGFxDT5nCd10f8f7O+NQZ
	 63Y9DMsUBPJZ+bpMgmAERTuUGCrpK2hXhLipfTgGa83oYo+PJD9WHtLKncvW1r94Luil9
	 tJG3sLAwpERbUCoRf1aaZKtozeRvixAPvCwwhlcKy4bz+n7XRLqnIQmMc2MAtOhAyDDWv
	 jqxnSh83vQqauH14iWOOoJSLjtm/ZkSyYnnftrFG2PvQBLUFhGqahv+aaQZ6kxQUien/N
	 u/Pqa0HTMymggKBullLD9y3VMuS7ZQbbGycA/wyBwBWibsqsGpGbc2QIgDn/wFAmzcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Diu4y1nG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A92BC606A31C;
	Wed, 18 Nov 2026 22:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Diu4y1nG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 052771F000C4;
	Wed, 18 Nov 2026 22:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040463;
	bh=ZTCsD2e8SeGTopj5E4SVEAfW1pLI7ap4UkzTtV+q+8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Diu4y1nG6UVL/BhPeAnO6PTfaAHUJYmp56MgL2Wnwt9sjv9sVinOghU4H4yM6hbHq
	 RVM9aV9JbT4CBCZbj/AAblQLeqKoOSFzNr8LC4sntv9LO1O3Du1Ko7q2kUnSbhC89g
	 A4eKDRMicKBsAJjsfjO0P9TUzU/DcgXR7scaxKIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingshuang Fu <fuqingshuang@kylinos.cn>,
	Thomas Gleixner <tglx@kernel.org>,
	John Stultz <jstultz@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2466/3318] selftests/timers: clocksource-switch: Fix unchecked open()/read()
Date: Wed, 18 Nov 2026 15:51:28 +0100
Message-ID: <20261118150435.398916746@linuxfoundation.org>
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
index 83faa4e354e38..4e7f81ffe0a35 100644
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



