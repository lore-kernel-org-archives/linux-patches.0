Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017080;
	b=jwVi3/ZCe+0UyTMxoCyVbGXRxhDeDZ+GhGIbtlVErsy8FJIlOh7PKEiLbB9CalupkD3T
	 O92zjM8CnGd+9UhsaNb4Fdv5OWU5GVEQGJ80yUMEzf1Ns7A+hlm32tdAq0GREKZ1bKSUa
	 rYxitQjKFCXbVoK8Nww4ET30uQ7PKgTRHNPb83vYH5caETI3IULjUvk7InY1EQXOoNsTD
	 wODuhzlJEw73m76bEPTcbpwtWhd5JEFjSctv8kQINdsqXlVGfOa0RJJBDRu40HtMgySkO
	 eXfmy25PvfZIW+ldg+qXIwewXCxy+rW9CjfVPH9L6Jobxa49+/ZBXOKi6fMuTTrr6IA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017080;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=hYD4wtb35auccA7XD+/RmlahiqvnEuPG4E5c1uqTRVk=;
	b=X3k7qiBFiLfvLnrS3y0hE1ae2+C615jq0cjhErxWJyX2iVR4EyogXyNQJtlfzeKv9dCu
	 4DTAPMY9DeY+oBmioyn2k7imRVppk01QDN+7ZDXHMiczxokxh75trSXPQtFcpz29W/EqP
	 LsFPbFIrNQN6aLudp6UDdgExa/MlZfecGBZfzqKMP1+GtpsCWiZk2UirYU8817PsQ8j4y
	 QX50bapFGi9O+c7HOnE3eNOptcQGHte5xAWm6PSZbPTbt+oPGKk0CVwM7erLYcVU39LHf
	 96mAv0G3Jgz/mwWE+UAI57+sPoXtTbILc2TByiZvVYpnCoo0i+hdPdG8fZ1Motqn4xA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YmTse3I2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 623F5606A31C;
	Wed, 18 Nov 2026 15:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YmTse3I2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAC391F000C6;
	Wed, 18 Nov 2026 15:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017080;
	bh=hYD4wtb35auccA7XD+/RmlahiqvnEuPG4E5c1uqTRVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YmTse3I2yK3JceiA42QNlpUbPuv7TJj8i3AFCCQ4x7sdCWdbM3uVucSBS7lL3gzcl
	 JCADh0tC0P2K98YYyhDrE8rMkHkRq704imN+6TGZr/TzMy0hIldGfDiyeKxCKq1PTh
	 TPc2/BY6Z4w8nG4DP/XBcoU5pHxz+NcnIRLuNeGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danish Khateeb <danishkhateeb03@gmail.com>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0757/2651] tools/nolibc: fix WIFSIGNALED() for status 0
Date: Wed, 18 Nov 2026 15:33:17 +0100
Message-ID: <20261118150315.132823010@linuxfoundation.org>
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
index 8f3cb18df7f1c..4373bd8a5b5f8 100644
--- a/tools/include/nolibc/types.h
+++ b/tools/include/nolibc/types.h
@@ -119,7 +119,7 @@ struct timeval {
 #define WEXITSTATUS(status) (((status) & 0xff00) >> 8)
 #define WIFEXITED(status)   (((status) & 0x7f) == 0)
 #define WTERMSIG(status)    ((status) & 0x7f)
-#define WIFSIGNALED(status) ((status) - 1 < 0xff)
+#define WIFSIGNALED(status) ((status) - 1U < 0xff)
 
 /* standard exit() codes */
 #define EXIT_SUCCESS 0
-- 
2.53.0



