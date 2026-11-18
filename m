Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049738;
	b=pw92PdRRUNLxSuUBN8AQC2Qw8q56W84HXH16GAMLzGBfB6oundf2Gf3CTKJHgYR8KI44
	 anNOzz459xFkMUvu/K7sqmYMUtKnbzpsd+2dJEw+j6RhsauwLmmYj4Aa4UJlaniRtex21
	 KPEjHlbBzXBfujmghIuYeFb9VUj8aT0mkPyMVw2xO/1qC8Pzp7lnjWMid+zjEqTzNBQbW
	 qImjabMtZ1xofBuxHG79u0icguvPhUdE8opfjJSJTsk7Fj32FOGOdYN9rn1O26TooH7XM
	 AgWEdp+O6WOojx24jqqJGCBtjNBk9uFO9mUd0zpva7hxJsE9eef/diiuVKigpSHR/+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049738;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=U5lBGtHuFQn9HoINdKkTc1k2SZx2+Rc19jo4ZOZxJw4=;
	b=EJwju2P7VgCQgxBpXFm318kXUfcJWsJoCKBpYvtXf/vMZT2pYo31vfbNF/B7yAFBeype
	 +auQetcTjYrWA8DrE1jgVAeRPrjqRHfI3Jx6YWls7EN+idvdSbjw88SeYaxpBPS/Kztoc
	 QsQKdexkToMXFSMQ+nQaAkL6aiwB6Wp+1plMlCA62RMNGubAoZdNz/MVcxFcNAEMG8I6b
	 LNhZcZ4apki9nTZM3I9ziTHRN+d+KOf0FTpoi3U2jE2Kvg8fzkp8NEaZzDaRsFRX8rH22
	 KEQubdCNwUKh84q0zheKkKMJVvtawn1Up1jWKuQ0/3qKmszCvETPs0s5w3VqsPj757A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TSmjFs5z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B661F606A320;
	Thu, 19 Nov 2026 00:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TSmjFs5z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0643E1F000C4;
	Thu, 19 Nov 2026 00:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049738;
	bh=U5lBGtHuFQn9HoINdKkTc1k2SZx2+Rc19jo4ZOZxJw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TSmjFs5zqVSQzA2eakOlcGJzbI8QM3uA0hKusAicpLlSXIlkFapVz+YesYFshY8q2
	 xmnvLoBmj7Ht26DUVUD/CLBLb7az950C46NVJ7RP7sUFw7O+VcaLuaJm5ISiWpls0r
	 zvco9oM4mweNuuThaJVblGgUX6pcjhj/ZosQ9cyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2460/2857] tools/thermal/tmon: Fix string truncation warning in optarg copy
Date: Wed, 18 Nov 2026 15:58:14 +0100
Message-ID: <20261118150330.141257792@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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



