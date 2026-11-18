Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060219;
	b=CwYTUPNQ3wYNx0/SPvLkHVa+WRR674h3rjcwrFQ4gj+WrP0cl7xpnFbqYPm5izzTG/VO
	 vwhrFg63mX3K4OxS9nSzt3iUdixY2TDB4qa3IHCqrq1sE588FkBhhGZnDfqMHYdFvvQ2p
	 DQVxCXJcGz2X2G6kmJFc6YJ3iobZ/Bc/BsQTJedI7nbt9oGKtMljXK1y3fTOx2H3e+7bM
	 KOQBfh8Uu/s94bOUlCDe9B/A5MXd6G4EBD8R3sHhqpmBKs9V/IANkVuuEw5xbpaonH9fT
	 rH3JB5xQ4QwoP371Hohj3RZrQmRcR8AO5tOzzUzeZiIonqJfLAuUhs88uw/0pXM/m8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060219;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ls5WPQoxHfn2pkZFCqi0oyOQaaIQOL7eVrFSRH/lnzE=;
	b=KsoSE7Xwxx+T439PDjUKQu3/dU4QOLS4iN9vuItactI2jw6a8UJ/aPJqThpnDO5VeHcf
	 cZywJtxtJrt+KQKLAY1hePFoE3GY5atbX5GwYvHKCaw8EPyAsIIrTR5rmcIIBgcptSyst
	 Z3NjAdKCO6MHMw4wLtuVkutWkS93oL96hiQ9TTtr48qpCuxKviSPs3hgknoPcDclZbYca
	 aqmL8KVcu4YSI/SuCsqwzdteYko+QhemmYadzOw0qBFHtoWvUS1ZJc+fQ/mgdF5AOCOHm
	 OpnI0UBP+dkl1+kkLELfP75yAJFI8e+9iP0pL47B/EZwyVPH1iilSEZ0fuJONbDNDuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cCTYYUYc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E878D606A325;
	Thu, 19 Nov 2026 03:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cCTYYUYc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ABCD1F000C4;
	Thu, 19 Nov 2026 03:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060218;
	bh=Ls5WPQoxHfn2pkZFCqi0oyOQaaIQOL7eVrFSRH/lnzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cCTYYUYc7BVYJkH3cpB/d5FoskfbXDPs4LiIODqVEvtNntt0SD/asrUBcNLsUiMoi
	 L4mWalkrFkMDSIiF/Zf/81MlMbT55+i7osN5iC7P2SPSw9Ne0vLU2AIR1VJn4BKKpi
	 HJnyGs3i0e9AkSat3xGMIvZ7RxSyQN2Du/3gcsSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Chen <chenyuan@kylinos.cn>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1121/1848] bpftool: Fix spurious batch file read error
Date: Wed, 18 Nov 2026 15:52:39 +0100
Message-ID: <20261118150006.248634463@linuxfoundation.org>
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
index 4fd4e3462ebce..82289d2b65fbf 100644
--- a/tools/bpf/bpftool/main.c
+++ b/tools/bpf/bpftool/main.c
@@ -300,7 +300,11 @@ static int do_batch(int argc, char **argv)
 
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
@@ -398,16 +402,6 @@ int main(int argc, char **argv)
 
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



