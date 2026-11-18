Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047809;
	b=QeQohb72hW5Jmw/jjXqw7zOMLPe2aBuW1t874Ig63me2s5dQQ0D2aHLr2CL9bIpPjoGq
	 COI/T8CwLchMG0w2Tk//e0lz2rd4VCY65bhplazui2CQuE+MQOrSWnpdxskx1cColJXll
	 nqPP3tpy0BzzoSY1c/VW/S8DEX8+clcb6o8xMumM5iJ7xklK+zR5KtlVofRIaEwggXW0X
	 rz/QdpqVohvasd/xtU1i2zTqdyHpxKfuVjGBiwXg01vOPTA23R4epJ07+rJB49EcTfp5E
	 wbcSrSL7BK6JOa0uZzIasYeOn3xIzb4b1o8oMZCJD22BKWfLLDLa/OQczRkI7cnMHNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047809;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wcpHkphulRS+qzcCaWDzlgQhwXJBzQgToa0cSx9XCOM=;
	b=P8MNxdFNRThGAu/496KSCnJ5hl8q2YtL5w7cWqG0q4Sn5reqUzNFH0P8z1Gnf0nhYaNp
	 aQaNzfSx4bMhbaxMfppBvRsAXzzuHnW7/Q7BOc2OEk+MeiPWueLbkdjw2LD3O//NgE/KE
	 54rDHVqQTojEV01CdgfhGFlROUOYSsvwdPERnEpZKAAhrUu14qAcIScC6NSrmnVH6fjr+
	 TxvUzZYsWdcF9CyuCoStG1UTaeYDkxwF7XHe1mB+/mR4LXm0fQNX36g7pELJlPEi9iRaX
	 1H8upKQWPrj8PHTxarrJilDjLCXZGOS6EaJDyXlEV6I/FZ1TK1QPoyvV3OS7VwtJmOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xlg2116p;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5E0A606A31C;
	Thu, 19 Nov 2026 00:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xlg2116p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 443ED1F000C4;
	Thu, 19 Nov 2026 00:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047808;
	bh=wcpHkphulRS+qzcCaWDzlgQhwXJBzQgToa0cSx9XCOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xlg2116p9kfVVsHWadmmdJ1/nIl0+eQwQGjmP/n1reZNflmfjvjFIDzfcRqTEW0MM
	 2P1rlDL19HCkNyCQjMmtjm82KAUiaJVcnYAs4Ifef/sxShwOF2rgH7JiNMT6GveLWF
	 6lETJyxsxi05yzrl3y8mZ+NTGbe8kr6U2GqQoZEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Chen <chenyuan@kylinos.cn>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1730/2857] bpftool: Fix spurious batch file read error
Date: Wed, 18 Nov 2026 15:46:04 +0100
Message-ID: <20261118150303.608825177@linuxfoundation.org>
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
index b2441fcbc1dc2..b53e282364533 100644
--- a/tools/bpf/bpftool/main.c
+++ b/tools/bpf/bpftool/main.c
@@ -333,7 +333,11 @@ static int do_batch(int argc, char **argv)
 
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
@@ -435,16 +439,6 @@ int main(int argc, char **argv)
 
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



