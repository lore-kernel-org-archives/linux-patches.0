Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056215;
	b=zY00wrGTaqr4aW1kmvvvadS3D0olDD0b1kWtZcvzRXzCQyVH5bD7xnyrHgCxALxcedGT
	 l7Hhyqi8yhEKzeQcZ9h2RkpwNDyzJWdGZXrc8/9AtgrXa7gEtyeySCOmDeQkl74xpR1HY
	 ooP1AxnQhP+2CBtgo87Wj2JhM296Lz26ZbuZbrhxIhxaOYUMom9yIJ00vc3+e88PpL3V2
	 LJm+e6qhqylt5eN3Higw37Gk4/36ePlEGvj0PPuurbbfozvBj3JwjP4/NO98DhMMuuQ5l
	 Ogdiws6f/S8hsQUQ3cm+5nA6M2AEkHKlfDNtHYNjBVrzpJYGqrdcT7K7L5DmXv9kEnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056215;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=enUCOHUrP/8k0/6dthBnNp7dcxmbfT3IQZkh5bU+dhg=;
	b=Mufwd+KYtWZkcIO+ayZopsFQASqTqQKtCtE6ccGo76ewE64F32wzR5ujWfCR7+4z1rQU
	 JwUvb5FH0I+LyKtR2Di7QjszkaNNasMj1u+gS/wQ4TQP4ROW7DZ7OQqFAoHmGhmeAf4bu
	 wqhCOaUDQDxpY22SQ4+AkKrfoRly0hUIir93RJJNpJ+IMSzdtptW1fb+BD14DqKgPysA9
	 YoyN28yhi7LhskItBdfuiryAmKqLTCDJig6vuCHeD1PGAhU8E0qTqHNkwOvVLArYL4Aoo
	 9QHfHB3Ke+bytkx2Uag/s5zWtY0orL/j49TirWnZU63TPoFl2CPfQy+a9xbDO5Hg2YQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x8ff6JoZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8541606A32A;
	Thu, 19 Nov 2026 02:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x8ff6JoZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FD431F000C4;
	Thu, 19 Nov 2026 02:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056215;
	bh=enUCOHUrP/8k0/6dthBnNp7dcxmbfT3IQZkh5bU+dhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x8ff6JoZkqZhrbK7dYNlsifQpfIBYFVLTp2Q7jjY/d188OukE3N0tlmcSVeoHit0l
	 IZBMrjaGT71kb2whZPs3xDc43PAQU7tPYC3bGyXOThu/41LgaoeZW5+9vyvLwz/X7Y
	 co4hNFATvwlmQEpqRYrLhqh1VWg4vNr6Xv2rzevg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1909/2214] tools/thermal/tmon: Fix string truncation warning in optarg copy
Date: Wed, 18 Nov 2026 15:59:45 +0100
Message-ID: <20261118150127.473634078@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

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



