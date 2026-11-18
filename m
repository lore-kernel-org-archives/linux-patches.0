Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044025;
	b=LvVOAm+U7P0TIAgtm7CB6cAObCyVyXtgH0VxaS41/P1TaOWYyo3+36GjtExY+n7rin9J
	 wOgIXTIAPlNq8dRpQAS4RLUZmwABmZtA36fdwHeT4VsedRFMDyOATkR3nDwLoMo9Icxyl
	 FFBtJS4W3AiiJeHwEzWxUc6dQ6nYcqSBnjo8ZdpkQCvyZ0PTbmCRQZlgqFJK+Pf1mA7Mb
	 6iwHImhWAbHf3U52Lv6GBtPrTFg8dHZfqVE/AgAb9b9YcX2hmMOp4E+7Y1z9PIUaZAchH
	 NPVizmZk2XCkTAeRpXbIORGLOyH/6n9b2FxzgkmbSNvDJmqzUX5VouXSYKxsSEpqrZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044025;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4eZkM3i/KKDisrwNEFgBQ56AEkgKnDfXwW+1JnG2crA=;
	b=x7R61whHf9LyPT+0ce7CvrkHq+R6JqYUeDnW2xKfgJUTwwjhSRmlL98yQTw4UgBOaUTo
	 wRpB/XhXdeXf/Xj7W5VWqwQTN/n7a9dKNLY+zs+ZC+YL40cs11UoOvqKq7aexCLTSslX5
	 0uuh+CK4LxzNs8xEx8QTpUtwiJFM/0b9yuCECsVaQc+g4PfCfgpqUwn2yHdN7kubZkYEn
	 v0h57+p3rMY2TY+BW4i0C7xfHswixMv9HvSnY6nWTsVgah2L0gcTpFdiHMHk3Q6Ox1+gn
	 dc7nT1KcDqD7vxZzyoBwwIPU8ycHXXcEW4hnV3+T/FtA/EEHhv3LlSTVTkNHFYCOyIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Iuvg+Oi6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42EB8606A31C;
	Wed, 18 Nov 2026 23:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Iuvg+Oi6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92EF41F000C4;
	Wed, 18 Nov 2026 23:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044025;
	bh=4eZkM3i/KKDisrwNEFgBQ56AEkgKnDfXwW+1JnG2crA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Iuvg+Oi6JdtU5vT7eYJPctcr0i1ycPe5DSJnvdOAZ6loUeftX9aBhOE9+oJvzjleQ
	 jYgVtz+XkC0jqY6ywTDtCVtTailY3oL69LjGYl9l6Kr4+0HszmliaF1vaHY6DsWiz0
	 EMlTOn0gWbd3y4EG7x5ur7Ke+U+NPTMcgQ8q8DOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0421/2857] tools/bootconfig: Fix integer overflow and truncation in size checks
Date: Wed, 18 Nov 2026 15:24:15 +0100
Message-ID: <20261118150216.538847031@linuxfoundation.org>
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

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

[ Upstream commit 462d0b066b613103f579793031429db2ca23abc0 ]

Sashiko reported that on 32-bit systems, if an attacker crafts size in
the bootconfig footer such that adding BOOTCONFIG_FOOTER_SIZE wraps around
(for instance, if size is 0xFFFFFFFF), the size check in
load_xbc_from_initrd() can be bypassed:

    if (stat.st_size < size + BOOTCONFIG_FOOTER_SIZE) {
        pr_err("bootconfig size is too big\n");
        return -E2BIG;
    }

Furthermore, on 64-bit systems with an initrd > 4.29 GB, comparing a
corrupted 32-bit size (e.g. 0xFFFFFFFF) against
stat.st_size - BOOTCONFIG_FOOTER_SIZE can also bypass the check if
size is not bounded. Similarly, load_xbc_file() passes 64-bit stat.st_size
directly into the 32-bit int size parameter of load_xbc_fd(), truncating
large standalone files (>= 2GB).

In both cases, passing 0xFFFFFFFF to load_xbc_fd() truncates to -1,
resulting in malloc(0), an integer overflow in read(), and an
out-of-bounds null-byte write.

Fix this by:
1. Rejecting size > XBC_DATA_MAX or
   size > stat.st_size - BOOTCONFIG_FOOTER_SIZE in load_xbc_from_initrd().
2. Rejecting stat.st_size > XBC_DATA_MAX in load_xbc_file() before passing
   it to load_xbc_fd().
3. Checking size < 0 || size > XBC_DATA_MAX defensively in load_xbc_fd().

Link: https://lore.kernel.org/all/178905332413.213925.3179977110281463499.stgit@devnote2/

Fixes: 950313ebf79c ("tools: bootconfig: Add bootconfig command")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/20260909161113.16C691F00A3A@smtp.kernel.org/
Closes: https://lore.kernel.org/all/20260910010137.EE0431F000FF@smtp.kernel.org/
Assisted-by: Antigravity:gemini-3.8-flash
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Reviewed-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bootconfig/main.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/tools/bootconfig/main.c b/tools/bootconfig/main.c
index f1a20f85a669d..5429a7674b35f 100644
--- a/tools/bootconfig/main.c
+++ b/tools/bootconfig/main.c
@@ -139,6 +139,9 @@ static int load_xbc_fd(int fd, char **buf, int size)
 {
 	int ret;
 
+	if (size < 0 || size > XBC_DATA_MAX)
+		return -EINVAL;
+
 	*buf = malloc(size + 1);
 	if (!*buf)
 		return -ENOMEM;
@@ -167,6 +170,13 @@ static int load_xbc_file(const char *path, char **buf)
 		return ret;
 	}
 
+	if (stat.st_size > XBC_DATA_MAX) {
+		pr_err("%s size is too big\n", path);
+		ret = -E2BIG;
+		close(fd);
+		return ret;
+	}
+
 	ret = load_xbc_fd(fd, buf, stat.st_size);
 
 	close(fd);
@@ -217,7 +227,8 @@ static int load_xbc_from_initrd(int fd, char **buf)
 	csum = le32toh(csum);
 
 	/* Wrong size error  */
-	if (stat.st_size < size + BOOTCONFIG_FOOTER_SIZE) {
+	if (size > XBC_DATA_MAX ||
+	    size > stat.st_size - BOOTCONFIG_FOOTER_SIZE) {
 		pr_err("bootconfig size is too big\n");
 		return -E2BIG;
 	}
-- 
2.53.0



