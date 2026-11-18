Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026580;
	b=JpWXYjFrIGhnCtNOVEszI9F5AK+E5vZCju1tE+CJA2nMOrscdPFGwBRLyHBYWdOQ/UT7
	 u6PowknPVOoQXbN7FMmXg14+3F59aOSbDuZQxMrrIlNn1resd81D8aGrZJWALrrO1wlKR
	 /verCMKvUDNkSfqW4FPzHCo3j4msztCxGur+KW6f9tiVhOJ26dU64ETTqAnVE7L9G404o
	 n/xZwtX2pn1BJTZ6JFltOq8yKkL6Ms2i9Xlhux2dbqQAI7kbWNKapfEVhPHTjx0EprcEp
	 /AFSK3Y01al1kOFRmLNL3Oxyz+RI04mtCgq6QZtB2I/0WXXjjPcIVm3WtJ50L7lgv2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026580;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=YD1JHLJVxEmpdYjEsGPmvlsALuvpAZ+6sw/ZIstVV3I=;
	b=jnNucLX/GAiNJWrVMFw2HlId4Il6jfmkNPzHdU/qZRsv84KFOkMzUwPdM26Gqdq0Wwza
	 e5DaJIeIun5wcA0WrtT3zAMMBH796lcntSifpRmWHG2FGTdZt6elFNY//CSEwUr2sjHKt
	 oNUn2gwOS47tAnPX2aMFYsQdCQi3Dutp7XTG4qT5lzg6esy6FjW1ekXlxHoObR+CQWztZ
	 7YqR1QJoggdEcvl5lQh6asEpWVZ3D/zYuyKreGvkicp/vt4VMJo3pTh9tvGkdnumQkWIg
	 rwrVW279vzBiJ2DjZ/TQOgbJGUwXRq05VQeB3VhUDlolJawDsnV57MO2gpLXUux6iDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XwOqpjDo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2FFA606A31C;
	Wed, 18 Nov 2026 18:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XwOqpjDo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ACAD1F000C4;
	Wed, 18 Nov 2026 18:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026579;
	bh=YD1JHLJVxEmpdYjEsGPmvlsALuvpAZ+6sw/ZIstVV3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XwOqpjDoOjOQbh1bqvFV03V4WgnZTrXUZqldNwFjQg9T7lJLNPEX4oPgtajclcLon
	 kN5ao/savYj5fz5KFX1sw1hCECFyyKDr+h5eIXAltS0wRFr4hDX0TFruhZUomJUeK2
	 VhGR+x9PH5gaxIlnnUjHjJ+HH3qpxvQ1omF2CQww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1486/2151] tools/thermal/tmon: Fix string truncation warning in optarg copy
Date: Wed, 18 Nov 2026 15:53:41 +0100
Message-ID: <20261118150216.013473348@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



