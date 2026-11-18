Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054596;
	b=An0y18UrL4bw7MmvW2wseCdJ8u2J3H0DTC2yg4tK2n9PFjtIN6x+llm9pyy46z888B9y
	 vdgSNwVxJqEEDQu0X0UqEOTpDB72zQPzT24R0SqipOkRF0Hoa26y86WILQ+g+E8kz+EpM
	 aplrlu/HOYmm2ZvtkwMNaHPNVBRz8RwkBlY8Gm+CPMsXyw7G+CJ2VCcmf3dHQCHGJeVHn
	 tQKtObPk4l9KOvddZ0KJ/MRltgcgzD692VZgUp/kw2yTY8pYk6l0WijnieOFKCuS/AIey
	 eNU6G8M0FrU+xJlk28os5kS3VbKwiNASxUZtg1aMte8pqUCqvp/P/yQzzayMbXuqMng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054596;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gXQnbBELCNccnrOP+iF1Mbwspw4lrjd9TGR4icwX368=;
	b=oblU9FXUgWH0MBri7LC0nszznyhlO4UW4WKp3PvVz8gTY1YSGxF6UGJ96iQHFRZflxQ4
	 1+Xeqcoh7T314UZv94/R2gwhC5Rw8u89SDKS08aNo2cKwds44difrAt7cZxXd0JQziD/S
	 CcAHZvdHDNDmV7y+a4ie9zjORLuvW8MuVtGzCWqjhzfzzyX7dHH7jrOUjWVONAslvZgcf
	 auglBeYQxlh1zS3tWNUG3yLRdhmkZXNaiQHeMRefDLtmU9t/uHCGTohFsr1umqnIebgtg
	 oFj7kwomp/fIIytuEPu4FE2ELyFYbPMbTw38RWoB/4ibfO2FPZ/DA9XXdrd+ex0h7lA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rB8n6wvf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9664606A325;
	Thu, 19 Nov 2026 02:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rB8n6wvf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3847D1F000C4;
	Thu, 19 Nov 2026 02:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054596;
	bh=gXQnbBELCNccnrOP+iF1Mbwspw4lrjd9TGR4icwX368=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rB8n6wvfD+fSDPyALezr05miEYyedOtSFmI4P617pisrJP+F3SY4rUbhIH4DnEjDS
	 TGEIRLGDbw7I/ejPdW5jesWSqNIpUPYrqo3B/Zlxr7C3fuPJdKcP1jPN9bHUF8BL0A
	 lUHbL/WGOgaD3XA6zAk5TBnBxG9tg0vMBG1nVnZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Chen <chenyuan@kylinos.cn>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1329/2214] bpftool: Fix spurious batch file read error
Date: Wed, 18 Nov 2026 15:50:05 +0100
Message-ID: <20261118150104.583644534@linuxfoundation.org>
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

From: Yuan Chen <chenyuan_fl@163.com>

[ Upstream commit 713c02b59e21840f623a3e31c43d967026c75181 ]

do_batch() checks errno after the read loop to detect read failures,
but fgets() does not clear errno on success, so a stale errno left by
a previously executed command (e.g. map dump's EBADF from a double
close) makes bpftool report a batch file read failure and exit with an
error even though every command succeeded.

Clear errno before each fgets() call, so the post-loop check only
sees the outcome of the last read: zero on success or EOF, E2BIG for
an overlong line, and a genuine errno when fgets() fails.

Since errno is now reset before every read in batch mode, drop the
USE_LIBCAP errno reset in main() that existed only to keep errno clean
for the batch mode.

Fixes: 71bb428fe2c1 ("tools: bpf: add bpftool")
Signed-off-by: Yuan Chen <chenyuan@kylinos.cn>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20260824092657.1789956-2-chenyuan_fl@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/main.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
index b70c023f3a571..04157ac068f53 100644
--- a/tools/bpf/bpftool/main.c
+++ b/tools/bpf/bpftool/main.c
@@ -304,7 +304,11 @@ static int do_batch(int argc, char **argv)
 
 	if (json_output)
 		jsonw_start_array(json_wtr);
-	while (fgets(buf, sizeof(buf), fp)) {
+	for (;;) {
+		errno = 0;
+		if (!fgets(buf, sizeof(buf), fp))
+			break;
+
 		cp = strchr(buf, '#');
 		if (cp)
 			*cp = '\0';
@@ -404,16 +408,6 @@ int main(int argc, char **argv)
 
 	setlinebuf(stdout);
 
-#ifdef USE_LIBCAP
-	/* Libcap < 2.63 hooks before main() to compute the number of
-	 * capabilities of the running kernel, and doing so it calls prctl()
-	 * which may fail and set errno to non-zero.
-	 * Let's reset errno to make sure this does not interfere with the
-	 * batch mode.
-	 */
-	errno = 0;
-#endif
-
 	last_do_help = do_help;
 	pretty_output = false;
 	json_output = false;
-- 
2.53.0



