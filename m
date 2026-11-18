Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061041;
	b=oQCoKZ/Cc0vNe+Qqmm7JK/N7QX0pvdBLcbMAT27sOLl44D2dNBQR2md4ctGdOcmoKynT
	 JE2zNom7wGkSGrbjwq9TTtm3xXTG54N/cWx9JDBtlQMZ4CGRCXX5PXcLeqa/HKXevrB6z
	 Ll6gXm76hMIkVcvljWy++vOwg6X0LK1HjswDlRdyThFzrmefKfJemQXm3Y8qfAf7NlQS4
	 A5nxGxcOHMGw3umuNRLOXYlOrrLxNfv48r/YaTvX/SoskyidCIg07BCt2l5+CN6KET+e5
	 6jabxO9Jsqs6PIxc7izK1DlDqU5GRM5OR0ECwjo5otyxlff5C+nkU9e07yRkCZ2OLvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061041;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8QUF+g2unfZ22DSdnGYAMJOEOxUmcqjzaWk5jaBDhK8=;
	b=EBpMGzNZVAo/78CvaSdL85RN+Vk9IH6XoKO+fmhlNglOSUUTiCiaAdaSLl7MJrPAzAYC
	 TsjRcqp9FOhkKwEa8UYYWmkoJq8DYtycfTynGI6eKs9qlbbztgYAJY80OwD4KM3+3yxY7
	 8xH7LYB+yWIL1b2ZW/IOkIJUF06Sz3+hiAe4NyGlPn4JFQhk/o5rep72CG9nHt/g1yNI/
	 qDDIUYI3qbwSQ6WYruQMgobOuGRFuvdCF5PEWCrs6I5WkXdeEEpwu6yWVzjkzF+oIEQlg
	 dw8VY4Bp+DbxnUXINMXBAFDiIWtS9SeGhiJIa4yb6/ix12lG3/iLlQN7/VnL7yeXyFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YLgSNVC6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D332606A326;
	Thu, 19 Nov 2026 04:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YLgSNVC6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A67CB1F000C4;
	Thu, 19 Nov 2026 04:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061041;
	bh=8QUF+g2unfZ22DSdnGYAMJOEOxUmcqjzaWk5jaBDhK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YLgSNVC63ysQM4xnQT257QGRiRCxFPOlM5PLBNmU9bdirGxAy2T7YeMAbRlaNZtiN
	 GUQWcipar/vU+oLtKYmPelIV1a0JwnE0fbCMHQ0Va6bqAu6xKlFk63mub9o5a6oP4w
	 vRu/FF50oLbEpxpd+f1gkb+wsjB/XVGq70Kkke1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingshuang Fu <fuqingshuang@kylinos.cn>,
	Thomas Gleixner <tglx@kernel.org>,
	John Stultz <jstultz@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1411/1848] selftests/timers: clocksource-switch: Fix unchecked open()/read()
Date: Wed, 18 Nov 2026 15:57:29 +0100
Message-ID: <20261118150018.584014934@linuxfoundation.org>
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
index c18313a5f357b..61d22a58a203f 100644
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



