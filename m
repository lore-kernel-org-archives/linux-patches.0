Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047525;
	b=uOSJVvBnPKs2WUDQupoMNGecyoqqkfPbS71/wstNhhqxCds0BoH+8od49M5QVDR3OHFy
	 wTMMmj5JbDn7CtW3DE2/IivD58pohxnu2tF7MwzN4k8CYNVaHW8Do+0u7jNmc1a06WQD5
	 OhHqDYMDclf2A1+Qhpf4v+cB5c4Vnd/DeXvV3+PtpZdi/mk4UR+GEE4NIEB0grAuYCatj
	 sIywO2z4X6GNnbOQ5dSgHo8Y4KiY2ELC3DWjGFPFwPPTtZcG+qPeb+nwAkk/88SB7sjGZ
	 wyUNwALR5KAK+QrtjLh/Gw1d+7u7WiQtewTad/vlOHZcjjdQKskNXWP9eLZ5Xs3LljQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047525;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=6V7phDasxKYxZkaM9kBbk1wsEjC176cBrfgq6ibwDYY=;
	b=gRFhdKxSLpOleUikAs1Qkqvz98+P6sc0u4uifEVPbFaqMD0PDOFJ0deoYKP7lUdUt1fB
	 y1S1j4cS15vMwNA+So06iGmZJjk0MVIPNu8j0Dnt/IawHvY3hNNzHOUFxWyKHQAAUrvOb
	 8e+vxysZxTacBwjwMA4nVDFBE9i0gsy7vk/l/U2ttA382Q4QyYjdgYmaC55RGesZ4C/tv
	 DC0TBQ7iaHABNuTspHAAVdgHrZJFSNWWFHenm3MBHVbpQwVTO4SFAuGvwpeFC6l0C8Ljt
	 g9E+L731qm6PVGXdIgr007ldUPzQ7FR9WabSMl8LcPTCeO2TsPHCrEZMhUnxCq95d4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tHHzNE14;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C88EA606A32A;
	Thu, 19 Nov 2026 00:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tHHzNE14
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24D611F000C4;
	Thu, 19 Nov 2026 00:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047525;
	bh=6V7phDasxKYxZkaM9kBbk1wsEjC176cBrfgq6ibwDYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tHHzNE14m9f60999XxisQ0nMiz69grmaxUJOeRYhf9s52cvD/prXtGsXDRhYk2RHR
	 BioxUfxnuQ/qBfWVQk+WOVbl1P1B70ePbHw+XKx0v066hN8/7FgB844xTXOuW3G2d0
	 9pj08bamoLJio4sHv9d1FFalULDkWiAKR4PCfoPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	=?UTF-8?q?Asaf=20Nuri=20Bertizlio=C4=9Flu?= <ycistak@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1669/2857] hwmon: (coretemp) Fix 32-bit jiffies wraparound in show_temp()
Date: Wed, 18 Nov 2026 15:45:03 +0100
Message-ID: <20261118150301.427217320@linuxfoundation.org>
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

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 9a6aa085c94c7f2817c4d50a7264e6fb51286f40 ]

show_temp() rate-limits MSR reads by storing tdata->last_updated as an
unsigned long and comparing it against jiffies using
time_after(jiffies, tdata->last_updated + HZ).

time_after() relies on signed long subtraction, which only produces the
expected result while the two timestamps are within LONG_MAX jiffies of
each other. On 32-bit kernels, if tempX_input is not read for more than
LONG_MAX jiffies (~24.85 days at HZ=1000), the signed difference flips
sign and time_after() evaluates to false. Because tdata->last_updated is
only refreshed when time_after() succeeds, subsequent reads remain
blocked from refreshing for another ~24.85 days until jiffies wraps
past tdata->last_updated + HZ again, returning either a stale cached
temperature or -ENODATA if the sensor had never been read since
initialization.

Store tdata->last_updated as a u64 and use get_jiffies_64() with
time_after64(), which does not wrap in any practical uptime.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: bebe467823c0 ("hwmon: New coretemp driver")
Cc: stable@vger.kernel.org
Tested-by: Asaf Nuri Bertizlioğlu <ycistak@gmail.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
[ sashal: Omitted timestamp initialization because the existing !tdata->valid check already forces the first read. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/coretemp.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index c0aa6bfa66b24..8ad0ac882afb9 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -70,7 +70,7 @@ struct temp_data {
 	int temp;
 	int ttarget;
 	int tjmax;
-	unsigned long last_updated;
+	u64 last_updated;
 	unsigned int cpu;
 	u32 cpu_core_id;
 	u32 status_reg;
@@ -157,7 +157,8 @@ static ssize_t show_temp(struct device *dev,
 	mutex_lock(&tdata->update_lock);
 
 	/* Check whether the time interval has elapsed */
-	if (!tdata->valid || time_after(jiffies, tdata->last_updated + HZ)) {
+	if (!tdata->valid ||
+	    time_after64(get_jiffies_64(), tdata->last_updated + HZ)) {
 		rdmsr_on_cpu(tdata->cpu, tdata->status_reg, &eax, &edx);
 		/*
 		 * Ignore the valid bit. In all observed cases the register
@@ -167,7 +168,7 @@ static ssize_t show_temp(struct device *dev,
 		 */
 		tdata->temp = tdata->tjmax - ((eax >> 16) & 0x7f) * 1000;
 		tdata->valid = true;
-		tdata->last_updated = jiffies;
+		tdata->last_updated = get_jiffies_64();
 	}
 
 	mutex_unlock(&tdata->update_lock);
-- 
2.53.0



