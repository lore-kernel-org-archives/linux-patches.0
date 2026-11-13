Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590343;
	b=vlAjKv0ZiG1fSMdkPACNu0QO916HUTFKD1Xrl+iJZyfOPv8tBmSDJjEH9TzD9OUS2q/B
	 cdPT15FoFj0Tb22WXt201eQaR+a+6WB08Ef7a9OjH6JItIRWkzT3mHD0O9g3z5lO+CUGf
	 X7WAJhyyxIqCToc0CPDCmN4PQZLp8lAJIJObT9Z+oyzx1VCfzzYYta0jMmOUR/NHErJ/a
	 d1XQ7FtVpJ7HdObvqhcneuiGA03NjV3oFwch2KmQEuslgvQxIzyxkl0pDSswFtiet3wXM
	 QwGkeNliTUrakRdGxZAeUo0AOiVwJaCVcdk68tnV1Wi8OPQGLsiCb2yE6W0NUznuYbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590343;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mmR+rkQBXqTAdR03aEFtHWMDgKfbq1EbjY1TuSYMD4E=;
	b=opbjt6VwA56SwFOv1famF7phM+NE+Qp+ybX6iHZGy2rCpxaJ+dmRJglWKbV/Gq4YE82q
	 Gvja42d+PbOyAqK6dg0LvLtgXTbR+TrdiNEHSYh2rp3ilpkzOqBOlP0U6/eiIVK3j5G2Q
	 UyqNRg3Izf5IxvDZO7LegBOvIl63JWivebMjx8ezIgsWm037wSAiz4qbFtZm++DexBZ40
	 9dPC32+L/6NlqZ0E28UbFJzJRMfTgIzDvqi1iJxS7WbNXIqNw/xYqtCntDyzJd6BfDS72
	 yOrYgbPr9XstwjiVUACZFQ0IIpVDMfM1K5EeHnWHp1eGi6RHAxGwUrqvSz3QBOj0pGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kfL7XiYp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A7D6083152;
	Fri, 13 Nov 2026 17:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kfL7XiYp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C15B21F000C4;
	Fri, 13 Nov 2026 17:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590343;
	bh=mmR+rkQBXqTAdR03aEFtHWMDgKfbq1EbjY1TuSYMD4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kfL7XiYpW1chjfRswtxuYlTBhmw342kGvgz6pvDOfZyDMAtuLILWsCz6xYA31s5q3
	 NMrN2XrQLS/5pSg+Cihuw0Ws4NRwkVpACrd4DwrUsjluFXoZ2zH63HO9K2lDFGSrIH
	 sQQgj8As4uFTPNffIa7dHoR9YEazHCZw7e15ugrA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 278/686] hwmon: chipcap2: do not discard pending alarms on disable
Date: Fri, 13 Nov 2026 10:46:51 -0500
Message-ID: <20261113153830.411730972@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

[ Upstream commit 22aecf164e1c0c849808c342c65322d14f45176f ]

cc2_disable() stops processing interrupts before the device is powered
down to ignore the alarms caused by voltage toggling. The handler of an
alarm raised by the last measurement might not have run at that point,
and the alarm is discarded when it finally does.

The sysfs read that triggered the measurement can then report no alarm
although the device raised one.

Wait for the alarm handlers that have already been raised before the
interrupt processing is stopped. This covers the case where the handler
thread has not been scheduled yet; an alarm that has not reached the
interrupt core at that point is discarded.

Fixes: 3af350929e75 ("hwmon: Add support for Amphenol ChipCap 2")
Cc: stable@vger.kernel.org
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://patch.msgid.link/20261014-chipcap2_locks-v3-9-27ebfc2c5b9e@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/chipcap2.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/hwmon/chipcap2.c b/drivers/hwmon/chipcap2.c
index 3e8218a7ff2ad..5f4b0fd535af8 100644
--- a/drivers/hwmon/chipcap2.c
+++ b/drivers/hwmon/chipcap2.c
@@ -144,6 +144,13 @@ static void cc2_disable(struct cc2_data *data)
 {
 	int err;
 
+	/* let the alarms already raised by the last measurement be processed */
+	if (data->irq_low > 0)
+		synchronize_irq(data->irq_low);
+
+	if (data->irq_high > 0)
+		synchronize_irq(data->irq_high);
+
 	/* ignore alarms triggered by voltage toggling when powering up */
 	data->process_irqs = false;
 
-- 
2.53.0



