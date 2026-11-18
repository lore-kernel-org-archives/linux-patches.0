Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020091;
	b=mSljperQlPXCTYDrWIaIlsvA7WOK5ifwhKZF7GsJk1rIZNha5SsIXXdjTqpMUWnP4G7p
	 xjZIt9Tc/7Fab13g5ynxEduUZXw+eqdnOGvxv9LZpFBOmGoXiWHW5uCo3NQ+HNYdV0VqW
	 KhYuBLPBh4quJttYi1eIUmjhWuDqLGgix1hGx6NRjFJaojflsf2nkDsI+eqe6RfT4zY/w
	 E1KgYpedL/ilIlWoSu4LOVLc60DKY06EQ/bAVjbWjW8WlzpZqW1ZHjpBH6C0m7Leeu/Y2
	 zrlCyI8dVvJDj0HXtMizYQGZsmJ39cR7pELvDcZbM88zMcZrtawgIgSGO/ka83cW2CA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020091;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=YGuHxNfL8cCzjfOi760+/UVIyePh1EaXFrWRCLGDnLg=;
	b=sAAs4kwrnhEBpc411clkLvRxkRbXpaB/nTBnAnF/3z2IDqcXd2Xc+Qf1/HXT0KbOomH0
	 2Zn5YUky8us02ih6D3Bh5SSeG/sOOWR3AKqg8+3qEuUsNw6Fl/8B6PfnAINcjzQKBKXsp
	 aAfoaFAJpPpgLyz1FslqjbKuABnBN7HeOksUcNQAWGM/H/hZFdKxioA0+GkW3NLdNhthv
	 FHXPfA0eIN0T4HiHvBIIMjiFIakpLqS6Gphm5q+2jDlwQcPmGMV76eGYXndosR7A2Mbro
	 +97j3NGQ/dt4qLpzKarQkPmqaBHIQPhcKttt0lvkDxiltI4v3UwhGfwIsUzV6YYM1Yw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c30qm+WE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2C96606A331;
	Wed, 18 Nov 2026 16:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c30qm+WE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4F201F000C5;
	Wed, 18 Nov 2026 16:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020090;
	bh=YGuHxNfL8cCzjfOi760+/UVIyePh1EaXFrWRCLGDnLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c30qm+WEQZ3ijLpaK3H3O2LU1RantykHoVdSczpIOp+ZcZ9zBM9Avm9TrH9qnecx/
	 QoP8u9gILDaMblkZoxRIGwOfeKCi6dBVxXFXRLXLpHqh8JVkfUTb8KWnGOoS6GJXWc
	 HSPLOJkz/l4LTCsVa7lfMT0w3OIbQ4Yce9YXXQ1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1827/2651] tools/thermal/tmon: Fix string truncation warning in optarg copy
Date: Wed, 18 Nov 2026 15:51:07 +0100
Message-ID: <20261118150352.915966094@linuxfoundation.org>
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

From: Florian Fainelli <florian.fainelli@broadcom.com>

[ Upstream commit 602da762f7a7c494a95cb204ac005965b214e556 ]

GCC warns about possible string truncation with -Wstringop-truncation:

  tmon.c: In function ‘main’:
  tmon.c:233:25: warning: ‘__builtin_strncpy’ specified bound 20 equals
destination size [-Wstringop-truncation]
    233 |                         strncpy(ctrl_cdev, optarg,
	CDEV_NAME_SIZE);
        |
^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Replace strncpy() with snprintf() to guarantee NUL-termination and
silence the compiler warning.

Fixes: 94f69966faf8 ("tools/thermal: Introduce tmon, a tool for thermal subsystem")
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
Link: https://patch.msgid.link/20260929201951.408456-1-florian.fainelli@broadcom.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/thermal/tmon/tmon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/thermal/tmon/tmon.c b/tools/thermal/tmon/tmon.c
index 7eb3216a27f45..0c8deee4652e2 100644
--- a/tools/thermal/tmon/tmon.c
+++ b/tools/thermal/tmon/tmon.c
@@ -230,7 +230,7 @@ int main(int argc, char **argv)
 		switch (c) {
 		case 'c':
 			no_control = 0;
-			strncpy(ctrl_cdev, optarg, CDEV_NAME_SIZE);
+			snprintf(ctrl_cdev, sizeof(ctrl_cdev), "%s", optarg);
 			break;
 		case 'd':
 			start_daemon_mode();
-- 
2.53.0



