Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031792;
	b=vUsDwMjaAnfEXjC1UOFR3Ugo8Usial1yvqh/E8SpKDkWxf7A6AbW8K5t/nGTHChHX+M5
	 GbguoC80oj9N7HGvyIcdpnNb+yc1iXfDmvLrHUCtUiIww0JTmSaIKpOsdwzSF2KLFicfX
	 lxeWA2JvTTt5pShgzgDDEQvg9Te0ywUvE1hIM3McuH2+71gcbmt468dD/MsKWwnPXykny
	 J9PCpPCogBeR4B6ora1Zr05YOUL7JTA5MU6koAOmasM1r1Wgu9LRnjxWryLlDcKLczVQX
	 77RNRmseC18ENlBZuuHGAG5coTKJJLbJlMX/MYfUplIOmGaMv2n9wJC9d40TNnmiv8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031792;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=vpZ1PNvWqpg8ACHWUyE36A71899hhlVvkBLqaJDVONY=;
	b=BwhfStzGLE2VF2qKLkspFZ+gP9TUahtDFMcYsmqjTP5CtwQDIWocgwnpe71KgizSzjid
	 oqMIbL7YNcSwQnppdnTeNeJJlB1loWHzYqvqeVJZyiy65AP96Uo8Df0BHHfhwWEvbkOfN
	 2yqjufOE+W3yzydvQIkfBXklHx9QXgEnvHSGRQcNRon8ntDriZTCQ8bmFZDponcV7j1wv
	 gOveP/s36Ew9EG26c4uMby3Ae/kOzo86am1NhgaGQLkBPAtzx3XEuuNTubs9PzohLsTBe
	 YfsBsH/r/LfrxzcJrYEIkrDPev2gmZfpaopZZ2zaUisE3ov22D6VJkBaEziVeBTkjzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VOpNkw76;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E1C7606A32A;
	Wed, 18 Nov 2026 19:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VOpNkw76
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F63A1F000C4;
	Wed, 18 Nov 2026 19:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031792;
	bh=vpZ1PNvWqpg8ACHWUyE36A71899hhlVvkBLqaJDVONY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VOpNkw76nKvuvq+Ji0PUXS2nZQoGuYWm++ZBlSAlUlTBmdLw2Av/JI+OeKs55NvpN
	 huIqeb9DIFQoH/kDsz0nmSua7uZZ3s0IDtX4ZYZlbHxAlxxVVvuwu+vyrEr9peGYMr
	 XF6wsl9djiiNW1H2WV5H4VIhasMzfregfRLX66t8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1182/1756] tools/thermal/tmon: Fix string truncation warning in optarg copy
Date: Wed, 18 Nov 2026 15:55:09 +0100
Message-ID: <20261118150056.968477042@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



