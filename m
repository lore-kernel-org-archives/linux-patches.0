Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034942;
	b=dklOKmJVUif2ikngOwx2gUYzvn8qN6s9EvAp2cQX6MKzvW+f9T/zieiR0ui0F9evsOOz
	 2VaMqMCXw5KLbpA+3NeuPIJ4q8Jp2BhgcNH4sFtBNB2dSNuSsSpe+n5jar4MKFcZ1ZvL7
	 NfGomfWWx4sg5k1LLGrqEz1a51a8ZxnfyCvaUuuCcoUvPI5rvJuMUXUbbeoTQTdCRHCpO
	 zy5jhdg4K4ts3ypA4VEdiyn2/DJlCNAGybF2+GDj12CG7hjQPz0wguMxuCLsKxyRZw12Z
	 xC0KvYvg8/FsaPbnwKkGL+r5Yob+kOGrpqSGVfRHcpMyG5zdA7LSgD8xZt/rXuX5wrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034942;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4FeOr2/9J/og6hflzt06L7gOOCnfSHBwKakq9iU/m2I=;
	b=2QKxr7FsgYu87QoO2jih6zkFIPgfn7akVPrl/PnrZvlL24KK7/6gvMuSXc7ahqWs0b3b
	 fWPKZ1tEBbVOyW35LEbQNLmtA1ZoajbelPgZhawz4e8x7YzpCHPWHaFcgeiFrCmeHfLOp
	 Ws8Fs8YAQiqbKthwoVcPlcLlShXzivqsmL4DQGJ3SkeTR+rPjC+6wJkYcfVkd9dGgw9eE
	 DcyzG+AfHWzawrN1Jlj0k8loT1MXxnJRNYBY5ln65/Qf2ro/T11xc26YCLA7EJMO4iSuR
	 wTfPdP42Lns7X2b+ootOKFoYuLygYuH3UdUiLvvtjx/Vm9yyqId2JQu9cRZMPHDRW1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Iu2udcbL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4ECE606A31C;
	Wed, 18 Nov 2026 20:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Iu2udcbL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D0611F000C4;
	Wed, 18 Nov 2026 20:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034942;
	bh=4FeOr2/9J/og6hflzt06L7gOOCnfSHBwKakq9iU/m2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Iu2udcbLLL8miW5EuIIGaGdEacuOfc60OCHzlDtwXtT+hSQlJYriDShsEFdPUcbP9
	 v9Cum2n8rb6CfSG1xpYCLUiaY3MI1h2c1+2+TsSWHID1Xc/LOl2TjL58F7rnGZMM7w
	 rhx7BLG0IFVrmATJmEGjGcyg3xV+BKTyiWAyVN+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Hutchings <benh@debian.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0550/3318] bootconfig: Fix negative seeks on 32-bit with LFS enabled
Date: Wed, 18 Nov 2026 15:19:32 +0100
Message-ID: <20261118150333.806873480@linuxfoundation.org>
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

From: Ben Hutchings <benh@debian.org>

[ Upstream commit 729dc340a4ed1267774fc8518284e976e2210bdc ]

Commit 26dda5769509 "tools/bootconfig: Cleanup bootconfig footer size
calculations" replaced some expressions of type int with the
BOOTCONFIG_FOOTER_SIZE macro, which expands to an expression of type
size_t, which is unsigned.

On 32-bit architectures with LFS enabled (i.e. off_t is 64-bit), the
seek offset of -BOOTCONFIG_FOOTER_SIZE now turns into a positive
value.

Fix this by casting the size to off_t before negating it.

Just in case someone changes BOOTCONFIG_MAGIC_LEN to have type size_t
later, do the same thing to the seek offset of -BOOTCONFIG_MAGIC_LEN.

Link: https://lore.kernel.org/all/aKHlevxeg6Y7UQrz@decadent.org.uk/

Fixes: 26dda5769509 ("tools/bootconfig: Cleanup bootconfig footer size calculations")
Signed-off-by: Ben Hutchings <benh@debian.org>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bootconfig/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/bootconfig/main.c b/tools/bootconfig/main.c
index 655ca7da4b843..5ccdb9881b5a0 100644
--- a/tools/bootconfig/main.c
+++ b/tools/bootconfig/main.c
@@ -205,7 +205,7 @@ static int load_xbc_from_initrd(int fd, char **buf)
 	if (stat.st_size < BOOTCONFIG_FOOTER_SIZE)
 		return 0;
 
-	if (lseek(fd, -BOOTCONFIG_MAGIC_LEN, SEEK_END) < 0)
+	if (lseek(fd, -(off_t)BOOTCONFIG_MAGIC_LEN, SEEK_END) < 0)
 		return pr_errno("Failed to lseek for magic", -errno);
 
 	if (read(fd, magic, BOOTCONFIG_MAGIC_LEN) < 0)
@@ -215,7 +215,7 @@ static int load_xbc_from_initrd(int fd, char **buf)
 	if (memcmp(magic, BOOTCONFIG_MAGIC, BOOTCONFIG_MAGIC_LEN) != 0)
 		return 0;
 
-	if (lseek(fd, -BOOTCONFIG_FOOTER_SIZE, SEEK_END) < 0)
+	if (lseek(fd, -(off_t)BOOTCONFIG_FOOTER_SIZE, SEEK_END) < 0)
 		return pr_errno("Failed to lseek for size", -errno);
 
 	if (read(fd, &size, sizeof(uint32_t)) < 0)
-- 
2.53.0



