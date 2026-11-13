Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590307;
	b=d8jrxLKEG4zSrwlpwegDF/a0QmKKX5hmGZe/wcpBuO9kzNqVlfys9Hm+qU1pXCHIwYod
	 F+KzltOKYVbzPrrsBqsy3sFy98VfFVCHpHOzUa+kodPesZiRLEu+CPWAqc8987S8GpBAG
	 AkeEhmNNzjwPCyOCIpzIEOg3AVBP+aanPdDkdmcBHt9Th8DH//E1G/N0SX45d9fWGm9im
	 aFLXfJS9OgaDiH0e5Zr1O336usoahc7o1zJ8USquPXjC8I/A7fSFwqeGqBI5FYQ+RR2GC
	 cquCLOAiGFAhxJeOQybMcxvHhf++8tpoeV+EfmGyA+FGuLqXmBu8WPdant5KhenqWwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590307;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Wb6u1NlcggfFW3rIgoyDuRL5cuxW4ryrbDH+LTovZFc=;
	b=ukxuYwE2xzuWfpGz+oyVUSi7Uh0GS5565MAjBJXUWUZ2Jpova5ki2P1eFTiHy2gEdbOS
	 JAPzrNcgUnuYRSy5bn9MXKJZFKkkxiNNr5MgJ6WWHL1pu9YbtoPPErD0qdKrfasNQmF3C
	 dy1U3pX8q0GscFLQOatl3nAHr/+hl2+u+tWFwH10EMmq5y9tAo44mpVCOUFkZCobh7PpA
	 AlEV4eRk758UO6PWRdN26EmiVoGtAFqPv3oRqCSlOWCG1ULcPogN7Q2KOC/QZwj0C+e2n
	 Oowo6rO9bLDHhLWj8YdoJMKm68+LJiIAJ1poPewgyOBNF5rc+O77gc8fcSOcwX8y8lA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ywnA2eei;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A470B607C37D;
	Fri, 13 Nov 2026 17:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ywnA2eei
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C7311F000C6;
	Fri, 13 Nov 2026 17:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590307;
	bh=Wb6u1NlcggfFW3rIgoyDuRL5cuxW4ryrbDH+LTovZFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ywnA2eeirqNYRRlCEza8Rq6dkSeILF6JfjYZyZK2h1Lz9DFHflnaXaE6UZUt7SijA
	 hKUStRg5swYzmzxJSr8ypX4Rm5nwHwXaf8qcTlnMVbk1oADzrMLHgcEj5dwiC4r3MT
	 AeMs+D+oHYoBNeE4XhkNlS4wJrLYweskAZXBxOYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 292/686] hwmon: (sht4x) Convert update_interval to jiffies in pending data check
Date: Fri, 13 Nov 2026 10:47:05 -0500
Message-ID: <20261113153830.867151076@linuxfoundation.org>
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

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 1a30ea0be623b7443edb6adc79e07632418cefdc ]

In sht4x_read_values(), the check for whether a pending post-heater
measurement is still fresh compares get_jiffies_64() against
data->heating_complete + data->update_interval. However,
data->heating_complete is stored in jiffies whereas data->update_interval
is stored in milliseconds.

Whenever HZ != 1000, adding data->update_interval directly without
msecs_to_jiffies() mixes incompatible time units. For example, with the
default 2000 ms update_interval, the validity window is inflated to 8
seconds at HZ=250 and 20 seconds at HZ=100 instead of 2 seconds. A read
within that extended window skips triggering a fresh measurement and
instead returns and caches the stale post-heating measurement left in the
sensor's output buffer.

Convert data->update_interval to jiffies using msecs_to_jiffies() when
computing the pending measurement expiration deadline, matching the
next_update calculation right below it.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: 0eed6fc3d2b9 ("hwmon: (sht4x): add heater support")
Cc: stable@vger.kernel.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/sht4x.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/hwmon/sht4x.c b/drivers/hwmon/sht4x.c
index 83dc3ca67046b..53c8feb7e2910 100644
--- a/drivers/hwmon/sht4x.c
+++ b/drivers/hwmon/sht4x.c
@@ -99,7 +99,9 @@ static int sht4x_read_values(struct sht4x_data *data)
 		msleep(jiffies_to_msecs(data->heating_complete - curr_jiffies));
 
 	if (data->data_pending &&
-	    time_before64(get_jiffies_64(), data->heating_complete + data->update_interval)) {
+	    time_before64(get_jiffies_64(),
+			  data->heating_complete +
+			  msecs_to_jiffies(data->update_interval))) {
 		data->data_pending = false;
 	} else {
 		next_update = data->last_updated +
-- 
2.53.0



